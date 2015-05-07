From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v1 06/14] xprtrdma: Acquire FMRs in rpcrdma_fmr_register_external()
Date: Thu, 07 May 2015 13:15:50 +0300
Message-ID: <554B3B56.1010806@dev.mellanox.co.il>
References: <20150504174626.3483.97639.stgit@manet.1015granger.net> <20150504175739.3483.46010.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150504175739.3483.46010.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 5/4/2015 8:57 PM, Chuck Lever wrote:
> Acquiring 64 FMRs in rpcrdma_buffer_get() while holding the buffer
> pool lock is expensive, and unnecessary because FMR mode can
> transfer up to a 1MB payload using just a single ib_fmr.
>
> Instead, acquire ib_fmrs one-at-a-time as chunks are registered, and
> return them to rb_mws immediately during deregistration.
>
> Transport reset is now unneeded for FMR. Each FMR is recovered
> synchronously when its RPC is retransmitted.

Does this worth a separate patch? I don't see why the two
changes are together. Is there a dependency I'm missing?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
