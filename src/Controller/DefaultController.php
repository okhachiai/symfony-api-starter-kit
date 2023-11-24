<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

class DefaultController extends AbstractController
{
    #[Route('/healthcheck', name: 'api_health_check')]
    public function index(): Response
    {
        return $this->json([
            'api_name' => $this->getParameter('APP_NAME'),
            'api_version' => $this->getParameter('APP_VERSION'),
            'api_status' => 'OK',
        ]);
    }
}
