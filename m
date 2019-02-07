From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [LSF/MM TOPIC] Discuss least bad options for resolving
 longterm-GUP usage by RDMA
Date: Thu, 7 Feb 2019 10:26:22 -0700
Message-ID: <20190207172622.GF22726@ziepe.ca>
References: <20190206173114.GB12227@ziepe.ca>
 <20190206175233.GN21860@bombadil.infradead.org>
 <47820c4d696aee41225854071ec73373a273fd4a.camel@redhat.com>
 <01000168c43d594c-7979fcf8-b9c1-4bda-b29a-500efe001d66-000000@email.amazonses.com>
 <20190206210356.GZ6173@dastard>
 <20190206220828.GJ12227@ziepe.ca>
 <0c868bc615a60c44d618fb0183fcbe0c418c7c83.camel@redhat.com>
 <CAPcyv4hqya1iKCfHJRXQJRD4qXZa3VjkoKGw6tEvtWNkKVbP+A@mail.gmail.com>
 <bfe0fdd5400d41d223d8d30142f56a9c8efc033d.camel@redhat.com>
 <20190207172405.GY21860@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190207172405.GY21860@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>
Cc: Doug Ledford <dledford@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Christopher Lameter <cl@linux.com>, Jan Kara <jack@suse.cz>, Ira Weiny <ira.weiny@intel.com>, lsf-pc@lists.linux-foundation.org, linux-rdma <linux-rdma@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, John Hubbard <jhubbard@nvidia.com>, Jerome Glisse <jglisse@redhat.com>, Michal Hocko <mhocko@kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 07, 2019 at 09:24:05AM -0800, Matthew Wilcox wrote:
> On Thu, Feb 07, 2019 at 11:25:35AM -0500, Doug Ledford wrote:
> > * Really though, as I said in my email to Tom Talpey, this entire
> > situation is simply screaming that we are doing DAX networking wrong. 
> > We shouldn't be writing the networking code once in every single
> > application that wants to do this.  If we had a memory segment that we
> > shared from server to client(s), and in that memory segment we
> > implemented a clustered filesystem, then applications would simply mmap
> > local files and be done with it.  If the file needed to move, the kernel
> > would update the mmap in the application, done.  If you ask me, it is
> > the attempt to do this the wrong way that is resulting in all this
> > heartache.  That said, for today, my recommendation would be to require
> > ODP hardware for XFS filesystem with the DAX option, but allow ext2
> > filesystems to mount DAX filesystems on non-ODP hardware, and go in and
> > modify the ext2 filesystem so that on DAX mounts, it disables hole punch
> > and ftrunctate any time they would result in the forced removal of an
> > established mmap.
> 
> I agree that something's wrong, but I think the fundamental problem is
> that there's no concept in RDMA of having an STag for storage rather
> than for memory.
> 
> Imagine if we could associate an STag with a file descriptor on the
> server.  The client could then perform an RDMA to that STag.  On the
> server, we'd need lots of smarts in the card and in the OS to know how
> to treat that packet on arrival -- depending on what the file descriptor
> referred to, it might only have to write into the page cache, or it
> might set up an NVMe DMA, or it might resolve the underlying physical
> address and DMA directly to an NV-DIMM.

I think you just described ODP MRs.

Jason
