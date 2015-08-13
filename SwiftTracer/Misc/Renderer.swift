//
//  Renderer.swift
//  SwiftTracer
//
//  Created by Hugo Tunius on 09/08/15.
//  Copyright © 2015 Hugo Tunius. All rights reserved.
//

import Foundation


struct Renderer {
    let scene: Scene
    var camera: Camera

    init(scene: Scene, camera: Camera) {
        self.scene = scene
        self.camera = camera
    }

    func render() -> [[Color]] {
        var result: [[Color]] = []

        for var x = 0; x < camera.width; ++x {
            result.append([])
            for var y = 0; y < camera.height; ++y {
                let ray = camera.createRay(x: x, y: y)
                var closestHit: Intersection?

                for var object in scene.objects {
                    if let hit = object.intersectWithRay(ray) {
                        if  let previousHit = closestHit where hit.t < previousHit.t  {
                            closestHit = hit
                        } else if closestHit == nil {
                            closestHit = hit
                        }
                    }
                }

                if let hit = closestHit {
                    result[x].append(shade(hit))
                } else {
                    result[x].append(scene.clearColor)
                }
            }
        }

        return result
    }

    private func shade(intersection: Intersection) -> Color {
        let material = intersection.shape.material
        var result = material.color * material.ambientCoefficient

        for var light in scene.lights {
            var inShadow = false
            let distanceToLight = (intersection.point - light.position).length()
            let lightDirection = (intersection.point - light.position).normalize()
            let ray = Ray(origin: intersection.point, direction: lightDirection)

            for var object in scene.objects {
                if let hit = object.intersectWithRay(ray) where hit.t < distanceToLight {
                    inShadow = true
                    break
                }
            }

            var dot = lightDirection.dot(intersection.normal)
            if dot < 0 || inShadow {
                dot = 0
            }

            result = result + (light.color * light.intensity) * (dot * material.diffuseCoefficient)
        }
        return result.clamp()
    }
}