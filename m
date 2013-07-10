From: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Subject: Re: mlx5: Add driver for Mellanox Connect-IB adapters
Date: Wed, 10 Jul 2013 13:16:28 -0700
Message-ID: <20130710201627.GA16689@jtriplet-mobl1>
References: <20130710105415.GA31232@longonot.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130710105415.GA31232-dZEljifmRObu9KfB+GxooP8+0UxHXcjY@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sparse-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 10, 2013 at 01:54:15PM +0300, Dan Carpenter wrote:
> ---
> Side note: Sparse should warn about endian bugs but in linux-next
> endian checking is disabled because we hit:
> 
> include/uapi/linux/swab.h:71:16: error: undefined identifier '__builtin_bswap64'
> include/uapi/linux/swab.h:71:33: error: not a function <noident>
> 
> do_error() in Sparse disables warning messages.  I feel like we
> shouldn't do that.

No, I think that's the correct behavior: sparse should only generate
*errors* rather than warnings when it hits something that prevents it
from handling some chunk of code, in which case we'd get a huge number
of spurious warnings if not suppressed.

In any case, current Sparse has __builtin_bswap64, so you shouldn't get
that error.

- Josh Triplett
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
