From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] IB/ipoib: Enable pkey and device name decoupling
Date: Tue, 17 Oct 2017 02:18:37 -0600
Message-ID: <20171017081837.GA19107@obsidianresearch.com>
References: <20170927093248.3819-1-yuval.shaia@oracle.com>
 <20170928163406.GB17880@obsidianresearch.com>
 <20170928164735.GC2297@mtr-leonro.local>
 <20170928165305.GE17880@obsidianresearch.com>
 <20171015054745.GA2608@yuvallap>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171015054745.GA2608@yuvallap>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kernel-6AxghH7DbtA@public.gmane.org, ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mukesh.kacker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, chien.yen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Oct 15, 2017 at 08:47:46AM +0300, Yuval Shaia wrote:

> > > As far as I understand ipoib_netlink.c, ipoib_new_child_link() already
> > > implements it and it is supported in "ip".
> > 
> > Oh right:
> > 
> >   ip link add DEVICE name NAME type ipoib [ pkey PKEY ] [mode MODE ]
> 
> So with this interface we can entirely remove the sysfs interface to create
> child, right?

Yes, we should add a deprecation one shot printk to the kernel for the
sysfs interface to encourage people to use ip

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
