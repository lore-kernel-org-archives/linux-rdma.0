From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Question about writing code that uses librdmacm
Date: Mon, 28 Nov 2011 19:15:22 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E9C6AB@ORSMSX101.amr.corp.intel.com>
References: <CALvMawqCDLA7hj3crH3aOmxsQPM0FdLSdRr6vkkEzD3Fgh+BOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALvMawqCDLA7hj3crH3aOmxsQPM0FdLSdRr6vkkEzD3Fgh+BOA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Is the following code skeleton is legal:

no, but I'm not sure I'm following the skeleton correctly.
 
> rdma_getaddrinfo(NULL, port, &hints, &res);
> rdma_freeaddrinfo(res);
> rdma_listen(listen_id, 0);

I'm assuming that you called rdma_create_id( ... &listen_id ...) somewhere.

> rdma_create_id(NULL, &id, NULL, RDMA_PS_UDP);

You don't want this call.

> rdma_accept(id, NULL) , when a QP wasn't created.

rdma_accept() requires that the listen operate asynchronously, so somewhere you need a call to rdma_get_cm_event().  A connect request event will return a newly created id.  rdma_accept should be called on the id returned in struct rdma_cm_event.
 
- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
