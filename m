From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V5 3/5] RDMA/iser: Limit sg tablesize and max_sectors to
 device fastreg max depth
Date: Mon, 6 Jul 2015 10:50:50 +0300
Message-ID: <559A335A.90506@dev.mellanox.co.il>
References: <20150705174353.10042.39648.stgit@build2.ogc.int>
 <20150705174452.10042.44695.stgit@build2.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150705174452.10042.44695.stgit-PBeJgSbIpn97NCTnQtmixQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 7/5/2015 8:44 PM, Steve Wise wrote:
> Currently the sg tablesize, which dictates fast register page list
> depth to use, does not take into account the limits of the rdma device.
> So adjust it once we discover the device fastreg max depth limit.  Also
> adjust the max_sectors based on the resulting sg tablesize.
>
> Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> ---
>
>   drivers/infiniband/ulp/iser/iscsi_iser.c |    9 +++++++++
>   1 files changed, 9 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
> index 6a594aa..de8730d 100644
> --- a/drivers/infiniband/ulp/iser/iscsi_iser.c
> +++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
> @@ -640,6 +640,15 @@ iscsi_iser_session_create(struct iscsi_endpoint *ep,
>   						   SHOST_DIX_GUARD_CRC);
>   		}
>
> +		/*
> +		 * Limit the sg_tablesize and max_sectors based on the device
> +		 * max fastreg page list length.
> +		 */
> +		shost->sg_tablesize = min_t(unsigned short, shost->sg_tablesize,
> +			ib_conn->device->dev_attr.max_fast_reg_page_list_len);
> +		shost->max_sectors = min_t(unsigned int,
> +			1024, (shost->sg_tablesize * PAGE_SIZE) >> 9);
> +

The min statement is meaningless for max_sectors - you do a min between
default sg_tablesize and frpl length - so the maximum sg_tablesize is
128 which is 1024 max_sectors.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
