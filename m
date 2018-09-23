From: Mike Rapoport <rppt@linux.vnet.ibm.com>
Subject: Re: Linux RDMA mini-conf at Plumbers 2018
Date: Sun, 23 Sep 2018 18:17:24 +0300
Message-ID: <20180923151724.GA2469@rapoport-lnx>
References: <20180920181923.GA6542@mellanox.com>
 <20180920185428.GT3519@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180920185428.GT3519@mtr-leonro.mtl.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Jason Gunthorpe <jgg@mellanox.com>, linux-rdma@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Alex Rosenbaum <alexr@mellanox.com>, Alex Williamson <alex.williamson@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>, Christoph Hellwig <hch@lst.de>, Christopher Lameter <cl@linux.com>, Dan Williams <dan.j.williams@intel.com>, Don Dutile <ddutile@redhat.com>, Doug Ledford <dledford@redhat.com>, Jan Kara <jack@suse.cz>, John Hubbard <jhubbard@nvidia.com>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Logan Gunthorpe <logang@deltatee.com>, Matthew Wilcox <willy@infradead.org>, Nicholas Piggin <npiggin@gmail.com>, Noa Osherovich <noaos@mellanox.com>, Parav Pandit <para>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 20, 2018 at 09:54:28PM +0300, Leon Romanovsky wrote:
> On Thu, Sep 20, 2018 at 12:19:23PM -0600, Jason Gunthorpe wrote:
> > This is just a friendly reminder that registration deadlines are
> > approaching for this conference. Please see
> >
> > https://www.linuxplumbersconf.org/event/2/page/7-attend
> >
> > For details.
> >
> > This year we expect to have close to a day set aside for RDMA related
> > topics. Including up to half a day for the thorny general kernel issues
> > related to get_user_pages(), particularly as exasperated by RDMA.
> >
> > We have been working on the following concepts for sessions, I've
> > roughly marked names based on past participation in related email
> > threads. As we get closer to the conference date we will be organizing
> > leaders for each section based on these lists, please let us know of
> > any changes, or desire to be a leader!
> >
> > RDMA and get_user_pages
> > =======================
> >   Dan Williams <dan.j.williams@intel.com>
> >   Matthew Wilcox <willy@infradead.org>
> >   John Hubbard <jhubbard@nvidia.com>
> >   Nicholas Piggin <npiggin@gmail.com>
> >   Jan Kara <jack@suse.cz>
> >
> >  RDMA, DAX and persistant memory co-existence.
> >
> >  Explore the limits of what is possible without using On
> >  Demand Paging Memory Registration. Discuss 'shootdown'
> >  of userspace MRs
> >
> >  Dirtying pages obtained with get_user_pages() can oops ext4
> >  discuss open solutions.
> >
> > RDMA and PCI peer to peer
> > =========================
> >   Don Dutile <ddutile@redhat.com>
> >   Alex Williamson <alex.williamson@redhat.com>
> >   Christoph Hellwig <hch@lst.de>
> >   Stephen Bates <sbates@raithlin.com>
> >   Logan Gunthorpe <logang@deltatee.com>
> >   Jérôme Glisse <jglisse@redhat.com>
> >   Christian König <christian.koenig@amd.com>
> >   Bjorn Helgaas <bhelgaas@google.com>
> >
> >  RDMA and PCI peer to peer transactions. IOMMU issues. Integration
> >  with HMM. How to expose PCI BAR memory to userspace and other
> >  drivers as a DMA target.
> >
> > Improving testing of RDMA with syzkaller, RXE and Python
> > ========================================================
> >  Noa Osherovich <noaos@mellanox.com>
> >  Don Dutile <ddutile@redhat.com>
> >  Jason Gunthorpe <jgg@mellanox.com>
> >
> >  Problem solve RDMA's distinct lack of public tests.
> >  Provide a better framework for all drivers to test with,
> >  and a framework for basic testing in userspace.
> >
> >  Worst remaining unfixed syzkaller bugs and how to try to fix them
> >
> >  How to hook syzkaller more deeply into RDMA.
> >
> > IOCTL conversion and new kABI topics
> > ====================================
> >  Jason Gunthorpe <jgg@mellanox.com>
> >  Alex Rosenbaum <alexr@mellanox.com>
> >
> >  Attempt to close on the remaining tasks to complete the project
> >
> >  Restore fork() support to userspace
> >
> > Container and namespaces for RDMA topics
> > ========================================
> >  Parav Pandit <parav@mellanox.com>
> >  Doug Ledford <dledford@redhat.com>
> >
> >  Remaining sticky situations with containers
> >
> >  namespaces in sysfs and legacy all-namespace operation
> >
> >  Remaining CM issues
> >
> >  Security isolation problems
> >
> > Very large Contiguous regions in userspace
> > ==========================================
> >  Christopher Lameter <cl@linux.com>
> >  Parav Pandit <parav@mellanox.com>
> >
> >  Poor performance of get_user_pages on very large virtual ranges
> >
> >  No standardized API to allocate regions to user space
> >
> >  Carry over from last year
> >
> > As we get closer to the conference date the exact schedule will be
> > published on the conference web site. I belive we have the Thursday
> > set aside right now.
> >
> > If there are any last minute topics people would like to see please
> > let us know.
> 
> I want to remind you that Mike wanted to bring the topic of enhancing
> remote page faults during post-copy container migration in CRIU over
> RDMA.
 
It's more Joel's topic, but thanks for the reminder anyway :)

> Thanks
> 
> >
> > See you all in Vancouver!
> >
> > Thanks,
> > Jason & Leon
> >

-- 
Sincerely yours,
Mike.
