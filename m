From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [LSF/MM TOPIC] Discuss least bad options for resolving
 longterm-GUP usage by RDMA
Date: Wed, 6 Feb 2019 16:41:32 -0700
Message-ID: <20190206234132.GB15234@ziepe.ca>
References: <20190206173114.GB12227@ziepe.ca>
 <20190206175233.GN21860@bombadil.infradead.org>
 <47820c4d696aee41225854071ec73373a273fd4a.camel@redhat.com>
 <01000168c43d594c-7979fcf8-b9c1-4bda-b29a-500efe001d66-000000@email.amazonses.com>
 <20190206210356.GZ6173@dastard>
 <20190206220828.GJ12227@ziepe.ca>
 <0c868bc615a60c44d618fb0183fcbe0c418c7c83.camel@redhat.com>
 <CAPcyv4hqya1iKCfHJRXQJRD4qXZa3VjkoKGw6tEvtWNkKVbP+A@mail.gmail.com>
 <20190206232130.GK12227@ziepe.ca>
 <CAPcyv4g2r=L3jfSDoRPt4VG7D_2CxCgv3s+JLu4FQRUSRWg+4Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPcyv4g2r=L3jfSDoRPt4VG7D_2CxCgv3s+JLu4FQRUSRWg+4Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Doug Ledford <dledford@redhat.com>, Dave Chinner <david@fromorbit.com>, Christopher Lameter <cl@linux.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Ira Weiny <ira.weiny@intel.com>, lsf-pc@lists.linux-foundation.org, linux-rdma <linux-rdma@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, John Hubbard <jhubbard@nvidia.com>, Jerome Glisse <jglisse@redhat.com>, Michal Hocko <mhocko@kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 06, 2019 at 03:30:27PM -0800, Dan Williams wrote:
> On Wed, Feb 6, 2019 at 3:21 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> >
> > On Wed, Feb 06, 2019 at 02:44:45PM -0800, Dan Williams wrote:
> >
> > > > Do they need to stick with xfs?
> > >
> > > Can you clarify the motivation for that question? This problem exists
> > > for any filesystem that implements an mmap that where the physical
> > > page backing the mapping is identical to the physical storage location
> > > for the file data.
> >
> > .. and needs to dynamicaly change that mapping. Which is not really
> > something inherent to the general idea of a filesystem. A file system
> > that had *strictly static* block assignments would work fine.
> >
> > Not all filesystem even implement hole punch.
> >
> > Not all filesystem implement reflink.
> >
> > ftruncate doesn't *have* to instantly return the free blocks to
> > allocation pool.
> >
> > ie this is not a DAX & RDMA issue but a XFS & RDMA issue.
> >
> > Replacing XFS is probably not be reasonable, but I wonder if a XFS--
> > operating mode could exist that had enough features removed to be
> > safe?
> 
> You're describing the current situation, i.e. Linux already implements
> this, it's called Device-DAX and some users of RDMA find it
> insufficient. The choices are to continue to tell them "no", or say
> "yes, but you need to submit to lease coordination".

Device-DAX is not what I'm imagining when I say XFS--.

I mean more like XFS with all features that require rellocation of
blocks disabled.

Forbidding hold punch, reflink, cow, etc, doesn't devolve back to
device-dax.

Jason
