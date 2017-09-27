From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/mlx5:: pr_err() and mlx5_ib_dbg() strings should end
 with newlines
Date: Wed, 27 Sep 2017 10:20:39 -0400
Message-ID: <1506522039.82712.26.camel@redhat.com>
References: <7a5a195cd37db476a2ca007eddc0f28f3ade265b.1506407876.git.arvind.yadav.cs@gmail.com>
         <20170926083843.GB6816@mtr-leonro.local>
         <1506438337.29089.8.camel@perches.com>
         <20170926155006.GD6816@mtr-leonro.local>
         <1506453105.29089.14.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1506453105.29089.14.camel-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Arvind Yadav <arvind.yadav.cs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-09-26 at 12:11 -0700, Joe Perches wrote:
> On Tue, 2017-09-26 at 18:50 +0300, Leon Romanovsky wrote:
> > So how can I reproduce the different output before and after this
> > change?
> 
> Try lib/test_module.c with and without the newline
> on "Hello, World" on a quiescent system.

I agree here.  The newlines are still worthwhile as they remove any
unnecessary stalls in the printk output while the printk engine decides
whether or not you are going to do a KERN_CONT print next.

Thanks, applied.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
