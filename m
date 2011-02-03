From: Mike Mundy <mmundy42-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: rdma_listen() backlog maximum
Date: Thu, 3 Feb 2011 10:40:53 -0600
Message-ID: <AANLkTikqiahK1qNc6_wS6X445oUoVUJsE-nd3uC-sPWs@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I'm prototyping a server that needs to accept a large number of
simultaneous incoming RDMA CM connections. I noticed that
drivers/infiniband/core/ucma.c limits the backlog to 128. Is there a
reason why the limit is 128? Or to put it another way, what breaks if
the limit is increased to a larger value (say 256)?

Mike M
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
