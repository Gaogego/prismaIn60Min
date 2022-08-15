/*
npx prisma generate
npx prisma migrate dev --name init
*/

import { PrismaClient } from "@prisma/client";
const prisma = new PrismaClient();

const main = async () => {
  // const user = await prisma.user.create({ data: { name: "Elsa", role: "user" } });
  // console.log(user);
  // const users = await prisma.user.findMany();
  // console.log(users);
  await prisma.user.deleteMany();
  const user = await prisma.user.create({
    data: {
      name: "alex",
      birthday: new Date("1978-09-22"),
      email: "alex@test.com",
      userPreference: {
        create: {
          emailUpdates: true,
        },
      },
    },
    include: { userPreference: true },
  });
  console.log(user);
};

main()
  .catch((e) => console.error(e.message))
  .finally(async () => {
    await prisma.$disconnect();
  });
