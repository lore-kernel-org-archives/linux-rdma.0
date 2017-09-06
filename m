From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH RFC 0/5] xprtrdma Send completion batching
Date: Wed, 6 Sep 2017 14:54:20 +0300
Message-ID: <1230f9d9-07c1-6d00-b197-f408712fb5c1@grimberg.me>
References: <20170905164347.11106.27140.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170905164347.11106.27140.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> Hi Jason, Sagi-

Hey Chuck,

> As we discussed a few weeks ago, this patch series implements the
> following:
> 
> - Send SGEs are now managed via lock-less, wait-free circular queues
> - Send SGEs referring to page cache pages are DMA unmapped during
>    Send completion
> - Send completions are batched to reduce interrupts, but still
>    provide a periodic heartbeat signal for SQ housekeeping
> - The circular queue prevents Send Queue overflow
> 
> The purpose of this change is to address the issue Sagi reported
> where the HCA continues to retry a delayed Send request _after_ RPC
> completion, resulting in a DMA error.

Question, what happens in direct-io for example? Can a mapped buffer be
reclaimed/free'd before the send completion arrives?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
