From: Rui Machado <ruimario-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: CQ overrun
Date: Thu, 11 Feb 2010 13:57:01 +0100
Message-ID: <6978b4af1002110457j26224acbr3dc28f4afb8cfb86@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi list,

I'm seeing the following message:

ib_mthca 0000:0d:00.0: CQ overrun on CQN 380090

can someone please tell me what does it mean and/or why and when this happens?
On the user-space side, the application is hanging while polling on
the queue pair.

Thanks in advance.

Rui Machado
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
