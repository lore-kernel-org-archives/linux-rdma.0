From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCHv2 for-4.6] RDMA/iw_cxgb4: Fix bar2 virtual address
 calculation for T4 adapters
Date: Tue, 5 Apr 2016 08:34:07 +0300
Message-ID: <20160405053407.GI5264@leon.nu>
References: <1459832028-27852-1-git-send-email-hariprasad@chelsio.com>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1459832028-27852-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 05, 2016 at 10:23:48AM +0530, Hariprasad Shenai wrote:
> 
> Fixes: 74217d4c6a4fb0d8 ("iw_cxgb4: support for bar2 qid densities exceeding the page size")
> 
> Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
> ---
> V2: Add RDMA to subject line, add kernel panic trace and the commit where
>     issue was introduced, based on review comment by Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>

Thanks a lot,
Reviewed-by: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
