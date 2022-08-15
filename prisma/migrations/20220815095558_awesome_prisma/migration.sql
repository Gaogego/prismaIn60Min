/*
  Warnings:

  - The primary key for the `User` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The `role` column on the `User` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - A unique constraint covering the columns `[email]` on the table `User` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[birthday,name]` on the table `User` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `birthday` to the `User` table without a default value. This is not possible if the table is not empty.
  - Added the required column `blob` to the `User` table without a default value. This is not possible if the table is not empty.

*/
-- CreateEnum
CREATE TYPE "Role" AS ENUM ('ADMIN', 'USER', 'GUEST');

-- AlterTable
ALTER TABLE "User" DROP CONSTRAINT "User_pkey",
ADD COLUMN     "birthday" TIMESTAMP(3) NOT NULL,
ADD COLUMN     "blob" BYTEA NOT NULL,
ADD COLUMN     "email" TEXT,
ADD COLUMN     "preferences" JSONB,
ALTER COLUMN "id" DROP DEFAULT,
ALTER COLUMN "id" SET DATA TYPE TEXT,
DROP COLUMN "role",
ADD COLUMN     "role" "Role" NOT NULL DEFAULT 'USER',
ADD CONSTRAINT "User_pkey" PRIMARY KEY ("id");
DROP SEQUENCE "User_id_seq";

-- CreateTable
CREATE TABLE "UserPreference" (
    "id" TEXT NOT NULL,
    "emailUpdates" BOOLEAN NOT NULL,
    "userId" TEXT NOT NULL,

    CONSTRAINT "UserPreference_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Post" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "averateRating" DOUBLE PRECISION NOT NULL,
    "body" TEXT NOT NULL,
    "cratedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "authorId" TEXT NOT NULL,
    "favoritedById" TEXT,

    CONSTRAINT "Post_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Catagory" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "Catagory_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_CatagoryToPost" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "UserPreference_userId_key" ON "UserPreference"("userId");

-- CreateIndex
CREATE INDEX "Post_id_idx" ON "Post"("id");

-- CreateIndex
CREATE UNIQUE INDEX "Catagory_name_key" ON "Catagory"("name");

-- CreateIndex
CREATE UNIQUE INDEX "_CatagoryToPost_AB_unique" ON "_CatagoryToPost"("A", "B");

-- CreateIndex
CREATE INDEX "_CatagoryToPost_B_index" ON "_CatagoryToPost"("B");

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE INDEX "User_email_idx" ON "User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "User_birthday_name_key" ON "User"("birthday", "name");

-- AddForeignKey
ALTER TABLE "UserPreference" ADD CONSTRAINT "UserPreference_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Post" ADD CONSTRAINT "Post_authorId_fkey" FOREIGN KEY ("authorId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Post" ADD CONSTRAINT "Post_favoritedById_fkey" FOREIGN KEY ("favoritedById") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_CatagoryToPost" ADD CONSTRAINT "_CatagoryToPost_A_fkey" FOREIGN KEY ("A") REFERENCES "Catagory"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_CatagoryToPost" ADD CONSTRAINT "_CatagoryToPost_B_fkey" FOREIGN KEY ("B") REFERENCES "Post"("id") ON DELETE CASCADE ON UPDATE CASCADE;
