From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: When is it safe to release connection resources?
Date: Wed, 4 Jan 2012 20:05:03 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823732566B335@ORSMSX101.amr.corp.intel.com>
References: <4EFC987B.6070901@list-group.com>
	<1828884A29C6694DAF28B7E6B8A8237325662B63@ORSMSX102.amr.corp.intel.com>
 <CAO+b5-qHFFg-KKQQkEZ2sS_+TWAFCJ0Ed4XGV15cs==_9zttSw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAO+b5-qHFFg-KKQQkEZ2sS_+TWAFCJ0Ed4XGV15cs==_9zttSw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Flavio Baronti <f.baronti-ngIpsMLAhaq41k5uCYKmRQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I've just had a look at the kernel code that implements all this
> (uverbs_cmd.c and uverbs_main.c). I haven't found any precautions
> against ib_uverbs_comp_handler() accessing *uobj after
> ib_uverbs_destroy_cq() has invoked put_uobj(uobj). Did I miss
> something ?

The kernel operation is different, since it relies on callbacks.  When the kernel ib_destroy_cq() returns, we are guaranteed that the completion handler (ib_uverbs_comp_handler) is not executing and will not be called.  After destroying the kernel cq, ib_uverbs_destroy_cq() will remove all references to the destroyed cq from the event list.

The issue is that another thread could have retrieved an event for this cq before the cleanup occurs.  When ib_uverbs_destroy_cq unwinds back to user space, it returns the total number of events that were retrieved from the kernel.  ibv_destroy_cq blocks until the application has processed all cq events, which are indicated by the app calling ibv_ack_cq_events().

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
