From: Liran Liss <liranl-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: RE: When IBoE will be merged to upstream?
Date: Mon, 12 Jul 2010 10:58:19 +0300
Message-ID: <E113D394D7C5DB4F8FF691FA7EE9DB443AACB08EA5@MTLMAIL.mtl.com>
References: <20100624203701.GA4630@obsidianresearch.com>
	<E113D394D7C5DB4F8FF691FA7EE9DB4439A78B0042@MTLMAIL.mtl.com>
	<20100625155755.GC4630@obsidianresearch.com>
	<E113D394D7C5DB4F8FF691FA7EE9DB4439BA54B70E@MTLMAIL.mtl.com>
	<adak4pcnw3c.fsf@roland-alpha.cisco.com>
	<E113D394D7C5DB4F8FF691FA7EE9DB443A8E048000@MTLMAIL.mtl.com>
	<4C32D0BD.3030902@Voltaire.com>
	<E113D394D7C5DB4F8FF691FA7EE9DB443A8E2E552A@MTLMAIL.mtl.com>
	<4C3417FA.7000600@Voltaire.com>
	<E113D394D7C5DB4F8FF691FA7EE9DB443AAB6D59C0@MTLMAIL.mtl.com>
	<20100711043449.GA31404@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100711043449.GA31404-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Aleksey Senin <aleksey-192fA4vuk7xBDLzU/O5InQ@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "monis-smomgflXvOZWk0Htik3J/w@public.gmane.org" <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org" <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "yiftahs-smomgflXvOZWk0Htik3J/w@public.gmane.org" <yiftahs-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org" <alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > "...A verbs consumer using a RoCE network relies strictly
> on so-called
> > Layer 3 addressing (GIDs); layer 2 addresses (e.g. subnet local
> > identifiers) are not passed across the verbs interface..."
> 
> Ah, hmm, well, I was on that list during this time and I don't think 
> this statement means what you are saying it does :)
>

?? It doesn't get any clearer than this.
  
> > As opposed to what it may seem at first sight, adding Eth L2 
> > parameters to the address vector, *does not* make RoCE closer to IB.
> > It actually goes the other way around.  Here is a quick
> list of what
> > would have to be changed if we were to include Eth L2 address 
> > parameters to the Address Vector and other
> structures/functions that
> > expose L2 params:
> 
> Umh, no.. Stick the L2 address in the GID itself, stick the vlan tag 
> in either the DLID or the PKey and you are done. No structures get 
> bigger, nothing really changes.
> 

Good idea! This is exactly what we do today for addresses that the user explicitly declares as link-local addresses.
But, we can't mandate an overload of the GID in a way that it prevents its use as a true L3 address (eventually routable). 

> There are already AH differences between iwarp and IB and generic code 
> to handle them.

Right, the iwarp code relies on rdmacm only to bind to a device, and then does L3-->L2 resolution on its own.

> 
> rdmacm can support address resultion only for UD applications.
> 
> Still not seeing how this is a big issue? 

UD applications would like to enjoy link-layer transparency as well, you know...

> 
> You cannot hide destination resolution in create_ah. You just can't.

Why?

> create_ah does not accept any sort of source address 
> specifier

You are wrong -- sgid_index specifies it.

> which is absolutely critical to reoslve a 
> destination ip address in all cases, ie for instance IPv6 link local 
> addresses, but there are other cases too.
> 
> If IP semantics are going to be used then *ALL* linux IP semantics 
> must be supported, not just those that are convinent to implement, and 
> that means you need a source IP address, device, QOS parameters and 
> destination IP address to make a route determination.

An address handle has a source address, destination address, flow_label, and traffic class, and is already associated with a specific device.
In fact, it is a superset of every field in the socket address that the application passed rdmacm in the first place!

> 
> The only subsystem in verbs that has this information is RDMA CM.
> 

Right, this is why we will call a generic rdmacm function to resolve the address handle for us :)

> To me this is a fundamental problem that completely nixes L3

Jason, bottom line, I think that we both agree that the rdmacm should do the address resolution.
The difference is that by having the rdmacm initially only bind to the device and complete the resolution later (by a call from create_ah()), we don't change the user API for *all* gid types.
Having addressed your concerns regarding resolution below the Verbs, we continue to believe that this is the best approach.

--Liran
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
