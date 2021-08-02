# 2D-people-detection-dataset
*8465 frames of labled 2d lidar data of people walking indoors.*

<img src="/Poster.jpg">

## More Info

 | Vertex Color | Label |
| -------------- | ------------------------------------------------------------------ |
| ![](https://via.placeholder.com/15/00ff00/000000?text=+) Green  | People |
| ![](https://via.placeholder.com/15/ff00ff/000000?text=+) Magenta | Enviroment |
| ![](https://via.placeholder.com/15/ff0000/000000?text=+) Red | Lidar Location |

## Specs

- Ecach frame has 897 lidar points for 360 degrees for a resoltuion of 0.40133 degrees (0.007 rad)
- 7 Scenes cointaing 8465 frames at ~10Hz for a total duration of 14 minutes
- Recored with a VLP-16 Lidar that is 35cm off of the floor
- Each Scene has 4 folders (EMPTY, PEOPLE, ENVIROMENT, BOTH) with a series of point cloud files
- Empty -> No people, just the static enviroment - 10+ frames are included to deal with Lidar noise
- Both -> The lidar in the same locaiton but now people are walking through the enviroment
- People -> A subset of 'Both' where only points labled as people are included (occationaly there are PCD files with 0 points)
- Enviroment -> A subset of 'Both' where only points labled as the enviroment are included

## Dataset highlights visualized (Youtube Video)

[![Video of dataset](https://img.youtube.com/vi/cTYTPsMvkPQ/0.jpg)](https://www.youtube.com/watch?v=cTYTPsMvkPQ)
