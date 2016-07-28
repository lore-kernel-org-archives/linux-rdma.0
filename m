From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH libmlx5 7/6] combine inline_hdr and inline_hdr_start
Date: Thu, 28 Jul 2016 10:27:17 -0400
Message-ID: <20160728142717.GO36313@redhat.com>
References: <1469647047-7544-1-git-send-email-jarod@redhat.com>
 <1469669554-23782-1-git-send-email-jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1469669554-23782-1-git-send-email-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 27, 2016 at 09:32:34PM -0400, Jarod Wilson wrote:
> I can't see any good reason why inline_hdr and inline_hdr_start should be
> two separate arrays in struct mlx5_wqe_eth_seg. The only time I see
> anything actually accessed by dereferencing either inline_hdr or
> inline_hdr_start is when the MLX5_ETH_L2_INLINE_HEADER_SIZE or less bytes
> are copied into inline_hdr_start. By default, it's 18 bytes, copied to
> what is a 2-byte and a 16-byte array back to back in the struct, and
> coverity and clang both sound alarms because the code says "just write 18
> bytes into that 2-byte array", which in practice is ultimately fine, but
> again, why?...
> 
> I propose to just add two bytes to inline_hdr and drop inline_hdr_start.

Heh, okay, so I see "Add TSO support for RAW Ethernet QP" posted today,
which does actually make use of those bits. Still not sure the split is
actually required though, that patch could probably be reworked to
operate on a single array as well.

-- 
Jarod Wilson
jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
