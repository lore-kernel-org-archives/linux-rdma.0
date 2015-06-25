From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH RFC 1/2] RDMA/iser: limit sg tablesize on device fastreg
 max depth
Date: Thu, 25 Jun 2015 19:36:46 +0300
Message-ID: <558C2E1E.9080704@mellanox.com>
References: <20150625153754.13272.432.stgit@build.ogc.int>
 <20150625153917.13272.52513.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150625153917.13272.52513.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: orgerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, raid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 6/25/2015 6:39 PM, Steve Wise wrote:
> Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> Tested-by: Vasu Dev <vasu.dev-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>   drivers/infiniband/ulp/iser/iscsi_iser.c |    7 +++++++
>   1 files changed, 7 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
> index 6a594aa..ec692f7 100644
> --- a/drivers/infiniband/ulp/iser/iscsi_iser.c
> +++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
> @@ -640,6 +640,13 @@ iscsi_iser_session_create(struct iscsi_endpoint *ep,
>   						   SHOST_DIX_GUARD_CRC);
>   		}
>
> +		/*
> +		 * Limit the sg_tablesize based on the device max fastreg page
> +		 * list length.
> +		 */
> +		shost->sg_tablesize = min_t(u32, shost->sg_tablesize,
> +			ib_conn->device->dev_attr.max_fast_reg_page_list_len);
> +
>   		if (iscsi_host_add(shost,
>   				   ib_conn->device->ib_device->dma_device)) {
>   			mutex_unlock(&iser_conn->state_mutex);
>

This looks good.

Note that I have a patch in the pipe to add support for up to
8MB IO size and there I take into account the device capabilities
(minimum between device capability and user preference).

I was supposed to submit it once the indirect registration support
lands in but given that will take some time, I'll go ahead and send it
out as well.

I have no problem rebasing over this so:

Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
