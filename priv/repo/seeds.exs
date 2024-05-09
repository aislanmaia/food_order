alias FoodOrder.Products
alias FoodOrder.Accounts

for _ <- 0..50,
    do:
      Products.create_product(%{
        description: "some description",
        name: "Pizza #{:rand.uniform(10_000)}",
        price: :rand.uniform(10_000),
        size: Enum.random(["SMALL", "MEDIUM", "LARGE"]),
        image_url: "product_#{1..4 |> Enum.random()}.jpeg"
      })

Accounts.register_user(%{
  email: "admin@email.com",
  password: "Admin1234567",
  role: "ADMIN"
})

Accounts.register_user(%{
  email: "user@email.com",
  password: "User12345678",
  role: "USER"
})
