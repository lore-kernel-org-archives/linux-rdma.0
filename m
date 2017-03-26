From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V2 rdma-core 6/6] Bump version and update debian
Date: Sun, 26 Mar 2017 14:45:23 -0600
Message-ID: <20170326204523.GC3113@obsidianresearch.com>
References: <1490277329-8738-1-git-send-email-yishaih@mellanox.com>
 <1490277329-8738-7-git-send-email-yishaih@mellanox.com>
 <20170323171916.GB5840@obsidianresearch.com>
 <20170323191155.GC20443@mtr-leonro.local>
 <20170323200214.GA10344@obsidianresearch.com>
 <20170324134905.GE20443@mtr-leonro.local>
 <20170324180914.GA13059@obsidianresearch.com>
 <20170325071326.GF20443@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170325071326.GF20443-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sat, Mar 25, 2017 at 10:13:26AM +0300, Leon Romanovsky wrote:
> > Do you need a changelog entry to have stuff in the symbols file?
> 
> I think that we need corresponding version in changelog.

There are lots of counter examples..

libibverbs.so.1 libibverbs1 #MINVER#
 IBVERBS_1.0@IBVERBS_1.0 1.1.6
 IBVERBS_1.1@IBVERBS_1.1 1.1.6

Eg we do not have 1.1.6 in the changelog

> > BTW, there are bad looking things in travis with this PR:
> >
> > parsechangelog/debian: warning:     debian/changelog(l5): found start of entry where expected more change data or trailer
> > LINE: rdma-core (13-1) unstable; urgency=low
> > parsechangelog/debian: warning:     debian/changelog(l5): found eof
> > where expected more change data or trailer
> >
> >  libmlx5.so.1 ibverbs-providers #MINVER#
> >   MLX5_1.0@MLX5_1.0 13-1
> >   MLX5_1.14@MLX5_1.14 14-1
> > + MLX5_1.1@MLX5_1.1 14-1
> > + mlx5dv_create_cq@MLX5_1.1 14-1
> >
> > Etc..
> 
> It is actual error, strange that travis passed while it was supposed to fail.

Maybe we should run dpkg-shlibdeps manually and somehow fail if this
situation happens... Can you look at that?

> The commit
> https://github.com/linux-rdma/rdma-core/pull/103/commits/4ba27e66294f59db7c969bde1580e7aa8d718cd7
> added MLX5_1.1, but in commit
> https://github.com/linux-rdma/rdma-core/pull/103/commits/9614ecdae2a6a5448cab819a057c703a570b3686
> debian was updated with incorrect stanza (MLX5_1.14).

Yes, we went back and forth on this unfortunately, I gave some bad
advice.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
