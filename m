From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [ANNOUNCE] Shared pull requests (was Re: Workflow for i40iw
 patch submissions)
Date: Tue, 26 Sep 2017 19:21:40 +0300
Message-ID: <20170926162140.GF6816@mtr-leonro.local>
References: <9DD61F30A802C4429A01CA4200E302A75B9FB085@fmsmsx116.amr.corp.intel.com>
 <1506179005.120853.67.camel@redhat.com>
 <20170925035910.GL25094@mtr-leonro.local>
 <5abacb7d-3e86-4e12-ce95-a8fe472a6a09@redhat.com>
 <20170925155749.GO25094@mtr-leonro.local>
 <7c01cef3-0471-8339-3498-1d9ec4f8a9d3@redhat.com>
 <20170926051349.GA1230@mtr-leonro.local>
 <20170926065600.GA6816@mtr-leonro.local>
 <6fa41141-cae5-da51-94ef-afe5bdec22bd@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="E7i4zwmWs5DOuDSH"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <6fa41141-cae5-da51-94ef-afe5bdec22bd-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Saleem, Shiraz" <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--E7i4zwmWs5DOuDSH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 26, 2017 at 12:03:01PM -0400, Doug Ledford wrote:

<...>

> >> He started to complain about empty merge commit with v4.13-rc1, and continued with explanations
> >> about difference between back and forward merges. From my point of view, my intention to base
> >> shared pull request on latest -rcX is exactly forward (good) merge, because it ensures that
> >> all our future submissions for net/net-next/rdma-rc/rdma-next are completely in sync and
> >> ready to go.
>
> This is why, when I submit a pull request for -rc, I also merge it into
> for-next.  It keeps this up to date as you say, without needing to pull
> in all of the -rc, so it gives Linus an easier history to look at.  It
> does not, however, sync up the net side of things.
>

Doug,

What is the bottom line for the bases for shared pull requests?

Thanks

--E7i4zwmWs5DOuDSH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnKfpMACgkQ5GN7iDZy
WKc6lxAArBghVMb1DfNmmn6/dDW3YO6Z/kD9pHOMqbyRyt5isjE5mZHcKovmWYcT
AdygGrhqFiD2buEsBE8IBOPbFigrDtFneKD2ueeQ2NaIc4CRIVPyjjUbeV4t9dTb
ERTs/hG0u4CflWYJLb2C26yaV59unaqE9WmMgMMpCjjXpkYLmk8epoXKgn4rpZKH
PD0hScMAPAwh7lSnalpBUkA3L/iXOM2OAkxkO9tFcY0W89b+NIkkSniELIuilTQv
Ssg/Sjhr0NduwE10lUj/b7TR6y17ofi44rVXhyb9QsmSPQqzTMiOVmPPfxHeMncn
1M9JASljzAT8fVyyiZhEHIpC6D0x/g+zV4SHyofbTPnrIf62edeIm5yxSBCEAc+6
9RanzbqJ0JfkGrU4cx1D+BCVne6+iPZ9ztOF8KCt6nbWcLg3HJ3y4QCEUPGmgtmE
oTGAqDSRQuPiuLzbz9nJXY4gvBbKAWtDAYh+YPinfOg3IfKhUkX1jESJ4fWdSIXe
3UNVEV3SuKOsDQ+h5FxCMKCnr3ZsY6hTg9c1dUN2PrNP5BgHaeAQNhTlwYw2kTjQ
16kn2Hv6tBNMaVRo4eI4uQTeF4CB4Re9+91x3pN3Apk3nHifU46GZ1ca/d60U/pf
0rSj8Klg1o9kJRA0OSykvrDUCX5C4XKms39HZr1/6M1ks/Ig0+c=
=CnZz
-----END PGP SIGNATURE-----

--E7i4zwmWs5DOuDSH--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
