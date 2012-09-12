From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next V2 02/22] IB/core: change pkey table lookups
 to support full and partial membership for the same pkey
Date: Wed, 12 Sep 2012 12:48:29 -0400
Message-ID: <5050BCDD.50106@redhat.com>
References: <1343983258-6268-1-git-send-email-jackm@dev.mellanox.co.il> <1343983258-6268-3-git-send-email-jackm@dev.mellanox.co.il> <504F6C4F.6050207@redhat.com> <201209121056.00309.jackm@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD05BC0DCFEAD292059DADFA2"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201209121056.00309.jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD05BC0DCFEAD292059DADFA2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

On 09/12/2012 03:56 AM, Jack Morgenstein wrote:
> On the Hypervisor, however, we assume that if both versions of the pkey=
 are in its pkey table,
> then for its own infiniband operation (as opposed to performing its pke=
y virtualizing function),
> it should operate with the highest membership type in its table for a g=
iven 15-bit pkey.

That's what I was looking for.  So, how can you know this assumption is
correct?  It seems to me that if someone wanted to restrict membership
of the hypervisor as part of a security lockdown, then give full
membership to a guest because that guest is some high security, single
task guest, then this assumption would break things (the user would be
able to assign the full membership key to the guest OK, but regardless
of how they wanted the hypervisor to be subscribed to that particular
pkey, it would always get the full membership from the guest).

>> Shouldn't we pick the
>> pkey that's appropriate for the vHCA sending the message?
>=20
> We do. When QPs on the guests are created, the modify-qp commands are n=
ot executed on the guest,
> but rather are passed to the PPF for processing. The PPF replaces the g=
uest-provided virtual pkey-index
> value with the appropriate physical pkey-index value.  See procedure "u=
pdate_pkey_index" in file
> resource_tracker.c, and all the places it is called (i.e., in the wrapp=
er functions for the various
> modify-qp firmware commands).

That's fine for the guest, but I don't see how this solves the
assumption issue.  My concern is that I could see a valid scenario that
a user might want to implement for security reasons that I think makes
your assumption above incorrect.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford



--------------enigD05BC0DCFEAD292059DADFA2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iQIcBAEBAgAGBQJQULzdAAoJELgmozMOVy/dpj4P/0qm1/ohfhNOhRU2h+igaIX7
SHPbnuoHI5Y8XV7Imd8fB/ajthFDzK2CmLDAZnoLMt2iNY6VBUX+x1wA4GACwoyS
Gi96WvanPO+86uIB9ZBYVWlFOe1dCbsvc2cRQg79AWXTq6tC+dJHg1nm1St/ZIlu
+jgWW883pWfEqrfeXPmPGctUFYEKLmg2ri0cr6e7SCW8w3/tmxjgsolAbzgC0G2n
M9KGjlrK99zq4FOQn+l2CQklNoGo19H/xqDCi+R/eU4RTMkR3Z/TbhQxX74phXMC
1PisUBrTQxufwrP4GrsBki0Suk1bZ5WJ2x/HYcA0142aKFzHJ1kQsbeD0nkGAi9v
nQtrE06g6P3ZFgvTTk+w7SsMuIj269ETMQy5CBHY+TyUD5cPv/QiTk96UgQ19996
kmEOwZxdDqvlmIyPRNlBHH4S1bwHh/l+urAHATOUbxZPBxkYWVZKMSqwMpBGgctJ
NhmoZ1sgbqHbliMXRoTqP4xoose5McFr3s/FbFO/7kEFh3q96L1kAAC3F1oPaLaF
wuDw/8jNPXQBty+++9bXAtClR0mtuN94SPoOxgNzJMndcTQBmt8DKHCS9Y9JKkR8
ftibFxMlYwDHo5w/HIUHefLa3zK93ChFDLti4XRFqtWqf7FwlqbVR6WsQi6EW3o/
+ex1uND+Du4nFtidH1oD
=uWG4
-----END PGP SIGNATURE-----

--------------enigD05BC0DCFEAD292059DADFA2--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
