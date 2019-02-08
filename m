From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [LSF/MM TOPIC] Discuss least bad options for resolving
 longterm-GUP usage by RDMA
Date: Fri, 8 Feb 2019 12:50:37 -0800
Message-ID: <CAPcyv4iVtBfO8zWZU3LZXLqv-dha1NSG+2+7MvgNy9TibCy4Cw@mail.gmail.com>
References: <20190206175233.GN21860@bombadil.infradead.org>
 <47820c4d696aee41225854071ec73373a273fd4a.camel@redhat.com>
 <01000168c43d594c-7979fcf8-b9c1-4bda-b29a-500efe001d66-000000@email.amazonses.com>
 <20190206210356.GZ6173@dastard> <20190206220828.GJ12227@ziepe.ca>
 <0c868bc615a60c44d618fb0183fcbe0c418c7c83.camel@redhat.com>
 <CAPcyv4hqya1iKCfHJRXQJRD4qXZa3VjkoKGw6tEvtWNkKVbP+A@mail.gmail.com>
 <bfe0fdd5400d41d223d8d30142f56a9c8efc033d.camel@redhat.com>
 <01000168c8e2de6b-9ab820ed-38ad-469c-b210-60fcff8ea81c-000000@email.amazonses.com>
 <20190208044302.GA20493@dastard> <20190208111028.GD6353@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190208111028.GD6353@quack2.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>, Christopher Lameter <cl@linux.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Matthew Wilcox <willy@infradead.org>, Ira Weiny <ira.weiny@intel.com>, lsf-pc@lists.linux-foundation.org, linux-rdma <linux-rdma@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, John Hubbard <jhubbard@nvidia.com>, Jerome Glisse <jglisse@redhat.com>, Michal Hocko <mhocko@kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Feb 8, 2019 at 3:11 AM Jan Kara <jack@suse.cz> wrote:
>
> On Fri 08-02-19 15:43:02, Dave Chinner wrote:
> > On Thu, Feb 07, 2019 at 04:55:37PM +0000, Christopher Lameter wrote:
> > > One approach that may be a clean way to solve this:
> > > 3. Filesystems that allow bypass of the page cache (like XFS / DAX) will
> > >    provide the virtual mapping when the PIN is done and DO NO OPERATIONS
> > >    on the longterm pinned range until the long term pin is removed.
> >
> > So, ummm, how do we do block allocation then, which is done on
> > demand during writes?
> >
> > IOWs, this requires the application to set up the file in the
> > correct state for the filesystem to lock it down so somebody else
> > can write to it.  That means the file can't be sparse, it can't be
> > preallocated (i.e. can't contain unwritten extents), it must have zeroes
> > written to it's full size before being shared because otherwise it
> > exposes stale data to the remote client (secure sites are going to
> > love that!), they can't be extended, etc.
> >
> > IOWs, once the file is prepped and leased out for RDMA, it becomes
> > an immutable for the purposes of local access.
> >
> > Which, essentially we can already do. Prep the file, map it
> > read/write, mark it immutable, then pin it via the longterm gup
> > interface which can do the necessary checks.
>
> Hum, and what will you do if the immutable file that is target for RDMA
> will be a source of reflink? That seems to be currently allowed for
> immutable files but RDMA store would be effectively corrupting the data of
> the target inode. But we could treat it similarly as swapfiles - those also
> have to deal with writes to blocks beyond filesystem control. In fact the
> similarity seems to be quite large there. What do you think?

This sounds so familiar...

    https://lwn.net/Articles/726481/

I'm not opposed to trying again, but leases was what crawled out
smoking crater when this last proposal was nuked.
