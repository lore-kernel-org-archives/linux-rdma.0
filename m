From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-rc 1/4] IB/rxe: Fix kernel panic in udp_setup_tunnel
Date: Tue, 6 Sep 2016 11:59:43 +0300
Message-ID: <20160906085943.GL21847@leon.nu>
References: <1473077359-11546-1-git-send-email-leon@kernel.org>
 <1473077359-11546-2-git-send-email-leon@kernel.org>
 <CAJ3xEMiBpGRy-JGuJ=P4eUF5zyz+2bm43F-jqPHtwm=3Uz9YYA@mail.gmail.com>
 <CAJ3xEMidqQRMqP6u+SJSJVbq0weREAtAJN=eXsA_zzS0KnQ_7Q@mail.gmail.com>
 <20160906050518.GJ21847@leon.nu>
 <CAJ3xEMiuuCTGiWbefAFLRYART4h8YypsvGqxT69cTpkbrDdx1g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="opXR4bS/BgjGcxUR"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMiuuCTGiWbefAFLRYART4h8YypsvGqxT69cTpkbrDdx1g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--opXR4bS/BgjGcxUR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 06, 2016 at 09:06:46AM +0300, Or Gerlitz wrote:
> On Tue, Sep 6, 2016 at 8:05 AM, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> > On Mon, Sep 05, 2016 at 10:21:15PM +0300, Or Gerlitz wrote:
>
> >> Hi Yoni, in this case, the trace contributes practically nothing to the
> >> driver and kernel maintainers, please remove it.
>
> > 1. We got this call stack from external user and he wants to know that
> > it is fixed.
>
> good to know, Yoni - we should give them credit! add Reported-by: line
> after your author S.O.B line

Internally, It was asked too, and we decided to skip it.
It is uncommon to put jenkins bot name.

--opXR4bS/BgjGcxUR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXzoV/AAoJEORje4g2clinKScP/RkmoguSVOtWdHFHG53Q2pv3
QqFk+DMJzZUIDIDPuXejfA+nChevjPkiL045ytHBJ0vLDZlwJ9GZ7/FFqIQ2kSZ2
LhRTFk41c1aTB+sUWXoPnZZXwzHDNg7NULhOWmEE9Pwao/OUpOnD79H09IpAcXzH
5hzmY0yuNZ+92oY2tvslpaLEDVrexLWocGlFYeKvSeV1Hq9aopUMXX6o7WdWg1Zc
g3F0B4R1Pb6L4AixkQY59Rfuy1GvKfbOBqtxfv6sdNmih9uHRwjUZXSzJTR4Xwqx
dz55mqeBD2mZy19L2YsxM+BZ7De0RJJtHjGquACdbKAOX54+hqmglLSw4pWBYEbV
cWiBjvCAtyUt4SAHaL3GbDBfEMpZtP1tlJOaiZGkPIlIJENUnDAhuPg9UQBcrIDn
yGfEKJaanl5RJRD9RDYRW60dTERnQn+uRv9W5BQOP8kYnwOUXty3MJJlPCveshMe
IxiCsKIh6eRZuK/Ia8iGKk5XQLNU53dufc2M/tr0Ioyiz9G9I1RhoPj8YlavTrFT
xYVmQ2ibRMUWde6VuiYwaqMYBvAiWLCiIpY+hduPSVycDxBPf3hrVvRV4PLjHE25
focp1Y8gLqtDSKxOGpMPKr1p9LYmx5qbceWynQ4Nm7+J5n1c9dUGosHeuHZWT42/
tNbGR9ONgVRJPKiOyCbA
=PD7u
-----END PGP SIGNATURE-----

--opXR4bS/BgjGcxUR--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
