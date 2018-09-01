From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v5 01/13] PCI/P2PDMA: Support peer-to-peer memory
Date: Sat, 1 Sep 2018 10:27:03 +0200
Message-ID: <20180901082703.GA670@lst.de>
References: <20180830185352.3369-1-logang@deltatee.com> <20180830185352.3369-2-logang@deltatee.com> <2711b3a7-f582-0dda-8ac2-530be7bda1bb@amd.com> <439181bb-6cd6-0ab2-bca6-fc820845166e@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <439181bb-6cd6-0ab2-bca6-fc820845166e@deltatee.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org, Stephen Bates <sbates@raithlin.com>, Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@intel.com>, Sagi Grimberg <sagi@grimberg.me>, Bjorn Helgaas <bhelgaas@google.com>, Jason Gunthorpe <jgg@mellanox.com>, Max Gurtovoy <maxg@mellanox.com>, Dan Williams <dan.j.williams@intel.com>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Alex Williamson <alex.williamson@redhat.com>
List-Id: linux-rdma@vger.kernel.org

On Fri, Aug 31, 2018 at 09:48:40AM -0600, Logan Gunthorpe wrote:
> Pretty easy. P2P detection is pretty much just pci_p2pdma_distance() ,
> which has nothing to do with the ZONE_DEVICE support.
> 
> (And the distance function makes use of a number of static functions
> which could be combined into a simpler interface, should we need it.)

I'd ѕay lets get things merged as-is, so that we can review the
non-ZONE_DEVICE users.  I'm a little curious how that is going to work,
so having it as a full series would be useful.
