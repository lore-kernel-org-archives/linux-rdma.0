From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: RDMA and memory ordering
Date: Mon, 11 Nov 2013 23:13:57 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237388CF721E@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I am running a server which essentially does the following operations in a
> loop:
> 
> A[i].value = counter;  //It's actually something else
> asm volatile ("" : : : "memory");
> asm volatile("mfence" ::: "memory");
> A[i].counter = counter;
> printf("%d %d\n", A[i].value, A[i].counter);
> counter ++;
> 
> Basically, I want a fresh value of A[i].counter to indicate a fresh
> A[i].value.
> 
> I have a remote client which reads the struct A[i] from the server
> (via RDMA) in a loop. Sometimes in the value that the client reads,
> A[i].counter is larger than A[i].value. i.e., I see the newer value of
> A[i].counter but A[i].value corresponds to a previous iteration of the
> server's loop.
> 
> How can this happen in the presence of memory barriers? With barriers,
> A[i].counter should be updated later and therefore should always be
> smaller than A[i].value.
> 
> Thanks for your help!

It seems possible for a remote read to start retrieving memory before an update, such that A[i].value is read and placed on the wire, the server modifies the memory, and then A[i].counter is read and placed on the wire.  It may depend on how large the data is that's being read and the RDMA read implementation.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
