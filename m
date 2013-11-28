From: Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: CQEs in unreliable connection
Date: Thu, 28 Nov 2013 17:54:13 +0530
Message-ID: <CADPSxAhQKoKOQVbixMXvQRpp0_h1iQCtChrF0v1UUR1cZsPZvA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi.

I had 2 questions related to RDMA operations (reads and writes) over
unreliable connections:

1. Are WQEs issued over an unreliable connection supposed to generate
CQEs? The Infiniband spec says that such WQEs may not generate an
'ACK'. I'm confused if ACK refers to CQE.

2. If the status of the work completion (fetched using ibv_poll_cq())
is IBV_WC_SUCCESS, does it mean that the operation was successful at
the remote host (even though we used an unreliable connection)?

Thanks for your help!

--Anuj
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
