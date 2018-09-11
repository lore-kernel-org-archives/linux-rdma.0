From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v5 07/13] block: Add PCI P2P flag for request queue and
 check support for requests
Date: Tue, 11 Sep 2018 09:10:55 +0200
Message-ID: <20180911071055.GA6609@lst.de>
References: <20180905201152.GA1893@lst.de> <eb42fb94-9da6-955b-8524-0a0f5ac4bd19@deltatee.com> <2a3394bd-5f13-4818-43f4-dfc61f501e05@kernel.dk> <e3ef26e6-6c8d-25b8-fa64-14594a51263c@deltatee.com> <3af4d1d4-da07-c0a6-8464-9ddc1378f2f4@kernel.dk> <f9e660cd-b597-bb6e-56a2-82fe71cb3649@deltatee.com> <34d9b2f7-9e6d-4a0a-77e5-ec0e99610f5c@kernel.dk> <c41c802c-9235-5383-2dfa-af9c1553f11b@deltatee.com> <20180910164144.GA24591@lst.de> <fc4f14ae-9490-f901-a60c-2bd1522ef137@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <fc4f14ae-9490-f901-a60c-2bd1522ef137@deltatee.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org, Stephen Bates <sbates@raithlin.com>, Keith Busch <keith.busch@intel.com>, Sagi Grimberg <sagi@grimberg.me>, Bjorn Helgaas <bhelgaas@google.com>, Jason Gunthorpe <jgg@mellanox.com>, Max Gurtovoy <maxg@mellanox.com>, Dan Williams <dan.j.williams@intel.com>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Alex Williamson <alex.williamson@redhat.com>, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 10, 2018 at 12:11:01PM -0600, Logan Gunthorpe wrote:
> > I just saw you added that "helper" in your tree.  Please don't, it is
> > a negative value add as it doesn't help anything with the checking.
> 
> Alright, so what's the consensus then? Just have a check in
> nvmet_bdev_execute_rw() to add REQ_NOMERGE when appropriate?

Yes.
