From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH libmlx5 3/6] fix buffer overrun copying inline header
Date: Wed, 27 Jul 2016 21:29:04 -0400
Message-ID: <20160728012904.GL36313@redhat.com>
References: <1469647047-7544-1-git-send-email-jarod@redhat.com>
 <1469647047-7544-4-git-send-email-jarod@redhat.com>
 <20160727212610.GJ36313@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160727212610.GJ36313-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 27, 2016 at 05:26:10PM -0400, Jarod Wilson wrote:
> On Wed, Jul 27, 2016 at 03:17:24PM -0400, Jarod Wilson wrote:
> > At present, the size of eseg->inline_hdr_start is 16 bits, while
> > MLX5_ETH_L2_INLINE_HEADER_SIZE is 18, so there are attempts made to copy
> > 18 bits into 16 bits of storage. The mlx5_dbg() statement in
> > copy_eth_inline_header() suggests that perhaps
> > MLX5_ETH_L2_INLINE_HEADER_SIZE should be only 16, not 18. So either that
> > needs to be changed, or the inline_hdr_start array needs to be bumped up
> > to 3 bytes instead of 2.
> 
> Ugh. Now I see what's going on. The copy is actually designed to copy 18
> _bytes_, not bits, into inline_hdr_start[2] and inline_hdr[16]. Is there a
> particular reason those two aren't just a single array?

Drop this one. I've got a new patch together that just merges the two.
I've looked over the code, and can't see anything that actually uses
inline_hdr separate from inline_hdr_start.

-- 
Jarod Wilson
jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
