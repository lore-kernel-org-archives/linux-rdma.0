From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] ib_core: Enable and expose force_mr module parameter
Date: Wed, 28 Jun 2017 18:41:12 +0300
Message-ID: <20170628154112.GH1248@mtr-leonro.local>
References: <20170619152351.2866.11046.stgit@klimt.1015granger.net>
 <20170620073236.GO17846@mtr-leonro.local>
 <DE0C511C-A4CB-4D76-8BA7-6BFF81F590B3@oracle.com>
 <20170620180348.GV17846@mtr-leonro.local>
 <C27E2410-44B7-451E-8069-DF1444048158@oracle.com>
 <20170620184046.GW17846@mtr-leonro.local>
 <B34E95B2-A7D9-4725-B7C2-3DA4DACD29B7@oracle.com>
 <16d52534-5564-8137-a8b3-6c66df6bb508@grimberg.me>
 <20170628095640.GB1248@mtr-leonro.local>
 <373E6A00-8505-468C-A974-DCDAC15A3B7B@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="lXp6bW3Dj4tVIRc6"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <373E6A00-8505-468C-A974-DCDAC15A3B7B-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--lXp6bW3Dj4tVIRc6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 28, 2017 at 10:49:00AM -0400, Chuck Lever wrote:
>
> > On Jun 28, 2017, at 5:56 AM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >
> > On Tue, Jun 27, 2017 at 12:24:20PM +0300, Sagi Grimberg wrote:
> >>
> >>>> It will be "marked" as UAPI and we won't be able to change it,
> >>>> which IMHO bad for the debug. It also invites users to set it
> >>>> and in perfect world, we should test our HCAs with this flag
> >>>> on and off, because curious user can set it.
> >>>
> >>> We have loads of legacy debugging interfaces.
> >>>
> >>> And yes, ULP developers should be aware of it and test with
> >>> both settings.
> >>>
> >>> I'm not convinced any of this is a problem for this particular
> >>> setting. However, I guess the thing for you to do is propose a
> >>> patch.
> >>
> >> Are you guys seriously still on this? Its simply a trivial
> >> debug flag, whats all the fuss really about?
> >
> > I hope that we are done.
> > https://patchwork.kernel.org/patch/9808615/
>
> Somehow this got by me.
>
> The patch description says "exposed to regular users." The
> force_mr option is not exposed to regular users. Module
> parameters are visible only to system administrators.
>
> Also, just looking at the patch, it's not obvious why "The
> force_mr module parameter wasn't exposed ... from the
> beginning". IMO an explanation of what has prevented
> exposure is needed. Commit a060b5629ab0 got the fourth
> parameter of module_param_named wrong. Maybe a Fixes:
> tag is needed too.
>
> But frankly there is no visible change from this patch.
> Before the patch, force_mr is not visible, and after the
> patch it is not visible. Why then is this change necessary?
> It would be helpful to cite a policy about why removal is
> preferred over fixing the incorrect parameter.
>
> Therefore IMO the patch description is not adequate.

I'll update it.

Thanks

>
>
> --
> Chuck Lever
>
>
>

--lXp6bW3Dj4tVIRc6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAllTzhcACgkQ5GN7iDZy
WKeyWg//YFtJdkvyxmOrL4N+lukW/f9/bFtlD00JVGrp/FJpSupgmXyYC3pT2Vdg
1uJqwt/i54dBC6FuqAz+b2vPU2ahlLv+/Dp0EI2CrO3DgcIdryzxwcgGUMKGrYLH
wfnkpfYj62A0hhsiJbq4hxjmOcoQ1pN+F5umHV2fc+Mr4SENQWD2f76miWih5XLb
iZKlOJenFXtBj2U4lbz4C0SQQRAayX1pZTVCEl4DR7sOT6oug3jZza9ukzX/TiLL
5dIAAussOD6x394jq8Qet5xEOx3tOPRJp9gGgP7mY6IMsGXQFhMNFokIjLeJAaUa
z6Q/gSblbTZ2N4uZ8glCcVZQ9wh1gLdU4zFxzA+esl8sfG6WUOO4auekD6cKEp4k
enbXaleV0QRI2C9odVWB3hKBSry5WfL3Tm8MGKnj9E0GARUST/g+Vr6CqbTl3Rws
YVVYaW/WDAnxNE8DoxyLNHUgCEc299atBl/WUF9ntcfHJhJe1vN6cis/iSXVtRNb
+xr2WVZRB2CjxnkEiUmK1qvzt+7XqiuqngBW4JehqQEuffLmnFPvIRNYWq9JJ01m
znBVtEudiCQzGt3HJV/cJjtIjLdrYJsWIPoXDhZK+QHiZO9pVoRb8aOwHpAwJciC
vRxSc2MbhH377ixSkm33bileqOfGFdNkW2MJVt/gXIphaGeBiGM=
=7wPQ
-----END PGP SIGNATURE-----

--lXp6bW3Dj4tVIRc6--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
