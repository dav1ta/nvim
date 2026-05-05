from __future__ import annotations

import sys

from textual.app import App, ComposeResult
from textual import containers
from textual.reactive import var
from textual.widgets import Footer, Header

from textual_diff_view import DiffView, LoadError


class CodeReviewDiffApp(App):
    TITLE = "CodeReview"
    BINDINGS = [
        ("s", "done(10)", "Stage"),
        ("n", "done(11)", "Skip"),
        ("q", "done(12)", "Quit"),
        ("space", "toggle('split')", "Split"),
        ("a", "toggle('annotations')", "Annotations"),
        ("w", "toggle('wrap')", "Wrap"),
    ]

    split = var(True)
    annotations = var(True)
    wrap = var(False)

    def __init__(self, original: str, modified: str, title: str) -> None:
        super().__init__()
        self.original = original
        self.modified = modified
        self.title = title

    def compose(self) -> ComposeResult:
        yield Header()
        yield containers.VerticalScroll(id="diff-container")
        yield Footer()

    async def on_mount(self) -> None:
        try:
            diff_view = await DiffView.load(self.original, self.modified)
        except LoadError as error:
            self.notify(str(error), title="Failed to load diff", severity="error")
            self.exit(return_code=1)
            return

        diff_view.data_bind(
            CodeReviewDiffApp.split,
            CodeReviewDiffApp.annotations,
            CodeReviewDiffApp.wrap,
        )
        await self.query_one("#diff-container").mount(diff_view)

    def action_done(self, return_code: int) -> None:
        self.exit(return_code=return_code)


def main() -> int:
    if len(sys.argv) != 4:
        print("Usage: codereview_textual_diff.py ORIGINAL MODIFIED TITLE", file=sys.stderr)
        return 2

    app = CodeReviewDiffApp(sys.argv[1], sys.argv[2], sys.argv[3])
    app.run()
    return app.return_code or 0


if __name__ == "__main__":
    raise SystemExit(main())
