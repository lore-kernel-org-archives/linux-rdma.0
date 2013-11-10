From: Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: RDMA and memory ordering
Date: Sun, 10 Nov 2013 06:46:30 -0400
Message-ID: <CADPSxAhAGYZude8CM65-UDvfiPscStgcNsAfs=2XBbntg-wL0w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi.

I am running a server which essentially does the following operations in a loop:

A[i].value = counter;  //It's actually something else
asm volatile ("" : : : "memory");
asm volatile("mfence" ::: "memory");
A[i].counter = counter;
printf("%d %d\n", A[i].value, A[i].counter);
counter ++;

Basically, I want a fresh value of A[i].counter to indicate a fresh A[i].value.

I have a remote client which reads the struct A[i] from the server
(via RDMA) in a loop. Sometimes in the value that the client reads,
A[i].counter is larger than A[i].value. i.e., I see the newer value of
A[i].counter but A[i].value corresponds to a previous iteration of the
server's loop.

How can this happen in the presence of memory barriers? With barriers,
A[i].counter should be updated later and therefore should always be
smaller than A[i].value.

Thanks for your help!

Anuj Kalia,
Carnegie Mellon University
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
