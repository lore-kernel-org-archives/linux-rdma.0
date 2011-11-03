From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: rdma_cm UD sendto without connect
Date: Thu, 3 Nov 2011 21:05:53 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E8CE14@ORSMSX101.amr.corp.intel.com>
References: <CAND8VyAYHTg3T2rMmPPMMjXbkN4dZJSDukXhQZFJnVYT2fW+1Q@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A8237316E8CD1B@ORSMSX101.amr.corp.intel.com>
 <CAND8VyCFZxQeeVz8AUacQAzJkqGcSpYBPbmiaPA+ZQOp1iiVGQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAND8VyCFZxQeeVz8AUacQAzJkqGcSpYBPbmiaPA+ZQOp1iiVGQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kelly Burkhart <kelly.burkhart-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Are there calls in rdma_cm that allow me to do this?  For the life of
> me I can't figure out how, for instance, I would write an app that has
> a single QP that recieves UD datagrams from anyone.  How do potential
> clients find the QP number, qkey and ah without using listen/accept
> which will create a brand new QP every time?

Yeah, the UD sample was based on an RC sample and isn't all that instructive...  When you call rdma_accept(), you can specify the qp_num as part of the conn_param.  So, once you call rdma_create_qp(), you can just reference that QPN for other lookup requests.  The code could look something like this in the thread that listens:

/* create QP */
rdma_create_id(&qp_id)
rdma_bind_addr()
rdma_create_qp()

/* listen for QPN lookup */
rdma_getaddrinfo(... use RAI_PASSIVE flag)
rdma_create_ep(&listen_id)  /* or rdma_create_id + rdma_bind_addr */
rdma_listen()

/* get lookup requests, reply, then discard */
conn_param.qp_num = qp_id->qp->qp_num;
while (1) {
	rdma_get_request(listen_id, new_id)
	rdma_accept(new_id)
	rdma_destroy_id(new_id)
}

If you use async operation, it requires a little more work to retrieve the events from the kernel, but this is the basic idea.  You can also create the QP on the first request that you receive, as long as you don't destroy that id until you're done with the QP.  I think you can even call rdma_create_qp() on the listen_id as long as it's been bound to a device first.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
