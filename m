From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/4] infiniband/mm: convert to the new put_user_page()
 call
Date: Mon, 1 Oct 2018 05:50:13 -0700
Message-ID: <20181001125013.GA6357@infradead.org>
References: <20180928053949.5381-1-jhubbard@nvidia.com>
 <20180928053949.5381-3-jhubbard@nvidia.com>
 <20180928153922.GA17076@ziepe.ca>
 <36bc65a3-8c2a-87df-44fc-89a1891b86db@nvidia.com>
 <20180929162117.GA31216@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180929162117.GA31216@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>
Cc: John Hubbard <jhubbard@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, john.hubbard@gmail.com, Michal Hocko <mhocko@kernel.org>, Christopher Lameter <cl@linux.com>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-fsdevel@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Christian Benvenuti <benve@cisco.com>
List-Id: linux-rdma@vger.kernel.org

On Sat, Sep 29, 2018 at 09:21:17AM -0700, Matthew Wilcox wrote:
> > being slow to pick it up. It looks like there are several patterns, and
> > we have to support both set_page_dirty() and set_page_dirty_lock(). So
> > the best combination looks to be adding a few variations of
> > release_user_pages*(), but leaving put_user_page() alone, because it's
> > the "do it yourself" basic one. Scatter-gather will be stuck with that.
> 
> I think our current interfaces are wrong.  We should really have a
> get_user_sg() / put_user_sg() function that will set up / destroy an
> SG list appropriate for that range of user memory.  This is almost
> orthogonal to the original intent here, so please don't see this as a
> "must do first" kind of argument that might derail the whole thing.

The SG list really is the wrong interface, as it mixes up information
about the pages/phys addr range and a potential dma mapping.  I think
the right interface is an array of bio_vecs.  In fact I've recently
been looking into a get_user_pages variant that does fill bio_vecs,
as it fundamentally is the right thing for doing I/O on large pages,
and will really help with direct I/O performance in that case.
