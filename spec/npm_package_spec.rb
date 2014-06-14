require 'bundler/setup'
require 'rspec'
require_relative '../lib/papers'

describe 'NpmPackageSpecification' do
  describe '#full_introspected_entries' do
    it 'combines dependencies and devDependencies' do
      Papers::NpmPackage.stub(:package)
                    .and_return({'dependencies' => {'prod_package' => '~> 1.2.3'},
                                 'devDependencies' => {'dev_package' => '~> 1.2.0'}})


      expect(Papers::NpmPackage.full_introspected_entries).to eq([
        {
          'name' => 'prod_package',
          'version' => '1.2.3'
        },
        {
          'name' => 'dev_package',
          'version' => '1.2.0'
        }
      ])
    end

    it 'returns dependencies when devDependencies is not defined' do
      Papers::NpmPackage.stub(:package)
                    .and_return({'dependencies' => {'npm_package' => '1.2.3'}})

      expect(Papers::NpmPackage.full_introspected_entries).to eq([{
        'name' => 'npm_package',
        'version' => '1.2.3'
      }])
    end

    it 'returns devDependencies when dependencies is not defined' do
      Papers::NpmPackage.stub(:package)
                    .and_return({'devDependencies' => {'npm_package' => '1.2.3'}})

      expect(Papers::NpmPackage.full_introspected_entries).to eq([{
        'name' => 'npm_package',
        'version' => '1.2.3'
      }])
    end

    it 'removes leading non-digits from the version' do
      Papers::NpmPackage.stub(:package)
                    .and_return({'dependencies' => {'npm_package' => '~> 1.2.3'}})

      expect(Papers::NpmPackage.full_introspected_entries).to eq([{
        'name' => 'npm_package',
        'version' => '1.2.3'
      }])
    end

    it 'returns an empty array when the dependencies and devDependencies keys are not defined' do
      Papers::NpmPackage.stub(:package)
                    .and_return({})

      expect(Papers::NpmPackage.full_introspected_entries).to eq([])
    end
  end

  describe "#introspected" do
    it "returns an array of name-version strings" do
      Papers::NpmPackage.stub(:full_introspected_entries)
                           .and_return([{
                                          'name' => 'npm_package',
                                          'version' => '1.2.3'
                                        }])

      expect(Papers::NpmPackage.introspected).to eq(["npm_package-1.2.3"])
    end

    it "returns an empty array when the dependencies key is not defined" do
      Papers::NpmPackage.stub(:full_introspected_entries)
                           .and_return([])

      expect(Papers::NpmPackage.introspected).to eq([])
    end
  end
end
