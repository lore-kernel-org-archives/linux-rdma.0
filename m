From: Logan Gunthorpe <logang@deltatee.com>
Subject: Re: [PATCH v5 07/13] block: Add PCI P2P flag for request queue and
 check support for requests
Date: Wed, 5 Sep 2018 13:53:43 -0600
Message-ID: <5e2c8d24-fe09-ad4a-9b11-9238e176be58@deltatee.com>
References: <20180830185352.3369-1-logang@deltatee.com>
 <20180830185352.3369-8-logang@deltatee.com>
 <b5ab8fa3-34ac-3117-fa0d-5206c3939435@kernel.dk>
 <20180901082812.GB670@lst.de>
 <5f79c012-c6e1-56bb-62fd-0689181fb2c9@deltatee.com>
 <59b28977-8f2a-6228-2050-03fae6bdbedd@kernel.dk>
 <1b4283da-44df-4a02-3167-e295243cef78@deltatee.com>
 <09258b9b-3aed-9890-b31a-bd70a133966c@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <09258b9b-3aed-9890-b31a-bd70a133966c@kernel.dk>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org, Stephen Bates <sbates@raithlin.com>, Keith Busch <keith.busch@intel.com>, Sagi Grimberg <sagi@grimberg.me>, Bjorn Helgaas <bhelgaas@google.com>, Jason Gunthorpe <jgg@mellanox.com>, Max Gurtovoy <maxg@mellanox.com>, Dan Williams <dan.j.williams@intel.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Alex Williamson <alex.williamson@redhat.com>, =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
List-Id: linux-rdma@vger.kernel.org



On 05/09/18 01:45 PM, Jens Axboe wrote:
> The point is that the caller doesn't necessarily know where the bio
> will end up, hence the caller can't fully check if the whole stack
> supports P2P.
> 
> What happens if a P2P request ends up with a driver that doesn't
> support it?

Yes, that's the whole point this check. Although we expect the caller to
do other checks before submitting a P2P request to a queue, so if a
driver does submit a P2P request to an unsupported queue, it is
definitely a problem in the driver (which is why we want to WARN).

Queues that support P2P (only PCI NVMe at this time, see patch 10) must
set QUEUE_FLAG_PCI_P2PDMA to indicate it. The check we are adding in
blk-core is meant to ensure any broken drivers that submit requests with
P2P memory do not get sent to a queue that doesn't indicate support.

On top of that, the code in NVMe target ensures that all namespaces on a
port are backed by queues that support P2P and, if not, it never
allocates any P2P SGLs.

Logan
