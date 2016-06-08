From: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 09/20] xprtrdma: Limit the number of rpcrdma_mws
Date: Wed, 8 Jun 2016 10:54:36 -0400
Message-ID: <c43e37cd-71ea-8629-20f2-bcd674d50b83@talpey.com>
References: <20160607194001.18401.88592.stgit@manet.1015granger.net>
 <20160607194732.18401.71941.stgit@manet.1015granger.net>
 <20160607204941.GA7991@obsidianresearch.com>
 <F1820E16-A2BF-4529-A5C9-59C9AD57369A@oracle.com>
 <20160607212831.GA9192@obsidianresearch.com>
 <D90190F5-ACCB-45D8-B08D-B75023ED6240@oracle.com>
 <20160607220107.GA9982@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160607220107.GA9982-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 6/7/2016 6:01 PM, Jason Gunthorpe wrote:
> On Tue, Jun 07, 2016 at 05:51:04PM -0400, Chuck Lever wrote:
>
>> There is a practical number of MRs that can be allocated
>> per device, I thought. And each MR consumes some amount
>> of host memory.
>
>> xprtrdma is happy to allocate thousands of MRs per QP/PD
>> pair, but that isn't practical as you start adding more
>> transports/connections.
>
> Yes, this is all sane and valid.
>
> Typically you'd target a concurrency limit per QP and allocate
> everything (# MRs, sq,rq,cq depth, etc) in accordance with that goal,
> I'd also suggest that target concurrency is probably a user tunable..

This is already present - it's the RPC slot table depth. It would be
great, IMO, to make this a mount parameter since it is transport- and
also server-dependent, but currently I believe it is just a kernel
RPC module parameter.

Tom.

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
