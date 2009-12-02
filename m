From: "Liran Liss" <liranl-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: RE: RDMAoE verbs questions
Date: Wed, 2 Dec 2009 12:49:14 +0200
Message-ID: <2ED289D4E09FBD4D92D911E869B97FDD01D64806@mtlexch01.mtl.com>
References: <F57121538EA0C94F86018DDD40ADA1D101A4E9A6@mtiexch01.mti.com>	<2ED289D4E09FBD4D92D911E869B97FDD01CBE494@mtlexch01.mtl.com>	<2ED289D4E09FBD4D92D911E869B97FDD01D0D6F9@mtlexch01.mtl.com>	<44B4931AF8354AF3BABCCA052150D2BA@amr.corp.intel.com> <2ED289D4E09FBD4D92D911E869B97FDD01D0D792@mtlexch01.mtl.com> <4B162080.6070805@voltaire.com> <000001ca732d$1f99b4d0$5ecd1e70$@com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-class: urn:content-classes:message
In-Reply-To: <000001ca732d$1f99b4d0$5ecd1e70$@com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paul Grun <pgrun-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Paul, you are not missing anything - lookback communication will work
in RDMAoE just as in IB.
--Liran

-----Original Message-----
From: Paul Grun [mailto:pgrun-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org] 
Sent: Wednesday, December 02, 2009 10:55 AM
To: 'Or Gerlitz'; Liran Liss
Cc: 'Sean Hefty'; 'Jason Gunthorpe'; 'Eli Cohen'; 'Jeff Squyres';
linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: RE: RDMAoE verbs questions

Why do you say that Or?  
I'm a hardware guy so can't comment on what the s/w supports/prevents,
but I can see no reason why loopback wouldn't be supported.  In fact, if
I were guessing, I would guess that the spec currently under development
would support loopback.tt What am I missing?
-Paul

-----Original Message-----
From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
[mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Or Gerlitz
Sent: Wednesday, December 02, 2009 12:09 AM
To: Liran Liss
Cc: Sean Hefty; Jason Gunthorpe; Eli Cohen; Jeff Squyres;
linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: RDMAoE verbs questions

Liran Liss wrote:
> from an rdmacm app's point of view - there is no visible difference
between IB and RDMAoE ports: both support the complete set of Verbs,
just as any IB transport provider
>   
wrong,  local (loopback) communication aren't supported  with RDMAoE.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info
at  http://vger.kernel.org/majordomo-info.html


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
