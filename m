From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: ib_destroy_cm_id() versus cm callback race ?
Date: Fri, 27 Apr 2012 17:18:58 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373469D891F@ORSMSX101.amr.corp.intel.com>
References: <4F9AC1F2.5070007@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F9AC1F2.5070007-HInyCGIudOg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: yangfanlinux <yangfanlinux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> If I interpret the source code in drivers/infiniband/core/cm.c correctly
> ib_destroy_cm_id() can return before an ongoing cm_id callback has
> finished. Is this on purpose ? If not, isn't there a
> flush_workqueue(cm.wq) call missing in cm_destroy_id() ?

ib_destroy_cm_id() will block while there's an outstanding reference held on the id.  We'll hold a reference on an id if we have any MAD outstanding against it (which can result in a send callback) or during the processing of a receive.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
