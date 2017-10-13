From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 04/13] SoftiWarp object management
Date: Thu, 12 Oct 2017 21:01:28 -0400
Message-ID: <a82cc3b1-af27-c1de-afb1-a8edea4baed2@redhat.com>
References: <20171006122853.16310-1-bmt@zurich.ibm.com>
 <20171006122853.16310-5-bmt@zurich.ibm.com>
 <20171008122839.GS25829@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="uexwB9MIJm0xqE9ODBUmdk6PF47WH68KI"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171008122839.GS25829-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--uexwB9MIJm0xqE9ODBUmdk6PF47WH68KI
Content-Type: multipart/mixed; boundary="pKNpqK7IU5gIpO6it5EjuLpGXTgU4JGDf";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <a82cc3b1-af27-c1de-afb1-a8edea4baed2-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 04/13] SoftiWarp object management
References: <20171006122853.16310-1-bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
 <20171006122853.16310-5-bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
 <20171008122839.GS25829-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
In-Reply-To: <20171008122839.GS25829-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>

--pKNpqK7IU5gIpO6it5EjuLpGXTgU4JGDf
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 10/8/2017 8:28 AM, Leon Romanovsky wrote:
>> +	} else if (id =3D=3D -ENOSPC && pre_id !=3D 1) {
>> +		pre_id =3D 1;
>> +		goto again;
>> +	} else {
>> +		BUG_ON(id =3D=3D 0);
> No BUG_ON in new code.
>=20
>> +		dprint(DBG_OBJ|DBG_ON, "(OBJ??): IDR New Object failed!\n");
>> +	}
>> +	return id > 0 ? 0 : id;
>> +}

Not to mention that this segment displays why BUG_ON() is so bad.  You
have issued a BUG_ON() and then on the very next line you have a
dprint() as if there is anything else that happens after a BUG_ON().
There isn't.  By definition, with a BUG_ON(), you have killed the entire
machine.  You will never get to the dprint() line, it is completely
unreachable code.  Unless you run across something the likes of a
hardware device that is completely out of control, that is DMAing to
random address, and that you can't stop, BUG_ON is not an appropriate
solution.  You should only BUG_ON if continuing to run will render the
machine randomly corrupted and jeopardize writing that corruption to
disk and wiping the persistent system data out.  Short of that, you need
to find a way to gracefully handle the situation and continue.  It may
mean shutting your device down forcefully so that the rest of the
machine may live, but that's OK.  Shutting the entire machine down is not=
=2E

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--pKNpqK7IU5gIpO6it5EjuLpGXTgU4JGDf--

--uexwB9MIJm0xqE9ODBUmdk6PF47WH68KI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZ4BBoAAoJELgmozMOVy/dyPsQAJtWMrmol1UIDl9SO+1WqjHH
bWl3M9fjr/7heXTuLllqcsLcyazFx5ZWCIxFSjnPhQqHJAdqeXL4TKAxDP/t2t5r
kIetKgefkxyYdtGQqDICjK7QxZmPpr9MuYDcGMm2gfJbctTlWZv7j9cQcy9200lI
fZwo2mmWi0ZG5YCeHRw9BzgzHjILwEIg7bNE9PVlL1DHuwz1jTTDhHITuMv+tsrk
fRXTrCEcDq/za/eSp8bMDTCnRdNI0NJ2WiWhlrkUJ8alZi5fi+FISFfE7x7UN7an
BWHAhE7Fk6gorSgi2QPbUGIPDaulbUFTMR4UgUv+pJuYMeG+reK8NtbAp0IHBC1G
FFe51qas3Xze3pAG3xRh+Fn/k4m19ZetZNm1mpPUjq7pFtUz9uY1hN1ul/dFSEzC
WcJeXgBI/GtYOgX5zbCBOmra7wuIdHIk6mAz7rYsUtGF9Zf71HJZ0llsrr3Y9hWc
hYLqCdZVtB9uHHnpBGgf9ii1UDlzO977syNUVh7x7QAhZpSaq94dQ6Tc2vgEq4w8
35HJ9Q1hPgIDJ6VJcHKBmDT8EMzPz27z80Vcg7lmLxCk/UnpMwVy82aatSh2X9Rd
Rx2T6bVHuRlahIfcqn6mkIGyLD/OGrfjyb6mXeSFEbU/w0wXgnh7RuDMikOOG2IZ
kGmOaa2G3ZixyJp5yvnO
=LY9A
-----END PGP SIGNATURE-----

--uexwB9MIJm0xqE9ODBUmdk6PF47WH68KI--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
