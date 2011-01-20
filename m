From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: IB: increase DMA max_segment_size on Mellanox hardware
Date: Thu, 20 Jan 2011 12:18:04 +0200
Message-ID: <4D380BDC.5080002@voltaire.com>
References: <1295230184.2574.26.camel@obelisk.thedillows.org>	<4D342510.80701@voltaire.com> <1295318783.3051.81.camel@obelisk.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1295318783.3051.81.camel-1q1vX8mYZiGLUyTwlgNVppKKF0rrzTr+@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

David Dillow wrote:
> The size could be 1, 2, 4, 8 MB or whatever. But if there isn't a HW
> limit, then why limit yourself at all? 

There are others limits in the echo system this patch live with, e.g some
buffer allocation and usage scheme with IB RC done by the target... IB
RC message is limited by spec to 2G and with mlx4 to 1GB, what not remaining
in the (say) 8MB area with this patch as well?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
