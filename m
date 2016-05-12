From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Could use some help getting SIW compiling on latest kernels
Date: Thu, 12 May 2016 15:08:24 -0400
Message-ID: <76dbb62f-71f8-d348-2847-702a19ed32c7@redhat.com>
References: <CAANLjFpmhtdfBsVCwAsLkmOx-mmTv9fb4u9VMM7ps3_c50s53Q@mail.gmail.com>
 <CAANLjFrhNathEQViOTePpjphWLqaXLTjPu=XrUiM3GAyD9yktA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="oFX6QE4JSEdRJ6MD4fGHSM9ahkFGED3HD"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAANLjFrhNathEQViOTePpjphWLqaXLTjPu=XrUiM3GAyD9yktA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--oFX6QE4JSEdRJ6MD4fGHSM9ahkFGED3HD
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 05/10/2016 06:30 PM, Robert LeBlanc wrote:
> I've figured out the error for the stack trace. Apparently iWARP
> doesn't need/use MADs and removing
>=20
> immutable->max_mad_size =3D IB_MGMT_MAD_SIZE;
>=20
> fixes it. I still don't get a device to show up with ibv_devices so I
> have some more digging to do. This is a minimal VM, so I could just be
> missing some libraries or something.

I wouldn't expect ibv_devices to show your device.  There is no user
space library I assume.  Is there even a /dev/infiniband/uverbs0 file
for the device?

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--oFX6QE4JSEdRJ6MD4fGHSM9ahkFGED3HD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXNNSoAAoJELgmozMOVy/dcA4QAIJamT94E9sKxVGJJXgURXPM
iiHPRJpjiWpo3Ryf4luGeDmVywT9uSfeoFjRTglbDUnfqNlkxwFfVmK7NcNMpk69
BJZFyZ81MZsNLnRyCm8AqH48ZFA24o4bSVblEYlocYz4o2/Qo2qEqOHUep7Q0zh/
8KqVYk+yLCsTfoTf17+qHil6ylF2hqxQXN28o5BLpymNIQyjjHROoRWhDu/q//ag
NvIBWFstI9WYLyXuDwJPVeJalnzBRVQNXmjvqbQdBm2JZdJtqsPZbE11L0dpQmTY
Kha1d89hcElhw0Eku94/LoYVbwFuvx0Mo/E6EdScJPiF+3qIZjKoyCt54Ob3h7Qt
JYmZXYktrjCaigDVLrudN6wv4UZQV6XPxtKqtTkRixrLd2cXBR/C4/O7bYljtNDU
T7B4vqHIqO4GJVYvQ2ylWrgfxeL80WhwnR3jMdw3XuiC5nUjyW/+J/Bbr51L2V+W
qd5inytz33y/uy3iotrCNVqFIS4LKxxXOUx10otKDpGTB6UnQqry2rKfj0+5JLvb
9xXdVxnf6hSV8C/t1T0iMs6WP7o6zsW8xNc3IdIo596mYF7djsOTjLcZgl+vpVcX
cnqqz7pf1wKB/lFZzDmxlHio5AUTM1ek4sjY7IBJXhxpXYOj1XO7rUQZIgabkqdk
Mc5U/oFCWg5auKnPXCa8
=1+Qc
-----END PGP SIGNATURE-----

--oFX6QE4JSEdRJ6MD4fGHSM9ahkFGED3HD--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
