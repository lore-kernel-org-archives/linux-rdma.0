From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCHv3 for-4.5 0/2] iw_cxgb4: Fixes static checker warnings
Date: Tue, 12 Jan 2016 14:16:40 +0200
Message-ID: <20160112121640.GA12332@leon.nu>
References: <1452596602-9952-1-git-send-email-hariprasad@chelsio.com>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1452596602-9952-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, leedom-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 12, 2016 at 04:33:20PM +0530, Hariprasad Shenai wrote:
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
> V3: Add the 'Fixes:' tag with the first 12 characters of the SHA-1 ID, and
>     the one line summary for Patch 1/2

Thank you for investing your time to address all my comments,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

> 
> V2: Dropped an error message in Patch 1/2 ("iw_cxgb4: Fixes static checker
>     warning in c4iw_rdev_open()"), and updated commit message to be
>     consistent. Based on review comments by Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org
> 
> Hariprasad Shenai (2):
>   iw_cxgb4: Fixes static checker warning in c4iw_rdev_open()
>   iw_cxgb4: Fixes GW-Basic labels to meaningful error names
> 
>  drivers/infiniband/hw/cxgb4/device.c | 53 ++++++++++++++----------------------
>  1 file changed, 21 insertions(+), 32 deletions(-)
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
