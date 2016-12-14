From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] IB/core: fix unmap_sg argument
Date: Wed, 14 Dec 2016 14:21:55 -0500
Message-ID: <eef9a03e-33c1-814c-e005-e135c17b7d78@redhat.com>
References: <alpine.LFD.2.20.1612021439450.3570@schleppi>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="R5r8N6bLcccHEaUBA5KTDV1t63SbMthSF"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.20.1612021439450.3570@schleppi>
Sender: linux-kernel-owner@vger.kernel.org
To: Sebastian Ott <sebott@linux.vnet.ibm.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--R5r8N6bLcccHEaUBA5KTDV1t63SbMthSF
Content-Type: multipart/mixed; boundary="wWf1SrCctQ0pDCaCE8IIswGEji7eNTMff";
 protected-headers="v1"
From: Doug Ledford <dledford@redhat.com>
To: Sebastian Ott <sebott@linux.vnet.ibm.com>,
 Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <eef9a03e-33c1-814c-e005-e135c17b7d78@redhat.com>
Subject: Re: [PATCH] IB/core: fix unmap_sg argument
References: <alpine.LFD.2.20.1612021439450.3570@schleppi>
In-Reply-To: <alpine.LFD.2.20.1612021439450.3570@schleppi>

--wWf1SrCctQ0pDCaCE8IIswGEji7eNTMff
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/2/2016 8:45 AM, Sebastian Ott wrote:

> __ib_umem_release calls dma_unmap_sg with a different number of
> sg_entries than ib_umem_get uses for dma_map_sg. This might cause
> trouble for implementations that merge sglist entries and results
> in the following dma debug complaint:
>=20
> DMA-API: device driver frees DMA sg list with different entry
>          count [map count=3D2] [unmap count=3D1]
>=20
> Fix it by using the correct value.
>=20
> Signed-off-by: Sebastian Ott <sebott@linux.vnet.ibm.com>
> ---
>  drivers/infiniband/core/umem.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/u=
mem.c
> index 84b4eff..1e62a5f 100644
> --- a/drivers/infiniband/core/umem.c
> +++ b/drivers/infiniband/core/umem.c
> @@ -51,7 +51,7 @@ static void __ib_umem_release(struct ib_device *dev, =
struct ib_umem *umem, int d
> =20
>  	if (umem->nmap > 0)
>  		ib_dma_unmap_sg(dev, umem->sg_head.sgl,
> -				umem->nmap,
> +				umem->npages,
>  				DMA_BIDIRECTIONAL);
> =20
>  	for_each_sg(umem->sg_head.sgl, sg, umem->npages, i) {
>=20

Thanks, applied.

--=20
Doug Ledford <dledford@redhat.com>
    GPG Key ID: 0E572FDD


--wWf1SrCctQ0pDCaCE8IIswGEji7eNTMff--

--R5r8N6bLcccHEaUBA5KTDV1t63SbMthSF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYUZvTAAoJELgmozMOVy/dbEYQALOZpdiUucpo9tL7DMLfwewH
TPWGZN71vQpZW46K3TF1LwJfDn1/tzvHnVR9z6fJJwofdscJOlTsBfncNkhQJKcm
w07gxu5NRVbZSpUjIVD6DDKbsvoXZQEtAO4FtHgB1ZqZ2H5QMTqFRCH83nY7u6hP
d962f/Vf1xUztI59iggvfqHKzhZOwKzffAa/igzMEDesM1zsPfWwO028vIy8YHwZ
4COUqDVqWKMIENL4A9oGPktgNd/bUyYawvSBFJhWVvz1cg8nr8qVfVONfvBepSTc
Dq7MviCDTwSGZzQsYXajdJTPVid2ZZpvpyrTc1d5Px3kahH7idKgPu/HbNr9WxQV
ryn4UDmxoI3r4DoxjSuGGsAq3n7h85hys6e3EysizcNv+G/73PnDGMCOSHe3UJGO
4tTUSVrr2raG/b8HEuRky9ggcmtBnByqqSkypzISSIzKXqqZjCPzX7FjNHZen4hi
30iXsZJhEBbFyHVcQZVKMo3sfxwHshGuuzLdarVKBxZkpvannvypwQ56vm1axRwi
/VQwQZUpOsd4QTFAeuKr+1XBYUI2iyEfGKP/TaPFxU2dNB9cPNJpOf57HX0BRh3q
D+yten1cqjG9nxr6ysGINc5oCPyOEdjERUn0Z8cHtqwC+34iwPKctx5xwrjynjh2
lTfiIILY3bqO3HxIX+Os
=R0IC
-----END PGP SIGNATURE-----

--R5r8N6bLcccHEaUBA5KTDV1t63SbMthSF--
