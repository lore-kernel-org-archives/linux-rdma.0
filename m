From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [LSF/MM TOPIC] Discuss least bad options for resolving
 longterm-GUP usage by RDMA
Date: Wed, 6 Feb 2019 11:40:55 -0800
Message-ID: <20190206194055.GP21860@bombadil.infradead.org>
References: <20190205175059.GB21617@iweiny-DESK2.sc.intel.com>
 <20190206095000.GA12006@quack2.suse.cz>
 <20190206173114.GB12227@ziepe.ca>
 <20190206175233.GN21860@bombadil.infradead.org>
 <47820c4d696aee41225854071ec73373a273fd4a.camel@redhat.com>
 <01000168c43d594c-7979fcf8-b9c1-4bda-b29a-500efe001d66-000000@email.amazonses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <01000168c43d594c-7979fcf8-b9c1-4bda-b29a-500efe001d66-000000@email.amazonses.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Christopher Lameter <cl@linux.com>
Cc: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Jan Kara <jack@suse.cz>, Ira Weiny <ira.weiny@intel.com>, lsf-pc@lists.linux-foundation.org, linux-rdma@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>, Jerome Glisse <jglisse@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Michal Hocko <mhocko@kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 06, 2019 at 07:16:21PM +0000, Christopher Lameter wrote:
> On Wed, 6 Feb 2019, Doug Ledford wrote:
> > > Most of the cases we want revoke for are things like truncate().
> > > Shouldn't happen with a sane system, but we're trying to avoid users
> > > doing awful things like being able to DMA to pages that are now part of
> > > a different file.
> >
> > Why is the solution revoke then?  Is there something besides truncate
> > that we have to worry about?  I ask because EBUSY is not currently
> > listed as a return value of truncate, so extending the API to include
> > EBUSY to mean "this file has pinned pages that can not be freed" is not
> > (or should not be) totally out of the question.
> >
> > Admittedly, I'm coming in late to this conversation, but did I miss the
> > portion where that alternative was ruled out?
> 
> Coming in late here too but isnt the only DAX case that we are concerned
> about where there was an mmap with the O_DAX option to do direct write

There is no O_DAX option.  There's mount -o dax, but there's nothing that
a program does to say "Use DAX".

> though? If we only allow this use case then we may not have to worry about
> long term GUP because DAX mapped files will stay in the physical location
> regardless.

... except for truncate.  And now that I think about it, there was a
desire to support hot-unplug which also needed revoke.

> Maybe we can solve the long term GUP problem through the requirement that
> user space acquires some sort of means to pin the pages? In the DAX case
> this is given by the filesystem and the hardware will basically take care
> of writeback.

It's not given by the filesystem.

> In case of anonymous memory this can be guaranteed otherwise and is less
> critical since these pages are not part of the pagecache and are not
> subject to writeback.

but are subject to being swapped out?
