From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Fri, 26 Aug 2016 20:16:38 +0300
Message-ID: <20160826171638.GD594@leon.nu>
References: <e5da14cf-fd5a-895e-5fad-9020b6a7efb1@redhat.com>
 <20160826144415.GC594@leon.nu>
 <3aee5577-9600-db32-db7f-4fb39afdc429@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="pZs/OQEoSSbxGlYw"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3aee5577-9600-db32-db7f-4fb39afdc429-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Torvalds, Linus" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--pZs/OQEoSSbxGlYw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 26, 2016 at 12:12:07PM -0400, Doug Ledford wrote:
> On 8/26/2016 10:44 AM, Leon Romanovsky wrote:
> > On Thu, Aug 25, 2016 at 03:29:12PM -0400, Doug Ledford wrote:
> >
> > Hi Doug,
> >
> > These two patches were supposed to be carried by us [1] and I explicitly
> > said that. Especially, the last patch in this series is wrong. Please
> > revert it. The proper patch is [2] and it was supposed to be sent right
> > after our shared code.
> >
> >> Yuval Shaia (2):
> >>       IB/mlx4: Make function use_tunnel_data return void
> >>       IB/mlx4: Return EAGAIN for any error in mlx4_ib_poll_one
> >
> > [1] https://www.spinics.net/lists/linux-rdma/msg38580.html
> > [2]
> > https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/commit/?h=topic/mlx-fixes&id=d5a1c56c3a49db6369b36aa04fbeabc7653ae107
> >
>
> I saw your request to carry it, but then never heard anything again from
> you.  The fix that the original patch implements is still valid and was
> something I wanted to get into 4.8, where as your patch is being held
> for 4.9 and goes down a different path to solving the issue.  IMO, the
> patch from Yuval is fine for 4.8, and if you want to apply yours to 4.9,
> that's fine too.  I don't see a need to revert the existing patch.  From
> what I can tell, the existing patch will work fine and do what Yuval
> intended, it just won't do what you intend to do in 4.9.  Please correct
> me if I'm wrong.

By our HW design and SW implementation poll_cq never fails and returns
errors, so all these prints are to catch ULP bugs. In case of such bug, Yuval's
patch will cause to reentry (EAGAIN) and kprints storm again and again.
It is undesired and misleading behaviour.

We targeted our patch to 4.9, because it is not actual fix, but help to
ULP developers and there is no real need to hurry up.

Will it be acceptable by you, if I revert Yuval's patch before sending
our version for 4.9?

Thanks.

>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG Key ID: 0E572FDD
>




--pZs/OQEoSSbxGlYw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXwHl2AAoJEORje4g2clinircQAJ8vJU4wrjdmnSvhhwMmwxVc
UbyinfEc+7cXnGK7ZbuMe4rwBPxIAD1KW/gMNm33hD218MVqbIBlRIN4iPKfhlnp
Hch59E1cJzuyPEMm1OWWlmI+kCi4RhqT2Uor7sHCelUND60uriPaQ8lBDFM+kk0Q
XnmsSpxPLP4ZTMafpXrzxMHIHK7HFqMnicCdU39rOPvxHNKEwAZJg/9QSR3YLnid
z3GkvTXJ7s1EgKnEjDnZkHq00+Ybih2YomGIImHZsDnclMAzfmTOZ84sy8Ew54Fk
dkXzMNR5+ImGVm4PV19KV+6zIE1X5M0CqXs1hrXEsrSkkQFsqtVUr55x7utmM5RA
4bAbnYZFPbinSv3m7wzS1p+i/g4XS/wsSHvDyXmWGPq0uHbkwyT/21bNRb+vl1dv
LyZFG+UVF2yA1EFknmAUNd1vWc3tmFkG6MSeE2xzOD3nT+mAwoaLbr+bq+Qfknxr
8epONSud5Pg+grs9gvjhSwR5usln4gKcY9/lg8D1VxkGnuxxfIRq70RDOH7P+eCK
uE8Q+i/IZOajJF04vpkw+OLkHRDKxmzDAEqlWMVMK6W4Fb9pIO/QWQdrYGKeFIGn
YfD1bW4U+WfkdUvRWQ0IqOjC4eOjCr5/jN5dRNztOzKIvKi6Xz13j2xR64VyimYy
J7XXDEuj1M5nzCUbrk83
=Bnvx
-----END PGP SIGNATURE-----

--pZs/OQEoSSbxGlYw--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
