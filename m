From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: shrink struct ib_send_wr V3
Date: Mon, 31 Aug 2015 18:11:16 +0200
Message-ID: <20150831161116.GA24494@lst.de>
References: <1440579639-10684-1-git-send-email-hch@lst.de> <55E321D7.7000209@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55E321D7.7000209-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Aug 30, 2015 at 06:31:35PM +0300, Sagi Grimberg wrote:
>>   - patch 2 now explicitly replaces the weird overloading in the mlx5
>>     driver with an explicit embedding of struct ib_send_wr, similar
>>     to what we do for all other MRs.
>
> That's nice,
>
> There is one non-trivial spot that was missed in mlx5_ib_post_send
> though:

Oh, that was a weird abuse of the old casts.

I've foled both your fixes and force pushed to the wr-cleanup branch.

I do not plan to resend the series until the merge window for 4.4
is open.  Doug, any chance you could pick up the first patch in the
series for 4.3-rc?  It's marked for stable as well.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
