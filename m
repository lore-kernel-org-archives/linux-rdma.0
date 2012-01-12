From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: ibv_req_notify_cq and multithreading
Date: Thu, 12 Jan 2012 15:52:34 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237325676B8F@ORSMSX101.amr.corp.intel.com>
References: <4F0EC562.2040709@list-group.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F0EC562.2040709-ngIpsMLAhaq41k5uCYKmRQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Flavio Baronti <f.baronti-ngIpsMLAhaq41k5uCYKmRQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I'm trying to have N threads reading from the same completion channel, bounded
> to M completion queues. I would like to
> have N << M, and to ensure that only a single thread at time can call
> ibv_poll_cq() on a given queue, to process the
> events in the same order they were put in the queue.
> 
> I can't understand how to properly achieve this, since:
> 1- If I call ibv_req_notify_cq() before ibv_poll_cq(), I might end up with two
> threads polling the same queue.
> 2- If I call ibv_req_notify_cq() after ibv_poll_cq(), I could end up with
> events in the cq not being notified in the
> channel (I read this on the IBTA 11.4.2.2, and I *think* I actually
> experienced this under load).
> 
> I can use option 1 with an additional lock before ibv_req_notify_cq(), but I
> would like to know if there is a simpler
> way which I can't see.

I can't think of a simpler way.  You just don't have any idea which CQ will be returned from the completion channel.  Does your traffic pattern work to create N completion channels and distributed the CQs among them?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
