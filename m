From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V1 rdma-core 7/7] mlx5: Export mlx5 direct verbs interface
Date: Mon, 13 Feb 2017 11:42:50 -0700
Message-ID: <20170213184250.GA12224@obsidianresearch.com>
References: <1486909012-15064-1-git-send-email-yishaih@mellanox.com>
 <1486909012-15064-8-git-send-email-yishaih@mellanox.com>
 <20170213164944.GB25430@obsidianresearch.com>
 <20170213182121.GD6989@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170213182121.GD6989-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 13, 2017 at 08:21:21PM +0200, Leon Romanovsky wrote:
> On Mon, Feb 13, 2017 at 09:49:44AM -0700, Jason Gunthorpe wrote:
> > On Sun, Feb 12, 2017 at 04:16:52PM +0200, Yishai Hadas wrote:
> > > diff --git a/debian/ibverbs-providers.install b/debian/ibverbs-providers.install
> > > index 70244ee..7bacc2e 100644
> > > +++ b/debian/ibverbs-providers.install
> > > @@ -1,8 +1,12 @@
> > > +usr/include/infiniband/mlx5dv.h
> > >  etc/libibverbs.d/
> > >  etc/modprobe.d/truescale.conf
> > >  usr/bin/rxe_cfg
> > >  usr/lib/*/libibverbs/lib*-rdmav2.so
> > > +usr/lib/*/libmlx5.*
> > >  usr/lib/truescale-serdes.cmds
> > >  usr/share/doc/rdma-core/rxe.md usr/share/doc/ibverbs-providers/
> > > +usr/share/man/man3/mlx5dv_*.3
> > > +usr/share/man/man7/mlx5dv.7
> >
> > These need to go in libibverbs-dev, as does the libmlx5*.so.
> 
> I'm not sure, at the end libmlx5 is a provider.

Devel items need to go in dev pacakges. That means headers, devel man
pages and the main .so symlink.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
