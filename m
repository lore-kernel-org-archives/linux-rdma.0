From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v4 1/3] mm: get_user_pages: consolidate error handling
Date: Mon, 8 Oct 2018 17:05:25 -0700
Message-ID: <20181008170525.62d1a910f7811d7c66a8c34c@linux-foundation.org>
References: <20181008211623.30796-1-jhubbard@nvidia.com>
        <20181008211623.30796-2-jhubbard@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181008211623.30796-2-jhubbard@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
To: john.hubbard@gmail.com
Cc: Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@kernel.org>, Christopher Lameter <cl@linux.com>, Jason Gunthorpe <jgg@ziepe.ca>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-fsdevel@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>
List-Id: linux-rdma@vger.kernel.org

On Mon,  8 Oct 2018 14:16:21 -0700 john.hubbard@gmail.com wrote:

> An upcoming patch requires a way to operate on each page that
> any of the get_user_pages_*() variants returns.
> 
> In preparation for that, consolidate the error handling for
> __get_user_pages(). This provides a single location (the "out:" label)
> for operating on the collected set of pages that are about to be returned.
> 
> As long every use of the "ret" variable is being edited, rename
> "ret" --> "err", so that its name matches its true role.
> This also gets rid of two shadowed variable declarations, as a
> tiny beneficial a side effect.

Reviewed-by: Andrew Morton <akpm@linux-foundation.org>

`i' is a pretty crappy identifier as well, but we'll live.
