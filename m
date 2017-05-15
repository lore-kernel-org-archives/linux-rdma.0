From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] ib_core: Enable and expose force_mr module parameter
Date: Mon, 15 May 2017 20:00:21 +0300
Message-ID: <20170515170021.GJ3616@mtr-leonro.local>
References: <20170515145203.10708.16921.stgit@klimt.1015granger.net>
 <20170515145757.GI3616@mtr-leonro.local>
 <02AFF424-A387-47F7-BD24-61C7734B9008@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="GrZJL/A7LJaW37J8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <02AFF424-A387-47F7-BD24-61C7734B9008-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--GrZJL/A7LJaW37J8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 15, 2017 at 11:09:06AM -0400, Chuck Lever wrote:
>
> > On May 15, 2017, at 10:57 AM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >
> > On Mon, May 15, 2017 at 10:52:44AM -0400, Chuck Lever wrote:
> >> The fourth parameter of the module_param_named macro is a set of
> >> file permissions. Passing 0 there means that module parameter is
> >> not created and that adding "options ib_core force_mr=1" to a
> >> modprobe.conf file has no effect.
> >>
> >> The default setting of rdma_rw_force_mr continues to be 0, or false.
> >>
> >> Fixes: a060b5629ab0 ("IB/core: generic RDMA READ/WRITE API")
> >> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> >
> > Chuck,
> >
> > Do we really need this parameter?
>
> Hi Leon-
>
> Christoph and Sagi introduced this with the new rdma_rw API.
> The default behavior is to avoid the use of FRWR, even for
> devices that can support FRWR but also work without. FRWR is
> used only for iWARP devices, which require it; but FRWR can
> have a (slight) negative performance impact, which is why it
> is not the default.
>
> The purpose of this module parameter is to enable the use of
> FRWR for devices that can go either way, as a way to test the
> FRWR capability when using those devices.
>
> I'm not sure we _need_ to have the module parameter. But I've
> certainly used it while developing the NFSD conversion to use
> the rdma_rw API, since I have no iWARP devices here.

I asked that question because commit a060b5629ab0 was added a year ago
and since then no one noticed that it is not usable, including authors.

I think that we can safely remove it and for development, we can set
rdma_rw_force_mr internally in the code.

Thanks

>
>
> >> ---
> >> drivers/infiniband/core/rw.c |    2 +-
> >> 1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/infiniband/core/rw.c b/drivers/infiniband/core/rw.c
> >> index dbfd854..1cc8f07 100644
> >> --- a/drivers/infiniband/core/rw.c
> >> +++ b/drivers/infiniband/core/rw.c
> >> @@ -23,7 +23,7 @@ enum {
> >> };
> >>
> >> static bool rdma_rw_force_mr;
> >> -module_param_named(force_mr, rdma_rw_force_mr, bool, 0);
> >> +module_param_named(force_mr, rdma_rw_force_mr, bool, 0644);
> >> MODULE_PARM_DESC(force_mr, "Force usage of MRs for RDMA READ/WRITE operations");
> >>
> >> /*
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> >> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> --
> Chuck Lever
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--GrZJL/A7LJaW37J8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlkZ3qUACgkQ5GN7iDZy
WKecrg/9G3imSAb4dpPk8CNsuXfk9SRG5mlAIVKyOdm5C9GeepOZNXTLWk0sPXVI
MgGU5fe4M+nWVlQwxNFYXlNzQEXcL7L4zhHL7lCgWoM4GfuvKHua2DJIDbY2zu1w
n5zMtcmVSokc9Bhk07GbwmKJowBCcHiZIbZDHf/vu3fCfNBI+yTiDu2Ev0EGWWuP
4dVOjDHjedq5CAHPjwrRFTvtsjv4PZRV5e0RxnKau3aZCXuTKTYoflEWdPJ74QDO
yzA58Z1EmDKlcvH1tAey3pbIjmzv7jrVkTMfzhDVr1lMsGiGcJ//jUGEtyPMWuQ4
7DHAavdDyY8FuvGLKwudD076ce/+Ihrnhitr35+lYMJv9R9pcD/4GkfbCfksumcO
W7fmbdN/1TG3u9vHE/1sp0ajPELj+x0QJjKEInHQuBFae4W6GnelbHZvXxc+dEUi
bP3XhQP/HN/AbzmO6q5LtDVz1+k7p7PbpBX3fll129mrruCngYXIerTvPzPOeWrh
LBjeln+lZx6k6pwEmUn3nOeY0Y9tnj8w+TI0mUVLxsPNm9vA7Ycgkr2ofAFCk156
bMDXY6I/QZ0mach6XnkqJi1SZgEitZcx3i7G3FF0B5CPJGO7du4HwVvrz24OtGYU
ObHv5Yqsq2Q6zJ05JzHCj1X47cu8hXBSM/ec6MqUFeCQGdQC27c=
=xYa8
-----END PGP SIGNATURE-----

--GrZJL/A7LJaW37J8--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
