From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 00/13] Request for Comments on SoftiWarp
Date: Fri, 20 Oct 2017 19:25:21 +0300
Message-ID: <20171020162521.GA2106@mtr-leonro.local>
References: <20171006122853.16310-1-bmt@zurich.ibm.com>
 <20171020134501.GD11604@ssaleem-MOBL4.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Yzwzo2Lpb9tBI5S/"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171020134501.GD11604-GOXS9JX10wfOxmVO0tvppfooFf0ArEBIu+b9c/7xato@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--Yzwzo2Lpb9tBI5S/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 20, 2017 at 08:45:01AM -0500, Shiraz Saleem wrote:
> On Fri, Oct 06, 2017 at 08:28:40AM -0400, Bernard Metzler wrote:
> >
> > To experiment with the current siw code, we suggest cloning our out-of-tree
> > development repo at https://github.com/zrlio/softiwarp.
> > Here, the branch 'dev-siw.mem_ext' contains the most recent code
> > development status, which is currently in sync with the patch.
> > Testing siw requires the installation of both user library and kernel
> > module, located within userlib/ and kernel/ respectively. That siw
> > version expects a running kernel of version >= 4.12.
> >
>
> So you need OFED (which ver. ?) installed for user-space?
> Is there a plan to integrate your user-space into rdma core? Would be
> easier to evaulate/test.

I doubt that someone will seriously think to accept SIW into the kernel,
before seeing complementary part for the rdma-core.

Thanks

>
> Shiraz
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--Yzwzo2Lpb9tBI5S/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnqI3EACgkQ5GN7iDZy
WKdxzRAAuMg7uUSrEn2VClt3B7QpSoEiY3HhFS1YhuuaPHyZREo0D68I+HSdJJ5d
8WZKGiUCCD7DJZL4H2xXAGLGPvyn7alt3rRivyVK75Q3xwWK4mCeGRudHaaza3a1
yIBUXlGO1j9wUbDSnoI+mSbFATP9ccKdS3HIpEey/NDeX7te4OuRIwoy01f8m7zd
dMAScBRGPPWQ2A+LK1vOlqVhH3SPd/Fol+Uqr7vsmJd+32gcbod4g3KCXxr9Vpyd
1Tdk7+LSX3KHm9SYoNbvkOAfsuBiVNfMlCoQhaH/JlYki67EMQ5pgD0V+4gWb0E6
6M5vydCLecclGny+1DTYVV3dk0kBLDvAm2h700PGyyI+4p8n+C64DqUPRl+G/y/L
N4nB+74mdvu2i12zALHKkEjeZwlYUSZlKHHsLnHGplVrJOPffqBHGvfWjOm8pWCy
yP/KO0d5x1ZNkIf1xXqNxxABDuhpyjyXBjUoa38gQoncWXFQ1Zh0+n5kw7uBhg30
Bt+iE6zGe8Ij78bpLOuRHT5LTgAG30pS+50VAaoMI94Upj8YSqo6620YM7PvNIaF
M0ynOhozeOjq24/tUYq2xWPsbG09VwG0fYMGDtPvE7pI/KmDIzlrAUcpST9bKTHY
b0+XpDvwtCskrOJ8PldKIMpK9zdSQ27WTtUZwfBDH00HEntyxYk=
=sENn
-----END PGP SIGNATURE-----

--Yzwzo2Lpb9tBI5S/--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
