From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] cxgb4: fix undefined behavior in mem.c
Date: Mon, 4 Mar 2019 15:54:46 -0400
Message-ID: <20190304195446.GA7751@ziepe.ca>
References: <1551393519-96595-1-git-send-email-shaobo@cs.utah.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1551393519-96595-1-git-send-email-shaobo@cs.utah.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: Shaobo He <shaobo@cs.utah.edu>
Cc: linux-rdma@vger.kernel.org, Steve Wise <swise@chelsio.com>, Doug Ledford <dledford@redhat.com>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 28, 2019 at 03:38:38PM -0700, Shaobo He wrote:
> In function `c4iw_dealloc_mw`, variable mhp's value is printed after
> freed, which triggers undefined behavior according to this post:
> https://trust-in-soft.com/dangling-pointer-indeterminate/.
> 
> This commit fixes it by swapping the order of `kfree` and `pr_debug`.
> 
> Signed-off-by: Shaobo He <shaobo@cs.utah.edu>
> ---
>  drivers/infiniband/hw/cxgb4/mem.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Discussion aside, this is a worthwile fix. I rewrote the commit
message to avoid referencing 'undefined behavior' though, this is just
a straight up bug in the logging. Another thread could get the same
pointer value for the mhp before the print creating a confusing log.

    cxgb4: kfree mhp after the debug print
    
    In function `c4iw_dealloc_mw`, variable mhp's value is printed after
    freed, it is clearer to have the print before the kfree.
    
    Otherwise racing threads could allocate another mhp with the same pointer
    value and create confusing tracing.

Jason
