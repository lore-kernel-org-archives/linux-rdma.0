From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv9 09/12] ib_core: Add VLAN support to IBoE
Date: Tue, 17 Aug 2010 09:43:02 -0700
Message-ID: <adatymtur55.fsf@roland-alpha.cisco.com>
References: <20100806144153.GJ20588@mtldesk30>
	<20100806164915.GL11306@obsidianresearch.com>
	<20100816125128.GB22111@mtldesk30>
	<adaeidyw6bd.fsf@roland-alpha.cisco.com>
	<20100817143623.GA626@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100817143623.GA626@mtldesk30> (Eli Cohen's message of "Tue, 17
	Aug 2010 17:36:23 +0300")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > > I'm having a hard time figuring out what this sentence has to do with
 > > this patch.  I don't see anywhere in the patch where the sl field is
 > > used except for copying the TOS into it, and I don't see what "user
 > > priority field" might be referring to.

 > (per the RoCE spec) the 3 LSbs of the SL in the address vector carry
 > the value that is meant to be used in the 802.1Q priority field
 > (user_priority).

OK but as I said I don't see what that has to do with this patch.

 > > Also, how do VLANs work with multicast?  As far as I can tell, there are
 > > no spare bits in an IB MGID or IPv6 multicast address that can be stolen
 > > to use for a VLAN ID.  For example, how would I create an AH to use to
 > > send to MGID ff02::1 on VLAN 25?

 > We take the VLAN from the SGID.

With current API at least the consumer only specifies the SGID index.
How does the consumer get a GID with a given VLAN into the local GID table?
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
