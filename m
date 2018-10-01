From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/4] infiniband/mm: convert to the new put_user_page()
 call
Date: Mon, 1 Oct 2018 08:51:46 -0700
Message-ID: <20181001155146.GA30236@infradead.org>
References: <20180928053949.5381-1-jhubbard@nvidia.com>
 <20180928053949.5381-3-jhubbard@nvidia.com>
 <20180928153922.GA17076@ziepe.ca>
 <36bc65a3-8c2a-87df-44fc-89a1891b86db@nvidia.com>
 <20180929162117.GA31216@bombadil.infradead.org>
 <20181001125013.GA6357@infradead.org>
 <20181001152929.GA21881@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181001152929.GA21881@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>, John Hubbard <jhubbard@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, john.hubbard@gmail.com, Michal Hocko <mhocko@kernel.org>, Christopher Lameter <cl@linux.com>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-fsdevel@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Christian Benvenuti <benve@cisco.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 01, 2018 at 08:29:29AM -0700, Matthew Wilcox wrote:
> I don't understand the dislike of the sg list.  Other than for special
> cases which we should't be optimising for (ramfs, brd, loopback
> filesystems), when we get a page to do I/O, we're going to want a dma
> mapping for them.  It makes sense to already allocate space to store
> the mapping at the outset.

We don't actually need the space - the scatterlist forces it on us,
otherwise we could translate directly in the on-disk format and
save that duplicate space.  I have prototypes for NVMe and RDMA that do
away with the scatterlist entirely.

And even if we are still using the scatterlist as we do right now we'd
need a second scatterlist at least for block / file system based I/O
as we can't plug the scatterlist into the I/O stack (nevermind that
due to splitting merging the lower one might not map 1:1 to the upper
one).

> [1] Can we ever admit that the bio_vec and the skb_frag_t are actually
> the same thing?

When I brought this up years ago the networking folks insisted that
their use of u16 offset/size fields was important for performance,
while for bio_vecs we needed the larger ones for some cases.  Since
then networking switched to 32-bit fields for what is now the fast
path, so it might be worth to give it another spin.

Than should also help with using my new bio_vec based dma-mapping
helpers to batch iommu mappings in networking, which Jesper had on
his todo list as all the indirect calls are causing performance
issues.
