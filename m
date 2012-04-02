From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Does the CM know how to handle bad packets?
Date: Mon, 2 Apr 2012 19:08:58 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823734519A4A8@ORSMSX101.amr.corp.intel.com>
References: <CALvMawr3KQS=EJ+DG13skKcyVwTCGiy1v-VPPz-5Feygbx+5Pg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALvMawr3KQS=EJ+DG13skKcyVwTCGiy1v-VPPz-5Feygbx+5Pg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> We noticed the following interesting scenario:
> 
> One host sent a CM request to a remote host.
> 
> The remote host, which doesn't have any CM support, performed the following
> steps:
> 
> 
> *	Replaced the sLID with the dLID
> *	Added an indication that this is a response MAD
> *	Set an error indication in the MAD status
> *	Left the payload (the CM req.) untouched
> *	Send the MAD back to the original host that tried to establish the
> connection using the CM

What kernel were you running?

This sounds non-compliant, specifically the part about "added an indication that this is a response MAD" and a non-0 status value in the MAD header.

> We noticed that the host that sent the the CM req. MAD, got it back and tried
> to handle it.
> 
> My questions are:
> 
> *	Does the CM (or maybe a lower module) know to drop a packet (or handle
> it in any other way) when there is a MAD error?

It depends on the error, but the CM will detect and drop certain types of errors.  The MAD layer may drop other errors before handing them up the stack.

> *	Does a CM req. which is being sent in a MAD response is a valid CM
> request?

Based on what you listed above, the MAD sounds like it's invalid.  I don't know if the CM would detect the error without walking through the code path.  Some work may be needed to detect more errors (in cm_recv_handler?) and drop the MADs.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
