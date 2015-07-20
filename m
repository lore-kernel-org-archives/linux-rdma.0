From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH RFC] svcrdma: Fix possible over population fast_reg_page_list
Date: Mon, 20 Jul 2015 12:27:51 -0500
Message-ID: <011701d0c311$67d66ab0$37834010$@opengridcomputing.com>
References: <1437411614-29722-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1437411614-29722-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Sagi Grimberg' <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: 'Chuck Lever' <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Sagi Grimberg
> Sent: Monday, July 20, 2015 12:00 PM
> To: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: Chuck Lever; Steve Wise
> Subject: [PATCH RFC] svcrdma: Fix possible over population fast_reg_page_list
> 
> When accounting the needed_pages, we need to look into
> the page_list->max_page_list_len and not the global
> context xprt->sc_frmr_pg_list_len.
> 
> Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
