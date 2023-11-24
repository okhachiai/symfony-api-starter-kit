<?php

namespace App\Story;

use App\Factory\UserFactory;
use Zenstruck\Foundry\Story;

final class DefaultUsersStory extends Story
{
    public function build(): void
    {
        UserFactory::createOne([
            'email' => 'admin@api.fr',
            'password' => 'admin@api.fr',
            'roles' => ['ROLE_ADMIN'],
        ]);

        UserFactory::createOne([
            'email' => 'user@api.fr',
            'password' => 'user@api.fr',
            'roles' => ['ROLE_USER'],
        ]);

        UserFactory::createMany(10);
    }
}
