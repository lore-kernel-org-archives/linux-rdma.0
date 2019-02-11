From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [LSF/MM TOPIC] Discuss least bad options for resolving
 longterm-GUP usage by RDMA
Date: Mon, 11 Feb 2019 11:26:49 -0700
Message-ID: <20190211182649.GD24692@ziepe.ca>
References: <CAPcyv4hqya1iKCfHJRXQJRD4qXZa3VjkoKGw6tEvtWNkKVbP+A@mail.gmail.com>
 <bfe0fdd5400d41d223d8d30142f56a9c8efc033d.camel@redhat.com>
 <01000168c8e2de6b-9ab820ed-38ad-469c-b210-60fcff8ea81c-000000@email.amazonses.com>
 <20190208044302.GA20493@dastard>
 <20190208111028.GD6353@quack2.suse.cz>
 <CAPcyv4iVtBfO8zWZU3LZXLqv-dha1NSG+2+7MvgNy9TibCy4Cw@mail.gmail.com>
 <20190211102402.GF19029@quack2.suse.cz>
 <CAPcyv4iHso+PqAm-4NfF0svoK4mELJMSWNp+vsG43UaW1S2eew@mail.gmail.com>
 <20190211180654.GB24692@ziepe.ca>
 <20190211181921.GA5526@iweiny-DESK2.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190211181921.GA5526@iweiny-DESK2.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ira Weiny <ira.weiny@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, Christopher Lameter <cl@linux.com>, Doug Ledford <dledford@redhat.com>, Matthew Wilcox <willy@infradead.org>, lsf-pc@lists.linux-foundation.org, linux-rdma <linux-rdma@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, John Hubbard <jhubbard@nvidia.com>, Jerome Glisse <jglisse@redhat.com>, Michal Hocko <mhocko@kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 11, 2019 at 10:19:22AM -0800, Ira Weiny wrote:
> On Mon, Feb 11, 2019 at 11:06:54AM -0700, Jason Gunthorpe wrote:
> > On Mon, Feb 11, 2019 at 09:22:58AM -0800, Dan Williams wrote:
> > 
> > > I honestly don't like the idea that random subsystems can pin down
> > > file blocks as a side effect of gup on the result of mmap. Recall that
> > > it's not just RDMA that wants this guarantee. It seems safer to have
> > > the file be in an explicit block-allocation-immutable-mode so that the
> > > fallocate man page can describe this error case. Otherwise how would
> > > you describe the scenarios under which FALLOC_FL_PUNCH_HOLE fails?
> > 
> > I rather liked CL's version of this - ftruncate/etc is simply racing
> > with a parallel pwrite - and it doesn't fail.
> > 
> > But it also doesnt' trucate/create a hole. Another thread wrote to it
> > right away and the 'hole' was essentially instantly reallocated. This
> > is an inherent, pre-existing, race in the ftrucate/etc APIs.
> 
> I kind of like it as well, except Christopher did not answer my question:
> 
> What if user space then writes to the end of the file with a regular write?
> Does that write end up at the point they truncated to or off the end of the
> mmaped area (old length)?

IIRC it depends how the user does the write..

pwrite() with a given offset will write to that offset, re-extending
the file if needed

A file opened with O_APPEND and a write done with write() should
append to the new end

A normal file with a normal write should write to the FD's current
seek pointer.

I'm not sure what happens if you write via mmap/msync.

RDMA is similar to pwrite() and mmap.

> Or is it safe to consider all gup pinned pages this way?

O_DIRECT still has to work sensibly, and if you ftruncate something
that is currently being written with O_DIRECT it should behave the
same as if the CPU touched the mmap'd memory, IMHO.

The only real change here is that if there is a GUP then ftruncate/etc
races are always resolved as 'GUP user goes last' instead of randomly.

ftrunacte/etc already only work as you'd expect if the operator has
excluded writes. Otherwise blocks are instantly reallocated by another
racing thread. 

I'm not sure why RDMA should be so special to earn an error code ..

Jason
