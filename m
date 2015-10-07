From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v2 06/16] xprtrdma: Use workqueue to process RPC/RDMA
 replies
Date: Wed, 7 Oct 2015 17:39:18 +0300
Message-ID: <56152E96.9040400@dev.mellanox.co.il>
References: <20151006142430.11788.42604.stgit@manet.1015granger.net>
 <20151006145924.11788.64757.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151006145924.11788.64757.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/6/2015 5:59 PM, Chuck Lever wrote:
> The reply tasklet is fast, but it's single threaded. After reply
> traffic saturates a single CPU, there's no more reply processing
> capacity.
>
> Replace the tasklet with a workqueue to spread reply handling across
> all CPUs.  This also moves RPC/RDMA reply handling out of the soft
> IRQ context and into a context that allows sleeps.

Hi Chuck,

I'm probably missing something here, but do you ever schedule in
the workqueue context? Don't you need to explicitly schedule after
a jiffie or so the code works also in a non fully preemptable kernel?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
