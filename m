From: Logan Gunthorpe <logang@deltatee.com>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Date: Sun, 22 Oct 2017 11:19:00 -0600
Message-ID: <85c98f79-e4b4-cbb5-feca-6944497c0c59@deltatee.com>
References: <MWHPR12MB169484839282E2D56124FA02F7B50@MWHPR12MB1694.namprd12.prod.outlook.com>
 <7f5e0303-f4ea-781a-8dec-74b30990d54f@desy.de>
 <be9f2dee-bb37-9e8f-af72-6ee1127ba8d4@deltatee.com>
 <1381807327.12461494.1508652825239.JavaMail.zimbra@desy.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <1381807327.12461494.1508652825239.JavaMail.zimbra@desy.de>
Content-Language: en-CA
Sender: linux-media-owner@vger.kernel.org
To: "Petrosyan, Ludwig" <ludwig.petrosyan@desy.de>
Cc: "Deucher, Alexander" <Alexander.Deucher@amd.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Linux-media@vger.kernel.org" <Linux-media@vger.kernel.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "Bridgman, John" <John.Bridgman@amd.com>, "Kuehling, Felix" <Felix.Kuehling@amd.com>, "Sagalovitch, Serguei" <Serguei.Sagalovitch@amd.com>, "Blinzer, Paul" <Paul.Blinzer@amd.com>, "Koenig, Christian" <Christian.Koenig@amd.com>, "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>, "Sander, Ben" <ben.sander@amd.com>
List-Id: linux-rdma@vger.kernel.org


On 22/10/17 12:13 AM, Petrosyan, Ludwig wrote:
> But at first sight it has to be simple:
> The PCIe Write transactions are address routed, so if in the packet header the other endpoint address is written the TLP has to be routed (by PCIe Switch to the endpoint), the DMA reading from the end point is really write transactions from the endpoint, usually (Xilinx core) to start DMA one has to write to the DMA control register of the endpoint the destination address. So I have change the device driver to set in this register the physical address of the other endpoint (get_resource start called to other endpoint, and it is the same address which I could see in lspci -vvvv -s bus-address of the switch port, memories behind bridge), so now the endpoint has to start send writes TLP with the other endpoint address in the TLP header.
> But this is not working (I want to understand why ...), but I could see the first address of the destination endpoint is changed (with the wrong value 0xFF),
> now I want to try prepare in the driver of one endpoint the DMA buffer , but using physical address of the other endpoint,
> Could be it will never work, but I want to understand why, there is my error ...

Hmm, well if I understand you correctly it sounds like, in theory, it
should work. But there could be any number of reasons why it does not.
You may need to get a hold of a PCIe analyzer to figure out what's
actually going on.

Logan
