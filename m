From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH v2] RDMA/CMA: fix iWARP adapter TCP port space usage
Date: Fri, 11 Jun 2010 16:13:12 -0500
Message-ID: <4C12A6E8.5040400@opengridcomputing.com>
References: <20100611124746.GA2292@CTUNG-MOBL1> <adapqzxy2sb.fsf@roland-alpha.cisco.com> <2EFBCAEF10980645BBCFB605689E08E904924CCE42@azsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2EFBCAEF10980645BBCFB605689E08E904924CCE42-uLM7Qlg6MbdZtRGVdHMbwrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Tung, Chien Tin wrote:
>>  > This patch resolves the issue by allocating a kernel socket consuming
>>  > the TCP port for the iWARP connection upon connection creation and
>>  > freeing the socket once the iWARP connection is destroyed.
>>
>> Hasn't this exact approach been explicitly NAK'ed by David Miller?
>>     
>
> Yes but this approach still is the simplest and cleanest way to solve this
> problem that I am aware of.
>
> I do want to make clear on the network resource usage.  For example, if
> you run an MPI job over host TCP stack and the job creates 4 connections
> thus consuming 4 sockets.  With this patch, the same job over iWARP will
> consume 4 sockets.  This patch has zero impact on non-iWARP applications
> and only consumes equal amount of network resources.
>
> I would like this patch to be reconsidered for inclusion into the kernel.
>
> Chien
>
>   

You can peruse this thread from 2007:

http://lkml.org/lkml/2007/8/15/174

In that thread David Miller said he would NAK this solution and even NAK 
a solution where we expose the low level port allocation services and 
allow RDMA/iWARP and TCP to share the port space.  Thus I see no way to 
resolve this issue with Dave's ACK, and maybe the RDMA contributors and 
maintainers should move forward without it?


My 2 cents.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
