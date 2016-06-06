From: Doug Ledford <dledford@redhat.com>
Subject: Re: [patch] IB/hfi1: fix some indenting
Date: Mon, 6 Jun 2016 19:15:25 -0400
Message-ID: <68978678-a002-3a9f-dcde-a0617941248f@redhat.com>
References: <20160528050120.GB4107@mwanda>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="FHnOf75CPCqgXfGJqOsPCmiJWQxDLAoSA"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160528050120.GB4107@mwanda>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>
Cc: Dennis Dalessandro <dennis.dalessandro@intel.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--FHnOf75CPCqgXfGJqOsPCmiJWQxDLAoSA
Content-Type: multipart/mixed; boundary="dtT6oIAlkmP3IKsW3xxhPCLBq61t31nFD"
From: Doug Ledford <dledford@redhat.com>
To: Dan Carpenter <dan.carpenter@oracle.com>,
 Mike Marciniszyn <mike.marciniszyn@intel.com>
Cc: Dennis Dalessandro <dennis.dalessandro@intel.com>,
 Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock
 <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Message-ID: <68978678-a002-3a9f-dcde-a0617941248f@redhat.com>
Subject: Re: [patch] IB/hfi1: fix some indenting
References: <20160528050120.GB4107@mwanda>
In-Reply-To: <20160528050120.GB4107@mwanda>

--dtT6oIAlkmP3IKsW3xxhPCLBq61t31nFD
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 5/28/2016 1:01 AM, Dan Carpenter wrote:
> That extra tabs are misleading.
>=20
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>=20
> diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/=
hfi1/init.c
> index 5cc492e..0d28a5a 100644
> --- a/drivers/infiniband/hw/hfi1/init.c
> +++ b/drivers/infiniband/hw/hfi1/init.c
> @@ -1337,7 +1337,7 @@ static void cleanup_device_data(struct hfi1_devda=
ta *dd)
>  		dma_free_coherent(&dd->pcidev->dev, sizeof(u64),
>  				  (void *)dd->rcvhdrtail_dummy_kvaddr,
>  				  dd->rcvhdrtail_dummy_physaddr);
> -				  dd->rcvhdrtail_dummy_kvaddr =3D NULL;
> +		dd->rcvhdrtail_dummy_kvaddr =3D NULL;
>  	}
> =20
>  	for (ctxt =3D 0; tmp && ctxt < dd->num_rcv_contexts; ctxt++) {
>=20

Thanks, applied.


--dtT6oIAlkmP3IKsW3xxhPCLBq61t31nFD--

--FHnOf75CPCqgXfGJqOsPCmiJWQxDLAoSA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXVgQNAAoJELgmozMOVy/dZAwP/0V9vLCtRLhUtG3CldmsIoid
WwjUPcCxoMBkT68eieTwS+0sJD8HLDBmHf97VzKAxEdGMvkeSZdL6mKiSiulhT4y
RDcgb/gM9H46wP3XlWIZnesoUg39E3xvfGdO20GYJmnVxoojGSTe+OKWXgylhce8
V1rdiy8plnnJZvW2DCuQLlzRznziMPapqVx/GKtAGZutjsPcAzlbFdrRn+8RbssW
++CN4bvYqYc1Sa+KGi2VnPvvWBcsIuG5BUUBV5l0i06DpXREGmSxJ+Axre6gx7im
X5wt8Y1QYhf9t1UnZ1F0EkpmQMnSZc8fWdtrfv24+VPQbaZCQqeZ++s9r2+qMB5T
DFT2utKxTo/wiDhzpa2mR5rIvzQODPAQT3tDcgpalW+JLViyZW3sePS8AsR1CA2u
9KP3D6U97dHWceeKPCamd3jEPD1JeswQIkZQSvI1GoSiHEuQy4UofkZdBSSYi1gX
znrDj8mx9Xgi60swoJbnf1pQFa9IhPlqT0oo6sdxkD5l4u0Darrsh86wFDaFEZF+
n8BcoVvl3K9baV6lm5Qpx+/SD6zAi+T/QXFWjs6X6XYq+Aaay9KqGOXcQGgrauVK
m02+GLFnSJzUezXXMmXdKgGdAiHcYPncV0vUxeOUP+QQxvIUdopfsisG3vtcKQXG
9GuTJbhp5boI4Ieq9wNd
=3bsN
-----END PGP SIGNATURE-----

--FHnOf75CPCqgXfGJqOsPCmiJWQxDLAoSA--
