From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH 1/2] IB/sysfs: fix NULL dereference
Date: Tue, 7 Jun 2016 07:48:03 -0400
Message-ID: <ac81a57f-c8ba-bcf8-b986-f852c01e34b2@redhat.com>
References: <1465157636-10120-1-git-send-email-sudipm.mukherjee@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="UIVmFtkphPSSfeNkqHN2DTPVH3cpjc0PF"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1465157636-10120-1-git-send-email-sudipm.mukherjee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--UIVmFtkphPSSfeNkqHN2DTPVH3cpjc0PF
Content-Type: multipart/mixed; boundary="1A00flpvg6xJfLIFSW8MG1B3rpn5Bg4rr"
From: Doug Ledford <dledford@redhat.com>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
 Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Message-ID: <ac81a57f-c8ba-bcf8-b986-f852c01e34b2@redhat.com>
Subject: Re: [PATCH 1/2] IB/sysfs: fix NULL dereference
References: <1465157636-10120-1-git-send-email-sudipm.mukherjee@gmail.com>
In-Reply-To: <1465157636-10120-1-git-send-email-sudipm.mukherjee@gmail.com>

--1A00flpvg6xJfLIFSW8MG1B3rpn5Bg4rr
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 6/5/2016 4:13 PM, Sudip Mukherjee wrote:
> If stats->names is NULL or stats->num_counters <=3D 0 we are jumping to=

> the error path where the for loop is freeing hsag->attrs[i]. But as i
> is initialized to 0 so i >=3D 0 will be true and the loop will execute
> once trying to free hsag->attrs[0]. But hsag is NULL still now leading
> to a NULL pointer dereference.
>=20
> Signed-off-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
> ---
>  drivers/infiniband/core/sysfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/=
sysfs.c
> index 5e573bb..fcf6f9c 100644
> --- a/drivers/infiniband/core/sysfs.c
> +++ b/drivers/infiniband/core/sysfs.c
> @@ -891,7 +891,7 @@ static void setup_hw_stats(struct ib_device *device=
, struct ib_port *port,
>  {
>  	struct attribute_group *hsag =3D NULL;
>  	struct rdma_hw_stats *stats;
> -	int i =3D 0, ret;
> +	int i =3D -1, ret;
> =20
>  	stats =3D device->alloc_hw_stats(device, port_num);
> =20
>=20

This issue was fixed in a different way and this patch is no longer
applicable.


--1A00flpvg6xJfLIFSW8MG1B3rpn5Bg4rr--

--UIVmFtkphPSSfeNkqHN2DTPVH3cpjc0PF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXVrRzAAoJELgmozMOVy/dwA8QALjJFF31Ilpb4uFn6pQwJnxf
CTKzNIGLkhccAWgOrhz1NNPR4QrC7eEL5EtDTVJzo5t0q7ZJHlavE5di967PLNth
1nA2vwWRe5KbyhmbM4GebjHxh7vFDarI87mULFgcJYmxbvpYqRO2T/haEsC6kdPw
8SNwVfGdjeEvLrNIBxUnJqwwF8zwUOgc69zfF6JlMKd6rWIH/vhh3/iPWHyT3amR
rumU+zfexRGv0IjUHL9pmGCBPs7EI9JC0or0flt2dOyBQa6XnDdGwiZkbQBmg28V
BvIjZph6katTTu91Y5I9TUvDIT5JxQ7FtV8lGpMz60zSmyECCAWaqm7HddWLCikJ
K/eOCmc97jJb1SteJcr8PuJqsOO5sVnxQfRFVZkTvZUTQwBL5K8h+OXDz5T0mUsV
tejtSzT35XZ56nHlpK3kmvV2tj4FaFPDehl9U3lNWfASFY2nroRLlVuZxBpZ5TFZ
WA17uIqxB2HUxVKIBBxsfyymx606uw/bT1s3SmHyFUkMibL8bfPliAjRDHdVIAVc
5GrJoXt+sVmGcE0aYmys/ljUfj5ayHOhrciA8TqUj3cqSZWtkM/gBaeA+aPUBie0
Wnn041NFMtEoaBgCO0dBn1jEstYFce5X91kZpTdYEZCpXB5XZZXWmt9n/rCULeCz
KytusBqj59K/Y7cDMBbT
=EF1d
-----END PGP SIGNATURE-----

--UIVmFtkphPSSfeNkqHN2DTPVH3cpjc0PF--
