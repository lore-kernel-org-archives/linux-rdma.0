From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH v3 4/6] nvme-rdma: use rdma connection reject helper
 functions
Date: Tue, 25 Oct 2016 19:36:25 +0300
Message-ID: <7191d136-aef4-9fed-223e-f2a9c1d958e5@grimberg.me>
References: <cover.1477336045.git.swise@opengridcomputing.com>
 <55638a1d2a9f79af8b9a19eb444c5d0a41691352.1477336045.git.swise@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55638a1d2a9f79af8b9a19eb444c5d0a41691352.1477336045.git.swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> +static const char *const nvme_rdma_cm_status_strs[] = {
> +	[NVME_RDMA_CM_INVALID_LEN]	= "invalid length",
> +	[NVME_RDMA_CM_INVALID_RECFMT]	= "invalid record format",
> +	[NVME_RDMA_CM_INVALID_QID]	= "invalid queue id",
> +	[NVME_RDMA_CM_INVALID_HSQSIZE]	= "invalid host sq size",
> +	[NVME_RDMA_CM_INVALID_HRQSIZE]	= "invalid host rq size",
> +	[NVME_RDMA_CM_NO_RSC]		= "resource not found",
> +	[NVME_RDMA_CM_INVALID_IRD]	= "invalid ird",
> +	[NVME_RDMA_CM_INVALID_ORD]	= "Invalid ord",
> +};

I think it'd be better to move them to include/linux/nvme-rdma.h
and use them for logging on the target side too.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
