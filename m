From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Why don't we always check that attr->port_num is valid?
Date: Tue, 3 Oct 2017 08:21:59 +0300
Message-ID: <20171003052159.GB26055@mtr-leonro.local>
References: <20171002113431.lqkf4ilmimjfouc7@mwanda>
 <20171002152033.GB12331@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="98e8jtXdkpgskNou"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171002152033.GB12331-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--98e8jtXdkpgskNou
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 02, 2017 at 09:20:33AM -0600, Jason Gunthorpe wrote:
> On Mon, Oct 02, 2017 at 02:34:31PM +0300, Dan Carpenter wrote:
>
> > We deliberately allow invalid attr->port_nums if IB_QP_PORT is not set.
> > Why must we do that?  From a kernel hardening perspective it would be
> > better to ban invalid values all together...
>
> It is part of the user ABI, so it has to stay that way...

Can we pre-process all invalid parameters at the kernel entry points to
ensure that drivers receive clean input?

For example, overwrite attr->port_nums to be zero if IB_QP_PORT is not set.

>
> Can some code restructuring bring both things under the same if
> somehow?
>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--98e8jtXdkpgskNou
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnTHncACgkQ5GN7iDZy
WKe+RxAAkf80KEubFTEW/fL0v045Ha7fdBhUz9SDPhcOyo1xy+0k/Z/PypibU2A8
kEo6Z0IZsdDbensqFhCW85XE2YetKqMx3/IdY28NINOz7QMU9AAPwd1IhnqhAs2h
iuQXrQNMphzIujuSb0Dzmgg23+9tvgSlfLY21xfvm3w9gZ1OSm7u72kS0w89mEjd
9qOom/CLYZ5HkMR0lv0iDPwG0J3CwpafOZ+14cjo+Zz6U2LLSu1mb+rpXwdqQd94
LjfkvdlxdqB4iqvICHfiPNRHPFJhYTCnd5Qo9gFX4aXFqoas2w1xYri5Bb9bjL3m
jIRgKfaceDdmU+WnbTxyHnS5IWQpaTbMQGt49a8IKszF78JAudFdC+gXhXPXROTn
tvxrY1D350ir6GFPawvbhNbNvoQYXr+4502R34kRQuqbhHaGovkzGuAgshh9JR1K
I7G2GFZ6NAwROJr09JNaPPp1tc3ooQ1yA8IhhAD5jyhl+K7r6Q03m9SSDCC+SHOI
iGLyft/STR3D/6/r6K8axlQRatMuId8WyuGxUzxqtcnDAOxU4S8hXmVFTO/+JkTI
FYjVE8eLd1G/Ai87v1qJCHSYyZHJJ0b6yaaA/pFX/hkvAIwXwg+0v2IyA7D7ei22
EckAZosUiahZAr7g2hP4H0UiZC+nZAjS8UE3bFAi34m+D2HtmPI=
=oZfX
-----END PGP SIGNATURE-----

--98e8jtXdkpgskNou--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
