From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v9 07/13] block: Add PCI P2P flag for request queue and
 check support for requests
Date: Wed, 10 Oct 2018 14:00:07 -0600
Message-ID: <167fcf01-4bbc-f870-3750-6e950bfd6471@kernel.dk>
References: <20181004212747.6301-1-logang@deltatee.com>
 <20181004212747.6301-8-logang@deltatee.com>
 <485de371-0e84-6f20-7f3b-cec5635b87fe@kernel.dk>
 <20181010195901.GE5906@bhelgaas-glaptop.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181010195901.GE5906@bhelgaas-glaptop.roam.corp.google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Logan Gunthorpe <logang@deltatee.com>, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>, =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Alex Williamson <alex.williamson@redhat.com>, Stephen Bates <sbates@raithlin.com>, Keith Busch <keith.busch@intel.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Dan Williams <dan.j.williams@intel.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-rdma@vger.kernel.org

On 10/10/18 1:59 PM, Bjorn Helgaas wrote:
> On Fri, Oct 05, 2018 at 07:16:04PM -0600, Jens Axboe wrote:
>> On 10/4/18 3:27 PM, Logan Gunthorpe wrote:
>>> QUEUE_FLAG_PCI_P2P is introduced meaning a driver's request queue
>>> supports targeting P2P memory. This will be used by P2P providers and
>>> orchestrators (in subsequent patches) to ensure block devices can
>>> support P2P memory before submitting P2P backed pages to submit_bio().
>>
>> Nit pick, but the subject line still says that it checks support
>> for requests. This patch just adds the ability to flag support
>> in the queue.
> 
> What about the following?  MAINTAINERS doesn't list a specific
> maintainer for include/linux/blkdev.h (maybe the "BLOCK LAYER" entry
> should have an F: pattern for it?), but I'd really like your ack
> before merging this.
> 
> commit 7e647ae1eda290786851c3dff4f38189b982386d
> Author: Logan Gunthorpe <logang@deltatee.com>
> Date:   Thu Oct 4 15:27:41 2018 -0600
> 
>     block: Add PCI P2P flag for request queue
>     
>     Add QUEUE_FLAG_PCI_P2P, meaning a driver's request queue supports targeting
>     P2P memory.  This will be used by P2P providers and orchestrators (in
>     subsequent patches) to ensure block devices can support P2P memory before
>     submitting P2P-backed pages to submit_bio().
>     
>     Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
>     Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
>     Reviewed-by: Christoph Hellwig <hch@lst.de>

You can add my acked-by to this one.

-- 
Jens Axboe
