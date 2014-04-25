From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: IB/cma: Make timeout dependent on the subnet timeout
Date: Fri, 25 Apr 2014 02:59:29 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373992F4F6E@ORSMSX109.amr.corp.intel.com>
References: <53566BB5.5030203@acm.org>
 <1828884A29C6694DAF28B7E6B8A82373992F2F15@ORSMSX109.amr.corp.intel.com>
 <5357B25D.2000108@dev.mellanox.co.il> <5357B626.8050209@acm.org>
 <1828884A29C6694DAF28B7E6B8A82373992F32A2@ORSMSX109.amr.corp.intel.com>
 <5358BF9D.4030409@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5358BF9D.4030409-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Sean, can't we have CMA to follow the same practice used in the CM where
> we derive the RC QP timeout based on the packet life time retrieved in
> path queries? e.g base the cm response time out on this value  too?

We could.  The timeout that's being modified by the patch is the time needed by the remote peer to process the incoming message and send a response.  This time is in addition to the packet life time value that gets used.

For a remote kernel agent, the time needed to respond to a CM message may be fairly small.  For a user space client, the time may be significant, on the order to seconds to minutes.  We can probably make due with a fairly short timeout, provided that MRAs are used by the remote side.

There's no great solution that I can think of.  Maybe the RDMA CM can adjust the timeout based on the remote address, assuming that it can determine if the remote address is a user space or kernel agent.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
