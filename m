From: Logan Gunthorpe <logang@deltatee.com>
Subject: Re: [PATCH v2 07/10] nvme-pci: Use PCI p2pmem subsystem to manage the
 CMB
Date: Mon, 5 Mar 2018 13:16:52 -0700
Message-ID: <608840df-85a6-6d3b-70b4-43b037db58c9@deltatee.com>
References: <20180228234006.21093-1-logang@deltatee.com>
 <20180228234006.21093-8-logang@deltatee.com>
 <CAOSf1CEj1vmLLd27-642=XSnL9ODkpEC0qLHA2_W5_7rV5+4Pg@mail.gmail.com>
 <20180305160004.GA30975@localhost.localdomain>
 <36c78987-006a-a97f-1d18-b0a08cbea9d4@grimberg.me>
 <20180305201053.GK11337@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180305201053.GK11337@mellanox.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>, Sagi Grimberg <sagi@grimberg.me>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, Keith Busch <keith.busch@intel.com>, Alex Williamson <alex.williamson@redhat.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-rdma@vger.kernel.org



On 05/03/18 01:10 PM, Jason Gunthorpe wrote:
> So when reading the above mlx code, we see the first wmb() being used
> to ensure that CPU stores to cachable memory are visible to the DMA
> triggered by the doorbell ring.

Oh, yes, that makes sense. Disregard my previous email as I was wrong.

Logan
