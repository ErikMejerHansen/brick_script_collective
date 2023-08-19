/**
 * Generate a default project.
 * Adapted from https://github.com/LLK/scratch-gui/blob/develop/src/lib/default-project/project-data.js
 */
const projectData = (): object => {
    return {
        targets: [
            {
                isStage: true,
                name: "Stage",
                variables: {},
                lists: {},
                broadcasts: {},
                blocks: {},
                currentCostume: 0,
                costumes: [
                    {
                        assetId: "cd21514d0531fdffb22204e0ec5ed84a",
                        name: "StageCostume",
                        md5ext: "cd21514d0531fdffb22204e0ec5ed84a.svg",
                        dataFormat: "svg",
                        rotationCenterX: 240,
                        rotationCenterY: 180,
                    },
                ],
                sounds: [],
                volume: 100,
            },
            {
                isStage: false,
                name: "FirstTarget",
                variables: {},
                lists: {},
                broadcasts: {},
                blocks: {},
                currentCostume: 0,
                costumes: [
                    {
                        assetId: "b7853f557e4426412e64bb3da6531a99",
                        name: "FirstTargetCostume",
                        bitmapResolution: 1,
                        md5ext: "b7853f557e4426412e64bb3da6531a99.svg",
                        dataFormat: "svg",
                        rotationCenterX: 48,
                        rotationCenterY: 50,
                    },
                ],
                sounds: [],
                volume: 100,
                visible: false,
                x: 0,
                y: 0,
                size: 100,
                direction: 90,
                draggable: false,
                rotationStyle: "all around",
            },
        ],
        meta: {
            semver: "3.0.0",
            vm: "0.1.0",
            agent:
                "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36", // eslint-disable-line max-len
        },
    };
};

export { projectData };