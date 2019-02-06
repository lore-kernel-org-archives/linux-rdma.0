From: Christopher Lameter <cl@linux.com>
Subject: Re: [LSF/MM TOPIC] Discuss least bad options for resolving longterm-GUP
 usage by RDMA
Date: Wed, 6 Feb 2019 20:24:17 +0000
Message-ID: <01000168c47b8b6a-ba1b2cd5-0a53-4367-a296-aa0b0ba26359-000000@email.amazonses.com>
References: <20190205175059.GB21617@iweiny-DESK2.sc.intel.com> <20190206095000.GA12006@quack2.suse.cz> <20190206173114.GB12227@ziepe.ca> <20190206175233.GN21860@bombadil.infradead.org> <47820c4d696aee41225854071ec73373a273fd4a.camel@redhat.com>
 <01000168c43d594c-7979fcf8-b9c1-4bda-b29a-500efe001d66-000000@email.amazonses.com> <20190206194055.GP21860@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190206194055.GP21860@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>
Cc: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Jan Kara <jack@suse.cz>, Ira Weiny <ira.weiny@intel.com>, lsf-pc@lists.linux-foundation.org, linux-rdma@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>, Jerome Glisse <jglisse@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Michal Hocko <mhocko@kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 6 Feb 2019, Matthew Wilcox wrote:

> >
> > Coming in late here too but isnt the only DAX case that we are concerned
> > about where there was an mmap with the O_DAX option to do direct write
>
> There is no O_DAX option.  There's mount -o dax, but there's nothing that
> a program does to say "Use DAX".

Hmmm... I thought that a file handle must have a special open mode to
actually to a dax map. Looks like that is not the case.

> > though? If we only allow this use case then we may not have to worry about
> > long term GUP because DAX mapped files will stay in the physical location
> > regardless.
>
> ... except for truncate.  And now that I think about it, there was a
> desire to support hot-unplug which also needed revoke.

Well but that requires that the application unmaps the file.

> > Maybe we can solve the long term GUP problem through the requirement that
> > user space acquires some sort of means to pin the pages? In the DAX case
> > this is given by the filesystem and the hardware will basically take care
> > of writeback.
>
> It's not given by the filesystem.

DAX provides a mapping to physical persistent memory that
does not go away. Or its a block device.

>
> > In case of anonymous memory this can be guaranteed otherwise and is less
> > critical since these pages are not part of the pagecache and are not
> > subject to writeback.
>
> but are subject to being swapped out?

Well that is controlled by mlock and could also involve other means like
disabling swap.
