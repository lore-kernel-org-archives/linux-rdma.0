From: Liran Liss <liranl-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: RE: When IBoE will be merged to upstream?
Date: Thu, 15 Jul 2010 13:55:32 +0300
Message-ID: <E113D394D7C5DB4F8FF691FA7EE9DB443ABB321006@MTLMAIL.mtl.com>
References: <adak4pcnw3c.fsf@roland-alpha.cisco.com>
	<E113D394D7C5DB4F8FF691FA7EE9DB443A8E048000@MTLMAIL.mtl.com>
	<4C32D0BD.3030902@Voltaire.com>
	<E113D394D7C5DB4F8FF691FA7EE9DB443A8E2E552A@MTLMAIL.mtl.com>
	<4C3417FA.7000600@Voltaire.com>
	<E113D394D7C5DB4F8FF691FA7EE9DB443AAB6D59C0@MTLMAIL.mtl.com>
	<20100711043449.GA31404@obsidianresearch.com>
	<E113D394D7C5DB4F8FF691FA7EE9DB443AACB08EA5@MTLMAIL.mtl.com>
	<20100712162131.GB15392@obsidianresearch.com>
	<E113D394D7C5DB4F8FF691FA7EE9DB443AACDEE865@MTLMAIL.mtl.com>
	<20100713193138.GA12614@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100713193138.GA12614-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Aleksey Senin <aleksey-192fA4vuk7xBDLzU/O5InQ@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "monis-smomgflXvOZWk0Htik3J/w@public.gmane.org" <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org" <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "yiftahs-smomgflXvOZWk0Htik3J/w@public.gmane.org" <yiftahs-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org" <alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > > The text is saying that the specification does not use any of the 
> > > LID fields in the verbs interface, that is it. It isn't talking 
> > > about MAC addresses.
> > > 
> > > Exactly how and where the MAC address comes about was 
> never decided, 
> > > and at least some participants thought it should be a 1:1 
> > > algorithmic mapping from the GID.
> > > 
> > > Ditto for VLANs, how and where the vlan tag comes about 
> is not part 
> > > of the spec.
> 
> > You are trying to rewrite history.
> > Read the spec, address handles fields are fixed.
> 
> Not really, this was all discussed on this list before the 
> IBxoE working group was formed,

The paragraph above is about the RoCE spec. And *this list* did not write the RoCE spec.

> it was discussed in the 
> working group,

The RoCE spec adopts the verbs defined in the base IB spec and does not add any new input modifiers to the AH verb. You may not agree with it but that does not change the spec.

> I objected to the draft spec leaving this area 
> absent, even.

You should submit a comment on this matter using the IBTA comment tracker database if you intend your concern to be taken into account.

> The spec doesn't say squat about how MAC and 
> VLAN values get into the AH,

True. The spec does not say it because there are no MAC and VLAN input modifiers to the "create AH" verb. The spec assumes the resolution from the L3 address happens below the channel interface.

> and you have already heard how 
> my opinion on this subject differs from others.

I never attempted to misrepresent your opinion. I am just pointing out what the RoCE spec says.

> 
> > > But, even if we do get there some day then we could extend the AH.
> > 
> > This is unacceptable - we are not going to add another L3 
> identifier.
> 
> It wouldn't be adding another L3 itentifier it would be an L2 
> next hop MAC address for the router. It would be nice to do 
> this from the start but if growing the AH is really that 
> scary then it should wait until someone figures out how to 
> solve the lossless routing problem on ethernet.

Augmenting the AH has a significant cost. There is a tradeoff here between preserving the verbs api vs. dealing with the implementation challenges associated with doing address resolution below the verbs. The RoCE spec deliberately chooses one direction. You seem to favor the other one. But in the interest of progress and since we all seem to agree on the way things work when we use link local GIDs, let us move forward with that approach for now. And we can get back to non local GIDs later.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
