# Products Feature

Owns product listing, product retrieval, and product list interactions.

## Structure

- `data/`  
  API/local data sources, models, and repository implementation.
- `domain/`  
  Product entities, repository abstraction, and use cases.
- `presentation/`  
  Product list screen, provider, and reusable UI widgets.

## Notes

- Keep product-details-specific UI in the dedicated `product_details` feature.
- Reuse shared cart/product presentation widgets from this feature when appropriate.
