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

    const COVERAGE = 0.8;

    protected $covered = 0;

    protected $total = 0;

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
            $array = json_decode(json_encode($xml), true);
            foreach ($array['project']['package'] as $file) {
                if (isset($file['file']['metrics'])) {
                $fileAttributes = $file['file']['metrics']['@attributes'];
                $this->updatePercentage($fileAttributes);
                } else {
                    foreach ($file['file'] as $subfile) {
                        $fileAttributes = $subfile['metrics']['@attributes'];
                        $this->updatePercentage($fileAttributes);
                    }
                }
            }
            $coverage = $this->covered / $this->total;
            if ($coverage < self::COVERAGE) {
                throw new \Exception(sprintf('Code coverage of %s not reached... The current coverage is %s.', self::COVERAGE, $coverage));
            }
        } else {
            exit(sprintf('Failed to open %s.', $filepath));
        }
    }

    protected function updatePercentage($fileAttributes)
    {
        if (isset($fileAttributes['methods'])) {
            $this->total += intval($fileAttributes['methods']);
        }
        $this->total += intval($fileAttributes['conditionals']);
        $this->total += intval($fileAttributes['statements']);
        $this->covered +=intval($fileAttributes['coveredmethods']);
        $this->covered +=intval($fileAttributes['coveredconditionals']);
        $this->covered +=intval($fileAttributes['coveredstatements']);
    }
}