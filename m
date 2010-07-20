From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: When IBoE will be merged to upstream?
Date: Tue, 20 Jul 2010 11:06:35 -0600
Message-ID: <20100720170635.GB25070@obsidianresearch.com>
References: <adak4pcnw3c.fsf@roland-alpha.cisco.com> <E113D394D7C5DB4F8FF691FA7EE9DB443A8E048000@MTLMAIL.mtl.com> <4C32D0BD.3030902@Voltaire.com> <E113D394D7C5DB4F8FF691FA7EE9DB443A8E2E552A@MTLMAIL.mtl.com> <4C3417FA.7000600@Voltaire.com> <E113D394D7C5DB4F8FF691FA7EE9DB443AAB6D59C0@MTLMAIL.mtl.com> <20100711043449.GA31404@obsidianresearch.com> <E113D394D7C5DB4F8FF691FA7EE9DB443AACB08EA5@MTLMAIL.mtl.com> <20100712162131.GB15392@obsidianresearch.com> <004e01cb27cc$61807010$24815030$@com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <004e01cb27cc$61807010$24815030$@com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paul Grun <pgrun-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Cc: 'Liran Liss' <liranl-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, 'Or Gerlitz' <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>, 'Roland Dreier' <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "'Hefty, Sean'" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Aleksey Senin' <aleksey-192fA4vuk7xBDLzU/O5InQ@public.gmane.org>, 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, monis-smomgflXvOZWk0Htik3J/w@public.gmane.org, alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org, yiftahs-smomgflXvOZWk0Htik3J/w@public.gmane.org, 'Tziporet Koren' <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Jul 19, 2010 at 10:28:24PM -0700, Paul Grun wrote:

> This is incorrect.  The intent of the text is that a verbs consumer deals
> ONLY in layer 3 addresses (GIDs).  It doesn't make any sense to restrict the
> interpretation to mean 'LIDs', since LIDs are a NOP for RoCE.  
> 
> CA16-17: When accessing the services of a RoCE verbs provider, the
> source and destination identifiers contained in the address vector shall
> consist of GIDs; the address vector shall not contain layer 2 references
> (e.g. local addresses). Layer 2 references include source and destination
> local identifiers and LID Path Bits.
> 
> "layer 2 references" refers to LIDs, MAC IDs or any other form of layer 2
> address.  If the wording of the text is insufficiently clear, please post a
> comment on comment tracker on the IBTA website.  Nevertheless, that is the
> intent.  

Since it never actually says MAC address it reads like it is just
excluding existing IB L2 addresses from use in ROCEE which makes alot
sense. If MAC address was ment, it should have been listed explicitly!

> > Exactly how and where the MAC address comes about was never decided,
> 
> Correct.  The IBTA IBXoE WG felt that defining the mapping from GID to MAC
> ID should be a function of the underlying fabric (Ethernet) and thus was out
> of scope for us to define the mapping mechanism.

IHMO, it is a bad design to create a architecture that requires the L2
information in the AH, forbid the L2 information from being passed
into the AH APIs, and then not specify how the L2 information is
created.

How is anyone supposed to implement this?

> > BTW, I absolutely hate the mixing of 'Sometimes it is a IPv4,
> > sometimes it is a GID, and sometimes it is an IPv6' in the same
> > field. That is just so nasty. The GID is a GID, don't overload it in
> > an ambiguous way to mean 2 other things!
> 
> I am unaware of any overloading, at least in the RoCE spec.

This is a feature added as part of the proposed patch set that spurned
this whole discussion. It is this feature that made create_ah into a
blocking call ...

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
