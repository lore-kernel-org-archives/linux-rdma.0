From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V3 3/4] RDMA/iser: limit sg tablesize to device fastreg
 max depth
Date: Wed, 1 Jul 2015 23:27:19 +0300
Message-ID: <CAJ3xEMidOySxVe_SsZ_02HQNi5F2fMZX8e9n2H9y1YoK3uj6vQ@mail.gmail.com>
References: <20150701162936.6501.45512.stgit@build.ogc.int>
	<20150701163052.6501.27775.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150701163052.6501.27775.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 1, 2015 at 7:30 PM, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> wrote:

please no empty change-logs for this driver (and elsewhere), find
something that fills @ least one sentence, it's easy.

Also, we are aiming to initiate (Sagi please make sure you follow on
this practice too) commit titles for the iser initiator with Capital
letter, so s/limit/Limit/g

> Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> ---
>  drivers/infiniband/ulp/iser/iscsi_iser.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
> index 6a594aa..ec692f7 100644
> --- a/drivers/infiniband/ulp/iser/iscsi_iser.c
> +++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
> @@ -640,6 +640,13 @@ iscsi_iser_session_create(struct iscsi_endpoint *ep,
>                                                    SHOST_DIX_GUARD_CRC);
>                 }
>
> +               /*
> +                * Limit the sg_tablesize based on the device max fastreg page
> +                * list length.
> +                */
> +               shost->sg_tablesize = min_t(u32, shost->sg_tablesize,
> +                       ib_conn->device->dev_attr.max_fast_reg_page_list_len);
> +

I guess you should also somehow recap shost->max_sectors (which is
hard coded to 1024 (== 512KB IO) now) for your needs.


>                 if (iscsi_host_add(shost,
>                                    ib_conn->device->ib_device->dma_device)) {
>                         mutex_unlock(&iser_conn->state_mutex);
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
