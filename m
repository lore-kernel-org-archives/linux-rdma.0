From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH iproute2-next] rdma: Move RDMA UAPI header file to be
 under RDMA responsibility
Date: Mon, 26 Mar 2018 20:07:58 +0300
Message-ID: <20180326170758.GM1877@mtr-leonro.local>
References: <20180325063856.31709-1-leon@kernel.org>
 <c1cd4d27-dce6-84d0-344d-86ff7223add8@gmail.com>
 <6a187694-654d-02f8-49fe-98704839de1f@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="FCF9ydJxlAJsfRTu"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <6a187694-654d-02f8-49fe-98704839de1f@opengridcomputing.com>
Sender: netdev-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>
Cc: David Ahern <dsahern@gmail.com>, netdev <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>
List-Id: linux-rdma@vger.kernel.org


--FCF9ydJxlAJsfRTu
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 26, 2018 at 09:23:46AM -0500, Steve Wise wrote:
>
>
> On 3/26/2018 9:03 AM, David Ahern wrote:
> > On 3/25/18 12:38 AM, Leon Romanovsky wrote:
> >> From: Leon Romanovsky <leonro@mellanox.com>
> >>
> >> In iproute2 package, the updates of UAPIs files are performed
> >> after the needed feature lands in kernel's net-next tree.
> >>
> >> Such development flow created delays to the rdma tool developers,
> >> who uses rdma-next tree as a basis for their work.
> >>
> >> Move RDMA UAPI file to be under rdma/ folder, so whole responsibility
> >> of syncing this file will be on them.
> >>
> >> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> >> ---
> >>  rdma/Makefile                                      | 1 +
> >>  {include =3D> rdma/include}/uapi/rdma/rdma_netlink.h | 0
> >>  2 files changed, 1 insertion(+)
> >>  rename {include =3D> rdma/include}/uapi/rdma/rdma_netlink.h (100%)
> > applied to iproute2-next
> >
>
> Hey Leon, so how do I change rdma/include/uapi/rdma_netlink.h now for my
> series [1]?=A0 Do I just make the changes?=A0 Or is there some other proc=
ess?

I don't think that we need "process" yet, simply copy from kernel.

>
> [1] https://www.spinics.net/lists/linux-rdma/msg61419.html
>
> Steve.

--FCF9ydJxlAJsfRTu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlq5KO0ACgkQ5GN7iDZy
WKdzQw//YnxK9OT5Hor1Lr1b53B21iiEqUxREkog0n2Ro7S1D4+7h3jauXOA9Mij
otqfVRy0NqEKyqytCztqT4JSVe0UF/GD4i1/TeOeVoNvxJ03VE8IOh6UaW8nUGN2
bCVJ+EPfvybv3OFgjvIyjJnpsrGH1glbT8CT2X4Yui8c1Ud7hTN8tdnIy/k47lCA
jsNkGu3YeUObo1Y9bad8brf/ynOPN/oN4uMBVOWmgsuwE+UCuT4Y2nhInRebdX6P
MHMoPGw8KQxr7PfJwOSJDNFaPbLPXLYPQEeIUYEGVaWF6JmW7B3nMt5hDj0MHjwF
Ct8H6fmzUiznNxPVqt91JkvePQYwOm4fITAhvjyoAw75sFbCOZsWHdcu+RsHkOqX
IEMHtFqPUWwV4he/I1cFebuohPMNgJIOeWaV6URretKIUDcFSJYA/qvESVCdYb58
zkny4ooBTXWAVcegDWamev9E5ftnwzTJ7t5340GrEJY3ZecJcthVV7NucSjjspoy
VlVoRTe2RQ7ZeQMY6OdmdfSCqJT89/beh0GeEG8drKbbD+tMKffNlJnpCqiQimT+
G8lA5zMIV0bN7TdGD2D3u9/qHsVMDfhrMWkTV9N45jY+xEvZ6tAk3rtsD0JuPQDY
zNH8zwj0TgPbVv+5ehiZkGKPMktFTbo1XZsnQ0RSAAy5H6A52rs=
=rAWD
-----END PGP SIGNATURE-----

--FCF9ydJxlAJsfRTu--
