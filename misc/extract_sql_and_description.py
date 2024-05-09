import json
from typing import TypedDict
from dbt.cli.main import dbtRunner, dbtRunnerResult
from dbt.contracts.graph.manifest import Manifest


class LLMInput(TypedDict):
    name: str
    description: str
    raw_code: str


# introspect manifest
def get_node_information_from_manifest(manifest: Manifest) -> list[LLMInput]:
    desired_output = []
    for node_name, node in manifest.nodes.items():
        if node_name.startswith("model.") and ".agg__" in node_name:
            desired_output.append(
                LLMInput(
                    name=node_name,
                    description=node.description,
                    raw_code=node.raw_code,
                )
            )

    return desired_output


def main() -> None:
    # use 'parse' command to load a Manifest
    res: dbtRunnerResult = dbtRunner().invoke(["parse"])
    manifest: Manifest = res.result  # type: ignore

    nodes = get_node_information_from_manifest(manifest)
    with open("achievement_descriptions_code.json", "w") as f:
        json.dump(nodes, f, indent=2)


if __name__ == "__main__":
    main()
