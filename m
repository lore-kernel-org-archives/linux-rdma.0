From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH, RFC] mlx4_ib: Make steering support independent of
 MLX4_BMME_FLAG_TYPE_2_WIN
Date: Thu, 2 Jun 2016 11:18:19 +0300
Message-ID: <20160602081819.GJ7477@leon.nu>
References: <2a929a48-559e-41ad-c42e-a722801c11d0@sandisk.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W/D3X8sky0X3AmG5"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2a929a48-559e-41ad-c42e-a722801c11d0-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--W/D3X8sky0X3AmG5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 01, 2016 at 05:07:17PM -0700, Bart Van Assche wrote:
> Hello,
>=20
> Can anyone who is familiar with the mlx4 driver tell me whether or not
> the patch below makes sense? I ran into this code by analyzing the mlx4
> source code with smatch.

Hi Bart,
Thank you bringing it to our attention. I had a fast chit-chat with
Matan who was the last person who touched that area. It looks like an
unharmful issue with the code, because we had support for memory window
feature literally forever.

Thanks.

>=20
> Thanks,
>=20
> Bart.
>=20
> ---
>  drivers/infiniband/hw/mlx4/main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/ml=
x4/main.c
> index b01ef6e..db7d0bc 100644
> --- a/drivers/infiniband/hw/mlx4/main.c
> +++ b/drivers/infiniband/hw/mlx4/main.c
> @@ -505,9 +505,9 @@ static int mlx4_ib_query_device(struct ib_device *ibd=
ev,
>  			props->device_cap_flags |=3D IB_DEVICE_MEM_WINDOW_TYPE_2B;
>  		else
>  			props->device_cap_flags |=3D IB_DEVICE_MEM_WINDOW_TYPE_2A;
> +	}
>  	if (dev->steering_support =3D=3D  MLX4_STEERING_MODE_DEVICE_MANAGED)
>  		props->device_cap_flags |=3D IB_DEVICE_MANAGED_FLOW_STEERING;
> -	}
> =20
>  	props->device_cap_flags |=3D IB_DEVICE_RAW_IP_CSUM;
> =20
> --=20
> 2.8.3
>=20

--W/D3X8sky0X3AmG5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXT+vLAAoJEORje4g2clin5QAP/A2nqpWmVKbcZThAafrLvOPT
pxHRST+hg8gvj2hHJVNHOpp7/yDOBRJ4xBW44rycguWv7Fpzp7NLdxIyupld49XN
3BGRoZ+eLqXUBINIzu4ChwebaZzQa6WvzaPFnSepC3fGvIXAkhkuftjJgg/2VDgT
tb1W1r+5IxXzs/xUfOnXIoCHCZ0K2uH/EKXPxLmErZoPRjiL1Vt6FedZX4bwuZ+8
lbMrOLAqNKb6xLRNT+lMCpkElaCLIfsEFXh2NNya/E8U8SWUe+mfQLUrI5Hoba+w
cFiMYGiZviaJsafmJyJBFzIlqHjka9uFQOaB7ilmMZ+dT8yYGnyOq1/uoMBIFMDW
g0PnuNRVkOwBDMFXollO2Aio+gG1/t9NXOINlyoFAqyXs7/YVbPWEQFEqYRVDN2J
k3dDrW1F0d37E8cLhw2Z36yG8+KuRXXQaklgynZ/GyvYagHDOsVeM67SlEYd1Pvg
Q1l9xrprnu4Yx0AhcuLPBfCOCBbwMXZuHF5QGJ42k6uBMb/qRcmljeXB6aSFPN8k
aEGBzyU0bB6OdHprwTwXME4DKPeWdPQQa2JFU7/MFigUCt9lFr7g8BnB66wVS043
XxddfjysDQMnYDgRYe7fB8L1HloONYntXzDwhcXux+XKYWD4kvXnPbP65tKfafKS
FU1Xyi8g8/Pfjnk7aN8I
=Nk9J
-----END PGP SIGNATURE-----

--W/D3X8sky0X3AmG5--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
