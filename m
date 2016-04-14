From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-rdma] IB/mlx5: Allow mapping the free running counter
 on PROT_EXEC
Date: Thu, 14 Apr 2016 17:23:16 +0300
Message-ID: <570FA7D4.5060002@mellanox.com>
References: <1460641930-5118-1-git-send-email-matanb@mellanox.com>
 <20160414135651.GA18711@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160414135651.GA18711-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 4/14/2016 4:56 PM, Christoph Hellwig wrote:
> And why the hack do we set PROT_EXEC on a mapping of device resources?

It is set automatically in the kernel for legacy processes that have the
READ_IMPLIES_EXEC personality.

See:
http://lxr.free-electrons.com/source/mm/mmap.c?v=4.5#L1285
https://lwn.net/Articles/94068/
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
