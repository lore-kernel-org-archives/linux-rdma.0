From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next V0.1 4/7] IB/core: Add RSS and TSS QP groups
Date: Thu, 10 May 2012 23:37:02 +0300
Message-ID: <CAJZOPZJOOULA9V2gqTZBJsUyiuhRVkCnoZ4ZFS1Q6KQBRw5pcg@mail.gmail.com>
References: <alpine.LRH.2.00.1205091803420.21487@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LRH.2.00.1205091803420.21487-VYr5/9ddeaGSIdy2EShu12Xnswh1EIUO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <mshefty-+/W+9+QloQG75v1z/vFq2g@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> RSS (Receive Side Scaling) TSS (Transmit Side Scaling, better known as
> MQ/Multi-Queue) are common networking techniques which allow to use
> contemporary NICs that support multiple receive and transmit descriptor
> queues (multi-queue), see also Documentation/networking/scaling.txt
>
> This patch introduces the concept of RSS and TSS QP groups which
> allows for implementing them by low level drivers and using it
> by IPoIB and later also by user space ULPs.

Hi Roland, Sean, everyone,

We'd be specially happy to get feedback on the QP groups concept,
which is used to implement RSS/TSS. Please note that the concept would
(with little help from a framework for verbs extension) apply to user
space as well, for both UD and RAW QPs.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
