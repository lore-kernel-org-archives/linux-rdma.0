From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/2] mm: set PG_dma_pinned on get_user_pages*()
Date: Mon, 18 Jun 2018 10:12:58 +0200
Message-ID: <20180618081258.GB16991@lst.de>
References: <20180617012510.20139-1-jhubbard@nvidia.com> <20180617012510.20139-3-jhubbard@nvidia.com> <CAPcyv4i=eky-QrPcLUEqjsASuRUrFEWqf79hWe0mU8xtz6Jk-w@mail.gmail.com> <20180617200432.krw36wrcwidb25cj@ziepe.ca> <CAPcyv4gayKk_zHDYAvntware12qMXWjnnL_FDJNUQsJS_zNfDw@mail.gmail.com> <311eba48-60f1-b6cc-d001-5cc3ed4d76a9@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <311eba48-60f1-b6cc-d001-5cc3ed4d76a9@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Hubbard <jhubbard@nvidia.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>, john.hubbard@gmail.com, Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@kernel.org>, Christopher Lameter <cl@linux.com>, Jan Kara <jack@suse.cz>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-rdma@vger.kernel.org

On Sun, Jun 17, 2018 at 01:28:18PM -0700, John Hubbard wrote:
> Yes. However, my thinking was: get_user_pages() can become a way to indicate that 
> these pages are going to be treated specially. In particular, the caller
> does not really want or need to support certain file operations, while the
> page is flagged this way.
> 
> If necessary, we could add a new API call.

That API call is called get_user_pages_longterm.

> But either way, I think we could
> reasonably document that "if you pin these pages (either via get_user_pages,
> or some new, similar-looking API call), you can DMA to/from them, and safely
> mark them as dirty when you're done, and the right things will happen. 
> And in the interim, you can expect that the follow file system API calls
> will not behave predictably: fallocate, truncate, ..."

That is not how get_user_pages(_fast) is used.  We use it all over the
kernel, including for direct I/O.  You'd break a lot of existing use
cases very badly.
