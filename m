From: Dave Chinner <david@fromorbit.com>
Subject: Re: [LSF/MM TOPIC] Discuss least bad options for resolving
 longterm-GUP usage by RDMA
Date: Sun, 17 Feb 2019 09:42:50 +1100
Message-ID: <20190216224250.GV20493@dastard>
References: <20190211180654.GB24692@ziepe.ca>
 <20190214202622.GB3420@redhat.com>
 <20190214205049.GC12668@bombadil.infradead.org>
 <20190214213922.GD3420@redhat.com>
 <20190215011921.GS20493@dastard>
 <01000168f1d25e3a-2857236c-a7cc-44b8-a5f3-f51c2cfe6ce4-000000@email.amazonses.com>
 <20190215180852.GJ12668@bombadil.infradead.org>
 <01000168f26d9e0c-aef3255a-5059-4657-b241-dae66663bbea-000000@email.amazonses.com>
 <20190215220031.GB8001@ziepe.ca>
 <20190215233828.GB30818@iweiny-DESK2.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190215233828.GB30818@iweiny-DESK2.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ira Weiny <ira.weiny@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Christopher Lameter <cl@linux.com>, Matthew Wilcox <willy@infradead.org>, Jerome Glisse <jglisse@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, Doug Ledford <dledford@redhat.com>, lsf-pc@lists.linux-foundation.org, linux-rdma <linux-rdma@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, John Hubbard <jhubbard@nvidia.com>, Michal Hocko <mhocko@kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Feb 15, 2019 at 03:38:29PM -0800, Ira Weiny wrote:
> On Fri, Feb 15, 2019 at 03:00:31PM -0700, Jason Gunthorpe wrote:
> > On Fri, Feb 15, 2019 at 06:31:36PM +0000, Christopher Lameter wrote:
> > > On Fri, 15 Feb 2019, Matthew Wilcox wrote:
> > > 
> > > > > Since RDMA is something similar: Can we say that a file that is used for
> > > > > RDMA should not use the page cache?
> > > >
> > > > That makes no sense.  The page cache is the standard synchronisation point
> > > > for filesystems and processes.  The only problems come in for the things
> > > > which bypass the page cache like O_DIRECT and DAX.
> > > 
> > > It makes a lot of sense since the filesystems play COW etc games with the
> > > pages and RDMA is very much like O_DIRECT in that the pages are modified
> > > directly under I/O. It also bypasses the page cache in case you have
> > > not noticed yet.
> > 
> > It is quite different, O_DIRECT modifies the physical blocks on the
> > storage, bypassing the memory copy.
> >
> 
> Really?  I thought O_DIRECT allowed the block drivers to write to/from user
> space buffers.  But the _storage_ was still under the control of the block
> drivers?

Yup, in a nutshell. Even O_DIRECT on DAX doesn't modify the physical
storage directly - it ends up in the pmem driver and it does a
memcpy() to move the data to/from the physical storage and the user
space buffer. It's exactly the same IO path as moving data to/from
the physical storage into the page cache pages....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
