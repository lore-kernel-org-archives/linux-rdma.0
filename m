From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Patches for rdma-core stable-v15
Date: Mon, 13 Nov 2017 18:38:12 +0200
Message-ID: <20171113163812.GN18825@mtr-leonro.local>
References: <6ccc2110-2e27-bacd-b821-f862785a10ca@suse.de>
 <20171113151437.GL18825@mtr-leonro.local>
 <f5e11706-5c7e-a79e-fcf3-4d3df5f35632@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="g2cxGlaq+3AsTAfB"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f5e11706-5c7e-a79e-fcf3-4d3df5f35632-l3A5Bk7waGM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--g2cxGlaq+3AsTAfB
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 13, 2017 at 05:19:46PM +0100, Nicolas Morey-Chaisemartin wrote:
>
>
> Le 13/11/2017 =E0 16:14, Leon Romanovsky a =E9crit=A0:
> > On Mon, Nov 13, 2017 at 04:02:26PM +0100, Nicolas Morey-Chaisemartin wr=
ote:
> >> Hi all,
> >>
> >> After looking into the ML, here are the candidates for the stable-v15 =
branch.
> >> Can the authors please confirm that they should be applied there ?
> >>
> >> Please let me know if I missed any.
> > In addition to the your list, I would like to see the following patches=
 too:
> > commit dbf7bd2151815a12428caef6874149523c0bda8e
> > Author: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Date:   Wed Oct 25 12:04:53 2017 +0300
> >
> >     verbs: Fix declaration of C++ include file in C-block
> >
> > commit 6a74285158a146f23cbf8a804fd9de32df0d5ed2
> > Author: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Date:   Mon Oct 9 10:56:21 2017 +0300
> >
> >     verbs: Fix C++ compilation break
> >
> > commit 983f80191923c082324295ea68ac91d34daaa4c8
> > Author: Nelio Laranjeiro <nelio.laranjeiro-pdR9zngts4EAvxtiuMwx3w@public.gmane.org>
> > Date:   Tue Sep 26 16:05:11 2017 +0200
> >
> >     verbs: fix compilation error with ICC
> >
> > commit bf03566e0aa976afc5dfbf917296280e9fa55bb8
> > Author: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> > Date:   Mon Oct 2 04:17:09 2017 +0800
> >
> >     hns: Fix create QP structure layout
> >
> >
> > Thanks
> >
> >
>
> Added to the list.
> Should we backport the changes done for travis validation ?
> It doesn't impact the code per say but it'd be nice to have the same vali=
dation running in the stable branch.

It depends on the easiest path: backport CI to stable, or teach main CI
to run for stable too.

Thanks

>
> Nicolas
>

--g2cxGlaq+3AsTAfB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloJynQACgkQ5GN7iDZy
WKc/wRAAphfa4llCS6+Z9H0op8GRUilR+skW0jebt/ZMuzwdccFUZN2tGPBNIw6p
Hl2BlXS74/XqtdUOl8Dm5zZPU+MhUsG9TlR4d0ozFrxF3gMmX0pPnp9KtMuBm1tK
PJ6XsWl/d0FgYiKTrDsUke4g/ri9isovLCy8+krONkhflPl9q8/jLLx9g/Fpt7Z1
c62qCFo0o5uM/pGpxCxuCoMSESzKgnABqxC4vbb6675woDKxl1TplRYUf5rCg7BL
AhXO/SCm3EG8rd1fj6b4oWCyIawm31nwHCqVFw744+rmg1zau/MUn+R8FsLD2UtA
koPeGoIjhRanFF3imM1gA9wbSuoRMpPr3gaLR3jX7QFwpv2ueVw8F2CEnGCxXEe6
qHBl49iFPbC/NdokukxTLc/TPEeIY/Gv+ZEdbF9/K9W2j3m9us1TTnGtWSVRH97B
B3wRIngxUdJ9CsU76w5pq0vn2eeT4BBpTN3zPI/5roHLL+xwrm39T9nrkHFrUFHm
YPFayIyxj7ShYde6ZI/jTB0bLw8RmrxUSuxxen2Dp0Vlb8SNb1kkesMx3IdunPpL
KEpeBNRwko+u/oBuuJUXY3kAfEOQhQAj8u4sFLeHEeQWGyjhjXG7sc9+nIxz5ytd
mF9nBewjfCwEc7htSbkPF5I7OjOh7COa7HQ1Yj6c6JeQwHCzRgE=
=zfT5
-----END PGP SIGNATURE-----

--g2cxGlaq+3AsTAfB--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
