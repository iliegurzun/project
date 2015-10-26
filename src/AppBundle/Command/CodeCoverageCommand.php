<?php

namespace AppBundle\Command;

use Symfony\Bundle\FrameworkBundle\Command\ContainerAwareCommand;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Console\Input\InputOption;

/**
 * @codeCoverageIgnore
 *
 * Class CodeCoverageCommand
 * @package AppBundle\Command\CodeCoverageCommand
 */
class CodeCoverageCommand extends ContainerAwareCommand
{
    const FILE_PATH = '/home/deploy/testing/clover.xml';

    const COVERAGE = 80;
    /**
     * command configuration
     */
    protected function configure()
    {
        $this->setName('app.code_coverage')
            ->setDescription('Command that checks the code coverage percentage')
            ->addOption('file', null, InputOption::VALUE_OPTIONAL, 'The file path', self::FILE_PATH)
            ->addOption('coverage', null, InputOption::VALUE_OPTIONAL, 'The minimum of coverage percentage', self::COVERAGE);
    }

    /**
     * @param InputInterface $input
     * @param OutputInterface $output
     */
    protected function execute(InputInterface $input, OutputInterface $output)
    {
        $filepath = $input->getOption('file');
        if (file_exists($filepath)) {
            $xml = simplexml_load_file($filepath);
            dump($xml);die;
        } else {
            exit(sprintf('Failed to open %s.', $filepath));
        }
    }
}