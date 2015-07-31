From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/2] update ocrdma to dual license
Date: Fri, 31 Jul 2015 12:02:11 -0400
Message-ID: <55BB9C03.1030103@redhat.com>
References: <1434127505-17739-1-git-send-email-devesh.sharma@avagotech.com>
 <20150630060631.GA21105@infradead.org>
 <CANjDDBh3pxLFe2o08KzAtw8dtVq94GK04x4YZ0nXA+YnVh5Bng@mail.gmail.com>
 <20150701072120.GB31381@infradead.org>
 <CANjDDBinTi43KTt14C7cJ0Uo=Do8Vt3G6bXutLbsViUFUG=jRg@mail.gmail.com>
 <2807E5FD2F6FDA4886F6618EAC48510E110A880D@CRSMSX101.amr.corp.intel.com>
 <20150703155234.GA6099@infradead.org>
 <CANjDDBh1C8Hh_MN9P1=N-g9tvwa-GF0h387_SHiE12cNVKfH2Q@mail.gmail.com>
 <20150708080108.GB5668@infradead.org> <559D7FA9.1040200@redhat.com>
 <20150708200212.GA28030@infradead.org>
 <alpine.DEB.2.11.1507310930240.12455@east.gentwo.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="R5rnNu7LebacQDcGWTsVxpTi6ABQJIi6P"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.11.1507310930240.12455-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--R5rnNu7LebacQDcGWTsVxpTi6ABQJIi6P
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 07/31/2015 10:31 AM, Christoph Lameter wrote:
> On Wed, 8 Jul 2015, Christoph Hellwig wrote:
>=20
>> So how about someone tells OFED to stop trying to enforce this BS?
>>
>> This just confirms my byass that Open-Fabrics Alliance are a bunch of
>> idiots making life hard, similar to all their horrible OFED driver
>> distributions that crated a total mess for everyone involved.
>=20
> There are a number of commmits already that change the license. Lets
> revert these:

Everyone on that Cc: list (and I note in particular that your name is
*not* on that list) has been contacted and gave permission to
Avagotech/Emulex to go ahead and change the copyright on the code.  As
such, it is their *right* to make that change if they see fit.  There
will be no revert, period.

> commit b8f5595eb96c9fce1c907d13e89581e5061edf2e
> Author: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
> Date:   Fri Jul 24 05:04:00 2015 +0530
>=20
>     RDMA/ocrdma: update ocrdma module license string
>=20
>     Change module_license from "GPL" to "Dual BSD/GPL"
>=20
>     Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>     Cc: Duan Jiong <duanj.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
>     Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
>     Cc: Jes Sorensen <Jes.Sorensen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     Cc: Sasha Levin <levinsasha928-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>     Cc: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>     Cc: Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     Cc: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
>     Cc: Wei Yongjun <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>
>     Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>     Cc: Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>
>     Cc: Li RongQing <roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>     Cc: Devendra Naga <devendra.aaru-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>     Signed-off-by: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
>     Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>=20
> commit 71ee67306ecbdfc0c94ed93c77ff99d29e961d69
> Author: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
> Date:   Fri Jul 24 05:03:59 2015 +0530
>=20
>     RDMA/ocrdma: update ocrdma license to dual-license
>=20
>     Change of license from GPLv2 to dual-license (GPLv2 and BSD 2-Claus=
e)
>=20
>     All contributors were contacted off-list and permission to make thi=
s
>     change was received.  The complete list of contributors are Cc:ed h=
ere.
>=20
>     Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>     Cc: Duan Jiong <duanj.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
>     Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
>     Cc: Jes Sorensen <Jes.Sorensen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     Cc: Sasha Levin <levinsasha928-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>     Cc: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>     Cc: Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     Cc: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
>     Cc: Wei Yongjun <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>
>     Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>     Cc: Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>
>     Cc: Li RongQing <roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>     Cc: Devendra Naga <devendra.aaru-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>     Signed-off-by: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
>     Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--R5rnNu7LebacQDcGWTsVxpTi6ABQJIi6P
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVu5wEAAoJELgmozMOVy/dl6YP/1UoDT2p7a/gQBKzUj8GaOyk
QcaTNRqET62KCRoxtghY8QIgjHwvMSq1Rxxk0UuALeX9BoLy47LsfAQZf/V6G14V
8de5qi2deu0fWmdsR0RUynsb7WDE+aCUnLBdwZpJORoM7jFWyt+xCS4YlRCdXcKJ
VPD08bGKXUZRipd9illll6IHBwcTrpqUmeUFUJVwYLnzSK2XV4mIi6Rq3Bqd6Pgn
LrO7SOb50qCLxrihDWN4dYF3UvO/4t2SE2dvMhtZAazw270LT6uU1AugIo16VX5Q
uHZENhkuzSGwRGDJ2E9Dupv+vObAEcqATXJqCq2H8wCkPBZ5jGkYSg2zeVQCvFTX
GoUcCWaFJcrt2Vyl72aiJU7GwYHJU4BwFlP2rybW57283YxUkfDYKH6jQuDDsthH
WdDyGXaKqYQYoZuLemezIImvLWU/rmzRM3zd4IOJ98W0LqPABzK2JD19+/AKP852
8PaRanHktXPmIaQN5XyrJpG1Tqg9yNvn5cYmS+cKkKD6mPpr43DlF4E+4G0CChuP
vjswNV7e5WqWGvDUNuumAy+dyEMXaeWwV+rQypCNgy6SJ/sVQD+KBnSbm6Qroq5B
JsPs04gqkl+zG8Gll4A4GqXmlBtKl8wqJnKM7y5+rZ2OU4d4TUy1FYNYxyQ2TSha
84Xv01gjAx8u4KvfsMAI
=Xq1M
-----END PGP SIGNATURE-----

--R5rnNu7LebacQDcGWTsVxpTi6ABQJIi6P--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
