From: Jerome Glisse <jglisse@redhat.com>
Subject: Re: [LSF/MM TOPIC] Discuss least bad options for resolving
 longterm-GUP usage by RDMA
Date: Thu, 14 Feb 2019 15:26:22 -0500
Message-ID: <20190214202622.GB3420@redhat.com>
References: <0c868bc615a60c44d618fb0183fcbe0c418c7c83.camel@redhat.com>
 <CAPcyv4hqya1iKCfHJRXQJRD4qXZa3VjkoKGw6tEvtWNkKVbP+A@mail.gmail.com>
 <bfe0fdd5400d41d223d8d30142f56a9c8efc033d.camel@redhat.com>
 <01000168c8e2de6b-9ab820ed-38ad-469c-b210-60fcff8ea81c-000000@email.amazonses.com>
 <20190208044302.GA20493@dastard>
 <20190208111028.GD6353@quack2.suse.cz>
 <CAPcyv4iVtBfO8zWZU3LZXLqv-dha1NSG+2+7MvgNy9TibCy4Cw@mail.gmail.com>
 <20190211102402.GF19029@quack2.suse.cz>
 <CAPcyv4iHso+PqAm-4NfF0svoK4mELJMSWNp+vsG43UaW1S2eew@mail.gmail.com>
 <20190211180654.GB24692@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190211180654.GB24692@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, Christopher Lameter <cl@linux.com>, Doug Ledford <dledford@redhat.com>, Matthew Wilcox <willy@infradead.org>, Ira Weiny <ira.weiny@intel.com>, lsf-pc@lists.linux-foundation.org, linux-rdma <linux-rdma@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, John Hubbard <jhubbard@nvidia.com>, Michal Hocko <mhocko@kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 11, 2019 at 11:06:54AM -0700, Jason Gunthorpe wrote:
> On Mon, Feb 11, 2019 at 09:22:58AM -0800, Dan Williams wrote:
> 
> > I honestly don't like the idea that random subsystems can pin down
> > file blocks as a side effect of gup on the result of mmap. Recall that
> > it's not just RDMA that wants this guarantee. It seems safer to have
> > the file be in an explicit block-allocation-immutable-mode so that the
> > fallocate man page can describe this error case. Otherwise how would
> > you describe the scenarios under which FALLOC_FL_PUNCH_HOLE fails?
> 
> I rather liked CL's version of this - ftruncate/etc is simply racing
> with a parallel pwrite - and it doesn't fail.
> 
> But it also doesnt' trucate/create a hole. Another thread wrote to it
> right away and the 'hole' was essentially instantly reallocated. This
> is an inherent, pre-existing, race in the ftrucate/etc APIs.

So it is kind of a // point to this, but direct I/O do "truncate" pages
or more exactly after a write direct I/O invalidate_inode_pages2_range()
is call and it will try to unmap and remove from page cache all pages
that have been written too.

So we probably want to think about what we want to do here if a device
like RDMA has also pin those pages. Do we want to abort the invalidate ?
Which would mean that then the direct I/O write was just a pointless
exercise. Do we want to not direct I/O but instead memcpy into page
cache memory ? Then you are just ignoring the direct I/O property of
the write. Or do we want to both direct I/O to the block and also
do a memcopy to the page so that we preserve the direct I/O semantics ?

I would probably go with the last one. In any cases we will need to
update the direct I/O code to handle GUPed page cache page.

Cheers,
Jérôme
