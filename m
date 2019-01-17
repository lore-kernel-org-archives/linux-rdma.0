From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] lib/scatterlist: Provide a DMA page iterator
Date: Thu, 17 Jan 2019 08:54:17 -0700
Message-ID: <20190117155417.GA9629@ziepe.ca>
References: <20190104223531.GA1705@ziepe.ca>
 <20190110234218.GM6890@ziepe.ca>
 <20190114094856.GB29604@lst.de>
 <1fb20ab4b171b281e9994b6c55734c120958530b.camel@vmware.com>
 <20190115212501.GE22045@ziepe.ca>
 <20190116161134.GA29041@lst.de>
 <20190116172436.GM22045@ziepe.ca>
 <20190117093001.GB31303@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190117093001.GB31303@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>
Cc: Thomas Hellstrom <thellstrom@vmware.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "yong.zhi@intel.com" <yong.zhi@intel.com>, "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "syeh@vmware.com" <syeh@vmware.com>, "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>, "bingbu.cao@intel.com" <bingbu.cao@intel.com>, "imre.deak@intel.com" <imre.deak@intel.com>, "tian.shu.qiu@intel.com" <tian.shu.qiu@intel.com>, "jian.xu.zheng@intel.com" <jian.xu.zheng@intel.com>, "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>, "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 17, 2019 at 10:30:01AM +0100, hch@lst.de wrote:
> On Wed, Jan 16, 2019 at 10:24:36AM -0700, Jason Gunthorpe wrote:
> > The fact is there is 0 industry interest in using RDMA on platforms
> > that can't do HW DMA cache coherency - the kernel syscalls required to
> > do the cache flushing on the IO path would just destroy performance to
> > the point of making RDMA pointless. Better to use netdev on those
> > platforms.
> 
> In general there is no syscall required for doing cache flushing, you
> just issue the proper instructions directly from userspace. 

At least on the ARM/MIPS systems I've worked with like this the cache
manipulation instructions are privileged and cannot be executed by
userspace. So the general case requires a syscall.

> In that case we just need to block userspace DMA access entirely.
> Which given the amount of problems it creates sounds like a pretty
> good idea anyway.

I doubt there is any support for that idea...

Jason
