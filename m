From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v2] RDMA/CMA: fix iWARP adapter TCP port space usage
Date: Fri, 11 Jun 2010 19:56:52 -0600
Message-ID: <20100612015652.GA7648@obsidianresearch.com>
References: <20100611124746.GA2292@CTUNG-MOBL1> <adapqzxy2sb.fsf@roland-alpha.cisco.com> <2EFBCAEF10980645BBCFB605689E08E904924CCE42@azsmsx506.amr.corp.intel.com> <4C12A6E8.5040400@opengridcomputing.com> <adamxv1w7cb.fsf@roland-alpha.cisco.com> <20100611224126.GA4630@obsidianresearch.com> <4C12C971.4000909@opengridcomputing.com> <20100612000431.GC4630@obsidianresearch.com> <4C12E073.2040008@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4C12E073.2040008-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jun 11, 2010 at 08:18:43PM -0500, Steve Wise wrote:

> Further, its not even needed for IB, just iWARP.  That's an unnecessary
> admin pain IMO.

IB already completely seperates from the host stack, that is why it
isn't effected by this problem. It has both a seperate port numbering
space (in rdma cm) and a separate addressing space (GID).

The entire problem with iWARP is that it is trying to not be
seperate, unlike IB. So.. simple answer: use a seperate IP, or use a
seperate port space (ie don't use the TCP protocol number).

ROCEE won't have this problem either..

> iWARP should and can easily co-exist with the host TCP by sharing
> the port space.  But, as Roland stated already, maybe the only way
> forward it to get end-user pressure applied at the appropriate
> places! :)

*shrug* This isn't going to happen until netdev decides to design-in
statefull offload. I doubt that is going to happen any time
soon. I've already seen Linux max out 40GE on benchmarks, so it is
hard to see what the driver would be.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
