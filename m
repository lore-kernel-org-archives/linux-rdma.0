From: "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v2] RDMA/CMA: fix iWARP adapter TCP port space usage
Date: Fri, 11 Jun 2010 12:49:59 -0700
Message-ID: <2EFBCAEF10980645BBCFB605689E08E904924CCE42@azsmsx506.amr.corp.intel.com>
References: <20100611124746.GA2292@CTUNG-MOBL1>
 <adapqzxy2sb.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adapqzxy2sb.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>  > This patch resolves the issue by allocating a kernel socket consuming
>  > the TCP port for the iWARP connection upon connection creation and
>  > freeing the socket once the iWARP connection is destroyed.
> 
> Hasn't this exact approach been explicitly NAK'ed by David Miller?

Yes but this approach still is the simplest and cleanest way to solve this
problem that I am aware of.

I do want to make clear on the network resource usage.  For example, if
you run an MPI job over host TCP stack and the job creates 4 connections
thus consuming 4 sockets.  With this patch, the same job over iWARP will
consume 4 sockets.  This patch has zero impact on non-iWARP applications
and only consumes equal amount of network resources.

I would like this patch to be reconsidered for inclusion into the kernel.

Chien



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
