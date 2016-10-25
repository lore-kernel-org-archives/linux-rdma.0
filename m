From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH v3 4/6] nvme-rdma: use rdma connection reject helper functions
Date: Tue, 25 Oct 2016 13:20:49 -0500
Message-ID: <014d01d22eec$832e60e0$898b22a0$@opengridcomputing.com>
References: <cover.1477336045.git.swise@opengridcomputing.com> <55638a1d2a9f79af8b9a19eb444c5d0a41691352.1477336045.git.swise@opengridcomputing.com> <b5d32deb-af6a-3f98-98da-c5f61d400876@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <b5d32deb-af6a-3f98-98da-c5f61d400876-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Bart Van Assche' <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> 
> On 10/24/2016 12:09 PM, Steve Wise wrote:
> > +static const char *const nvme_rdma_cm_status_strs[] = {
> > +	[NVME_RDMA_CM_INVALID_LEN]	= "invalid length",
> > +	[NVME_RDMA_CM_INVALID_RECFMT]	= "invalid record format",
> > +	[NVME_RDMA_CM_INVALID_QID]	= "invalid queue id",
> > +	[NVME_RDMA_CM_INVALID_HSQSIZE]	= "invalid host sq size",
> > +	[NVME_RDMA_CM_INVALID_HRQSIZE]	= "invalid host rq size",
> > +	[NVME_RDMA_CM_NO_RSC]		= "resource not found",
> > +	[NVME_RDMA_CM_INVALID_IRD]	= "invalid ird",
> > +	[NVME_RDMA_CM_INVALID_ORD]	= "Invalid ord",
> > +};
> 
> Please capitalize abbreviations (SQ, RQ, ID, IRD and ORD).
>

will do.

 
> > +static const char *nvme_rdma_cm_msg(enum nvme_rdma_cm_status status)
> > +{
> > +	size_t index = status;
> > +
> > +	if (index >= ARRAY_SIZE(nvme_rdma_cm_status_strs) ||
> > +	    !nvme_rdma_cm_status_strs[index])
> > +		return "unrecognized reason";
> > +	else
> > +		return nvme_rdma_cm_status_strs[index];
> > +};
> 
> Please consider rewriting this if-statement such that the recognized
> reason scenario occurs first.
>

sure.
 
> > +	rej_msg = rdma_reject_msg(cm_id, status);
> > +	rej_data = (struct nvme_rdma_cm_rej *)
> > +		   rdma_consumer_reject_data(cm_id, ev, &rej_data_len);
> 
> Please reorder the patches in this patch series such that it doesn't
> break a bisect. rdma_consumer_reject_data() should be introduced before
> it is used.
> 

rdma_consumer_reject_data() is introduced in patch 3.



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
