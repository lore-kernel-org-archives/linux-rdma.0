From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V3 4/4] RDMA/isert: Support iWARP transport
Date: Wed, 1 Jul 2015 20:16:26 +0300
Message-ID: <5594206A.90001@dev.mellanox.co.il>
References: <20150701162936.6501.45512.stgit@build.ogc.int>
 <20150701163058.6501.39171.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150701163058.6501.39171.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 7/1/2015 7:30 PM, Steve Wise wrote:
> Memory regions that are the target of an iWARP RDMA READ RESPONSE need
> REMOTE_WRITE access rights.  So enable REMOTE_WRITE for iWARP devices.
>
> Use the device's max_sge_rd capability to compute the target's read sge
> depth.  Save both the read and write max_sge values in the isert_conn
> struct, and use these when creating RDMA_READ work requests
>
> Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> ---
>   drivers/infiniband/ulp/isert/ib_isert.c |   54 ++++++++++++++++++++++++++-----
>   drivers/infiniband/ulp/isert/ib_isert.h |    3 +-
>   2 files changed, 47 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
> index 9e7b492..8334dd0 100644
> --- a/drivers/infiniband/ulp/isert/ib_isert.c
> +++ b/drivers/infiniband/ulp/isert/ib_isert.c
> @@ -163,7 +163,9 @@ isert_create_qp(struct isert_conn *isert_conn,
>   	 * outgoing control PDU responses.
>   	 */
>   	attr.cap.max_send_sge = max(2, device->dev_attr.max_sge - 2);
> -	isert_conn->max_sge = attr.cap.max_send_sge;
> +	isert_conn->max_write_sge = attr.cap.max_send_sge;
> +	isert_conn->max_read_sge = min_t(u32, device->dev_attr.max_sge_rd,
> +					 attr.cap.max_send_sge);
>
>   	attr.cap.max_recv_sge = 1;
>   	attr.sq_sig_type = IB_SIGNAL_REQ_WR;
> @@ -348,6 +350,17 @@ out_cq:
>   	return ret;
>   }
>
> +static int any_port_is_iwarp(struct isert_device *device)
> +{
> +	int i;
> +
> +	for (i = rdma_start_port(device->ib_device);
> +	     i <= rdma_end_port(device->ib_device); i++)
> +		if (rdma_protocol_iwarp(device->ib_device, i))
> +			return 1;
> +	return 0;
> +}
> +

Lets get rid of that as soon as possible...

However,
Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>


Nic,

I think it makes sense that this will go via doug's tree.
Any objection?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
