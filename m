From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH v2] RDMA/CMA: fix iWARP adapter TCP port space usage
Date: Sat, 12 Jun 2010 10:17:58 -0500
Message-ID: <4C13A526.3040500@opengridcomputing.com>
References: <20100611124746.GA2292@CTUNG-MOBL1>	<adapqzxy2sb.fsf@roland-alpha.cisco.com>	<2EFBCAEF10980645BBCFB605689E08E904924CCE42@azsmsx506.amr.corp.intel.com>	<4C12A6E8.5040400@opengridcomputing.com>	<adamxv1w7cb.fsf@roland-alpha.cisco.com>	<20100611224126.GA4630@obsidianresearch.com>	<4C12C971.4000909@opengridcomputing.com>	<20100612000431.GC4630@obsidianresearch.com>	<4C12E073.2040008@opengridcomputing.com>	<20100612015652.GA7648@obsidianresearch.com>	<4C12EC89.1030305@opengridcomputing.com>	<Pine.WNT.4.64.1006112117160.6192@PPWASKIE-MOBL2.amr.corp.intel.com> <adaeigcx3hw.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adaeigcx3hw.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Roland Dreier wrote:
>  > Other protocols are also running over networking today, such as iSCSI
>  > and FCoE.  These happily co-exist with other L2->L4 protocols in the
>  > stack. This iWARP patch allows iWARP to happily co-exist on a TCP
>  > connection, and does *not* negatively affect the networking stack at
>  > all.
>
> How do iSCSI offload HBAs coexist?  As I understand it, they typically
> just choose a separate IP address.
>
> In any case I'm not going to slip in a patch that another maintainer has
> explicitly NAKed.  Maybe one way to force things forward would be to
> write up an exhaustive explanation of the underlying problem and the
> impact on end users, include this patch, explain that it touches only
> RDMA code, and point out that most end users are already using this
> patch since it's shipped in OFED.  Then send the whole thing to Linus
> and Andrew Morton, making sure to cc Dave Miller, netdev, and
> linux-rdma.
>
>  - R.
>   

My 2007 thread does this basically, but posted it to lkml and David 
Miller.  But the rationale for why we need it as well as other possible 
solutions is included in that thread.  We could re-package it and send 
it on as you suggest.  It might carry more weight coming from the linux 
rdma maintainer though. :)





--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
