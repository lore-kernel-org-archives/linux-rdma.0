From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: ib_destroy_cm_id() versus cm callback race ?
Date: Fri, 27 Apr 2012 15:57:38 +0000
Message-ID: <4F9AC1F2.5070007@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: yangfanlinux <yangfanlinux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello,

If I interpret the source code in drivers/infiniband/core/cm.c correctly
ib_destroy_cm_id() can return before an ongoing cm_id callback has
finished. Is this on purpose ? If not, isn't there a
flush_workqueue(cm.wq) call missing in cm_destroy_id() ?

Thanks,

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
