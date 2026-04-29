# Cart Feature

Handles shopping cart state, rules, and cart UI.

## Structure

- `data/`  
  Repository implementations and data persistence details.
- `domain/`  
  Entities, repository contracts, and cart use cases.
- `presentation/`  
  Provider state management, screens, and cart widgets.

## Flow

Presentation triggers domain use cases through `CartProvider`, which delegates to the cart repository implementation in `data`.
