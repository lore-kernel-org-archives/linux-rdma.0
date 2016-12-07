From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] libcxgb4: set *bad_wr in post_send/recv error paths
Date: Wed, 7 Dec 2016 20:23:16 +0200
Message-ID: <20161207182315.GC3709@yuval-lap>
References: <20161206210403.71E59E08C5@smtp.ogc.us>
 <20161207181541.GA3709@yuval-lap>
 <129501d250b6$b4f65c40$1ee314c0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <129501d250b6$b4f65c40$1ee314c0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I see,
so FWIW:
Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

On Wed, Dec 07, 2016 at 12:21:19PM -0600, Steve Wise wrote:
> > 
> > Looks like same fix should be applied to cxgb4 driver, right?
> > 
> > Yuval
> 
> Hey Yuval,
> 
> Yes, I sent out that fix earlier:
>  
> https://www.spinics.net/lists/linux-rdma/msg42000.html
> 
> Steve.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
