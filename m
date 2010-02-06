From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: bug 1918 - openmpi broken due to rdma-cm changes
Date: Fri, 05 Feb 2010 16:54:30 -0800
Message-ID: <ada8wb7xjy1.fsf@roland-alpha.cisco.com>
References: <ada4olvefl4.fsf@roland-alpha.cisco.com>
	<324EFA68-12F6-46E9-B876-7F4847B53224@cisco.com>
	<4B6C6453.9090706@opengridcomputing.com>
	<20100205185616.GS16490@obsidianresearch.com>
	<E8FF8BD1-80AC-4AA7-BC2A-CE7547FB9ABA@cisco.com>
	<20100205211455.GT16490@obsidianresearch.com>
	<697C6107-13A9-48E3-B451-02529305100D@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <697C6107-13A9-48E3-B451-02529305100D-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> (Jeff Squyres's
	message of "Fri, 5 Feb 2010 16:40:16 -0500")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > > Well, I think you are right. This kind of change seems appropriate to
 > > me for mainline, but OFED/RHEL should carry a responsibility to manage
 > > an identified incompatibility, either patch their kernel, patch their
 > > OMPI, or publish an errata. That is the role of a distribution.
 > 
 > RHEL has said, multiple times, that they rely on OpenFabrics to do the Right Thing.  They don't do a lot of testing, validating, etc.

In that case OFED plays the role of distribution.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cisco.com - http://www.cisco.com

For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
