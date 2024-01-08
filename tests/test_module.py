"""Tests the basic functionality of the Webcam Module."""

import time
import unittest
from pathlib import Path

import requests
from wei import ExperimentClient
from wei.core.data_classes import WorkcellData, WorkflowStatus


class TestWEI_Base(unittest.TestCase):
    """Base class for WEI's pytest tests"""

    def __init__(self, *args, **kwargs):
        """Basic setup for WEI's pytest tests"""
        super().__init__(*args, **kwargs)
        self.root_dir = Path(__file__).resolve().parent.parent
        self.workcell_file = self.root_dir / Path(
            "tests/workcell_defs/test_workcell.yaml"
        )
        self.workcell = WorkcellData.from_yaml(self.workcell_file)
        self.server_host = self.workcell.config.server_host
        self.server_port = self.workcell.config.server_port
        self.url = f"http://{self.server_host}:{self.server_port}"
        self.redis_host = self.workcell.config.redis_host

        # Check to see that server is up
        start_time = time.time()
        while True:
            try:
                if requests.get(self.url + "/wc/state").status_code == 200:
                    break
            except Exception:
                pass
            time.sleep(1)
            if time.time() - start_time > 60:
                raise TimeoutError("Server did not start in 60 seconds")


class TestWebcamModule(TestWEI_Base):
    """Tests the basic functionality of the Sleep Module."""

    def test_take_picture_action(self):
        """Tests that the take_picture action works"""
        exp = ExperimentClient(self.server_host, self.server_port, "")

        result = exp.start_run(
            Path(self.root_dir) / Path("tests/workflow_defs/test_workflow.yaml"),
            simulate=False,
            blocking=True,
        )
        assert result["status"] == WorkflowStatus.COMPLETED
        exp.get_file(
            input_filepath=result["hist"]["Take Picture"]["action_msg"],
            output_filepath=Path("~/.wei/temp/test_image.jpg").expanduser(),
        )
        assert Path("~/.wei/temp/test_image.jpg").expanduser().exists()


if __name__ == "__main__":
    unittest.main()
