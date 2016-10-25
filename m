From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v3 1/6] rdma_cm: add rdma_reject_msg() helper function
Date: Tue, 25 Oct 2016 10:58:01 -0700
Message-ID: <93f8b8f8-51f5-a595-c9ad-0b3e22789636@sandisk.com>
References: <cover.1477336045.git.swise@opengridcomputing.com>
 <ca2185d1f1e9008922d1b344f3887d400a1d6053.1477336045.git.swise@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ca2185d1f1e9008922d1b344f3887d400a1d6053.1477336045.git.swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "axboe-b10kYP2dOMg@public.gmane.org" <axboe-b10kYP2dOMg@public.gmane.org>, "santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/24/2016 12:09 PM, Steve Wise wrote:
> +	[IB_CM_REJ_RDC_NOT_EXIST]		= "rdc not exist",

Please change this into "RDC does not exist".

> +	[IB_CM_REJ_INVALID_GID]			= "invalid gid",
> +	[IB_CM_REJ_INVALID_LID]			= "invalid lid",
> +	[IB_CM_REJ_INVALID_SL]			= "invalid sl",
> +	[IB_CM_REJ_INVALID_TRAFFIC_CLASS]	= "invalid traffic class",
> +	[IB_CM_REJ_INVALID_HOP_LIMIT]		= "invalid hop limit",
> +	[IB_CM_REJ_INVALID_PACKET_RATE]		= "invalid packet rate",
> +	[IB_CM_REJ_INVALID_ALT_GID]		= "invalid alt gid",
> +	[IB_CM_REJ_INVALID_ALT_LID]		= "invalid alt lid",
> +	[IB_CM_REJ_INVALID_ALT_SL]		= "invalid alt sl",
> +	[IB_CM_REJ_INVALID_ALT_TRAFFIC_CLASS]	= "invalid alt traffic class",
> +	[IB_CM_REJ_INVALID_ALT_HOP_LIMIT]	= "invalid alt hop limit",
> +	[IB_CM_REJ_INVALID_ALT_PACKET_RATE]	= "invalid alt packet rate",
> +	[IB_CM_REJ_PORT_CM_REDIRECT]		= "port cm redirect",
> +	[IB_CM_REJ_PORT_REDIRECT]		= "port redirect",
> +	[IB_CM_REJ_INVALID_MTU]			= "invalid mtu",
> +	[IB_CM_REJ_INSUFFICIENT_RESP_RESOURCES]	= "insufficient resp resources",
> +	[IB_CM_REJ_CONSUMER_DEFINED]		= "consumer defined",
> +	[IB_CM_REJ_INVALID_RNR_RETRY]		= "invalid rnr retry",
> +	[IB_CM_REJ_DUPLICATE_LOCAL_COMM_ID]	= "duplicate local comm id",
> +	[IB_CM_REJ_INVALID_CLASS_VERSION]	= "invalid class version",
> +	[IB_CM_REJ_INVALID_FLOW_LABEL]		= "invalid flow label",
> +	[IB_CM_REJ_INVALID_ALT_FLOW_LABEL]	= "invalid alt flow label",

Other error messages capitalize GID, LID, CM, ID, RNR and SL so please 
do this here too.

> +const char *__attribute_const__ ibcm_reject_msg(int reason)
> +{
> +	size_t index = reason;
> +
> +	if (index >= ARRAY_SIZE(ibcm_rej_reason_strs) ||
> +	    !ibcm_rej_reason_strs[index])
> +		return "unrecognized reason";
> +	else
> +		return ibcm_rej_reason_strs[index];
> +}

Please consider using positive logic - this means negating the 
if-condition and swapping the if- and else-parts.

> +const char *__attribute_const__ rdma_reject_msg(struct rdma_cm_id *id,
> +						int reason)
> +{
> +	if (rdma_ib_or_roce(id->device, id->port_num))
> +		return ibcm_reject_msg(reason);
> +
> +	if (rdma_protocol_iwarp(id->device, id->port_num))
> +		return iwcm_reject_msg(reason);
> +
> +	WARN_ON_ONCE(1);
> +	return "unrecognized reason";

Have you considered to return "unrecognized transport" here instead?

> +const char *__attribute_const__ iwcm_reject_msg(int reason)
> +{
> +	size_t index;
> +
> +	/* iWARP uses negative errnos */
> +	index = -reason;
> +
> +	if (index >= ARRAY_SIZE(iwcm_rej_reason_strs) ||
> +	    !iwcm_rej_reason_strs[index])
> +		return "unrecognized reason";
> +	else
> +		return iwcm_rej_reason_strs[index];
> +}

Also for this function, please consider using positive logic.

Thanks,

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
