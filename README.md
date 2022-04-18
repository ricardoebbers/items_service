# Items Service

Simple web API that conforms to the [JSON:API specification](https://jsonapi.org/).
The API was written in Elixir and uses the Phoenix framework as it's web server.

The API serves `items` which have the following attributes:
- id (integer)
- parent_id (integer)
- name (string)
- priority (integer)

## Features

- [x] Imports and seeds data from a CSV file (Mix task)
- [x] Supports filtering, sorting and pagination of it's endpoints
- [x] Fetches items based on it's hierarchy

## Testing locally

### Pré-requisites

- Git
- Docker and docker-compose
- Elixir 1.13.4 
- Erlang 24.3.3
- Insomnia (optional)

### Setting up

1. Clone this repository: `git clone https://github.com/ricardoebbers/items_service.git`
2. Change into the folder: `cd items_service`
3. Start up the database with docker-compose: `docker-compose up -d`
4. Fetch dependencies and setup the database: `mix setup`
5. Seed the database with the CSV file: `mix csv.seed items_seeds.csv`
6. Start the server: `mix phx.server`

### Running the tests

#### Automated tests

1. Run `mix test`
   
#### Insomnia collection

1. Import the [collection](docs/items_service_collection.yaml) on Insomnia
2. Run the endpoints on the collection

#### Manually

1. List all items: GET http://localhost:4000/api/items
2. Filter the list of items: GET http://localhost:4000/api/items?filter%5Bname%5D=folder%201%201
3. Sort the list of items: GET http://localhost:4000/api/items?sort=-priority
4. Paginate the list of items: GET http://localhost:4000/api/items?page%5Bpage%5D=2&page%5Bsize%5D=1
5. Get an item by it's path: GET http://localhost:4000/api/items/heading%202/folder%202%203/subfolder%202%203%202
6. Get an item by it's id: GET http://localhost:4000/api/items/7
7. Get an item by it's name: GET http://localhost:4000/api/items/heading%201
