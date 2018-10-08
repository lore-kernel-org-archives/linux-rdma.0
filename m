From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v3 2/3] mm: introduce put_user_page*(), placeholder
 versions
Date: Mon, 8 Oct 2018 18:49:07 +0200
Message-ID: <20181008164907.GA11150@quack2.suse.cz>
References: <20181006024949.20691-1-jhubbard@nvidia.com>
 <20181006024949.20691-3-jhubbard@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181006024949.20691-3-jhubbard@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
To: john.hubbard@gmail.com
Cc: Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@kernel.org>, Christopher Lameter <cl@linux.com>, Jason Gunthorpe <jgg@ziepe.ca>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-fsdevel@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>, Al Viro <viro@zeniv.linux.org.uk>, Jerome Glisse <jglisse@redhat.com>, Christoph Hellwig <hch@infradead.org>, Ralph Campbell <rcampbell@nvidia.com>
List-Id: linux-rdma@vger.kernel.org

On Fri 05-10-18 19:49:48, john.hubbard@gmail.com wrote:
> From: John Hubbard <jhubbard@nvidia.com>
> 
> Introduces put_user_page(), which simply calls put_page().
> This provides a way to update all get_user_pages*() callers,
> so that they call put_user_page(), instead of put_page().
> 
> Also introduces put_user_pages(), and a few dirty/locked variations,
> as a replacement for release_pages(), and also as a replacement
> for open-coded loops that release multiple pages.
> These may be used for subsequent performance improvements,
> via batching of pages to be released.
> 
> This prepares for eventually fixing the problem described
> in [1], and is following a plan listed in [2], [3], [4].
> 
> [1] https://lwn.net/Articles/753027/ : "The Trouble with get_user_pages()"
> 
> [2] https://lkml.kernel.org/r/20180709080554.21931-1-jhubbard@nvidia.com
>     Proposed steps for fixing get_user_pages() + DMA problems.
> 
> [3]https://lkml.kernel.org/r/20180710082100.mkdwngdv5kkrcz6n@quack2.suse.cz
>     Bounce buffers (otherwise [2] is not really viable).
> 
> [4] https://lkml.kernel.org/r/20181003162115.GG24030@quack2.suse.cz
>     Follow-up discussions.
> 
> CC: Matthew Wilcox <willy@infradead.org>
> CC: Michal Hocko <mhocko@kernel.org>
> CC: Christopher Lameter <cl@linux.com>
> CC: Jason Gunthorpe <jgg@ziepe.ca>
> CC: Dan Williams <dan.j.williams@intel.com>
> CC: Jan Kara <jack@suse.cz>
> CC: Al Viro <viro@zeniv.linux.org.uk>
> CC: Jerome Glisse <jglisse@redhat.com>
> CC: Christoph Hellwig <hch@infradead.org>
> CC: Ralph Campbell <rcampbell@nvidia.com>
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
> ---
>  include/linux/mm.h | 48 ++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 46 insertions(+), 2 deletions(-)

Looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

Just one nit below:

> +/* Pages that were pinned via get_user_pages*() should be released via
> + * either put_user_page(), or one of the put_user_pages*() routines
> + * below.
> + */

Multi-line comments usually follow formatting:

/*
 * Some text here
 * and more text here...
 */

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
