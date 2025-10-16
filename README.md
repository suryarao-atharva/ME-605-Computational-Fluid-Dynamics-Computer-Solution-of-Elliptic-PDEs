# 🌡️ 2D Steady-State Heat Conduction Solver (Elliptic PDEs)

This repository contains the computer program and analysis for solving the **two-dimensional steady-state heat conduction equation** ($\nabla^2 T = 0$) on a rectangular domain using the **Finite Difference Method (FDM)**.  

The primary goal of this project is to **compare the performance, convergence characteristics, and computational efficiency** of four different numerical solution techniques for elliptic Partial Differential Equations (PDEs) across various grid resolutions.

---

## 🚀 Project Overview

### Governing Equation
The governing equation solved is the **2D Laplace equation** on an $80 \, \text{mm} \times 80 \, \text{mm}$ square domain:

$\nabla^2 T = \dfrac{\partial^2 T}{\partial x^2} + \dfrac{\partial^2 T}{\partial y^2} = 0$


### Boundary Conditions

- **Bottom ($y=0$):** Dirichlet BC → $T = 323 \, \text{K}$  
- **Top ($y=80 \, \text{mm}$):** Dirichlet BC → $T = 423 \, \text{K}$  
- **Right ($x=80 \, \text{mm}$):** Dirichlet BC → $T = 473 \, \text{K}$  
- **Left ($x=0$):** Mixed (Neumann/Convective) BC:

$$
h(T_{\infty} - T(x=0,y)) = -\lambda \frac{\partial T}{\partial x}\bigg|_{x=0}
$$

where:

| Symbol | Parameter | Value |
|:-------:|:-----------|:------|
| $\lambda$ | Thermal conductivity | $5 \, \text{W/(m·K)}$ |
| $h$ | Convective heat transfer coefficient | $250 \, \text{W/(m}^2\text{·K)}$ |
| $T_{\infty}$ | Free-stream temperature | $573 \, \text{K}$ |

---

## 🧩 Grid Resolutions

The system is solved for **three uniform mesh sizes**:

| Grid Type | Grid Size |
|:-----------|:-----------|
| Coarse | $11 \times 11$ |
| Medium | $21 \times 21$ |
| Fine | $41 \times 41$ |

---

## 🔢 Implemented Solution Methods

This project implements and compares **custom-written solvers** for the discretized algebraic equations — no built-in linear system solvers are used.

### 1. **Direct Method: Gaussian Elimination**
- Analyzed for **CPU run time scaling** vs. total number of grid points.

### 2. **Point-Wise Iterative Method: Gauss–Seidel**
- Analyzed for **convergence rate** (Residual vs. Iterations).  
- Analyzed for **CPU run time scaling**.

### 3. **Line-by-Line Iterative Method: TDMA (Tri-Diagonal Matrix Algorithm)**
- TDMA applied within an iterative **row-sweep** loop.  
- Analyzed for **convergence rate** and **CPU run time scaling**, with a direct comparison to Gauss–Seidel.

### 4. **Time-Marching Scheme: ADI (Alternating Direction Implicit)**
- TDMA utilized for implicit steps (**row and column sweeps**).  
- Analyzed for **convergence rate** on a $21 \times 41$ grid and compared with other iterative methods.

