From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: When IBoE will be merged to upstream?
Date: Thu, 15 Jul 2010 10:59:25 -0600
Message-ID: <20100715165925.GA18583@obsidianresearch.com>
References: <4C32D0BD.3030902@Voltaire.com> <E113D394D7C5DB4F8FF691FA7EE9DB443A8E2E552A@MTLMAIL.mtl.com> <4C3417FA.7000600@Voltaire.com> <E113D394D7C5DB4F8FF691FA7EE9DB443AAB6D59C0@MTLMAIL.mtl.com> <20100711043449.GA31404@obsidianresearch.com> <E113D394D7C5DB4F8FF691FA7EE9DB443AACB08EA5@MTLMAIL.mtl.com> <20100712162131.GB15392@obsidianresearch.com> <E113D394D7C5DB4F8FF691FA7EE9DB443AACDEE865@MTLMAIL.mtl.com> <20100713193138.GA12614@obsidianresearch.com> <E113D394D7C5DB4F8FF691FA7EE9DB443ABB321006@MTLMAIL.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <E113D394D7C5DB4F8FF691FA7EE9DB443ABB321006-WQlSmcKwN8Te+A/uUDamNg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Liran Liss <liranl-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Aleksey Senin <aleksey-192fA4vuk7xBDLzU/O5InQ@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "monis-smomgflXvOZWk0Htik3J/w@public.gmane.org" <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org" <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "yiftahs-smomgflXvOZWk0Htik3J/w@public.gmane.org" <yiftahs-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org" <alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 15, 2010 at 01:55:32PM +0300, Liran Liss wrote:

> > I objected to the draft spec leaving this area 
> > absent, even.
> 
> You should submit a comment on this matter using the IBTA comment
> tracker database if you intend your concern to be taken into account.

The position of IBTA is that the L2 layer is not specified as part of
the spec, so of course there is no talk of how to get/create L2
information. The spec is *silent* on the issue of L2 addressing, so,
IMHO, it is compltely wrong to assume it specs one approach over
another, just because it omits L2 addressing related
discussion/fields/etc.

It, unfortunately, becomes implementation defined - and if that means
an implementation chooses to extend the AH, then so be it.

This is the problem with rushing incomplete specs through :)

> > It wouldn't be adding another L3 itentifier it would be an L2 
> > next hop MAC address for the router. It would be nice to do 
> > this from the start but if growing the AH is really that 
> > scary then it should wait until someone figures out how to 
> > solve the lossless routing problem on ethernet.

> Augmenting the AH has a significant cost. There is a tradeoff here
> between preserving the verbs api vs. dealing with the implementation
> challenges associated with doing address resolution below the
> verbs. The RoCE spec deliberately chooses one direction. You seem to
> favor the other one. But in the interest of progress and since we
> all seem to agree on the way things work when we use link local
> GIDs, let us move forward with that approach for now. And we can get
> back to non local GIDs later.

You still have to solve the problem with vlan tags, and either each
vlan interface has a seperate rdma interface or the tag has to flow
into the AH from the RDMA-CM.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
