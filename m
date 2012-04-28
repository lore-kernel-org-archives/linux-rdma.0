From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: ib_destroy_cm_id() versus cm callback race ?
Date: Sat, 28 Apr 2012 09:56:59 +0000
Message-ID: <4F9BBEEB.40806@acm.org>
References: <4F9AC1F2.5070007@acm.org> <1828884A29C6694DAF28B7E6B8A82373469D891F@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373469D891F-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, yangfanlinux <yangfanlinux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 04/27/12 17:18, Hefty, Sean wrote:

>> If I interpret the source code in drivers/infiniband/core/cm.c correctly
>> ib_destroy_cm_id() can return before an ongoing cm_id callback has
>> finished. Is this on purpose ? If not, isn't there a
>> flush_workqueue(cm.wq) call missing in cm_destroy_id() ?
> 
> ib_destroy_cm_id() will block while there's an outstanding reference

> held on the id.  We'll hold a reference on an id if we have any MAD
> outstanding against it (which can result in a send callback) or
> during the processing of a receive.

Hello Sean,

Thanks for the quick reply. Something else: I've noticed that the IB CM
work queue is created as follows:

    cm.wq = create_workqueue("ib_cm");

That makes me wonder how it is prevented that two CM callbacks for the
same CM ID run concurrently on different CPUs ?

Thanks,

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
