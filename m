From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [ANNOUNCE] Shared pull requests (was Re: Workflow for i40iw
 patch submissions)
Date: Mon, 25 Sep 2017 07:23:55 +0300
Message-ID: <20170925042355.GM25094@mtr-leonro.local>
References: <9DD61F30A802C4429A01CA4200E302A75B9FB085@fmsmsx116.amr.corp.intel.com>
 <1506179005.120853.67.camel@redhat.com>
 <20170924195627.GB18007@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="UUMz/kfoogzZ9WLZ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170924195627.GB18007-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Saleem, Shiraz" <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--UUMz/kfoogzZ9WLZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Sep 24, 2017 at 01:56:27PM -0600, Jason Gunthorpe wrote:
> On Sat, Sep 23, 2017 at 11:03:25AM -0400, Doug Ledford wrote:
>
> > That's my answer to people not necessarily wanting to wait until kernel
> > n+1 to use features they put in their net driver in kernel n.  So, this
> > applies to the mlx4, mlx5, cxgb3, cxgb4, bnxt_re, hns_roce, and i40iw
> > drivers off the top of my head.
>
> A different possible model would be to more broadly accept pull
> requests for drivers and push the work to synchronize with other parts
> of the tree directly to the driver folks, instead of trying to
> coordinate it all yourself.
>
> When a driver sends you a PR it will have to be 'clean' and be based
> on accepted shared commits already in Linus's tree, in the net tree
> and in the rdma-core tree. Ignoring shared commits, the PR can only
> touch drivers/infiniband/hw/xxx. No uAPIs. Each driver team can decide
> how they want to construct their PR within those guidelines.
>
> Set a cut off of rc6 or something for these driver PRs to give time to
> sort out any RDMA merge issues.
>
> Run the core and ULP parts as a normal tree with a normal work flow,
> don't integrate tricky driver PRs into the normal tree until the merge
> window. Make sure this flow runs fast enough that the driver people can
> pull from here when constructing their driver branch.
>
> Run a single 'volatile' for-next tree that merges all pending
> branches, including driver PRs. This is the early warning for
> merge problems.
>
> When the merge window comes around decide what to branches to send based
> on what is in Linus's tree already. Maybe two PRs per merge window
> will be needed to sort out dependencies, depends how fast net/etc are
> at getting merged. I think other subsystems do this already?
>
> The advantage is *you* are largely no longer worrying about timing or
> monitoring the net tree or anything like that. The driver teams take
> full responsibility to do that in a set time window. Either they post
> an acceptable PR in time or they miss the merge window. Some scripting
> is possible so you can determine on a daily basis when driver PRs become
> 'clean' and thus sendable to Linus. Eliminates some of the manual
> coordination.
>
> Another advantage is QA. When the driver teams QA their PR, they are
> now QA'ing something with all dependent changes, and the configuration
> they QA'd is recorded in the git history instead of being lost when
> patches get rebased as they flow through patchworks. They have more
> certainty what they will QA and they do not have to run so many
> various speculative combinations.
>
> I belive this is broadly similar to what arm-soc does for how they
> manage the SOC maintainers, and deal with their crazy cross-tree
> dependencies.
>
> Review one of their presentations:
>
> http://events.linuxfoundation.org/sites/events/files/slides/Maintaining%20a%20large%20kernel%20subsystem_0.pdf
>
> And imagine things like SOC's are our drivers (eg omap == mlx)
>
> arm-soc does a bit more than just this, their downstreams split
> patches eg into fixes/fixes-non-critical, etc. RDMA could do that
> do.
>
> People are asking for more certainty, the best way I can think to
> provide that is to let them run their own sub-tree within certain
> fairly tight boundaries.

Jason,

I reread it a couple of times and still didn't find an answer for
myself. Why do we need it?

After LPC, I left with an impression that we have three main issues:
1. Overloaded maintainer who can't go without worries to PTO, especially
in this subsystem which is backed by distributed companies which work
around the globe and have a little in common with US holidays and vacations.
Next major holiday will be Christmas and at least two companies here
(and from previous years, Linus too) will continue to work.
2. Unclear guidelines to the QA.
3. Contributors to this subsystem are paid developers and not hobbyists.
It creates certain expectations from all participants.

So I believe that once we will solve the first issue, the rest will be easy.

Thanks

>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--UUMz/kfoogzZ9WLZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnIhNsACgkQ5GN7iDZy
WKfYlA/+LiVrkTJwSmZapXbJhCYPURPyYpoqvcHlbQFI3GlYFWCxuPvTNMPHKski
lH7XTS1SPCTAelV7fci58kIraBUDJVxmDktUXfDWI0+5OgeBMgEmVkK/V3ZnDd9Y
cI5olzj4JLgv6VtWkk7dQ7qVTGfUQ0yEGrvkdTLRl3B+iQTdKAoqaV41ZkAJU7kl
9iCEKrjjYXHlPWZCCQkjoGq2n6RBFZYHkB8iIHfdsGm2+ec/UuA4ZpBtxrnxlp6b
Lenicequl20S5p7JuxXyyivS36iPidrfS/2V+djcggHnCD7nNNUTJBEmQXWvHjjd
+onnRnQT8F3cBUqc+i6VKb36F6/vOU4xmB94I6ILd8aDKMFR61gKlh9w28lKMgoU
mKC2OB/a9CSuomW3oLRWv25ZD4VayL9l+HVuMe2CiC7hbUxJKvjU74W10osR24wN
AcZW7zmWqiwOgkkdTbqRUb11BIXCsUAHWbD5Jcg0XK49qm6CXI2TlXtKkURlnUUe
aZ5uJXXhwRAHDjUwENKYEyviA/fQaXI5H5B8KyD/CDws9y9b7r1Xkhewjz5U+IJO
8wzam6tQIIyA+zqo8qY97ED5LeXCNuThza8O7Ryq29Y6z2o7MH/C6iJh+4g9sBiu
M7JbofdyrpnS5V8OPGR3K3Af/mWGYdtpGPwBlsojiC0DcIvFvOg=
=ZXqW
-----END PGP SIGNATURE-----

--UUMz/kfoogzZ9WLZ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
