From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: IB/cma: Make timeout dependent on the subnet timeout
Date: Fri, 25 Apr 2014 18:21:58 +0200
Message-ID: <535A8BA6.4090603@acm.org>
References: <53566BB5.5030203@acm.org> <1828884A29C6694DAF28B7E6B8A82373992F2F15@ORSMSX109.amr.corp.intel.com> <5357B25D.2000108@dev.mellanox.co.il> <5357B626.8050209@acm.org> <1828884A29C6694DAF28B7E6B8A82373992F32A2@ORSMSX109.amr.corp.intel.com> <5358BF9D.4030409@mellanox.com> <1828884A29C6694DAF28B7E6B8A82373992F4F6E@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373992F4F6E-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 04/25/14 04:59, Hefty, Sean wrote:
>> Sean, can't we have CMA to follow the same practice used in the CM where
>> we derive the RC QP timeout based on the packet life time retrieved in
>> path queries? e.g base the cm response time out on this value  too?
> 
> We could.  The timeout that's being modified by the patch is the time needed
> by the remote peer to process the incoming message and send a
response. This
> time is in addition to the packet life time value that gets used.
> 
> For a remote kernel agent, the time needed to respond to a CM message may be
> fairly small.  For a user space client, the time may be significant,
on the
> order to seconds to minutes.  We can probably make due with a fairly short
> timeout, provided that MRAs are used by the remote side.
> 
> There's no great solution that I can think of.  Maybe the RDMA CM can adjust
> the timeout based on the remote address, assuming that it can determine if
> the remote address is a user space or kernel agent.

Another possible approach is to make the CM timeout configurable for
kernel clients only. How about creating two versions of struct
rdma_conn_param - the existing version for communication between user
space and kernel and a second version for in-kernel clients only ? In
that second version a field could be added that allows to specify the CM
timeout.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
