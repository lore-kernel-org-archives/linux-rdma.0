From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: rdma-core release?
Date: Wed, 12 Oct 2016 20:37:02 +0300
Message-ID: <20161012173702.GW9282@leon.nu>
References: <20161012105103.GA30534@infradead.org>
 <CALq1K=JEkvN_4tZL9D53c6-EH9E4efay8rmoyBEyB-7Sxr6H-w@mail.gmail.com>
 <59ebde13-0fcd-0640-e750-bb6e57bfb921@redhat.com>
 <00c801d22496$f31798f0$d946cad0$@opengridcomputing.com>
 <20161012163149.GA20174@infradead.org>
 <20161012164759.GB18838@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="bD34TO62teEVCiRb"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161012164759.GB18838-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--bD34TO62teEVCiRb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 12, 2016 at 10:47:59AM -0600, Jason Gunthorpe wrote:
> On Wed, Oct 12, 2016 at 09:31:49AM -0700, 'Christoph Hellwig' wrote:
> > On Wed, Oct 12, 2016 at 09:43:08AM -0500, Steve Wise wrote:
> > > I recommend we release something for OFED-4.8 to pull in.  That
> > > might help flush out the release process earlier rather than
> > > later.  Either way, though, I want the latest libcxgb4 in OFED-4.8
> > > to support the new chelsio HW.  But we talked about the repo being
> > > "always stable", so I guess the OFA could just pull the code and
> > > use it?  Still would be nice to have it released...
> >
> > Yeah, I'd much prefer to release early, release often.  If people
> > don't feel quite comfortable with the new bundle yet we can officially
> > call it a pre-release.
>
> One of the best ways to get it tested is to get it to go through the
> full OFED process.

No problem, I'll grab all remaining patches from ML tomorrow and we will
be ready for first release.

>
> Woody, what could we do to help make that happen? Do you know of any
> blocker?
>
> I think this will be the best for everyone. I also predict that OFED
> will be under pressure to quickly take up the new drivers that will
> land in 4.9, and their user space will live in rdma-core.
>
> I also propose we give someone from the OFED team repo access and they
> can maintain a public branch for ofed-4.8 with any backported fixes.

First of them, they need to express desire :)
Let's start from pull request model and see if it is enough/not enough.

>
> Jason

--bD34TO62teEVCiRb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX/nS+AAoJEORje4g2clinnVQQAMKI+52x4gScfbz32JohvrGc
q5VDS46RsL8z2tfDu6jEAb/DlqwpAxP60ORGyP6UYDBTw1/1sVDQSuYLdwLL0u0F
IHTF9fFnSLwYVqhm5lQPZDim4kdyChZl5GyqRTiECtMI9QRp0utvD8RlHUES+Qij
rqli3TRnsQu11id8yhxXyf9uCDnbHfcvrCDtRXzQh83B0OSxZJF7Kr/v/EyJ1f88
g0oHwiqtkwTNhTmbIy621Zkss/CUuo1xp/RO7x11IqAM2krvft6RQHXz2cU+P3+S
hFPPw1cZIlTXNHn6mVfK1DNoDnaOGAuf0hqUlsRc8/dsLw3W4tvKsM0Y8aFI5MDn
vdk0eMuAryqUFABZe+iixCQGhoXczna3vHJTkaOc2MKCeGez+r3w0mCUnAtDQLQi
IlGisttlYwlZjXeflnk4YlW8k8kQ6AvbcSyibpMCHlZVCx7CbI471EOEuDD6se8+
EPJOBQDPxm1ghc2DzUWr5HY77s6mf+I3tgQvzfQ2A/Mjg/CVI+QCkD9ZVWk5Mn37
G7cNg/pBNlexnYu8KZPy8Ep5XkgsLuI+uCCDS+jnXI7+zz7ojMSY79YBoT8aisYX
6KqPsI7klHfiVzRR/uL3zLvMHFDauEiGGZaFN1MgP+QDadgWn2sr0cm7U0dG9evX
Wy9+b01qqNR//Aj9BELZ
=08If
-----END PGP SIGNATURE-----

--bD34TO62teEVCiRb--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
