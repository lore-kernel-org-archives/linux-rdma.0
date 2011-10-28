From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH 2/2] RDMA/cxgb3: Serialize calls to cq's comp_handler
 by lock
Date: Fri, 28 Oct 2011 08:57:35 -0500
Message-ID: <4EAAB4CF.5020905@opengridcomputing.com>
References: <1319471422-30113-1-git-send-email-kumaras@chelsio.com> <1319471422-30113-2-git-send-email-kumaras@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1319471422-30113-2-git-send-email-kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, divy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Parav.Pandit-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/24/2011 10:50 AM, Kumar Sanghvi wrote:
> iw_cxgb3 has a potential problem wherein the cq's comp_handler
> can get called simultaneously from different places in iw_cxgb3
> driver. This does not comply with Documentation/infiniband/core_locking.txt,
> which states that at a given point of time, there should be only one
> callback per CQ should be active.
>
> Such problem was reported by Parav Pandit<Parav.Pandit-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>  for
> iw_cxgb4 driver. Based on discussion between Parav Pandit and Steve Wise,
> this patch aims to correct above problem by serializing the calls to cq's
> comp_handler using a spin_lock.
>
> Signed-off-by: Kumar Sanghvi<kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

Acked-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
