From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v2] RDMA/CMA: fix iWARP adapter TCP port space usage
Date: Fri, 11 Jun 2010 15:47:55 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF255F6BB9B7@orsmsx501.amr.corp.intel.com>
References: <20100611124746.GA2292@CTUNG-MOBL1>
 <adapqzxy2sb.fsf@roland-alpha.cisco.com>
 <2EFBCAEF10980645BBCFB605689E08E904924CCE42@azsmsx506.amr.corp.intel.com>
 <4C12A6E8.5040400@opengridcomputing.com>
 <adamxv1w7cb.fsf@roland-alpha.cisco.com>
 <20100611224126.GA4630@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100611224126.GA4630-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> What exactly is the end-user harm anyhow? Everything works 100%
> correctly without this patch, and your arguments all revolved around
> diagnostic capability..

OFED includes this patch, which was picked up by the distros.  I'm not sure iWarp customers are running without it.

> It is a known weakness that the RDMA stack has crappy visibility. That
> has been talked about before. If you want better visibility then fix
> that by adding netlink stuff to dump out all the QP states, PDs, etc,
> similar to what TCP does.

This is a separate topic from what the patch is trying to address.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
