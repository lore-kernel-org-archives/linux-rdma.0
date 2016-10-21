From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH RFC v2 1/3] rdma_cm: add rdma_reject_msg() helper function
Date: Sat, 22 Oct 2016 00:51:18 +0300
Message-ID: <0923e213-cef7-f470-d148-9a513d9c37b2@grimberg.me>
References: <cover.1477003235.git.swise@opengridcomputing.com>
 <1360f08b7c25f3befcd6836b47af81e2ecb51b75.1477003235.git.swise@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1360f08b7c25f3befcd6836b47af81e2ecb51b75.1477003235.git.swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: sagig-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> +static const char * const ib_rej_reason_strs[] = {
> +	[IB_CM_REJ_NO_QP]			= "no qp",
> +	[IB_CM_REJ_NO_EEC]			= "no eec",
> +	[IB_CM_REJ_NO_RESOURCES]		= "no resources",
> +	[IB_CM_REJ_TIMEOUT]			= "timeout",
> +	[IB_CM_REJ_UNSUPPORTED]			= "unsupported",
> +	[IB_CM_REJ_INVALID_COMM_ID]		= "invalid comm id",
> +	[IB_CM_REJ_INVALID_COMM_INSTANCE]	= "invalid comm instance",
> +	[IB_CM_REJ_INVALID_SERVICE_ID]		= "invalid service id",
> +	[IB_CM_REJ_INVALID_TRANSPORT_TYPE]	= "invalid transport type",
> +	[IB_CM_REJ_STALE_CONN]			= "stale conn",
> +	[IB_CM_REJ_RDC_NOT_EXIST]		= "rdc not exist",
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
> +};
> +
> +const char *__attribute_const__ ib_reject_msg(int reason)

Please call it ibcm_reject_msg()


> +const char *__attribute_const__ iw_reject_msg(int reason)

and this iwcm_reject_msg
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
