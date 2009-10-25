From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] link-local address fix for rdma_resolve_addr
Date: Sun, 25 Oct 2009 13:52:13 +0200
Message-ID: <4AE43BED.3090405@voltaire.com>
References: <676AB781CD644CC28E1AD4951EA4EEF8@amr.corp.intel.com>	<20091020003344.GA14520@obsidianresearch.com>	<1256164230.12075.31.camel@wilder.ibm.com>	<9D257695083141E79685CB2B260D7D7C@amr.corp.intel.com>	<20091021233639.GS14520@obsidianresearch.com>	<BFF5CD71FFA74BF09A2EED5F3319F370@amr.corp.intel.com>	<20091022002846.GU14520@obsidianresearch.com>	<4803112A5B7A4953B62ABAFD1BBD9881@amr.corp.intel.com>	<20091022011939.GW14520@obsidianresearch.com>	<60E9443821EE4FFA90448DF5CC1368A8@amr.corp.intel.com> <20091022062531.GB26003@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091022062531.GB26003-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "'David J. Wilder'" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Jason Gunthorpe wrote:
> Mainly for RDMA what you get is more kernel flexability, IP like
> capabilities, better bonding, and better support of IB APM semantics:
>  - bind() + listen() actually works properly if more than one
>    interface is bound to the same IP - the cm_id returned by accept is
>    bound to the hca and port that accepted the connection
>    [ This is a L3 form of bonding Linux supports ]
>
>    This is actually something of a mandatory notion to implement the
>    full generality of the IB CM protocol which allows the CM REP to
>    contain a port GUID of another port on the same node (multi-port
>    APM is an IB feature). So you never know what port the accept()
>    result will get bound to.
>
>    BTW: I suppose ideally AF_IB would have a way to say 'CM accept REPs on
>    any port on this node' Hmm, reserved GID prefix perhaps? Hmm.
>
>    When used with bonding this would also afford the kernel with the
>    ability to accept incoming connections across all the redundant
>    RDMA devices - and still have correct bound-to-IP semantics.
>
>  - rdma_resolve_addr more or less as the inverse of all the above
>    * multiple interfaces with same IP case works, kernel and routing
>      table can distribute outgoing connections
>    * multi-port APM works, kernel and user space can choose primary
>      and backup port for the IP addy
>    * bonding works, kernel can balance outgoing connections across the
>      bond slaves.
>
> These are all useful features.

Jason,  Have you even looked into or tested any of the bonding 
load-balancing modes with ipoib? some/most of them are not applicable to 
IPoIB and I don't think that the ones which may be such were ever 
tested. Next, multiple interfaces with the same ip address isn't 
something I see very useful for production environment (but I'd be happy 
to get educated what L3 bonding is and where it can play), next, 
multi-port APM isn't something I ever heard to be required by customers 
and more important, from comments made by Sean in the past, I don't 
think it fits the rdma-cm spirit.

All in all, someone comes here and suggests some fixes to the rdma-cm 
address resolution code to have IPv6 work. I don't think Dave should 
carry on his back/patch all your proposed future enhancements.  Let him 
fix things and following that you can work on the patches to support all 
these nice/nitch features starting with IPv4 and then IPv6.

Or

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
