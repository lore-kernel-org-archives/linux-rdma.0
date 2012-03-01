From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: possible circular locking dependency in ucma
Date: Thu, 1 Mar 2012 22:22:17 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823733B765D97@ORSMSX101.amr.corp.intel.com>
References: <alpine.LRH.2.00.1202271115070.22652@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LRH.2.00.1202271115070.22652-VYr5/9ddeaGSIdy2EShu12Xnswh1EIUO@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I run into the below ucma related warnings from the kernel with 3.3-rc5
> when I stepped over crash of process as of wrong libs/etc (not the point
> here...). Do you see here a real bug? basically the process was exiting
> and the cleanup code in the kernel was running rdma_destroy_id when a
> callback on that id was arriving from the IB CM. I saw that you lately
> touched that/similar area in commit 9ced69ca5296567033804950d8d2161f454c5012
> "RDMA/ucma: Discard all events for new connections until accepted"

This is a real issue, but unrelated to the above commit.  The problem has likely existed in the code for quite a while.  I'll work on a fix.

- Sean

--
FYI
The issue is that under certain conditions, we hold file->mut when calling rdma_destroy_id().  rdma_destroy_id() blocks until all outstanding callbacks complete, but in this case the callback also wants to acquire file->mut, resulting in the deadlock.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
