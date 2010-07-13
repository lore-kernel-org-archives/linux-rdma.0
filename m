From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: When IBoE will be merged to upstream?
Date: Tue, 13 Jul 2010 14:20:12 -0700
Message-ID: <ada8w5fxenn.fsf@roland-alpha.cisco.com>
References: <E113D394D7C5DB4F8FF691FA7EE9DB4439BA54B70E@MTLMAIL.mtl.com>
	<adak4pcnw3c.fsf@roland-alpha.cisco.com>
	<E113D394D7C5DB4F8FF691FA7EE9DB443A8E048000@MTLMAIL.mtl.com>
	<4C32D0BD.3030902@Voltaire.com>
	<E113D394D7C5DB4F8FF691FA7EE9DB443A8E2E552A@MTLMAIL.mtl.com>
	<4C3417FA.7000600@Voltaire.com>
	<E113D394D7C5DB4F8FF691FA7EE9DB443AAB6D59C0@MTLMAIL.mtl.com>
	<20100711043449.GA31404@obsidianresearch.com>
	<E113D394D7C5DB4F8FF691FA7EE9DB443AACB08EA5@MTLMAIL.mtl.com>
	<adatyo4xuqx.fsf@roland-alpha.cisco.com>
	<20100713193828.GB12614@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100713193828.GB12614-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> (Jason Gunthorpe's
	message of "Tue, 13 Jul 2010 13:38:28 -0600")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Liran Liss <liranl-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Aleksey Senin <aleksey-192fA4vuk7xBDLzU/O5InQ@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "monis@voltaire.com" <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "alekseys@voltaire.com" <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "yiftahs@voltaire.com" <yiftahs-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "alexr@voltaire.com" <alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > A quibble about multicast - AFAIK this is unsolved. I think some spec
 > needs to be agreed that documents what sort of multicast snooping
 > operations switches need to do, ie if IGMP joins imply that IBoE
 > traffic for the same DMAC is included in the join, or if IBoE requires
 > a seperate IGMP type process on its own ether-type. That would make it
 > much clearer what to do with MGIDs.

I agree -- the current spec is rather broken for multicast.  Choosing a
different ethertype and then saying that all switches will just flood
multicast traffic is half-baked at best.

 > It would be nice to at least have a plan on how to integrate a
 > non-link local address, if that is ever necessary in future. An
 > extended AH with an additional 48 DMAC field seems reasonable to me?

You mean have a next-hop destination + a final destination?  Could be
done I guess.  But I'm not sure how having a routing table where you
have to look up 48-bit Ethernet addresses is all that different from
just having a standard Ethernet forwarding table.

I suppose something based on MAC-in-MAC (a la 802.1ah) could be done but
to be honest the IBoE spec that the IBTA came up with looks rather
broken for routing.

 - R.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
