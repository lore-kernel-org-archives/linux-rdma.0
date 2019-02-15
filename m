From: Dave Chinner <david@fromorbit.com>
Subject: Re: [LSF/MM TOPIC] Discuss least bad options for resolving
 longterm-GUP usage by RDMA
Date: Fri, 15 Feb 2019 12:19:21 +1100
Message-ID: <20190215011921.GS20493@dastard>
References: <01000168c8e2de6b-9ab820ed-38ad-469c-b210-60fcff8ea81c-000000@email.amazonses.com>
 <20190208044302.GA20493@dastard>
 <20190208111028.GD6353@quack2.suse.cz>
 <CAPcyv4iVtBfO8zWZU3LZXLqv-dha1NSG+2+7MvgNy9TibCy4Cw@mail.gmail.com>
 <20190211102402.GF19029@quack2.suse.cz>
 <CAPcyv4iHso+PqAm-4NfF0svoK4mELJMSWNp+vsG43UaW1S2eew@mail.gmail.com>
 <20190211180654.GB24692@ziepe.ca>
 <20190214202622.GB3420@redhat.com>
 <20190214205049.GC12668@bombadil.infradead.org>
 <20190214213922.GD3420@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190214213922.GD3420@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jerome Glisse <jglisse@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, Christopher Lameter <cl@linux.com>, Doug Ledford <dledford@redhat.com>, Ira Weiny <ira.weiny@intel.com>, lsf-pc@lists.linux-foundation.org, linux-rdma <linux-rdma@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, John Hubbard <jhubbard@nvidia.com>, Michal Hocko <mhocko@kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 14, 2019 at 04:39:22PM -0500, Jerome Glisse wrote:
> On Thu, Feb 14, 2019 at 12:50:49PM -0800, Matthew Wilcox wrote:
> > On Thu, Feb 14, 2019 at 03:26:22PM -0500, Jerome Glisse wrote:
> > > On Mon, Feb 11, 2019 at 11:06:54AM -0700, Jason Gunthorpe wrote:
> > > > But it also doesnt' trucate/create a hole. Another thread wrote to it
> > > > right away and the 'hole' was essentially instantly reallocated. This
> > > > is an inherent, pre-existing, race in the ftrucate/etc APIs.
> > > 
> > > So it is kind of a // point to this, but direct I/O do "truncate" pages
> > > or more exactly after a write direct I/O invalidate_inode_pages2_range()
> > > is call and it will try to unmap and remove from page cache all pages
> > > that have been written too.
> > 
> > Hang on.  Pages are tossed out of the page cache _before_ an O_DIRECT
> > write starts.  The only way what you're describing can happen is if
> > there's a race between an O_DIRECT writer and an mmap.  Which is either
> > an incredibly badly written application or someone trying an exploit.
> 
> I believe they are tossed after O_DIRECT starts (dio_complete). But

Yes, but also before. See iomap_dio_rw() and
generic_file_direct_write().

> regardless the issues is that an RDMA can have pin the page long
> before the DIO in which case the page can not be toss from the page
> cache and what ever is written to the block device will be discarded
> once the RDMA unpin the pages. So we would end up in the code path
> that spit out big error message in the kernel log.

Which tells us filesystem people that the applications are doing
something that _will_ cause data corruption and hence not to spend
any time triaging data corruption reports because it's not a
filesystem bug that caused it.

See open(2):

	Applications should avoid mixing O_DIRECT and normal I/O to
	the same file, and especially to overlapping byte regions in
	the same file.  Even when the filesystem correctly handles
	the coherency issues in this situation, overall I/O
	throughput is likely to be slower than using either mode
	alone.  Likewise, applications should avoid mixing mmap(2)
	of files with direct I/O to the same files.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
