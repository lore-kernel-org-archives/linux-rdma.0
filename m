From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next V3 0/8] Add completion timestamping support
Date: Fri, 12 Jun 2015 15:53:08 -0400
Message-ID: <557B38A4.9080901@redhat.com>
References: <1434029727-6062-1-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="xT2K3hSpfwXVjBUOShU7JvrBq4BIX15cm"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1434029727-6062-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--xT2K3hSpfwXVjBUOShU7JvrBq4BIX15cm
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 06/11/2015 09:35 AM, Or Gerlitz wrote:
> Hi Doug,
>=20
> This patchset adds the kernel control path for completion timestamping =

> support by user-space verbs consumers.=20
>=20
> Timestamping is used by applications in order to know when a WQE was=20
> received/transmitted by the HW. The value is given is HCA hardware cycl=
es,
> but could be easily converted as the hardware's core clock frequecny is=
=20
> available through extension of query device.=20
>=20
> Moreover, we add an ability to read the HCA's current clock. This could=
 be=20
> useful on order to synchronize events to the wall clock.
>=20
> This functionality is achieved by adding/extending the following verbs:=

>=20
> create_cq - create_cq is extended in order to allow passing creation fl=
ags
> to the CQ creation function. We change IB/core --> vendors API
> to be easily extendible by passing a struct which contains
> comp_vectors, cqe and the new flags parameter. In order to create
> CQ which supports timestamping, IB_CQ_FLAGS_TIMESTAMP_COMPLETION should=
 be given.
>=20
> query_device - We extend query_device uverb further by giving the hardw=
are's
> clock frequency and the timestamp mask (the number of timestamp
> bits which are supported). If timestamp isn't supported, 0 is returned.=

>=20
> In order to read the timestamp in the WQE, the user needs to query the =
device=20
> for support, create an appropriate CQ (using the extanded uverb with
> IB_CQ_FLAGS_TIMESTAMP_COMPLETION) and poll the CQ with an extended poll=
_cq verb (currently,
> only implemented in user-space).
>=20
> In mlx4, allowing the user to read the core clock efficiently involves =
mapping
> this area of the hardware to user-space (being done by using a mmap com=
mand)
> and reading the clock from the correct offset of the page.=20
>=20
> This offset is returned in the vendor's specific data from mlx4's kerne=
l driver=20
> to the mlx4's user-space driver. query_device is modified in order to s=
upport
> passing this vendor specific data. A user-space application could use a=
 new
> verb in order to read the hardware's clock.
>=20
> Translating the hardware's clock into ms could be done by dividing this=

> value by hca_core_clock (which is returned by the extended version of
> query_device uverb).
>=20
> The below V2 --> V3 changes address the review comments on the kernel b=
its.=20
>=20
> Jason had another comment calling for re-thinking / questioning the=20
> need for a dedicated uverbs_ex_cmd_mask in the IB device. This goes=20
> beyond the scope of this specific series.=20
>=20
> Matan and Or.
>=20
> Changes from V2:
>  (1) Use KHZ for hca_core_clock
>  (2) ib_create_cq gets const cq_attr
>  (3  use {} initialization instead of memset
>  (4) squashed last two mlx4 patches
>=20
> Changes from V1:
>  (1) fixed lustre IB's code build
>  (2) squashed mlx4 V1 9-11 patches into one
>  (3) changed IB_CQ_FLAGS_TIMESTAMP --> IB_CQ_FLAGS_TIMESTAMP_COMPLETION=

>=20
> Changes from V0:
> (1) Pass ib_cq_init_attr instead of cqe and comp_vector.
> (2) Fix unneeded indentation.
> (3) Change flags to u32.
> (4) Add const to create_cq's ib_cq_init_attr argument in vendor impleme=
ntation.

I've pulled this series in for 4.2.  However, I forgot to add the extra
reviewed-by tags before it was tagged, signed, and pushed to k.o.  My
apologies for that.



--xT2K3hSpfwXVjBUOShU7JvrBq4BIX15cm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVezikAAoJELgmozMOVy/dXsIQAMC8ei3MYqLWB/uGHpc8PA6u
er9OM5VcNm2IHlKggMjm9l2GAbsATSm2J9AJBjNk3sljkzyhtIRBVw2W0bB0yeh3
Bn0axBQSzL37D3HQ0rq+91uCcpzQiY2jlGISyTwkqclsZfAFKem3tVxRc6YwghLZ
ig1jUMMp68/CBJhPSkiWWn4axb9xRF1KUgBBUxHUAfou5X1/+xQFSEwDPHXwWS2w
N5+o180L++uGXbEy+nhsWD7qBTeN0+mR6vBGjdn6drHSwrWfUPiIsreEgxN+irtK
Oa5a1fi/X5llsYsgUfR1vdVewzHc9Aqm27L011BD8vIfQliKy4eoBITAyGqC8Sex
1ggC0vwXEar3zgg/2B4x7lXPXwvs1uwu0lpyU77yUZakv05s42CAFqtL50Yl94BZ
wIIIf0EIaORR8m/Y9zrzwUl2pV2Tkwdt+F6wbIplukGMoPfw3XnKvsL5xPP0XedI
PpIo98F2KAt/45qo+6NmAbLbgt4UyStkAmh8NoeQ8jU+kXawOLnNgiJ1sPydUkI3
e8t92tUBCKvT29i1R084nYJAC4XJY8Szlp7ZtwYcIQ2wPddCu7n33IGyVTrTMqbg
uGlGadzyAAUBb7EtxF4OYbuVH5Vt8CI0HYCdvkHj72ip5E6yWDHoAxwjeXN3iaNR
fVRxjz0WMy0SFEj3vR8t
=ehEU
-----END PGP SIGNATURE-----

--xT2K3hSpfwXVjBUOShU7JvrBq4BIX15cm--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
