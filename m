From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH] IB/mlx4: Use boottime
Date: Mon, 1 Feb 2016 11:48:42 +0200
Message-ID: <20160201094842.GC30795@leon.nu>
References: <20160131095534.GA30795@leon.nu>
 <1454266411-25591-1-git-send-email-klock.android@gmail.com>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1454266411-25591-1-git-send-email-klock.android-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Abhilash Jindal <klock.android-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Jan 31, 2016 at 01:53:31PM -0500, Abhilash Jindal wrote:
> Wall time obtained from ktime_get_real_ns is susceptible to sudden jumps due to
> user setting the time or due to NTP.  Boot time is constantly increasing time
> better suited for comparing two timestamps.
> 
> Signed-off-by: Abhilash Jindal <klock.android-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Thanks you.
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
