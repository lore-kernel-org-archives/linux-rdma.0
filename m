From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH RESEND] IB/device: Convert ib-comp-wq to be CPU-bound
Date: Thu, 9 Mar 2017 00:59:18 +0200
Message-ID: <cd58c1c9-4bd1-b609-e2ca-48678ee74ef3@grimberg.me>
References: <1489003397-2321-1-git-send-email-sagi@grimberg.me>
 <20170308213619.GD32009@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170308213619.GD32009-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> This looks fine in principle, but any performance number showing
> how this helps (or at least doesn't hurt)?

I had it back when I noticed it and came up with this patch,
but it was a while ago... Also, IIRC Ming ran it at some point.

I'll rerun it though.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
