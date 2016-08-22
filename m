From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V3] IB/hfi1: Allocate cpu mask on the heap to silence
 warning
Date: Mon, 22 Aug 2016 14:09:39 -0400
Message-ID: <3685350b-f56c-9784-ad43-084a223e9ad1@redhat.com>
References: <1470269972-11472-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="NavAgjtPnpnetQg28MlndviShkk93rimP"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1470269972-11472-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--NavAgjtPnpnetQg28MlndviShkk93rimP
Content-Type: multipart/mixed; boundary="HsFhjp4nqeS35QVv7OPPhBxTQ7Fm1r8Bn"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Message-ID: <3685350b-f56c-9784-ad43-084a223e9ad1-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V3] IB/hfi1: Allocate cpu mask on the heap to silence
 warning
References: <1470269972-11472-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
In-Reply-To: <1470269972-11472-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

--HsFhjp4nqeS35QVv7OPPhBxTQ7Fm1r8Bn
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 8/3/2016 8:19 PM, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> From: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> If CONFIG_FRAME_WARN is small (1K) and CONFIG_NR_CPUS big
> then a frame size warning is triggered during build.
> Allocate the cpu mask dynamically to silence the warning.
>=20
> Reviewed-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> ---
> Changes from V1:
> 	Return -ENOMEM if zalloc_cpumask_var fails
> Changes from V2:
> 	Remove internal commit message cruft
>=20
>  drivers/infiniband/hw/hfi1/affinity.c | 20 +++++++++++++-------
>  1 file changed, 13 insertions(+), 7 deletions(-)

Thanks, applied.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--HsFhjp4nqeS35QVv7OPPhBxTQ7Fm1r8Bn--

--NavAgjtPnpnetQg28MlndviShkk93rimP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXuz/jAAoJELgmozMOVy/d9usP/27olC/Ylb2DeSWMnvDKlioI
TDzkNHQW6xy4op6sQwy8naOD3Zwge3nZK3ETiWHm6wpqWwfjmnhSo2KjuU/Sxcmq
Vr6qqjT5ARHZOb1huzX7W28zaswx3fWunVqIeha0W5BTvGt3yMpYk7Z6Xn06c/Mm
CUhcOTSAd9xh6vsZWq4zhPvIojUBX9WddX+WtQTkspqvjMUAfWqk+QFURqc9bBFu
osa69NUlGTDTSBqwYFfJg3KinrBK75Dmq+x1dJwUdCMHZaWqjcgOP9yB+GBYBsdV
eOH1kPIBi87/wXPJKQwVBAR/2pooX03dope/J8QObMXYKBvJJ1gVwzJw9yP7MPkv
CRCLDvnZObFcFffT4NT5aRThz4T9/UhoPGGH9iOpZd5BmKz19bM5Lkatbju5R55m
VxsuWQF3va7W0w+F6IXaFsfAtiWdKg9M2NiWKsD2wLnW32OCA/cHeD7BhgK8yqTT
0ggDcIZ6PfzjN2EmMQh5qzx9qlCdpjEpGsnM/q9KecowRm7wlNI4Rg92zOl5OoSK
edHDKQ3EcDgubvOCp9/DAvI9wfF/6nG5BquqmFLpH/HLBlAb61qO1fSSXtBpvkCp
dH6tL5GmqBAH4SDxbl+NfpW6zTVc6+mbt63WMSh7JTwenqDlrZZi4nUsAhl64xwx
eQggVn2acyFL1ZpGXF8f
=NzUU
-----END PGP SIGNATURE-----

--NavAgjtPnpnetQg28MlndviShkk93rimP--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
