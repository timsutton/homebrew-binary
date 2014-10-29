require 'formula'

class Packer < Formula
  homepage 'http://www.packer.io'
  version '0.7.2'

  if Hardware.is_64_bit?
    url 'https://dl.bintray.com/mitchellh/packer/packer_0.7.2_darwin_amd64.zip'
    sha256 'bed7ddc255b5b71b139de5e30d4221926cd314a87baf0b937ba7a97c196b1286'
  else
    url 'https://dl.bintray.com/mitchellh/packer/packer_0.7.2_darwin_386.zip'
    sha256 '00c73eba76139869e39377e6c342e937d36f1a1b81920f4948608c5c10455190'
  end

  depends_on :arch => :intel

  def install
    bin.install Dir['*']
  end

  test do
    minimal = testpath/"minimal.json"
    minimal.write <<-EOS.undent
      {
        "builders": [{
          "type": "amazon-ebs",
          "region": "us-east-1",
          "source_ami": "ami-59a4a230",
          "instance_type": "m3.medium",
          "ssh_username": "ubuntu",
          "ami_name": "homebrew packer test - {{timestamp}}"
        }],
        "provisioners": [{
          "type": "shell",
          "inline": [
            "sleep 30",
            "sudo apt-get update"
          ]
        }]
      }
    EOS
    system "#{bin}/packer", "validate", minimal
  end
end
