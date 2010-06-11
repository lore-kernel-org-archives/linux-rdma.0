From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] RDMA/CMA: fix iWARP adapter TCP port space usage
Date: Fri, 11 Jun 2010 15:08:20 -0700
Message-ID: <adamxv1w7cb.fsf@roland-alpha.cisco.com>
References: <20100611124746.GA2292@CTUNG-MOBL1>
	<adapqzxy2sb.fsf@roland-alpha.cisco.com>
	<2EFBCAEF10980645BBCFB605689E08E904924CCE42@azsmsx506.amr.corp.intel.com>
	<4C12A6E8.5040400@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C12A6E8.5040400-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> (Steve Wise's message of
	"Fri, 11 Jun 2010 16:13:12 -0500")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma@vger.kernel.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > You can peruse this thread from 2007:
 > 
 > http://lkml.org/lkml/2007/8/15/174
 > 
 > In that thread David Miller said he would NAK this solution and even
 > NAK a solution where we expose the low level port allocation services
 > and allow RDMA/iWARP and TCP to share the port space.  Thus I see no
 > way to resolve this issue with Dave's ACK, and maybe the RDMA
 > contributors and maintainers should move forward without it?

If Dave Miller says this is an unacceptable thing to merge, then I'm not
going to merge it over his explicit and unequivocal NAK.  Trying sneak
this in by hiding this patch on linux-rdma without cc-ing netdev is the
wrong approach... the right approach is to get the hordes of users being
hurt by this issue (if there are such hordes), make a big stink, and
force a solution that everyone agrees on.

 - R.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
