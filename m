From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: RDMA CM EVENT rejected with status = 4 (timeout)
Date: Fri, 23 Aug 2013 19:59:22 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237388CA7FF4@ORSMSX109.amr.corp.intel.com>
References: <CABqF1pZSmv1S-07pGxwoSaLB7zYWRhuFxiAtz6S-hFYtyEOY5w@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A8237388CA7FBA@ORSMSX109.amr.corp.intel.com>
 <CABqF1pZPX_WovmcgQ37LXnzXUYw+ADUxx=v7a6Ao_Rr15WmgcQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CABqF1pZPX_WovmcgQ37LXnzXUYw+ADUxx=v7a6Ao_Rr15WmgcQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: lokesh agarwal <lokesh.agarwal1986-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Can you point me to the patch that fixes this..? I am using ofed 1.5.5 bits...

I don't recall which patches.  But the following commits to the upstream kernel may be relevant:

418edaaba96e58112b15c82b4907084e2a9caf42
RDMA/ucma.c: Fix for events with wrong context on iWARP

186834b5de69a89ba6cc846e7259451ced689b64
RDMA/ucma: Fix AB-BA deadlock

9ced69ca5296567033804950d8d2161f454c5012
RDMA/ucma: Discard all events for new connections until accepted

Those are all that stood out to me looking back to 2009.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
