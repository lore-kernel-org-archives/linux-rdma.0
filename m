From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: dedicated list for rdma userspace programming
Date: Mon, 24 Apr 2017 15:34:13 +0300
Message-ID: <20170424123413.GJ14088@mtr-leonro.local>
References: <CACaajQu1jvvCYJk82_oGOGH7jbjXzbkw_YoggqvW7TZhXj4VBw@mail.gmail.com>
 <20170424104259.GH14088@mtr-leonro.local>
 <CACaajQu9y2HawOjeuwjYSHeFmYfhWreQORB5_61nPiEspoQ2JA@mail.gmail.com>
 <20170424114733.GI14088@mtr-leonro.local>
 <CACaajQs=04be-QDFgqjXj4u=qp4wC6KFU8y5g=kR7vkV0QkbdQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="27KoNqt0fmcl1zj/"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CACaajQs=04be-QDFgqjXj4u=qp4wC6KFU8y5g=kR7vkV0QkbdQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--27KoNqt0fmcl1zj/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 24, 2017 at 02:58:57PM +0300, Vasiliy Tolstov wrote:
> 2017-04-24 14:47 GMT+03:00 Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>:
> > On Mon, Apr 24, 2017 at 02:07:14PM +0300, Vasiliy Tolstov wrote:
> >> 2017-04-24 13:42 GMT+03:00 Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>:
> >> > There are number of char devices exported by infiniband subsystem
> >> > (/dev/infiniband/*) and the communication is performed with read/write
> >> > interfaces to uverbs file [1].
> >> >
> >> > Right now, we are in process of migration from these interfaces to ioctl
> >> > based, see Matan's latest RFC [2].
> >>
> >>
> >> Where i can find tree with commits from [2] ?
> >
> > https://github.com/matanb10/linux tag: abi-devel-latest
>
> Thanks!
>
> >
> >> And how much work needs to be done to get this work upstream? (1
> >> month, 6 months, years...) ?
> >
> > At least one kernel cycle, and after transition read/write will be
> > obsolete and will be dropped.
> >
>
> So 4.12-4.13 ?

4.12 is almost closed. We are in rc8 now and merge window will be next
week, so it will be 4.13-4.14 (optimistic).

>
> >> If i want to try working with uverbs without C librarary, where i can
> >> find some info about format of messages reader and writed to uverbs
> >> device?
> >
> > Did you see Documentation/infiniband/user_verbs.txt?
>
>
> https://www.kernel.org/doc/Documentation/infiniband/user_verbs.txt as
> i see this nothing says about format of data writed/readed...
>

See in include/uapi/rdma/ib_user_verbs.h, User fills struct from that
file, and kernel performs copy_from_user to extract the data. That's
all.

Thanks


> --
> Vasiliy Tolstov,
> e-mail: v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--27KoNqt0fmcl1zj/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlj98MQACgkQ5GN7iDZy
WKeu8xAAiRmD5qs2ugJzN2sQtp6+3rXjIT9zUAJhyTtVdE0t72vR2FKMbxA4mQVr
NoILSU/ZU/HpHDUdfBGDozqJ6L7CbEw64HJzl76Ph4zNXJh29ZiUD51GV75fzHt2
SIu+/+rjPxlb6u+p8s7OakAU9qWpOYsfa4z1r620UL9Pkuta0umdNKWxPWVilfeR
VK8A9ZuRGqUmWjXDiv0QZsLzJ1z/FpY1HHM32Q3FP8H4xdyik4DBoZwGbh8E18tN
2VyhpJX7sawsR4zU58uAyiBokdi589q8ZeeOAJRk6Xk8PFVyjAUAOunadhttI2/J
wGEJnxv4oRrPDcoRSkB8QV03r1Ejif/3TDS6h3c6EQktYTLDA4cx8fHNdbit4TOu
4Wkm6AB4MwPrcxr7kz+VMBLdzXePrIZfSOaLRcCzUBW+XRaTP0CznRYYceKnPLlR
QAZ0uBYqhExN0p3x4GeIwTKJVHhLfhxJ46oMhS7lzhDMrGsEBoQA2S0GMFhCdK/E
5DBf9KHmFP8duxdPo1UrXdvk8s7c3HYqCEOnjn/ZDb7hGtkiXI8bVVDz9rlePz5K
RvakC412g+VB9AFJPGUBIdTI21qZTG4Viercp4xEI+EkqWrewBuKTq/djU2dDFiW
arYaMTnk/yleTGSZnN5N5fkACMjyhsEk0/qTYiv8qJHaIel9Xe0=
=Kih0
-----END PGP SIGNATURE-----

--27KoNqt0fmcl1zj/--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
