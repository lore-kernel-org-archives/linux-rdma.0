From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH v2 19/20] IB/rdmavt, IB/qib, IB/hfi1: Make percpu
 refcount optional for user MRs
Date: Thu, 6 Apr 2017 10:49:55 +0300
Message-ID: <20170406074955.GG2269@mtr-leonro.local>
References: <20170321001900.28538.38175.stgit@scvm10.sc.intel.com>
 <20170321002631.28538.2121.stgit@scvm10.sc.intel.com>
 <1491417489.2923.6.camel@redhat.com>
 <f008c532-340e-01f2-80e6-4bea74175e3e@intel.com>
 <CALq1K=JsjSCiSBeZVe4kHQmjw7tznL36JcsamZTVGZ5RhBvZPw@mail.gmail.com>
 <32E1700B9017364D9B60AED9960492BC342EA858@fmsmsx120.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="B0nZA57HJSoPbsHY"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <32E1700B9017364D9B60AED9960492BC342EA858-RjuIdWtd+YbTXloPLtfHfbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--B0nZA57HJSoPbsHY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 05, 2017 at 08:09:16PM +0000, Marciniszyn, Mike wrote:
>  > Is there a another way we should be looking at for setting things like this?
> >
> > Use vendor channel interface to configure your driver.
> >
>
> What is that? configfs or something else?

An immediate answer without digging into your code is Matan's KABI work.
https://github.com/matanb10/linux/tree/abi-devel-latest

However, I have an question, how do you ensure that user memory has no
users without refcounts? Will it be possible to dereg the memory despite
the fact that there are users?

Thanks

>
> Mike

--B0nZA57HJSoPbsHY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAljl8yMACgkQ5GN7iDZy
WKcMvhAAyBE5DrFiCtt8B167Y8K48mH9xGVk5PXIFaqg5X5dZLZvFdnpyNeDauIs
l4W6l2vpx8VSL/Gqg/jlwogbOF3Q6YVpEJ3lU0LjdQ4LE0l10rfN0Bar1BE/8uKB
p0akMZq/82hzT/s0oYT8OXPvJo0ekhmpUaUkpUgpYO2kzl/hWWaeH2oqj9jkUBqe
Nl8Be15vunbhNkEjOwDiVSZoQOMLcVvrgC1IaJSehMc7gOG5NfgM+oKgH4lBOtKd
pPqyvYEZEe4qUmdevebv+uaKeJIj0fOnSjcTgxAZuBMq44OZq93c3AD2+Cdhkx4L
c1is8OO7rs5sPHS7fJhCytwhUFUKyWaUa23stq7QtmO4QaI5ZdFhhpCeVXCyvkYp
uDoOpDF0dTkT8Q+w3LDKBIMS3XqFAwP/dnxoebxyIow8lQO9NTsTl7muOBnqcn0H
WoAGxMwBL/d6h5fRzlzWTo5GYm7keQUY4xFRPQorifSewY53LgRCGWIE6k7eVm3E
UfS+7d0JqRlhF0RlrzP6n9WJL2hRisGo/dDiyywvPUDZIgAI/yNhsn8+9GCb2pxb
b9bn8vzuJDk/hG+KpIXY6YRMgs84SxNKP/x97fM8WSkyN5u2ox6w0WBkjBEWlRDb
QGJNX+hjmV4PqJ75SOaPcbLb1r8tJNZmiaImZ0+ZJNNSTIEIWg0=
=+WE8
-----END PGP SIGNATURE-----

--B0nZA57HJSoPbsHY--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
