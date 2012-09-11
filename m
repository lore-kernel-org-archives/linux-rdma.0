From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next V2 03/22] IB/core: Add ib_find_exact_cached_pkey()
 to search for 16-bit pkey match
Date: Tue, 11 Sep 2012 13:12:27 -0400
Message-ID: <504F70FB.6030806@redhat.com>
References: <1343983258-6268-1-git-send-email-jackm@dev.mellanox.co.il> <1343983258-6268-4-git-send-email-jackm@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigEF2AC6BB70CABE8B1ABA5E98"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1343983258-6268-4-git-send-email-jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Mascarenhas, Edward" <edward.mascarenhas-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigEF2AC6BB70CABE8B1ABA5E98
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 8/3/2012 4:40 AM, Jack Morgenstein wrote:
> When port pkey table potentially contains both full and partial
> membership copies for the same pkey, we need a function to find
> the exact (16-bit) pkey index.
>=20
> This is particularly necessary when the master forwards QP1 MADS
> sent by guests.  If the guest has sent the MAD with a limited
> membership pkey, we wish to forward the MAD using the same limited
> membership pkey.  Since master may have both the limited and
> the full member pkeys in its table, we must make sure to retrieve
> the limited membership pkey in this case.
>=20
> This requires the 16-bit pkey lookup function (which includes the
> membership bit).

As a second note, I would like to know why Intel (previously QLogic)
does not use these functions in their driver and what it would take to
get all drivers to use the functions.  Do we need to add more to them?
In my opinion these should be generally useful and used by all drivers.
 Mike?

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enigEF2AC6BB70CABE8B1ABA5E98
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iQIcBAEBAgAGBQJQT3D7AAoJELgmozMOVy/d98MP/3KWD4SGT3zkJqjMP1o3I2Lj
zkF3FqJakH2mVtt6HoqN03/Q2jSp9d73PK92elji37uHzku53dkYKtjIVtDvbuLD
FF90BUXNFA66aJnA5xqnng0nk090fGCF6k0Qy+0fcJcBCM7inpnW4cAHq2otSz6k
fP35w5WaXYNfvpMFiNPTpw3R5QlLdGY/ipO9aBnqj+nNFTJK6LVp4AFO3lGRr+jh
yF9+6LGzuQoGTdIab5bpjSccYDnYKd2QWG9iSy1FzIbVW9KLCAwsh47urDtd//qQ
WoTTohvq6vnSSScssvLH6sHjc/jbxxj/f9mODO1shtVKql6GSq41uaI7+/Mj0SWX
k00vaMLSqnO2/UXUxi79O4a6o5hI5G3q/MaQ2Ey3WbTxDkeNorZz2ujQieEd7gfz
ALyJJ3sNJmspy3SRrDC5+iFFpnEBI4T5dPITa/zhdcID3Mpcx/z3QhAb2LVyubfc
V5NQhIj9HT+nFJL7WoSaf+SZSxSgmH6J773/l/AJcRFokn6d4hwFcjmNeblGj1FW
tKZgbMHNcaQCli8AgaL3ybfkrMQRvQxjSKeqJZI7AJdHId4VxmzaGKpWmZUWeb8j
dL98I28RsLG9rbZNAwcoyO6JrstMEmZSbvLpvCazboqWCOTuF1ALI+j0RFgKWnfS
ef6g4k9GnhVzNKAsr2oz
=VJar
-----END PGP SIGNATURE-----

--------------enigEF2AC6BB70CABE8B1ABA5E98--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
