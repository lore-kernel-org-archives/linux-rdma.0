From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v4 2/3] mm: introduce put_user_page*(), placeholder
 versions
Date: Tue, 9 Oct 2018 10:30:25 +0200
Message-ID: <20181009083025.GE11150@quack2.suse.cz>
References: <20181008211623.30796-1-jhubbard@nvidia.com>
 <20181008211623.30796-3-jhubbard@nvidia.com>
 <20181008171442.d3b3a1ea07d56c26d813a11e@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181008171442.d3b3a1ea07d56c26d813a11e@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: john.hubbard@gmail.com, Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@kernel.org>, Christopher Lameter <cl@linux.com>, Jason Gunthorpe <jgg@ziepe.ca>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-fsdevel@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>, Al Viro <viro@zeniv.linux.org.uk>, Jerome Glisse <jglisse@redhat.com>, Christoph Hellwig <hch@infradead.org>, Ralph Campbell <rcampbell@nvidia.com>
List-Id: linux-rdma@vger.kernel.org

On Mon 08-10-18 17:14:42, Andrew Morton wrote:
> On Mon,  8 Oct 2018 14:16:22 -0700 john.hubbard@gmail.com wrote:
> > +		put_user_page(pages[index]);
> > +	}
> > +}
> > +
> > +static inline void put_user_pages(struct page **pages,
> > +				  unsigned long npages)
> > +{
> > +	unsigned long index;
> > +
> > +	for (index = 0; index < npages; index++)
> > +		put_user_page(pages[index]);
> > +}
> > +
> 
> Otherwise looks OK.  Ish.  But it would be nice if that comment were to
> explain *why* get_user_pages() pages must be released with
> put_user_page().

The reason is that eventually we want to track reference from GUP
separately but you're right that it would be good to have a comment about
that somewhere.

> Also, maintainability.  What happens if someone now uses put_page() by
> mistake?  Kernel fails in some mysterious fashion?  How can we prevent
> this from occurring as code evolves?  Is there a cheap way of detecting
> this bug at runtime?

The same will happen as with any other reference counting bug - the special
user reference will leak. It will be pretty hard to debug I agree. I was
thinking about whether we could provide some type safety against such bugs
such as get_user_pages() not returning struct page pointers but rather some
other special type but it would result in a big amount of additional churn
as we'd have to propagate this different type e.g. through the IO path so
that IO completion routines could properly call put_user_pages(). So I'm
not sure it's really worth it.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
