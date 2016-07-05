From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next 2/2] IB/core: Support for CMA multicast join
 flags
Date: Tue, 5 Jul 2016 13:45:25 +0300
Message-ID: <20160705104525.GC15009@leon.nu>
References: <1467550074-24061-1-git-send-email-leon@kernel.org>
 <1467550074-24061-3-git-send-email-leon@kernel.org>
 <CAJ3xEMjqkn09zFXZ5Fj3wvtM3GSa=vzgTuuVoAFENToa4Zh4uw@mail.gmail.com>
 <20160704045111.GA5289@leon.nu>
 <CAJ3xEMgErk9Gu8g98dxkdjRP6aiq6hdkAOPj-a2zKLSTwaGZ0w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bAmEntskrkuBymla"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMgErk9Gu8g98dxkdjRP6aiq6hdkAOPj-a2zKLSTwaGZ0w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--bAmEntskrkuBymla
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 04, 2016 at 03:40:10PM +0300, Or Gerlitz wrote:
> On Mon, Jul 4, 2016 at 7:51 AM, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wro=
te:
> > On Sun, Jul 03, 2016 at 04:46:23PM +0300, Or Gerlitz wrote:
> >> On Sun, Jul 3, 2016 at 3:47 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrot=
e:
> >> > From: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >> >
> >>
> >> >  drivers/infiniband/core/cma.c    | 98 +++++++++++++++++++++++++++++=
++++++++---
> >> >  drivers/infiniband/core/ucma.c   | 18 ++++++--
> >> >  include/rdma/ib_sa.h             |  5 ++
> >> >  include/rdma/rdma_cm.h           |  4 +-
> >> >  include/uapi/rdma/rdma_user_cm.h |  9 +++-
> >> >  5 files changed, 122 insertions(+), 12 deletions(-)
> >>
> >>
> >> For the ease/robustness of review for UAPI changes, we have a long
> >> time common practice
> >> to break things like this one to IB core kernel only patch, and one
> >> that deals the user-space
>=20
> > You are right, this practice exists and we are following it as much as =
it makes sense.
> > This specific case doesn't need to be separated, because it introduces =
one logical
> > change and separate patches will be useless as standalone patches.
>=20
> Leon,
>=20
> The point is that you need to get people to be used to that practice,
> and it seems we're not doing that. Otherwise I wouldn't have to chat
> for 20m with 2-3 people that wonder why I made these comments. I think
> we should require it from the developers, period and not argue on
> that. B/c in bunch of other places, it is totally required, for
> example, here you could just carve this small piece to be part of your
> UAPI patch, what's wrong with that?
>=20
> --- a/include/uapi/rdma/rdma_user_cm.h
> +++ b/include/uapi/rdma/rdma_user_cm.h
> @@ -244,12 +244,19 @@ struct rdma_ucm_join_ip_mcast {
>   __u32 id;
>  };
>=20
>  struct rdma_ucm_join_mcast {
>   __u64 response; /* rdma_ucma_create_id_resp */
>   __u64 uid;
>   __u32 id;
>   __u16 addr_size;
> - __u16 reserved;
> + __u16 join_flags;
>   struct sockaddr_storage addr;
>  };

The main issue here that new code is using this struct and new field while =
the old
code uses reserved field.

--bAmEntskrkuBymla
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXe4/FAAoJEORje4g2clinHOAQAKKVYe5BF1EoHzJYHCWb+6Wr
R6RHBRTB6ERmrpU3WbOI5hhdbafMWm9+Ca7IjW81gn58FXz8vd+e8gqFIy5pyuw4
oRQQ8DPNMccfxnzCiywBPJVQkC3BTWG03U1YPM6sM/YD/XU0Wd5VowGIK0LufEV6
lbBBuSuNJWlgntT7iuU49o0DoBEwvN6p9R0Kxwl20TRZh0Wj6xoBvwD3GIvjLw+p
EODjVxuzz3on9xwBZk0vXgo6+0kAvArYJ6e+B+kdwWbAtsgMHwMnXMbDoTeEhCKy
8nKB0CC8v2K1jNDc06xt/MATQw4yCGGNFS3LQdO9360EOvKVUOXDi8k/g0MnnCPY
f2KHgUaAZ1faK/ODQBXokBzP6hEWfRi+FYMgWwDrct+Cr0bQKKukqpI9ul/mP/zu
TtlLYpD6RCBPyrNG416MTQmnvlzkqOGY7mbQwi7ZetdOkHDG7HCd9lObyi94dQGY
nyQCh8zjoO8z6XKiQS5qVywMRiaEzW6r/r+45WLGc01Vsk0NtJmQJH8lX/rhG2yB
xaOceGkp6MkYHMEddpK1L6mBCgMDofh0FFrFied/evpKir3t2f0vw5HgBRm7/Zja
TxbmtKmXzoqs6oFTW6Q4h95YA/u801Dqyhho91ib4BJfSzlvAwjZdDtksSn7RXNf
zpNRAjoCdHwxNO03kOE0
=Rt8s
-----END PGP SIGNATURE-----

--bAmEntskrkuBymla--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
