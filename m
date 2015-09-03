From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch] IB/core: off by one in error handling
Date: Thu, 3 Sep 2015 13:39:57 -0400
Message-ID: <55E885ED.9080804@redhat.com>
References: <20150818092317.GF3965@mwanda>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="iLWoEsLXxUWsE9o6u3afESOMvAX0e7PTE"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150818092317.GF3965@mwanda>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--iLWoEsLXxUWsE9o6u3afESOMvAX0e7PTE
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 08/18/2015 05:23 AM, Dan Carpenter wrote:
> This is a zero offset array.  The current code could try to free random=

> memory and crash.  Also it leaks the first element.
>=20
> Fixes: 230145ff8124 ('IB/core: Add RoCE GID table management')
> Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

This one, however, was not needed after Matan's fixup series was applied.=


> diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/=
cache.c
> index a9d5c70..f5d14a7 100644
> --- a/drivers/infiniband/core/cache.c
> +++ b/drivers/infiniband/core/cache.c
> @@ -582,7 +582,7 @@ static int _gid_table_setup_one(struct ib_device *i=
b_dev)
>  	return 0;
> =20
>  rollback_table_setup:
> -	for (port =3D 1; port <=3D ib_dev->phys_port_cnt; port++)
> +	for (port =3D 0; port < ib_dev->phys_port_cnt; port++)
>  		free_gid_table(ib_dev, port, table[port]);
> =20
>  	kfree(table);
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--iLWoEsLXxUWsE9o6u3afESOMvAX0e7PTE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV6IXtAAoJELgmozMOVy/dtPoQAI255yyPWI/zlBoW4anh+LAc
73XODsamKn/yVGSuf51QZPdvGVpAAo4O+WSUudezNPC+S5hMqbsdYAqDeZDhWuVf
axVoH2Pu9qot/U25R0lz9HdR8qVkUkfUPlW9J7Z+s3rjcXhls7zS+8mRGKl10KYn
uPAMm1X4+mg0RbfzMCksI9HC3AATH1pcq1KBP3yG4o90bvCyG7d60U1xUTclIP5F
WttJwjcfYqjcAabW1ruPOsd58kcnsaX7tm8g+ppoSjRjtw471Pjk9anb4k4ioUl3
o6jD+c+/YIp07LB8vNmnq2bTV607Vzav+2hzERqaTjnAAF1AsXN12GwPgNA9yG1U
u6MF96puSLpn/VAAiAS1GqPZmCPXUcMI6DtGTXItoLM3APCkldSQ1XBTUMSLRm+6
GEQ/LEvWN3zOhQHrR94jJG8eMea03pcYwEXZKLXgOg8A9YzdEE9fudhzNXuiAqle
+Uj3x/iA81XPa+rMyU/XYyslNjPuvJ8LGiJC6oAfZPxyiEwBIH1fSIxyTpV4VKTj
Er3pdnyXaxEyJa90AKTMTs1vbQoQ8X7TUW8zWAdG2l/DtDYKNpIAgsN3/+7vqR3y
eGZtw22xr5zAbEG2McRUR+UJOYkT8P+H10A9LETGHw+gGL4GEc49UCyqMl9QupD1
Vg6qW7UuczyiRdGzr5rK
=bMQS
-----END PGP SIGNATURE-----

--iLWoEsLXxUWsE9o6u3afESOMvAX0e7PTE--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
