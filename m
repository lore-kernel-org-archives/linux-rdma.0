From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: ib_destroy_cm_id() versus cm callback race ?
Date: Mon, 30 Apr 2012 19:04:10 +0000
Message-ID: <4F9EE22A.4020000@acm.org>
References: <4F9AC1F2.5070007@acm.org> <1828884A29C6694DAF28B7E6B8A82373469D891F@ORSMSX101.amr.corp.intel.com> <4F9BBEEB.40806@acm.org> <1828884A29C6694DAF28B7E6B8A82373469FED01@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373469FED01-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, yangfanlinux <yangfanlinux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 04/30/12 18:29, Hefty, Sean wrote:

>> That makes me wonder how it is prevented that two CM callbacks for the
>> same CM ID run concurrently on different CPUs ?
> 
> The callback code ends up looking like this:
> 
>         ret = atomic_inc_and_test(&cm_id_priv->work_count);
>         if (!ret)
>                 list_add_tail(&work->list, &cm_id_priv->work_list);
>         spin_unlock_irq(&cm_id_priv->lock);
> 
>         if (ret)
>                 cm_process_work(cm_id_priv, work);
> 
> Only 1 thread will end up invoking callbacks to the user.  Other events

> end up being queued on the work_list for a given id.

Are you sure that only one thread at a time will invoke a CM callback ? As
far as I can see cm_recv_handler() queues work without checking whether
any other work is ongoing. From drivers/infiniband/core/cm.c:

static void cm_recv_handler(...)
{
        [ ... ]

        work = kmalloc(sizeof *work + sizeof(struct ib_sa_path_rec) * paths,
                       GFP_KERNEL);
        if (!work) {
                ib_free_recv_mad(mad_recv_wc);
                return;
        }

        INIT_DELAYED_WORK(&work->work, cm_work_handler);
        work->cm_event.event = event;
        work->mad_recv_wc = mad_recv_wc;
        work->port = port;
        queue_delayed_work(cm.wq, &work->work, 0);
}

What I have noticed could be explained by the following sequence of events:
* IB CM core receives a connection request and invokes the callback for event
  IB_CM_REQ_RECEIVED.
* That callback adds connection information to a global list (and keeps running).
* User requests shutdown and hence from another thread ib_send_cm_dreq() is invoked.
* IB CM core receives a DREP message and invokes the callback for event
  IB_CM_DREP_RECEIVED. That callback function gets confused because of the
  concurrent connection state manipulations by the IB_CM_REQ_RECEIVED handler
  (which is still running).

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
