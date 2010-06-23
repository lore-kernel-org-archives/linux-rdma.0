From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] RDMA/CMA: fix iWARP adapter TCP port space usage
Date: Wed, 23 Jun 2010 13:01:06 -0700
Message-ID: <adawrtpsem5.fsf@roland-alpha.cisco.com>
References: <OF026C9B22.332F6F2C-ONC1257745.00429E02-C1257745.004E411D@ch.ibm.com>
	<ada8w65veq4.fsf@roland-alpha.cisco.com>
	<4C225078.6050001@opengridcomputing.com>
	<adar5jxtxho.fsf@roland-alpha.cisco.com>
	<4C225697.6060702@opengridcomputing.com>
	<20100623192909.GT4630@obsidianresearch.com>
	<4C2263B3.9010608@opengridcomputing.com>
	<20100623195210.GU4630@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100623195210.GU4630-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> (Jason Gunthorpe's
	message of "Wed, 23 Jun 2010 13:52:10 -0600")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>, "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma@vger.kernel.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter P Waskiewicz Jr <peter.p.waskiewicz.jr-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > Doesn't that mean the port collision problem still exits [for iSCSI],
 > although probably less likely?

Yes, it's there, but almost impossible to hit: first of all, iSCSI HBAs
never listen on a port, so that can never collide.  Second, iSCSI HBAs
only establish connections to iSCSI targets on the iSCSI port -- so
really your only chance of a problem is if you ran an offloaded and
non-offloaded iSCSI initiator on the same IP to the same target, _and_
you got unlucky on the local ports that you chose.  So in practice no
one will hit this.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
