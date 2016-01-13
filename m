From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCHv3 for-4.5 0/2] iw_cxgb4: Fixes static checker warnings
Date: Wed, 13 Jan 2016 08:42:12 -0600
Message-ID: <004701d14e10$969fe6c0$c3dfb440$@opengridcomputing.com>
References: <1452596602-9952-1-git-send-email-hariprasad@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1452596602-9952-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Hariprasad Shenai' <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leedom-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Hariprasad Shenai
> Sent: Tuesday, January 12, 2016 5:03 AM
> To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org; leedom-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org; nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org; Hariprasad Shenai
> Subject: [PATCHv3 for-4.5 0/2] iw_cxgb4: Fixes static checker warnings
> 
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


Series looks ok.

Acked-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
