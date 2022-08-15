/*
npx prisma generate
npx prisma migrate dev --name init
*/

import { PrismaClient } from "@prisma/client";
const prisma = new PrismaClient();

const main = async () => {
  // const user = await prisma.user.create({ data: { name: "Elsa", role: "user" } });
  // console.log(user);
  const users = await prisma.user.findMany();
  console.log(users);
};

main()
  .catch((e) => console.error(e.message))
  .finally(async () => {
    await prisma.$disconnect();
  });
