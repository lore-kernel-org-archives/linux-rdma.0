From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: shrink struct ib_send_wr V4
Date: Thu, 29 Oct 2015 10:38:54 -0400
Message-ID: <56322F7E.9030900@redhat.com>
References: <1442157215-22341-1-git-send-email-hch@lst.de>
 <5631839B.30300@redhat.com> <56318B37.20207@redhat.com>
 <20151029115114.GA18466@lst.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="7fuTKA6ITXIWE7bsb2Tbep5Wt4IQX6oCM"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151029115114.GA18466-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--7fuTKA6ITXIWE7bsb2Tbep5Wt4IQX6oCM
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 10/29/2015 07:51 AM, Christoph Hellwig wrote:
> On Wed, Oct 28, 2015 at 10:57:59PM -0400, Doug Ledford wrote:
>>> I had to do a minor hand merge to get this to apply, but it has been
>>> pulled in for 4.4.
>>
>> This breaks all of the drivers in staging BTW.  That will need fixed u=
p
>> before the pull request goes in during the merge window.
>=20
> That latest branch on infradead.org should have fixed all the staging
> drivers.

You're right, it did.  It was my mistake thinking it was your patchset
that caused the problem (that's what I get for working on very little
sleep).  You're patchset was pulled in as a preparatory requirement for
the fast-reg patchset from Sagi.  It was the fast-reg patchset that
skips the staging drivers.  I had to remove the top patch from that
patchset (the one that finally removed the old core API) in order to get
my kernel to compile again).  Sorry about the confusion.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--7fuTKA6ITXIWE7bsb2Tbep5Wt4IQX6oCM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWMi9+AAoJELgmozMOVy/dLk8QAKjStUYprpa/UbQLkBUJp2Zl
mZE3T53VqE+2uVRXQRIpEaVQYYmidxG2xHt+HNiSS2IA5KZdi5h1i6q0Q7YBCvOL
x+H8UV14W6tvH9FfbDP7K4sesEeF1+CBfRC7Fm+tUqnAgAkZlQ/fD21+nhSjge+U
T3mmYcqwCpQurUujxGyfRhthP88nEMoSO+ch/cOzQDoZzFmAZhOvk+eIrFsJrj6Q
5SrzQHxQBVEQqyk9+ufzML6QW5Ttud3i1zYdVwiHveXCzpg/Ux86kCwtRZ4RHTR0
5EV32xs8LUvG11UhF5tmzYwKQt7JKIqSqsRaNtsByliTNcZRuDTu0O9NVCj5/Z2V
tAbqIUj1Dai5CwJdAKq/kFcEPYklrepq9rmYwqx0erd1XYUJd2DmXe69qqhRkMLH
iOiYxQDaIcWFPW4bGvABN1+n/8OXoTrggACptzgIhNEYqCx8TitAXahsrpIfHwpU
RznNdalCCTCAOyFNmNzHbcQ+8BZQbprisWWlBIw7xjKVoj7GslhYEjh/UW7Wuj8P
/BKthhMZ6R6+sArF7Op2vuT67LbpaetILW3lXCd6aUPsxKDqiEAydLyH8hFf/cN2
BS0crCNTKQlE4br6+G45bT97tDXAS2KIgUE/kyrYt/hq3JaODZkvBLQVUqZXTPh6
zT55WRDrIbxR4fJ7mERo
=QMl7
-----END PGP SIGNATURE-----

--7fuTKA6ITXIWE7bsb2Tbep5Wt4IQX6oCM--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
