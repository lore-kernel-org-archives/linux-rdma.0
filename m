From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH, RFC] rdma: split struct ib_send_wr
Date: Tue, 4 Aug 2015 20:06:16 +0300
Message-ID: <55C0F108.4090003@dev.mellanox.co.il>
References: <1438672609-12599-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438672609-12599-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 8/4/2015 10:16 AM, Christoph Hellwig wrote:
> This patch split up struct ib_send_wr so that all non-trivial verbs
> use their own structure which embedds struct ib_send_wr.  This dramaticly
> shrinks the size of a WR for most common operations.

Hey Christoph,

I think this looks good in general.

Question though, a ULP may want to keep a couple of WRs around instead
of having each allocated in the stack and handled one by one. We need
to provide it with a hint of what is the size it needs.

I just posted a patch to do that in iser 
(http://www.spinics.net/lists/linux-rdma/msg27632.html).

So if I would want to preallocate an array of work requests, what is the
size of the space I'd need?
is it some form of max(sizeof(struct ib_send_wr),
                        sizeof(struct ib_fastreg_wr),
                        sizeof(struct sig_handover), ..)?

>
> This is just a WIP with basic testing for now.  While all in-tree drivers
> except for iSER and iSERt are converted testing coverage is very limited.
>
> For iSER I could really use a helping hand as the WR usage is rather
> confusing..

I can do it. no problem.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
