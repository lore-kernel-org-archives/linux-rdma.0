From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC] [PATCH 5/22 v2] [for 2.6.36] rdma/cm: update port
	reservation to support AF_IB
Date: Thu, 25 Mar 2010 17:43:58 -0600
Message-ID: <20100325234358.GQ29129@obsidianresearch.com>
References: <2F3826558E79459EAD2A457A604221C1@amr.corp.intel.com> <012F7D9E5E97445E9100EF170212AEE7@amr.corp.intel.com> <7451BD1514874F3E987E55040776EECC@amr.corp.intel.com> <20100325202924.GO29129@obsidianresearch.com> <AC26D518E7AE4BE6BA3BDFC11480F8DB@amr.corp.intel.com> <20100325220435.GP29129@obsidianresearch.com> <C70579E21917462C89AAEAE3C225A58B@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <C70579E21917462C89AAEAE3C225A58B-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 25, 2010 at 03:40:35PM -0700, Sean Hefty wrote:

> >I would be inclined to ditch the port space concept entirely for
> >AF_IB. Just ignore the input parameter and always base the selection
> >on the SID region. It is confusing to that there are two ways to
> >specify the same thing.
> 
> The address family is not sufficient to determine the desired port space.  For
> example, AF_INET is usable for RDMA_PS_TCP and RDMA_PS_UDP.

Right, but AF_IB has only one 'port space' - SID, so the ps input
parameter should be unused. It is reasonable that port space is an
address family specific input like the protocol input is to socket(2).

For now, what can happen inside the kernel is that a function like
cma_get_port can include:

if (sa_family == AF_IB) {
   if (sib_sid inside SDP_PREFIX)
          ps = &sdp_ps;
   if (sib_sid inside TCP_PREFIX)
          ps = &tcp_ps;
   if (sib_sid inside UDP_PREFIX)
          ps = &udp_ps;
   else -EINVAL; // FIXME, support more cases
}

And the user specifies the port space they want by setting the sib_sid
and sib_sid_mask appropriately.

Ideally want we want in the kernel is a better scheme than seperate
idr tables for managing the SID space in IB - the user API should be
built to support that general notion and the kernel can catch up.

If no bind address is specified then the kernel can use the IB locally
administered SID prefix of 0x2/8.

So the flow is:
 - AF_INET/AF_INET6 *must* specify a port space and use 16 bit port
   addressing
 - AF_IB does not use the port space input
 - AF_IB with no bind address, or a wild card SID, is identical to
   binding to the SID 0x2/8
 - AF_IB with a bind address can bind to any port space by specifying
   the correct SID prefix during bind.

These semantics are intended to make sense as a user space API, not
so much to reflect how the kernel currently works..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
