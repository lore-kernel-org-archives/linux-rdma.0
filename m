From: Adit Ranadive <adit.262-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: RDMA version of select for multiplexing rdma connections?
Date: Fri, 22 Oct 2010 17:07:23 -0400
Message-ID: <AANLkTikPStczJpRo9va7Q=rj0C+gwwq0X0kOUKDBKN34@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello,

I have been building a server client type of application based on top
of RDMA/Verbs user libraries.
The issue that Im running into is how to multiplex between multiple
clients connecting to the server using rdma_listen & rdma_connect
functions.
Looking at he man pages the rdma_listen call supports having a backlog
of connections but doesnt say how to multiplex between that backlog
of connections.

One approach obviously is to create multiple sockets and allow clients
to connect to that but that does not really seem a good solution to
tell clients
which socket to connect to.

Is there a rdma version of the sockets select function which allows us
to multiplex between different sockets for the rdma connection
manager?


Thanks,
Adit
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
