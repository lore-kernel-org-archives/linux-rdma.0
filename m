From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] mm: set PG_dma_pinned on get_user_pages*()
Date: Wed, 27 Jun 2018 13:53:49 +0200
Message-ID: <20180627115349.cu2k3ainqqdrrepz@quack2.suse.cz>
References: <CAPcyv4gayKk_zHDYAvntware12qMXWjnnL_FDJNUQsJS_zNfDw@mail.gmail.com>
 <311eba48-60f1-b6cc-d001-5cc3ed4d76a9@nvidia.com>
 <20180618081258.GB16991@lst.de>
 <d4817192-6db0-2f3f-7c67-6078b69686d3@nvidia.com>
 <CAPcyv4iacHYxGmyWokFrVsmxvLj7=phqp2i0tv8z6AT-mYuEEA@mail.gmail.com>
 <3898ef6b-2fa0-e852-a9ac-d904b47320d5@nvidia.com>
 <CAPcyv4iRBzmwWn_9zDvqdfVmTZL_Gn7uA_26A1T-kJib=84tvA@mail.gmail.com>
 <20180626134757.GY28965@dhcp22.suse.cz>
 <20180626164825.fz4m2lv6hydbdrds@quack2.suse.cz>
 <20180627113221.GO32348@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180627113221.GO32348@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Dan Williams <dan.j.williams@intel.com>, John Hubbard <jhubbard@nvidia.com>, Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <john.hubbard@gmail.com>, Matthew Wilcox <willy@infradead.org>, Christopher Lameter <cl@linux.com>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Wed 27-06-18 13:32:21, Michal Hocko wrote:
> On Tue 26-06-18 18:48:25, Jan Kara wrote:
> > On Tue 26-06-18 15:47:57, Michal Hocko wrote:
> > > On Mon 18-06-18 12:21:46, Dan Williams wrote:
> > > [...]
> > > > I do think we should explore a page flag for pages that are "long
> > > > term" pinned. Michal asked for something along these lines at LSF / MM
> > > > so that the core-mm can give up on pages that the kernel has lost
> > > > lifetime control. Michal, did I capture your ask correctly?
> > > 
> > > I am sorry to be late. I didn't ask for a page flag exactly. I've asked
> > > for a way to query for the pin to be temporal or permanent. How that is
> > > achieved is another question. Maybe we have some more spare room after
> > > recent struct page reorganization but I dunno, to be honest. Maybe we
> > > can have an _count offset for these longterm pins. It is not like we are
> > > using the whole ref count space, right?
> > 
> > Matthew had an interesting idea to pull pinned pages completely out from
> > any LRU and reuse that space in struct page for pinned refcounts. From some
> > initial investigation (read on elsewhere in this thread) it looks doable. I
> > was considering offsetting in refcount as well but on 32-bit architectures
> > there's not that many bits that I'd be really comfortable with that
> > solution...
> 
> I am really slow at following up this discussion. The problem I would
> see with off-lru pages is that this can quickly turn into a weird
> reclaim behavior. Especially when we are talking about a lot of memory.
> It is true that such pages wouldn't be reclaimable directly but could
> poke them in some way if we see too many of them while scanning LRU.
> 
> Not that this is a fundamental block stopper but this is the first thing
> that popped out when thinking about such a solution. Maybe it is a good
> start though.
> 
> Appart from that, do we really care about 32b here? Big DIO, IB users
> seem to be 64b only AFAIU.

IMO it is a bad habit to leave unpriviledged-user-triggerable oops in the
kernel even for uncommon platforms...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
