From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH 0/3] Add gup fast + longterm and use it in HFI1
Date: Mon, 11 Feb 2019 15:50:52 -0700
Message-ID: <20190211225052.GL24692@ziepe.ca>
References: <20190211201643.7599-1-ira.weiny@intel.com>
 <20190211203417.a2c2kbmjai43flyz@linux-r8p5>
 <20190211204710.GE24692@ziepe.ca>
 <20190211214257.GA7891@iweiny-DESK2.sc.intel.com>
 <20190211222208.GJ24692@ziepe.ca>
 <2807E5FD2F6FDA4886F6618EAC48510E79BCF37B@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E79BCF37B@CRSMSX101.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Weiny, Ira" <ira.weiny@intel.com>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Daniel Borkmann <daniel@iogearbox.net>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "Marciniszyn, Mike" <mike.marciniszyn@intel.com>, "Dalessandro, Dennis" <dennis.dalessandro@intel.com>, Doug Ledford <dledford@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 11, 2019 at 10:40:02PM +0000, Weiny, Ira wrote:

> > Many drivers do this, the 'doorbell' is a PCI -> CPU thing of some sort
> 
> My surprise is why does _userspace_ allocate this memory?

Well, userspace needs to read the memory, so either userpace allocates
it and the kernel GUP's it, or userspace mmap's a kernel page which
was DMA mapped.

The GUP version lets the doorbells have lower alignment than a PAGE,
and thes RDMA drivers hard requires GUP->DMA to function..

So why not use a umem here? It already has to work.

> > > This does not seem to be allocating memory regions.  Jason, do you
> > > want a patch to just convert these calls and consider it legacy code?
> > 
> > It needs to use umem like all the other drivers on this path.
> > Otherwise it doesn't get the page pinning logic right
>
> Not sure what you mean regarding the pinning logic?

The RLIMIT_MEMLOCK stuff and so on.

> > There is also something else rotten with these longterm callsites,
> > they seem to have very different ideas how to handle
> > RLIMIT_MEMLOCK.
> > 
> > ie vfio doesn't even touch pinned_vm.. and rdma is applying
> > RLIMIT_MEMLOCK to mm->pinned_vm, while vfio is using locked_vm.. No
> > idea which is right, but they should be the same, and this pattern should
> > probably be in core code someplace.
> 
> Neither do I.  But AFAIK pinned_vm is a subset of locked_vm.

I thought so..

> So should we be accounting both of the counters?

Someone should check :)

Since we don't increment locked_vm when we increment pinned_vm and
vfio only checke RLIMIT_MEMLOCK against locked_vm one can certainly
exceed the limit by mixing and matching RDMA and VFIO pins in the same
process. Sure seems like there is a bug somewhere here.

Jason
