
# Conway's Game of Life (Zig)

## Goal

This project is an implementation of **Conway's Game of Life** written in **Zig**, using **SDL3** for graphics and input.

The primary goal is educational rather than producing the shortest possible implementation. The project is intended to explore:

* Zig syntax and language features
* Manual memory management
* Project structure and code organisation
* SDL rendering and event handling
* Building a complete application from first principles

The simulation engine should remain independent of SDL so that it could be reused by another renderer in the future.

---

# Architecture

The project is divided into a small number of components, each with a single responsibility.

## Engine

The `Engine` is the owner of the application.

It is responsible for:

* Initialising and shutting down the application
* Owning the board and renderer
* Running the main loop
* Processing user input
* Updating the simulation
* Calling the renderer each frame
* Managing application state (running, paused, editing, etc.)

The engine coordinates the application but does not implement simulation or rendering logic itself.

---

## Board

The `Board` contains the complete Game of Life simulation.

It owns:

* Board dimensions
* Current generation
* Next generation
* Memory allocation for board state

It is responsible for:

* Reading and modifying cells
* Counting neighbours
* Computing the next generation
* Swapping simulation buffers

The board has no knowledge of SDL, windows, rendering, timing, or user input. It is purely the simulation engine.

---

## Renderer

The `Renderer` is responsible for displaying the simulation using SDL.

It owns the SDL rendering objects and converts the board state into pixels on the screen.

Responsibilities include:

* Drawing the board
* Drawing alive and dead cells
* Window management
* Rendering future UI elements

The renderer never modifies the board. It only reads the current state in order to display it.

---

# Design Philosophy

This project follows a separation of responsibilities:

* **Engine** controls the application.
* **Board** controls the simulation.
* **Renderer** controls presentation.

Each component should have a clearly defined purpose and minimal knowledge of the others. Keeping these responsibilities separate makes the code easier to understand, test, and extend.

---

# Current Progress

* [x] Board allocation and cleanup
* [x] Cell access helpers
* [x] Neighbour counting
* [x] Simulation step (double-buffered)
* [x] SDL rendering
* [ ] Engine/game loop
* [ ] Input handling
* [ ] Simulation controls
* [ ] Pattern loading and editing
