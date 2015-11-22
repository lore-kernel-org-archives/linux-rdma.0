From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] IB/srp: Fix possible send queue overflow
Date: Sun, 22 Nov 2015 05:37:04 -0800
Message-ID: <20151122133704.GA22831@infradead.org>
References: <1444901206-27462-1-git-send-email-sagig@mellanox.com>
 <5639035D.6050805@dev.mellanox.co.il>
 <563B2E0A.4020102@dev.mellanox.co.il>
 <5641C859.6070107@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5641C859.6070107-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 10, 2015 at 12:35:05PM +0200, Sagi Grimberg wrote:
> >Are you planning to pick this up? Note that this patch
> >is stable material as well.
> 
> Doug? any plans for this patch?

We should really get this in an into -stable.  Bart, can you resend
the series and if it doesn't get picked up next week send it directly
to Linus?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
