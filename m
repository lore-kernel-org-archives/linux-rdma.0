From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: sparse endianness complaints for drivers/infiniband
Date: Sun, 4 Dec 2011 16:35:55 +0100
Message-ID: <CAO+b5-q97ri0YhKcbO1RBOGHXeJh2YMRjShtNDzihU7QjN+UVA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Has anyone had a look recently at the sparse endianness complaints
about the code under drivers/infiniband ? I haven't analyzed these
messages closely yet - these might indicate real bugs.

$ make C=2 CF=-D__CHECK_ENDIAN__ M=drivers/infiniband modules
[ ... ]
CHECK   drivers/infiniband/core/cma.c
drivers/infiniband/core/cma.c:1111:69: warning: incorrect type in
argument 2 (different base types)
drivers/infiniband/core/cma.c:1111:69:    expected unsigned short
[unsigned] [usertype] pkey
drivers/infiniband/core/cma.c:1111:69:    got restricted __be16 [usertype] pkey
drivers/infiniband/core/cma.c:2894:56: warning: incorrect type in
argument 3 (different base types)
drivers/infiniband/core/cma.c:2894:56:    expected unsigned short
[unsigned] [usertype] lid
drivers/infiniband/core/cma.c:2894:56:    got restricted __be16 [usertype] mlid
drivers/infiniband/core/cma.c:3155:70: warning: incorrect type in
argument 3 (different base types)
drivers/infiniband/core/cma.c:3155:70:    expected unsigned short
[unsigned] [usertype] lid
drivers/infiniband/core/cma.c:3155:70:    got restricted __be16 [usertype] mlid
[ ... ]

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
