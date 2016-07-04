From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next 2/2] IB/core: Support for CMA multicast join
 flags
Date: Mon, 4 Jul 2016 08:35:54 +0300
Message-ID: <20160704053554.GC5289@leon.nu>
References: <1467550074-24061-1-git-send-email-leon@kernel.org>
 <1467550074-24061-3-git-send-email-leon@kernel.org>
 <CAJ3xEMitNu8HACD3EZ1kQGU4o-VyDphWFUN7qn94+LpBSV4E=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9Ek0hoCL9XbhcSqy"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMitNu8HACD3EZ1kQGU4o-VyDphWFUN7qn94+LpBSV4E=w@mail.gmail.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--9Ek0hoCL9XbhcSqy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 04, 2016 at 12:46:31AM +0300, Or Gerlitz wrote:
> On Sun, Jul 3, 2016 at 3:47 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > From: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> > Added UCMA and CMA support for multicast join flags. Flags are
> > passed using UCMA CM join command previously reserved fields.
> > Currently supporting two join flags indicating two different
> > multicast JoinStates:
> [...]
>=20
> > --- a/include/rdma/ib_sa.h
> > +++ b/include/rdma/ib_sa.h
>=20
> > +#define IB_SA_MCMEMBER_REC_JOIN_STATE_FULL_MEMBER       BIT(0)
> > +#define IB_SA_MCMEMBER_REC_JOIN_STATE_NON_MEMBER        BIT(1)
> > +#define IB_SA_MCMEMBER_REC_JOIN_STATE_SO_NON_MEMBER     BIT(2)
> > +#define IB_SA_MCMEMBER_REC_JOIN_STATE_SO_FULL_MEMBER    BIT(3)
> > +
>=20
> can we somehow avoid repeating defining these join states in 2-3
> places and either make the code introduced in commit  cd6e9b7ef
> "IB/core: Support new type of join-state for multicast"
>=20
> --- a/drivers/infiniband/core/multicast.c
> +++ b/drivers/infiniband/core/multicast.c
> @@ -93,6 +93,18 @@ enum {
>=20
>  struct mcast_member;
>=20
> +/*
> +* There are 4 types of join states:
> +* FullMember, NonMember, SendOnlyNonMember, SendOnlyFullMember.
> +*/
> +enum {
> + FULLMEMBER_JOIN,
> + NONMEMBER_JOIN,
> + SENDONLY_NONMEBER_JOIN,
> + SENDONLY_FULLMEMBER_JOIN,
> + NUM_JOIN_MEMBERSHIP_TYPES,
> +};
>=20
> to use the above defines, or the code added by this patch to use the
> enum Erez added, or both code pieces to be re-written and use some
> shared enum/define?

Good point,
Thanks

>=20
> Or.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--9Ek0hoCL9XbhcSqy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXefW6AAoJEORje4g2clin+1QP/2swXkAy15d2oa+sM6AB9336
DkgaWfHJKyqts9xg2nxOrxuab5TcIg3hiTesxHMVetrDMeNuDYNHmer4mG+N6jDK
ghdw/2xjIEHRZ+B7gZf11EpNJs4UyXBSfZ/PDGak0vDUNfUb1M5LWHq4bqtuNaaW
zwk1qCOy0sgA+A9GyRULStcgyPFkio5f/J51ZUKQMm/lant8XgXLfe0MjLMDHr89
ADm9jARoODRTpGhP4pn0q5++KoFPvZxsYz3cFv5TalYQY4S4Glfr0uJwFHVttBgW
zi4eQaj+N2vK8OE4y1qfC2RDJKlS4dA3qM0xoeowjgCzirBSgzv5RA5vJtPUWAcB
EGd2l65lB5u+p56GQGgX+MWgI0SrkN7yWq2Is+jxqk4y7xxagN4b9/l3mFT3EXG/
q8F3q/2RqnjbSuG8sZgedvsXSjqmmyqjpRP+UKk6zfB93pH9eJOEGQP/KT3VvFTn
9jr5tqwVeWl96qxM23lJNVecAcKG8mQd0MBN92hD8G2J4NLtTCDwGEB3l/jC2+TZ
jSziLHxPyWEL8jDMsHP7olcQFW2KM2cNz6jOuCXBR5xjk/E04RhYlVYKyrenQSpn
Y7Z2z/xDGK/n7iUHXHgk0FLHGkcAZLvgUx1wkxgZ+ya/jmgC7e0QNGHvkm3URfOn
1DRqx0PpXbD0aeFjN+q5
=d/sg
-----END PGP SIGNATURE-----

--9Ek0hoCL9XbhcSqy--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
