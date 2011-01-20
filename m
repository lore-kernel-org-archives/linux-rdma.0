From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: IB: increase DMA max_segment_size on Mellanox hardware
Date: Thu, 20 Jan 2011 07:25:51 -0500
Message-ID: <1295526351.22825.35.camel@obelisk.thedillows.org>
References: <1295230184.2574.26.camel@obelisk.thedillows.org>
	 <4D342510.80701@voltaire.com>
	 <1295318783.3051.81.camel@obelisk.thedillows.org>
	 <4D380BDC.5080002@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D380BDC.5080002-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 2011-01-20 at 12:18 +0200, Or Gerlitz wrote:
> David Dillow wrote:
> > The size could be 1, 2, 4, 8 MB or whatever. But if there isn't a HW
> > limit, then why limit yourself at all? 
> 
> There are others limits in the echo system this patch live with, e.g some
> buffer allocation and usage scheme with IB RC done by the target...

Keep in mind this is not directly seen by the target -- this is purely
an optimization for the block stack. The target has to deal with > 1 MB
requests from an initiator anyway, or it is buggy -- we can generate
those today, just not reliably. And we have the proper tools to deal
with that -- it's called max_hw_sectors_kb, as set by the max_sect
option to SRP.

>  IB RC message is limited by spec to 2G and with mlx4 to 1GB, what not remaining
> in the (say) 8MB area with this patch as well?

I would call that a HW/spec limit, and would be fine if mlx4 set it to 1
GB. Or even 512 MB or 256 MB. 8 MB would work, but to give room to grow
I'd rather see it higher.
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
