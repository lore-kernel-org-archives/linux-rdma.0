From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH] nvmet-rdma: Fix a possible uninitialized variable
 dereference
Date: Mon, 13 Mar 2017 15:38:20 +0200
Message-ID: <2074844b-1801-937a-cc8a-466abea6423a@grimberg.me>
References: <1489403135-12774-1-git-send-email-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1489403135-12774-1-git-send-email-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> When handling a new recv command, we grab a new rsp resource and
> check for the queue state being live. In case the queue is not in
> live state, we simply restore the rsp back to the free list. However
> in this flow we didn't set rsp->queue yet, so we cannot dereference it.
>
> Instead, get rid of rsp->queue, because we already have rsp->cmd
> reference which has a queue reference already, so use that instead.

OK this breaks the srq case. for SRQ we repost the cmd before we release
the response (which on the send completion), the cmd can later serve
a different queue so we can end up mess up if we reference
rsp->cmd->queue...

Sending a v2 to fix.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
