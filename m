From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH for-4.5 0/2] iw_cxgb4: Fix static checker warnings
Date: Mon, 11 Jan 2016 13:31:57 +0200
Message-ID: <20160111113157.GA21991@leon.nu>
References: <1452507660-27441-1-git-send-email-hariprasad@chelsio.com>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1452507660-27441-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leedom-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 11, 2016 at 03:50:58PM +0530, Hariprasad Shenai wrote:
> Hi,
> 
> This series fixes static checker warning's and fixes GW-Basic name labels
> to meaningful ones.
> 
> This patch series has been created against Doug's linux tree and includes
> patches on iw_cxgb4 driver.
> 
> We have included all the maintainers of respective drivers. Kindly review
> the change and let us know in case of any review comments.
> 
> Thanks
> 
> Hariprasad Shenai (2):
>   iw_cxgb4: Fix static checker warning in c4iw_rdev_open()
>   iw_cxgb4: fix the GW-Basic labels to meaningful error names

It will be great to be consistent in the subject line (s/fix/Fix).

> 
>  drivers/infiniband/hw/cxgb4/device.c | 55 +++++++++++++++---------------------
>  1 file changed, 23 insertions(+), 32 deletions(-)
> 
> -- 
> 2.3.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
