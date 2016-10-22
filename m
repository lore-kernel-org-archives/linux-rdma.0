From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH RFC v2 3/3] nvme-rdma: use rdma_reject_msg() to log connection rejects
Date: Sat, 22 Oct 2016 11:12:11 -0500
Message-ID: <005601d22c7f$0bd36dc0$237a4940$@opengridcomputing.com>
References: <cover.1477003235.git.swise@opengridcomputing.com> <60243a2ce17e08cdc93600b9998698dbd7f83306.1477003235.git.swise@opengridcomputing.com> <20161021122318.GB17325@lst.de>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161021122318.GB17325-jcswGhMUV9g@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, sagig-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> 
> On Thu, Oct 20, 2016 at 03:40:29PM -0700, Steve Wise wrote:
> > @@ -1237,18 +1237,22 @@ out_destroy_queue_ib:
> >  static int nvme_rdma_conn_rejected(struct nvme_rdma_queue *queue,
> >  		struct rdma_cm_event *ev)
> >  {
> > +	struct rdma_cm_id *cm_id = queue->cm_id;
> > +	int rdma_status = ev->status;
> > +	short nvme_status = -1;
> > +
> > +	if (rdma_consumer_reject(cm_id, rdma_status) &&
> > +	    ev->param.conn.private_data_len) {
> >  		struct nvme_rdma_cm_rej *rej =
> >  			(struct nvme_rdma_cm_rej *)ev-
> >param.conn.private_data;
> 
> Given the nasty casting issues in the current RDMA/CM API maybe we should
> actually expand the scope of the rdma_consumer_reject helper to include
> the above check, e.g. check that there is a private data len and then
> return a pointer to the private data?

An application could reject and not provide private data, so I think we need
3 helpers (so far):

rdma_reject_msg() - protocol reject reason string
rdma_is_consumer_reject() - true if the peer consumer/ulp rejected
rdma_consumer_reject_data() - ptr to any private data

Sound good?


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
