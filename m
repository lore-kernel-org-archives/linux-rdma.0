From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH RFC v2 3/3] nvme-rdma: use rdma_reject_msg() to log connection rejects
Date: Mon, 24 Oct 2016 09:57:50 -0500
Message-ID: <011d01d22e06$fd606480$f8212d80$@opengridcomputing.com>
References: <cover.1477003235.git.swise@opengridcomputing.com> <60243a2ce17e08cdc93600b9998698dbd7f83306.1477003235.git.swise@opengridcomputing.com> <20161021122318.GB17325@lst.de> <005701d22c7f$0c883ed0$2598bc70$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <005701d22c7f$0c883ed0$2598bc70$@opengridcomputing.com>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, sagig-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> > Given the nasty casting issues in the current RDMA/CM API maybe we
> should
> > actually expand the scope of the rdma_consumer_reject helper to include
> > the above check, e.g. check that there is a private data len and then
> > return a pointer to the private data?
> 
> An application could reject and not provide private data, so I think we
> need 3 helpers (so far):
> 
> rdma_reject_msg() - protocol reject reason string
> rdma_is_consumer_reject() - true if the peer consumer/ulp rejected
> rdma_consumer_reject_data() - ptr to any private data
> 
> Sound good?

Or these 3 could be rolled into one uber function that returns true if the
consumer rejected, and sets 2 pointers passed in: one to the protocol reject
string, and one to the private data, if any.   If the something like like this:

bool rdma_reject_info(struct rdma_cm_id *id, int reason, char **protocol_msg,
char **consumer_data)

Kinda ugly, but only one call is needed vs 3 calls to get this info...



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
