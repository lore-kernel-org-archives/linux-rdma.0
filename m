From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/4] get_user_pages*() and RDMA: first steps
Date: Mon, 1 Oct 2018 05:47:57 -0700
Message-ID: <20181001124757.GA26218@infradead.org>
References: <20180928053949.5381-1-jhubbard@nvidia.com>
 <20180928152958.GA3321@redhat.com>
 <4c884529-e2ff-3808-9763-eb0e71f5a616@nvidia.com>
 <20180928214934.GA3265@redhat.com>
 <dfa6aaef-b97e-ebd4-6cc8-c907a7b3f9bb@nvidia.com>
 <20180929084608.GA3188@redhat.com>
 <20181001061127.GQ31060@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181001061127.GQ31060@dastard>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Jerome Glisse <jglisse@redhat.com>, John Hubbard <jhubbard@nvidia.com>, john.hubbard@gmail.com, Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@kernel.org>, Christopher Lameter <cl@linux.com>, Jason Gunthorpe <jgg@ziepe.ca>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-fsdevel@vger.kernel.org, Christian Benvenuti <benve@cisco.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Doug Ledford <dledford@redhat.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 01, 2018 at 04:11:27PM +1000, Dave Chinner wrote:
> This reminds me so much of Linux mmap() in the mid-2000s - mmap()
> worked for ext3 without being aware of page faults,

And "worked" still is a bit of a stretch, as soon as you'd get
ENOSPC it would still blow up badly.  Which probably makes it an
even better analogy to the current case.

> RDMA does not call ->page_mkwrite on clean file backed pages before it
> writes to them and calls set_page_dirty(), and hence RDMA to file
> backed pages is completely unreliable. I'm not sure this can be
> solved without having page fault capable RDMA hardware....

We can always software prefault at gup time.  And also remember that
while RDMA might be the case at least some people care about here it
really isn't different from any of the other gup + I/O cases, including
doing direct I/O to a mmap area.  The only difference in the various
cases is how long the area should be pinned down - some users like RDMA
want a long term mapping, while others like direct I/O just need a short
transient one.

> We could address these use-after-free situations via forcing RDMA to
> use file layout leases and revoke the lease when we need to modify
> the backing store on leased files. However, this doesn't solve the
> need for filesystems to receive write fault notifications via
> ->page_mkwrite.

Exactly.   We need three things here:

 - notification to the filesystem that a page is (possibly) beeing
   written to
 - a way to to block fs operations while the pages are pinned
 - a way to distinguish between short and long term mappings,
   and only allow long terms mappings if they can be broken
   using something like leases

I'm also pretty sure we already explained this a long time ago when the
issue came up last year, so I'm not sure why this is even still
contentious.
