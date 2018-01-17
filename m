From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-core] cbuild: Add Fedora 27 container
Date: Wed, 17 Jan 2018 09:16:14 -0700
Message-ID: <20180117161614.GA3764@mellanox.com>
References: <20180112115209.17437-1-leon@kernel.org>
 <1516202077.3403.254.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1516202077.3403.254.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 17, 2018 at 10:14:37AM -0500, Doug Ledford wrote:
> On Fri, 2018-01-12 at 13:52 +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > 
> > Add Fedora 27 to the list of cbuild targets.
> > 
> > Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >  buildlib/cbuild | 15 +++++++++++++++
> >  1 file changed, 15 insertions(+)
> > 
> > diff --git a/buildlib/cbuild b/buildlib/cbuild
> > index 3f659bf8..0ef80b60 100755
> > +++ b/buildlib/cbuild
> > @@ -141,6 +141,20 @@ class fc26(Environment):
> >              " ".join(sorted(self.pkgs))));
> >          return res;
> > 
> > +class fc27(Environment):
> > +    docker_parent = "fedora:27";
> > +    pkgs = (centos7.pkgs - {"make"}) | {"ninja-build"};
> 
> Is there some reason why are you pulling a fedora:27 container and then
> centos packages?

That is the pattern, centos7 has a list of required packages that is
most similar to fc27. It will make more sense when the patch is respun
to have fc27 replace fc26..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
