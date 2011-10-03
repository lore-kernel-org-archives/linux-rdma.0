From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH 2/4] iw_cxgb4: Add support for MPA V2 Enhanced RDMA Negotiation
Date: Mon, 03 Oct 2011 14:26:59 -0500
Message-ID: <4E8A0C83.8070808@opengridcomputing.com>
References: <1316962066-28701-1-git-send-email-kumaras@chelsio.com> <1316962066-28701-3-git-send-email-kumaras@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1316962066-28701-3-git-send-email-kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, divy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Faisal.Latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 09/25/2011 09:47 AM, Kumar Sanghvi wrote:
> The patch adds support for Enhanced RDMA Connection Establishment
> (draft-ietf-storm-mpa-peer-connect-06).
> Details of draft can be obtained from:
> http://www.ietf.org/id/draft-ietf-storm-mpa-peer-connect-06.txt
>
> The patch updates the following functions for initiator perspective:
> -send_mpa_request
> -process_mpa_reply
> -post_terminate for TERM error codes
> -destroy_qp for TERM related change
> -adds layer/etype/ecode to c4iw_qp_attrs for sending with TERM
> -peer_abort for retrying connection attempt with MPA_v1 message
> -added c4iw_reconnect function
>
> The patch updates the following functions for responder perspective:
> -process_mpa_request
> -send_mpa_reply
> -c4iw_accept_cr
> -passes ird/ord to upper layers
>
> Signed-off-by: Kumar Sanghvi<kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
