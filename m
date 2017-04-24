From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: dedicated list for rdma userspace programming
Date: Mon, 24 Apr 2017 14:47:33 +0300
Message-ID: <20170424114733.GI14088@mtr-leonro.local>
References: <CACaajQu1jvvCYJk82_oGOGH7jbjXzbkw_YoggqvW7TZhXj4VBw@mail.gmail.com>
 <20170424104259.GH14088@mtr-leonro.local>
 <CACaajQu9y2HawOjeuwjYSHeFmYfhWreQORB5_61nPiEspoQ2JA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="fzZfjcV6kaBgkq89"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CACaajQu9y2HawOjeuwjYSHeFmYfhWreQORB5_61nPiEspoQ2JA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--fzZfjcV6kaBgkq89
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 24, 2017 at 02:07:14PM +0300, Vasiliy Tolstov wrote:
> 2017-04-24 13:42 GMT+03:00 Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>:
> > There are number of char devices exported by infiniband subsystem
> > (/dev/infiniband/*) and the communication is performed with read/write
> > interfaces to uverbs file [1].
> >
> > Right now, we are in process of migration from these interfaces to ioctl
> > based, see Matan's latest RFC [2].
>
>
> Where i can find tree with commits from [2] ?

https://github.com/matanb10/linux tag: abi-devel-latest

> And how much work needs to be done to get this work upstream? (1
> month, 6 months, years...) ?

At least one kernel cycle, and after transition read/write will be
obsolete and will be dropped.

> If i want to try working with uverbs without C librarary, where i can
> find some info about format of messages reader and writed to uverbs
> device?

Did you see Documentation/infiniband/user_verbs.txt?

Thanks
>
> --
> Vasiliy Tolstov,
> e-mail: v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org

--fzZfjcV6kaBgkq89
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlj95dUACgkQ5GN7iDZy
WKe4AA/8CgwEH6T4hY54hLqx/lbVdS5Sr0r2Xz7w85p0g9HHSc1DOG9vsyvGN3Tf
TSJ6dBOk4O4GnrlMcHEaLyDFAWkJGW1ll/KYUyQghLgIKp9KTXEre7eKVLOMy8nr
g53awenXpzCYKNl3gv2Th/uuFbWMiR/PMImJcoKVGKgP8RefkXnpxwd4QNh1wSaM
NHEhvL6R8c7euq3Z9UeXxmson3MvgMqNMSavjlSm6nxtamj6E5lzlt8ZTcgoDXh0
eUDyLeqX5VnFvUHZqDQkvXyEy2iFWw9edsVfQN/T0tPCX0YS5xbgCSBx//9T0zYn
pPCGnSSXx/D7ROMRHAs1/q60NTx/mWFsLEaP6PQZA1nLkrT0NPWcpP9bVtrCycOQ
O47Sz3d3BbBIdDkYJ4ChmCd6rsFbJCqstkpAzu96YArwzOSrLv5XtQ8wVylqremM
AcUwGVTEojaf2CjssWlitDb0qeU6kyTzpfAqQ/SObDg+ZaOtsMKjKJzPDLamQ5cq
AUuCmiyAAHDJp6+ifp/BhVR3NJnRXWhbdDA0hdC8CGRJ3lHTJs9A4+WbWAMLtlFD
kklzmWRiPbsBTIXjGT04t0/DGuNFzac3n+UBTlARgA/oMttQNskisVC21j3hraRF
ehYYJD951n+MNvoMTuh4stMNO88LT0gI8gw7QA56HR0aCJMO+SE=
=lhNn
-----END PGP SIGNATURE-----

--fzZfjcV6kaBgkq89--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
