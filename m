From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH v2] RDMA/CMA: fix iWARP adapter TCP port space usage
Date: Fri, 11 Jun 2010 18:45:16 -0500
Message-ID: <4C12CA8C.6050806@opengridcomputing.com>
References: <20100611124746.GA2292@CTUNG-MOBL1>	<adapqzxy2sb.fsf@roland-alpha.cisco.com>	<2EFBCAEF10980645BBCFB605689E08E904924CCE42@azsmsx506.amr.corp.intel.com>	<4C12A6E8.5040400@opengridcomputing.com> <adamxv1w7cb.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adamxv1w7cb.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Roland Dreier wrote:
>  > You can peruse this thread from 2007:
>  > 
>  > http://lkml.org/lkml/2007/8/15/174
>  > 
>  > In that thread David Miller said he would NAK this solution and even
>  > NAK a solution where we expose the low level port allocation services
>  > and allow RDMA/iWARP and TCP to share the port space.  Thus I see no
>  > way to resolve this issue with Dave's ACK, and maybe the RDMA
>  > contributors and maintainers should move forward without it?
>
> If Dave Miller says this is an unacceptable thing to merge, then I'm not
> going to merge it over his explicit and unequivocal NAK.  Trying sneak
> this in by hiding this patch on linux-rdma without cc-ing netdev is the
> wrong approach... the right approach is to get the hordes of users being
> hurt by this issue (if there are such hordes), make a big stink, and
> force a solution that everyone agrees on.
>
>   

I hear ya.

It seems to be difficult to get end users to horde up and stink about 
these sorts of technical issues, because they don't have the background 
to argue their case.   And technical merit alone isn't working here.

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
