From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/3] cbuild: Support distros that only ship
 python3
Date: Wed, 17 Jan 2018 09:28:58 -0700
Message-ID: <20180117162858.GA3788@ziepe.ca>
References: <20180115211347.5651-1-jgg@ziepe.ca>
 <20180115211347.5651-2-jgg@ziepe.ca>
 <f75a3cd5-9763-0b4c-5e99-0565023967e4@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f75a3cd5-9763-0b4c-5e99-0565023967e4-l3A5Bk7waGM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 17, 2018 at 05:25:12PM +0100, Nicolas Morey-Chaisemartin wrote:
> 
> 
> Le 15/01/2018 à 22:13, Jason Gunthorpe a écrit :
> > From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > SuSE tumbleweed is no longer shipping python2 by default, at least
> > in the minimal docker image. This breaks cbuild and travis.
> >
> > Revise this little scriptlet we run in the container to support
> > both versions of python and use python3 in tumbleweed.
> >
> > Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >  buildlib/cbuild | 16 ++++++++++------
> >  1 file changed, 10 insertions(+), 6 deletions(-)
> >
> > diff --git a/buildlib/cbuild b/buildlib/cbuild
> 
> I'm guessing this one should probably be backported to the stable branches so they keep working in travis ?
> I don't think we need the others.
> 
> Can you confirm ?

Makes sense to me, we should have travis working for the stable
branches.. You can use the github UI to construct PRs for the stable
branches if people want to use that?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
