From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: QoS in local SA entity
Date: Sun, 08 Nov 2009 08:25:55 +0200
Message-ID: <4AF66473.2050303@voltaire.com>
References: <4AF2C00A.4040808@voltaire.com> <9BF1CEFA7F6F44F5B5641065C4914EB5@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9BF1CEFA7F6F44F5B5641065C4914EB5-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sean Hefty wrote:
> I wasn't trying to limit how the SA could 'distribute' QoS information to the end nodes.  ACM will obtain QoS information from the SA when it joins its
> multicast groups
excellent... still, this is dependent on how the ACM MGIDs are 
constructed, I'll take a look on the code.

> ACM is intended to be a service that's used by the librdmacm to resolve address mappings and routes.  Trying to have ACM use the librdmacm ends up with a circular dependency.  That's the part I'm trying to avoid.

fail-enough, I believe that my suggestion is doable also without 
circular dependency, e.g as you indicated below or with a fairly small 
enhancement of librdmacm, see next


> ACM uses address mappings as defined in an address configuration file (IP ->
> device, port, pkey).  The address file can be created using the provided ib_acme utility, which uses the current system configuration (in an ugly way, but it works).  I think this provides QoS behavior similar to what you're describing
I assume you are referring to an IP local to the system where ACM runs 
on correct? this would work well for applications calling rdma_bind 
and/or rdma_resolve_address while specifying a source address. To 
support also the case of application which do neither of these two, that 
is call rdma_resolve_addr with dest address only, I suggest to enhance 
librdmacm-calling-ACM flow and resolve the source address using route 
lookup from user space, next the librdmacm can issue rdma_bind on behalf 
of this ID and you have the <device, port, pkey> triplet at your hand so 
now the ACM call can be made form librdmacm. Writing this, I realized 
that better(should) be done also for apps _resove_addr with src ip 
specified. This way you have unified flow for the ACM use in librdmacm 
for either of apps A,B,C below

A.1 rdma_bind(src=X)
A.2 rdma_resolve_addr(src=null, dst=Y)

B.1 rdma_resolve_addr(src=null, dst=Y)

C.1 rdma_resolve_addr(src=X, dst=Y)

where librdmacm calling-ACM flow is

L1. compute source address
L2. issue kernel rdma_bind to source address and resolve <device, port, 
pkey>
L3. issue ACM address (DGID) resolution call using (<device, port, 
pkey>, dest-ip)

makes sense? if yes, what's the need in the address configuration file?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
