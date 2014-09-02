From: Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Lock contention in multi-threaded verbs applications
Date: Mon, 1 Sep 2014 22:55:11 -0400
Message-ID: <CADPSxAgaRLGZUZmMGmocswpGwbP033mQq5pM=Mx-xzqjaL8ArA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi.

I'm developing a multi-threaded application where each thread uses a
separate queue pair for communication with remote hosts. The queue
pairs share only an ibv_context and a protection domain.

When I run one application instance with 10 threads, each thread gets
very bad performance. However, when I run 10 instances with 1 thread
each, each instance gets good performance. I suspect that this is
because of lock contention in the 1-instance-10-thread case for
bf_lock and uar_lock (mlx4.h), because the threads share an
ibv_context. If this is correct, will using a different ibv_context
for each thread eliminate all lock contention? Is it safe to create
several ibv_contexts in an application?

Thanks for your help.

Anuj Kalia.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
