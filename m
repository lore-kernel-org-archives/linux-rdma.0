From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH rdma-next v7 0/8] RDMA resource tracking
Date: Tue, 30 Jan 2018 10:16:01 -0600
Message-ID: <035a01d399e5$9ed499d0$dc7dcd70$@opengridcomputing.com>
References: <20180128091725.13103-1-leon@kernel.org> <20180128210520.GK23869@ziepe.ca> <1517256713.27592.241.camel@redhat.com> <20180130033436.GA17053@ziepe.ca> <20180130091654.GD2055@mtr-leonro.local> <034101d399de$01183730$0348a590$@opengridcomputing.com> <20180130155643.GC17053@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180130155643.GC17053-uk2M96/98Pc@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgg-uk2M96/98Pc@public.gmane.org>
Cc: 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'RDMA mailing list' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Mark Bloch' <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > Thanks guys,  Q: 4.15-rc2 kills my machine, I've been rebasing to a
later rc
> > to continue my development work, but the rebase fails horribly on mlx5.
I
> > skip these failures and don't compile mlx5 because I don't need it.
> >
> > Anyway, will rdma-next be rebased on 4.15.0 soon?  Or does that wait
until
> > -rc2...
> 
> It is annoying for all concerned but Linus has asked us not to have
> needless merges. Hopefully we can build enough trust to relax on that
> down the road as other trees do.
> 
> I have made a merge to v4.15 here:
> 
>
https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git/log/?h=wip/for
-
> linus-merged

What is this a merge of exactly? I don't see the restrack stuff, for
instance.

Thanks,

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
