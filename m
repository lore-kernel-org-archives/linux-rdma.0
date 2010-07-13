From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: When IBoE will be merged to upstream?
Date: Tue, 13 Jul 2010 13:31:39 -0600
Message-ID: <20100713193138.GA12614@obsidianresearch.com>
References: <adak4pcnw3c.fsf@roland-alpha.cisco.com> <E113D394D7C5DB4F8FF691FA7EE9DB443A8E048000@MTLMAIL.mtl.com> <4C32D0BD.3030902@Voltaire.com> <E113D394D7C5DB4F8FF691FA7EE9DB443A8E2E552A@MTLMAIL.mtl.com> <4C3417FA.7000600@Voltaire.com> <E113D394D7C5DB4F8FF691FA7EE9DB443AAB6D59C0@MTLMAIL.mtl.com> <20100711043449.GA31404@obsidianresearch.com> <E113D394D7C5DB4F8FF691FA7EE9DB443AACB08EA5@MTLMAIL.mtl.com> <20100712162131.GB15392@obsidianresearch.com> <E113D394D7C5DB4F8FF691FA7EE9DB443AACDEE865@MTLMAIL.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <E113D394D7C5DB4F8FF691FA7EE9DB443AACDEE865-WQlSmcKwN8Te+A/uUDamNg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Liran Liss <liranl-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Aleksey Senin <aleksey-192fA4vuk7xBDLzU/O5InQ@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "monis-smomgflXvOZWk0Htik3J/w@public.gmane.org" <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org" <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "yiftahs-smomgflXvOZWk0Htik3J/w@public.gmane.org" <yiftahs-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org" <alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 13, 2010 at 11:26:41AM +0300, Liran Liss wrote:

> > 'subnet local identidifer' == LID
> > 
> > The text is saying that the specification does not use any of the LID
> > fields in the verbs interface, that is it. It isn't talking about MAC
> > addresses.
> > 
> > Exactly how and where the MAC address comes about was never decided,
> > and at least some participants thought it should be a 1:1 algorithmic
> > mapping from the GID.
> > 
> > Ditto for VLANs, how and where the vlan tag comes about is not part of
> > the spec.

> You are trying to rewrite history.
> Read the spec, address handles fields are fixed.

Not really, this was all discussed on this list before the IBxoE
working group was formed, it was discussed in the working group, I
objected to the draft spec leaving this area absent, even. The spec
doesn't say squat about how MAC and VLAN values get into the AH, and
you have already heard how my opinion on this subject differs from
others.

> > But, even if we do get there some day then we could extend the AH.
> 
> This is unacceptable - we are not going to add another L3 identifier.

It wouldn't be adding another L3 itentifier it would be an L2 next hop
MAC address for the router. It would be nice to do this from the start
but if growing the AH is really that scary then it should wait until
someone figures out how to solve the lossless routing problem on ethernet.

> > BTW, I absolutely hate the mixing of 'Sometimes it is a IPv4,
> > sometimes it is a GID, and sometimes it is an IPv6' in the same
> > field. That is just so nasty. The GID is a GID, don't overload it in
> > an ambiguous way to mean 2 other things!
> 
> A GID is a GID indeed -- in a RoCE environment, it's the layer 3 identifier.
> All of our intended values are standard ipv6 encapsulations.

What makes a GID a GID is the fact that it is a seperate addressing
space from IPv6! If it is a GID then you don't overload it, if it is
an IPv6 then you don't get to special case certain things, like link
local!

> > > > create_ah does not accept any sort of source address 
> > > > specifier
> > > 
> > > You are wrong -- sgid_index specifies it.
> > 
> > So, what do you propose to put in sgid_index? It isn't big enough to
> > store an IPv6 address. You can't exactly number every IP assigned to
> > every ethernet interface.
> 
> An iboe device is associated with a specific Ethernet
> interface. Thus, its gid table only needs to map the ip addresses
> assigned to that interface.

A few messages ago you said there was only one RDMA device per
physical ethernet interface, not one per vlan! VLAN interfaces can
have overlapping addreses (ie IPv6 link local) so I really don't see
how creating an GID table helps dis-ambiguate these cases.

> > Doing two routing lookups for the same connection is bad design, it is
> > racey. L2 parameters have to flow from the first routing lookup in
> > RDMA-CM to everything else.
> 
> So is caching L3-->L2 mappings that change a second later...
> So what?

No, it is not the same.

If you do a route lookup you get an atomic result from the routing
table that represents something an admin configured. If you do two
lookups and use information from both then the net result might be a
configuration that was never admin configured - ie you loose the
atomicity of route configuration change.

Normally ND mappings (L3->L2) track updates through the things that
use them. The fact this cannot happen with IBoE is another bug, and
again, a reason why it is unsuitable to treat a GID as an IPv6 address
when you cannot provide the same functionality.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
