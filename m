From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] libibverbs: add path record definitions to sa.h
Date: Mon, 17 May 2010 20:32:16 -0700
Message-ID: <adask5pnav3.fsf@roland-alpha.cisco.com>
References: <2420730B531C4665BD842A7F46007DA2@amr.corp.intel.com>
	<adapr18zmmj.fsf@roland-alpha.cisco.com>
	<63BD07796ED544AEAC6E41E669DC6EAC@amr.corp.intel.com>
	<adavdano5lb.fsf@roland-alpha.cisco.com>
	<4BF146F2.5060909@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4BF146F2.5060909-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> (Steve Wise's message of
	"Mon, 17 May 2010 08:38:58 -0500")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > Can you add the RAW_ETY qp type in this release as well?

To be honest I haven't looked at the iWARP datagram stuff at all.  I'm
not sure overloading the RAW_ETY QP type is necessarily the right thing
to do -- it has quite different (never implemented) semantics in the IB
case.  Is there any overview of what you guys are planning as far as
how work requests are created for such QPs?
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
