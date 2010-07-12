From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: When IBoE will be merged to upstream?
Date: Mon, 12 Jul 2010 10:21:31 -0600
Message-ID: <20100712162131.GB15392@obsidianresearch.com>
References: <20100625155755.GC4630@obsidianresearch.com> <E113D394D7C5DB4F8FF691FA7EE9DB4439BA54B70E@MTLMAIL.mtl.com> <adak4pcnw3c.fsf@roland-alpha.cisco.com> <E113D394D7C5DB4F8FF691FA7EE9DB443A8E048000@MTLMAIL.mtl.com> <4C32D0BD.3030902@Voltaire.com> <E113D394D7C5DB4F8FF691FA7EE9DB443A8E2E552A@MTLMAIL.mtl.com> <4C3417FA.7000600@Voltaire.com> <E113D394D7C5DB4F8FF691FA7EE9DB443AAB6D59C0@MTLMAIL.mtl.com> <20100711043449.GA31404@obsidianresearch.com> <E113D394D7C5DB4F8FF691FA7EE9DB443AACB08EA5@MTLMAIL.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <E113D394D7C5DB4F8FF691FA7EE9DB443AACB08EA5-WQlSmcKwN8Te+A/uUDamNg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Liran Liss <liranl-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Aleksey Senin <aleksey-192fA4vuk7xBDLzU/O5InQ@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "monis-smomgflXvOZWk0Htik3J/w@public.gmane.org" <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org" <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "yiftahs-smomgflXvOZWk0Htik3J/w@public.gmane.org" <yiftahs-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org" <alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jul 12, 2010 at 10:58:19AM +0300, Liran Liss wrote:

>> "...A verbs consumer using a RoCE network relies strictly
>> > on so-called
>> > > Layer 3 addressing (GIDs); layer 2 addresses (e.g. subnet local
>> > > identifiers) are not passed across the verbs interface..."
>> > 
>> > Ah, hmm, well, I was on that list during this time and I don't
>> think 
>> > this statement means what you are saying it does  :) 
>> >

> ?? It doesn't get any clearer than this.
  
'subnet local identidifer' == LID

The text is saying that the specification does not use any of the LID
fields in the verbs interface, that is it. It isn't talking about MAC
addresses.

Exactly how and where the MAC address comes about was never decided,
and at least some participants thought it should be a 1:1 algorithmic
mapping from the GID.

Ditto for VLANs, how and where the vlan tag comes about is not part of
the spec.

> Good idea! This is exactly what we do today for addresses that the
> user explicitly declares as link-local addresses.  But, we can't
> mandate an overload of the GID in a way that it prevents its use as
> a true L3 address (eventually routable).

We are very unlikely to see routable IBoE, ever.. But, even if we do
get there some day then we could extend the AH.

BTW, I absolutely hate the mixing of 'Sometimes it is a IPv4,
sometimes it is a GID, and sometimes it is an IPv6' in the same
field. That is just so nasty. The GID is a GID, don't overload it in
an ambiguous way to mean 2 other things!

> > create_ah does not accept any sort of source address 
> > specifier
> 
> You are wrong -- sgid_index specifies it.

So, what do you propose to put in sgid_index? It isn't big enough to
store an IPv6 address. You can't exactly number every IP assigned to
every ethernet interface.

The other fields you mention are not a supserset of socket parameters,
they are only IPv6 parameters, IPv4 uses a different set.

> Jason, bottom line, I think that we both agree that the rdmacm
> should do the address resolution.  The difference is that by having
> the rdmacm initially only bind to the device and complete the
> resolution later (by a call from create_ah()), we don't change the
> user API for *all* gid types.  Having addressed your concerns
> regarding resolution below the Verbs, we continue to believe that
> this is the best approach.

Again, I don't see how what I've outlined changes the API in any
way.

Doing two routing lookups for the same connection is bad design, it is
racey. L2 parameters have to flow from the first routing lookup in
RDMA-CM to everything else.

Liran, I don't think you have at all come close to addressing my
concerns, you still haven't explained how a full route lookup is even
possible in create_ah, for instance. Let alone my other concerns!

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
