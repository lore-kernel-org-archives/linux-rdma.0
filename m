From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH] prevent CVE-2012-2372 rds-ping causes kernel panic
Date: Mon, 22 Oct 2012 11:19:49 -0700
Message-ID: <20121022181949.GA10077@kroah.com>
References: <20121022181253.GA13736@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121022181253.GA13736-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jay Fenlason <fenlason-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 22, 2012 at 02:12:54PM -0400, Jay Fenlason wrote:
> If you use rds-ping of the local IP address of some Infiniband HCAs
> (QLogic, possibly others) the machine will panic with a BUG_ON due to
> an overly restrictive check.  Loosen the restriction a bit
> 
> This should have gotten sent a while ago (it was first noticed in
>  https://bugzilla.redhat.com/show_bug.cgi?id=803936
> and patched in kernel-2.6.32-275.el6) but I got confused about its
> embargo status and lost it.
> 
> Signed-off-by: Jay Fenlason <fenlason-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> diff --git a/net/rds/ib_send.c b/net/rds/ib_send.c

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
