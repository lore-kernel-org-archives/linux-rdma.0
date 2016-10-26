From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH v4 4/8] nvme-rdma: use rdma connection reject helper functions
Date: Wed, 26 Oct 2016 11:17:23 -0500
Message-ID: <06fb01d22fa4$6fb83190$4f2894b0$@opengridcomputing.com>
References: <cover.1477426743.git.swise@opengridcomputing.com> <35db2feb4dcac92924992d5655630aa70972ad00.1477426743.git.swise@opengridcomputing.com> <62db5521-9c15-146b-9057-2a22658fa210@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <62db5521-9c15-146b-9057-2a22658fa210-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Bart Van Assche' <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> 
> On 10/25/2016 12:34 PM, Steve Wise wrote:
> > +	rej_data = (struct nvme_rdma_cm_rej *)
> > +		   rdma_consumer_reject_data(cm_id, ev, &rej_data_len);
> 
> This cast casts away constness; that's ugly. If the data type of
> rej_data would be changed into const ... * then no cast would have been
> necessary.
>

Ok.
 
> > +	if (rej_data && rej_data_len >= sizeof(u16)) {
> > +		u16 sts = le16_to_cpu(rej_data->sts);
> >
> >  		dev_err(queue->ctrl->ctrl.device,
> > -			"Connect rejected, status %d.", le16_to_cpu(rej-
> >sts));
> > -		/* XXX: Think of something clever to do here... */
> > -	} else {
> > +		      "Connect rejected: status %d (%s) nvme status %d
> (%s).\n",
> > +		      status, rej_msg, sts, nvme_rdma_cm_msg(sts));
> > +	} else
> >  		dev_err(queue->ctrl->ctrl.device,
> > -			"Connect rejected, no private data.\n");
> > -	}
> > +			"Connect rejected: status %d (%s).\n", status,
> rej_msg);
> 
> Braces are not balanced for this if-then-else statement :-(
> 
> If you have to resend this patch series please address these comments.
> 

Sure, I'll spin another version with these changes.  This is destined for
4.10 so we have time. :)

Thanks for reviewing!



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
