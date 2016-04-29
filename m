From: Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Why do only connected transports provide RDMA reads and writes?
Date: Fri, 29 Apr 2016 03:00:32 -0400
Message-ID: <CADPSxAjsJH8sV=5XGwNe=YctG4rs0u28=Mq=TLBUfVadH_FUCA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi everyone.

Connected transports (RC and UC) each provide some subset of RDMA
reads, writes, and atomic operations. However, these transports suffer
from scalability issues when the number of queue pairs becomes large.
Mellanox tries to solve this problem with DCT, but DCT incurs
additional overhead by sending dynamic disconnect and connect
messages. On the other hand, datagram transport scales well, but
provides only messaging.

Is there a fundamental reason why only connected transports provide
RDMA reads and writes? Why can't we have these over UD? I can think of
two issues; please let me know your thoughts.

1. RDMA reads and atomics need reliable transport to make sense to the
application: if the network (or software networking layer) does not
provide reliability, how does the application distinguish between a
failed RDMA read and a delayed RDMA read? It is hard to provide
end-to-end reliability over datagrams, particularly in
memory-constrained NICs (maybe that's why no one implements reliable
datagram). So: reads and atomics require reliability which requires
connection-oriented transport.

2. Exposing host memory for modifications over UD can be a big
security hole. The initial handshake while establishing a connection
in RC/UC provides (some) additional security.

Regards,
Anuj
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
