From: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 0/4] iWARP MPAv2 Support
Date: Mon, 03 Oct 2011 20:19:31 +0530
Message-ID: <4E89CB7B.6060806@chelsio.com>
References: <1316962066-28701-1-git-send-email-kumaras@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1316962066-28701-1-git-send-email-kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, divy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Faisal.Latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

On 09/25/2011 08:17 PM, Kumar Sanghvi wrote:
> This series adds support for MPA V2 Enhanced RDMA Negotiation
> protocol.
> Details about the protocol are available at below IETF Draft:
> http://www.ietf.org/id/draft-ietf-storm-mpa-peer-connect-06.txt
>
> To brief on MPA V2:
> 1) It allows two communicating endpoints to negotiate the IRD/ORD
>     values to be used in RDMA tranfers.
> 2) It allows two communicating endpoints to negotiate the type of
>     RTR message to use, when operating in peer2peer mode.
> 3) MPA v2 is backwards compatible with original MPA protocol.
>
> Patch 1/4 adds support to pass the ird/ord values upwards to the ULP
> application so that they can take part in ird/ord negotiation.
>
> Patch 2/4 adds MPA V2 support to the Chelsio iw_cxgb4.
>
> Patch 3/4 adds minimal MPA V2 support to iw_cxgb3 and amso1100.
>
> Patch 4/4 adds MPA V2 support to the Intel iw_nes.
>
> MPA_v2 support to the iw_cxgb4 and iw_nes has been tested to work
> fine, by both Intel and Chelsio, using basic test tools like
> rping and rdma_bw.
> ---
>
> Kumar Sanghvi (3):
>    iw_cm: Propagate ird/ord values upwards
>    iw_cxgb4: Add support for MPA V2 Enhanced RDMA Negotiation
>    amso1100/iw_cxgb3: Minimal MPAv2 support
>
> Tatyana (1):
>    RDMA/nes: Adds support for MPA frame Version 2
>
>   drivers/infiniband/core/cma.c            |    8 +-
>   drivers/infiniband/hw/amso1100/c2_ae.c   |    5 +
>   drivers/infiniband/hw/amso1100/c2_intr.c |    5 +
>   drivers/infiniband/hw/cxgb3/iwch_cm.c    |   10 +
>   drivers/infiniband/hw/cxgb4/cm.c         |  469 ++++++++++++-
>   drivers/infiniband/hw/cxgb4/iw_cxgb4.h   |   22 +-
>   drivers/infiniband/hw/cxgb4/qp.c         |   14 +-
>   drivers/infiniband/hw/nes/nes_cm.c       | 1101 +++++++++++++++++------------
>   drivers/infiniband/hw/nes/nes_cm.h       |   73 ++-
>   drivers/infiniband/hw/nes/nes_verbs.h    |    3 +-
>   include/rdma/iw_cm.h                     |    2 +
>   11 files changed, 1197 insertions(+), 515 deletions(-)
>

Just wanted to ask if you had a chance to review this patch-series and 
if there are any feedback/comments on this patch-series.


Thanks & regards,
Kumar.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
