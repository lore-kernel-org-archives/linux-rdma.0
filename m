From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v4 2/3] mm: introduce put_user_page*(), placeholder
 versions
Date: Tue, 9 Oct 2018 16:20:12 -0700
Message-ID: <20181009162012.c662ef0b041993557e150035@linux-foundation.org>
References: <20181008211623.30796-1-jhubbard@nvidia.com>
        <20181008211623.30796-3-jhubbard@nvidia.com>
        <20181008171442.d3b3a1ea07d56c26d813a11e@linux-foundation.org>
        <20181009083025.GE11150@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181009083025.GE11150@quack2.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: john.hubbard@gmail.com, Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@kernel.org>, Christopher Lameter <cl@linux.com>, Jason Gunthorpe <jgg@ziepe.ca>, Dan Williams <dan.j.williams@intel.com>, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-fsdevel@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>, Al Viro <viro@zeniv.linux.org.uk>, Jerome Glisse <jglisse@redhat.com>, Christoph Hellwig <hch@infradead.org>, Ralph Campbell <rcampbell@nvidia.com>
List-Id: linux-rdma@vger.kernel.org

On Tue, 9 Oct 2018 10:30:25 +0200 Jan Kara <jack@suse.cz> wrote:

> > Also, maintainability.  What happens if someone now uses put_page() by
> > mistake?  Kernel fails in some mysterious fashion?  How can we prevent
> > this from occurring as code evolves?  Is there a cheap way of detecting
> > this bug at runtime?
> 
> The same will happen as with any other reference counting bug - the special
> user reference will leak. It will be pretty hard to debug I agree. I was
> thinking about whether we could provide some type safety against such bugs
> such as get_user_pages() not returning struct page pointers but rather some
> other special type but it would result in a big amount of additional churn
> as we'd have to propagate this different type e.g. through the IO path so
> that IO completion routines could properly call put_user_pages(). So I'm
> not sure it's really worth it.

I'm not really understanding.  Patch 3/3 changes just one infiniband
driver to use put_user_page().  But the changelogs here imply (to me)
that every user of get_user_pages() needs to be converted to
s/put_page/put_user_page/.

Methinks a bit more explanation is needed in these changelogs?
