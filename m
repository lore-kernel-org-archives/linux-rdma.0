From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: ib_uverbs: list corruption destroying a cq
Date: Wed, 26 Jul 2017 11:34:54 -0500
Message-ID: <00e301d3062d$1c7a2be0$556e83a0$@opengridcomputing.com>
References: <00d301d30627$26b58d80$7420a880$@opengridcomputing.com> <CAAKD3BCkZVcMbvyMPVF75Kg0wU4Ld7cByMTWRrydgsyqjCuS9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAAKD3BCkZVcMbvyMPVF75Kg0wU4Ld7cByMTWRrydgsyqjCuS9g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Matan Barak' <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> Hi Steve,
> 
> AFAIK, we haven't seen anything like this. A few questions:
> 1. Does your test use multiple threads from which it executes uverbs commands?

Yes.  This particular test runs 6 processes, each setting up hundreds of connections and divvying up the workload among many threads.  Over 100 threads (the poor host probably has 8 cpus :)).

> 2. Does your test use completion channel?

Not in this instance; polling only.  Each connection gets its own cq for both the RQ and SQ of its QP.

> 3. Which rdma device are you using?

iw_cxgb4

> 4. Do you know approximately in which kernel version this warning started?

I believe 4.13-rc.  But I'm not certain. 

> 5. Is it reproducible?

They hit it once after ~4 hours so far, and the tests keep running subsequent instances.

> 6. Are you willing to send the actual test?
>

I don't think that's possible.  


I'll keep debugging, but was wondering if anyone has seen this already in 4.13-rc.  

Thanks Matan!

Steve.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
