From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Is ib_mtu iboe_get_mtu() slightly off?
Date: Mon, 9 Oct 2017 16:41:31 +0300
Message-ID: <20171009134131.GB1252@mtr-leonro.local>
References: <CAL1RGDX33tBR=x2sOp_F1605SY5nu_6YALr-XYE_LiuvsHQ1ng@mail.gmail.com>
 <VI1PR0502MB300886CB47BB3DFDE098A26AD1660@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <1507556073.46071.27.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="xXmbgvnjoT4axfJE"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1507556073.46071.27.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--xXmbgvnjoT4axfJE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 09, 2017 at 09:34:33AM -0400, Doug Ledford wrote:
> On Thu, 2017-09-21 at 02:20 +0000, Parav Pandit wrote:
> > > From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> > > owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Roland Dreier
> > > Sent: Wednesday, September 20, 2017 7:39 PM
> > > To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > Subject: Is ib_mtu iboe_get_mtu() slightly off?
> > >
> > > We have:
> > >
> > > static inline enum ib_mtu iboe_get_mtu(int mtu) {
> > >         /*
> > >          * reduce IB headers from effective IBoE MTU. 28 stands for
> > >          * atomic header which is the biggest possible header after
> > > BTH
> > >          */
> > >         mtu = mtu - IB_GRH_BYTES - IB_BTH_BYTES - 28;
> > >        ...
> > >
> > > 28 bytes is the size of the AtomicETH header.  But couldn't we have
> > > a packet
> > > with both AtomicETH and XRCETH (4 more bytes)?
> >
> > XRCETH + AtomicETH is possible.
> > Additionally I guess 4 bytes of ICRC is missing too in calculation.
>
> Since no one rolled a patch for this, I did.
>

Doug,

Parav created, I waited for our shared code.
https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/commit/?h=rdma-next&id=51ed6735dd59008aea4d7308416ed994b277f168

commit 51ed6735dd59008aea4d7308416ed994b277f168
Author: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date:   Thu Oct 5 10:33:12 2017 -0500

    IB/core: Take into account optional XRC header and mandatory ICRC for RoCE MTU

    This fix considers optional XRC header size and mandatory ICRC 4 bytes in
    calculation of path MTU, by considering additional 8 bytes, path MTU calculation
    is more accurate.

    Link: https://www.spinics.net/lists/linux-rdma/msg54558.html
    Fixes: 3c86aa70bf67 ("RDMA/cm: Add RDMA CM support for IBoE devices")
    Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
    Reviewed-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
    Reported-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
    Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks

--xXmbgvnjoT4axfJE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnbfIsACgkQ5GN7iDZy
WKc8xQ/+LpfOslah6Ep3DAb6eQH5EikJ+94N6m7TGe7cqS+D4WYeFKKcOnAuC4PK
+8ROhXeX3w+1q33d06D7ugWD3zM3HezNDkRDIDfozikM02c/SHnB4rP7kiLEjzXT
Qu1iUVXgSToeX3NQkFSXlC+/3slTddR7nCxl1ceIqNXi4SD/KfnAG7pOBDhITkwc
sPgXk0uGJ21lwVsBjAPkEH9I6raW90c/XMDSOuH52gZ3bKtO6piN0g+LBkgEMN8E
iK6W6uLdAhKOSMF+J+3UE0XvDgYF/jfA+qI4sv8boakltipIJ328uYaFk8pqODA0
m6SDzB/GzZiCfmjZz7jp8ZpgILsdeNzTrsjOcWx9c3kPOB1SDJxAffZza//XYVMo
EeSu/MfoQgFj0ljaG6ODzFmCEGv8orJ1NmOoosq3JiW33SWKNw5YloCXmp01JRXz
tD2f369vydjetS8Bv5DgKF5RLd66Yw5HIaiJPhYefQiqSHAOvAlCTrEnBmq50N7F
6sD0Tmk3Kaj167hNW3QnOaLfFNkpkGdnytoc58exjG9mxC/dwtfSmsrCWblWdhIB
WyxF45l9JaaGmPijv585xkCH3Y+KnUl1wB3X5YLSkMZJK2JghQER4fzp6Ic67Xlv
4UobMkkcZ4qNJYY4/WRBGukL/2o5GII019lPyEmDyCVAORglky0=
=aBkg
-----END PGP SIGNATURE-----

--xXmbgvnjoT4axfJE--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
