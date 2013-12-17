From: Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Question regarding max_rd_atomic
Date: Tue, 17 Dec 2013 16:23:14 -0500
Message-ID: <CADPSxAgR8PRXPfMgTEKp0=f8uGNLs4nSDLpKubPMH8RRV9VzxA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi.

I wanted to understand the max_rd_atomic parameter better. The man
page describes this parameter as "Number of outstanding RDMA reads &
atomic operations on the destination QP". The maximum value of this
parameter is a HCA specific value, which is 16 for my system.

I have the following specific questions:

1. Why doesn't this exist for other operations like RDMA write or SEND?
2. Why is the maximum value so small i.e 16?

Any other information about this would be really helpful.

Thanks!

--Anuj
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
