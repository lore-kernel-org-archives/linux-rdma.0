From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Fwd: Re: [PATCH] IB/core: Make device counter infrastructure dynamic
Date: Thu, 19 May 2016 23:15:45 -0400
Message-ID: <490a5365-ce89-f4a5-3547-32c37757da1d@redhat.com>
References: <fb1272e0-8c87-e51a-2220-5fdde598311f@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="puNMic3gx1wE6CLCgrt5wxQBUkFhDHgIU"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <fb1272e0-8c87-e51a-2220-5fdde598311f-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--puNMic3gx1wE6CLCgrt5wxQBUkFhDHgIU
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Reply-all didn't include the list for some reason :-/


-------- Forwarded Message --------
Subject: Re: [PATCH] IB/core: Make device counter infrastructure dynamic
Date: Thu, 19 May 2016 18:13:22 -0400
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Organization: Red Hat, Inc.
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
CC: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Mark
Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

On 05/19/2016 05:50 PM, Jason Gunthorpe wrote:
> On Thu, May 19, 2016 at 05:35:13PM -0400, Doug Ledford wrote:
>=20
>> +	return sprintf(buf, "%d msecs (rounded from jiffies), 0-10000 allowe=
d "
>> +		       "range\n", msecs);
>=20
> sysfs files should not have usage commentary like that, just use the
> %d

I had that originally, and I'll pull this out when the stuff is
documented somewhere else (either in the code or Documentation).

>> +char *names[] =3D {
>=20
> static const char * const names[] =3D {
>=20
> For Kees

Fixed (in all places)

>> +	[NR_COUNTERS] =3D NULL
>=20
> Don't really need this, just use ARRAY_SIZE(names) in place of
> NR_COUTNERS

The original code required a NULL terminated array.  Given that the attr
array requires a NULL terminated array, and these are used to set that
up, I'm not sure I mind burning an extra NULL for the semantic match,
even though it's no longer necessary.

>> +       stats =3D kzalloc(sizeof(*stats) + NR_COUNTERS * sizeof(u64), =
GFP_KERNEL);
>=20
> People have been switching the above pattern to use kcalloc

Read the above again.  It allocates one copy of the stats struct and
then NR_COUNTERS elements of u64.  Unless I'm misreading kcalloc, it
doesn't allow this (not without math to fudge the size).

>> +	[I40IW_HW_STAT_INDEX_MAX_64 + I40IW_HW_STAT_INDEX_MAX_32] =3D ""
>=20
> Why an empty string?

Oops, vi command p overrun.

> Trailing comments are not the kdoc standard for structure members,
> IIRC.

That falls in the same category as the lifespan sysfs file.  I tend to
document things in place while I'm writing, and then erase the
documentation when the final version is complete and the real docs are
in place.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD




--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--puNMic3gx1wE6CLCgrt5wxQBUkFhDHgIU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXPoFhAAoJELgmozMOVy/dF/4P/3zSwMpd0BImRKCLZ0U62S7q
qeiE0rrnbC+rT6c9NtcBS4vNrHFXqsBiE99gD2dlgEcvhAZnpdO3E0BUEmNXMwiJ
NRttxCJXxCy0XBmJ6LrL3wPJPaEnI+MIZ4v5cVVxF4t5gUI17qXwqpMiREpMoyCm
DcNSnaVHZs49DNS5VZ9hPU97ngh91nbb7ifjEm+Wr3Flspd+PymibarLlmdVdpRE
0SYkw2BcFBVuaom12s6BctE+fRws0o1nDnOB5Ct0nY5548o+87v0lA29SMPps6Rp
jz75bk5ZhvMbk0MkPXGh+JttqC5v9vHltRb+i2HxYGwXuZuBL2F+6y+tDmk2lc26
TRjkKF7cDLXEc0tVppdLbZV8vLjbUMlY2Ji5R/Z6J/xzcKfL7l9tVlVJ4d60H1sK
1bumBXxOqb2lGTaJU7LmdCvE2QGJzbRQZ4Ix5L5WrnRsgPabHuwn2Uti/mLAJlS4
1DkHqCO/VzKD12OAgRaNhC0Hc4wT+i0uoj/90UkvhexAPfLOFAMfhgDtbhyLTDMF
egMUilp+L7fTSmdQnTDGDg+GmhpgQYcBHwYEofMMDBMnSYSXMIsaq5XyBbzSo0RH
SdNuuxhCE5j2YLDrqbr15/8K8Gs4xapa9HNEHn3fNgAQ0Vn+9pJ7cIv2ICVeNdvs
AfVFUHIaf++W+vq86oht
=CSiV
-----END PGP SIGNATURE-----

--puNMic3gx1wE6CLCgrt5wxQBUkFhDHgIU--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
