From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: When is it safe to release connection resources?
Date: Mon, 2 Jan 2012 16:39:08 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237325662B63@ORSMSX102.amr.corp.intel.com>
References: <4EFC987B.6070901@list-group.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4EFC987B.6070901-ngIpsMLAhaq41k5uCYKmRQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Flavio Baronti <f.baronti-ngIpsMLAhaq41k5uCYKmRQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> If I understood correctly, when ibv_get_cq_event returns, it holds some sort
> of lock over the completion queue, which is

ibv_get_cq_event will increment a reference count on the CQ that it is returning.

> released when I call ibv_req_notify_cq. This lock is checked also in

You decrement the count with ibv_ack_cq_events.  ibv_req_notify_cq is used to arm the cq, so that a completion generates an interrupt and a new event.

> ibv_destroy_cq, so that:
> 1) When ibv_destroy_cq returns, I am certain that there is no thread running
> somewhere between ibv_get_cq_event and
> ibv_req_notify_cq

ibv_destroy_cq will block until all outstanding references on the cq have been released.  The intent is to protect the user from ibv_get_cq_event from returning a reference to a cq that is being destroyed from another thread, which could result in a crash in the user's code.

> 2) When ibv_destroy_cq returns, I am certain that ibv_get_cq_event will not
> return the destroyed cq any more.

correct

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
