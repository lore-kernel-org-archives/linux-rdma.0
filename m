From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V3] svcrdma: advertise the correct max payload
Date: Wed, 24 Sep 2014 14:55:56 +0300
Message-ID: <5422B14C.3040502@dev.mellanox.co.il>
References: <20140923221122.24227.91718.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140923221122.24227.91718.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, fields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 9/24/2014 1:11 AM, Steve Wise wrote:
> Svcrdma currently advertises 1MB, which is too large.  The correct value
> is the minimum of RPCSVC_MAXPAYLOAD and the max scatter-gather allowed
> in an NFSRDMA IO chunk * the host page size. This bug is usually benign
> because the Linux X64 NFSRDMA client correctly limits the payload size to
> the correct value (64*4096 = 256KB).  But if the Linux client is PPC64
> with a 64KB page size, then the client will indeed use a payload size
> that will overflow the server.
>

Maybe I'm a bit late with this, but can you explain why SG table is
limited to 64 (fastreg MR and page_list probably bound it). Where is it
coming from? Naturally it needs to be bound by some figure, but why 64?

Sorry if I'm nit-picking on this pretty straight-forward bug fix...

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
