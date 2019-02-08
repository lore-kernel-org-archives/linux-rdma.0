From: Christopher Lameter <cl@linux.com>
Subject: Re: [LSF/MM TOPIC] Discuss least bad options for resolving longterm-GUP
 usage by RDMA
Date: Fri, 8 Feb 2019 15:33:48 +0000
Message-ID: <01000168cdbe520b-2b2be741-8ceb-4a5d-92f2-9f68795d7db3-000000@email.amazonses.com>
References: <20190206173114.GB12227@ziepe.ca> <20190206175233.GN21860@bombadil.infradead.org> <47820c4d696aee41225854071ec73373a273fd4a.camel@redhat.com> <01000168c43d594c-7979fcf8-b9c1-4bda-b29a-500efe001d66-000000@email.amazonses.com> <20190206210356.GZ6173@dastard>
 <20190206220828.GJ12227@ziepe.ca> <0c868bc615a60c44d618fb0183fcbe0c418c7c83.camel@redhat.com> <CAPcyv4hqya1iKCfHJRXQJRD4qXZa3VjkoKGw6tEvtWNkKVbP+A@mail.gmail.com> <bfe0fdd5400d41d223d8d30142f56a9c8efc033d.camel@redhat.com>
 <01000168c8e2de6b-9ab820ed-38ad-469c-b210-60fcff8ea81c-000000@email.amazonses.com> <20190208044302.GA20493@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190208044302.GA20493@dastard>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Doug Ledford <dledford@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Ira Weiny <ira.weiny@intel.com>, lsf-pc@lists.linux-foundation.org, linux-rdma <linux-rdma@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, John Hubbard <jhubbard@nvidia.com>, Jerome Glisse <jglisse@redhat.com>, Michal Hocko <mhocko@kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 8 Feb 2019, Dave Chinner wrote:

> On Thu, Feb 07, 2019 at 04:55:37PM +0000, Christopher Lameter wrote:
> > One approach that may be a clean way to solve this:
> > 3. Filesystems that allow bypass of the page cache (like XFS / DAX) will
> >    provide the virtual mapping when the PIN is done and DO NO OPERATIONS
> >    on the longterm pinned range until the long term pin is removed.
>
> So, ummm, how do we do block allocation then, which is done on
> demand during writes?

If a memory region is mapped by RDMA then this is essentially a long
write. The allocation needs to happen then.

> IOWs, this requires the application to set up the file in the
> correct state for the filesystem to lock it down so somebody else
> can write to it.  That means the file can't be sparse, it can't be
> preallocated (i.e. can't contain unwritten extents), it must have zeroes
> written to it's full size before being shared because otherwise it
> exposes stale data to the remote client (secure sites are going to
> love that!), they can't be extended, etc.

Yes. That is required.

> IOWs, once the file is prepped and leased out for RDMA, it becomes
> an immutable for the purposes of local access.

The contents are mutable but the mapping to the physical medium is
immutable.


> Which, essentially we can already do. Prep the file, map it
> read/write, mark it immutable, then pin it via the longterm gup
> interface which can do the necessary checks.
>
> Simple to implement, the reasons for errors trying to modify the
> file are already documented and queriable, and it's hard for
> applications to get wrong.

Yup. Why not do it this way? Just make the sections actually long term GUP
mapped inmutable and not subject to the other page cache things.

This is basically a straight through bypass of the page cache for a file.

HEY! It may be used to map huge pages in the future too!!
