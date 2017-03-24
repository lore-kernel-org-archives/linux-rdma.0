From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V2 rdma-core 6/6] Bump version and update debian
Date: Fri, 24 Mar 2017 12:09:14 -0600
Message-ID: <20170324180914.GA13059@obsidianresearch.com>
References: <1490277329-8738-1-git-send-email-yishaih@mellanox.com>
 <1490277329-8738-7-git-send-email-yishaih@mellanox.com>
 <20170323171916.GB5840@obsidianresearch.com>
 <20170323191155.GC20443@mtr-leonro.local>
 <20170323200214.GA10344@obsidianresearch.com>
 <20170324134905.GE20443@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170324134905.GE20443-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Mar 24, 2017 at 04:49:05PM +0300, Leon Romanovsky wrote:
> On Thu, Mar 23, 2017 at 02:02:14PM -0600, Jason Gunthorpe wrote:
> > On Thu, Mar 23, 2017 at 09:11:55PM +0200, Leon Romanovsky wrote:
> > > > > index 3defc05..f47fcec 100644
> > > > > +++ b/debian/changelog
> > > > > @@ -1,5 +1,8 @@
> > > > > -rdma-core (13-1) unstable; urgency=low
> > > > > +rdma-core (14-1) unstable; urgency=low
> > > > > +
> > > > > +  * Bump version.
> > > >
> > > > I haven't been adding new change log entires in the past, this is just
> > > > a standin file - Debian will maintain their own in their .diff. Same
> > > > with rpm.
> > >
> > > It was more convenient for me to bump version in this file too,
> > > so new symbols in debian/*.symbol will have more clear minimal
> > > version (14-1), which is close to rdma-core-14.
> >
> > I meant, you still have to bump the version, I was just doing it in
> > place, because we are not actually keeping a changelog.
> 
> And what about 13-1 in all *.symbols files? It will need to be changed
> too.

Do you need a changelog entry to have stuff in the symbols file?

BTW, there are bad looking things in travis with this PR:

parsechangelog/debian: warning:     debian/changelog(l5): found start of entry where expected more change data or trailer
LINE: rdma-core (13-1) unstable; urgency=low
parsechangelog/debian: warning:     debian/changelog(l5): found eof
where expected more change data or trailer

 libmlx5.so.1 ibverbs-providers #MINVER#
  MLX5_1.0@MLX5_1.0 13-1
  MLX5_1.14@MLX5_1.14 14-1
+ MLX5_1.1@MLX5_1.1 14-1
+ mlx5dv_create_cq@MLX5_1.1 14-1

Etc..

https://travis-ci.org/linux-rdma/rdma-core/builds/214329236

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
