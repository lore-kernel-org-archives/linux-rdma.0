From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [ewg] [ANNOUNCE] OFED 4.8-rc2 release is available
Date: Thu, 4 May 2017 14:40:22 -0400
Message-ID: <75ebb17e-cec3-6605-2a2f-d2533e95a5ec@redhat.com>
References: <590096A3.5090107@dev.mellanox.co.il>
 <20170427070657.GA13585@infradead.org> <20170504084933.GA1359@infradead.org>
 <9C6B67F36DCAFC479B1CF6A967258A8C7E953FA6@ORSMSX115.amr.corp.intel.com>
 <20170504153003.GA854@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB1199FA@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="NoIDuAlhUAG0XRAkOOiivAqeHVj8JNUJB"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB1199FA-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Woodruff, Robert J" <robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--NoIDuAlhUAG0XRAkOOiivAqeHVj8JNUJB
Content-Type: multipart/mixed; boundary="hFHl8jlX5F9916h95i0IuEwXpMHCkqu0k";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>,
 "Woodruff, Robert J" <robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
 "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Message-ID: <75ebb17e-cec3-6605-2a2f-d2533e95a5ec-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [ewg] [ANNOUNCE] OFED 4.8-rc2 release is available
References: <590096A3.5090107-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
 <20170427070657.GA13585-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> <20170504084933.GA1359-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
 <9C6B67F36DCAFC479B1CF6A967258A8C7E953FA6-8oqHQFITsIFqS6EAlXoojrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
 <20170504153003.GA854-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
 <1828884A29C6694DAF28B7E6B8A82373AB1199FA-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB1199FA-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>

--hFHl8jlX5F9916h95i0IuEwXpMHCkqu0k
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 5/4/2017 1:34 PM, Hefty, Sean wrote:
>> This is exactly why we so strongly discourage this out of tree
>> stuff - getting something unmergable in OFED is *NOT* Job Done,
>> Time to Go Home. Down this path just creates another Lustre mess.
>=20
> Actually, this may be 'job done'.  No individual or company is
> obligated to provide upstream software for any of their hardware.

Very true, but in that case you would expect Intel to be shipping the
software, not OFA.  Much like they already do with their compiler, their
MPI, etc.

> OFA decides what to ship in their software products, not the greater
> linux kernel community.  Individual companies can decide if out of
> tree maintenance is more cost effective than trying to merge code
> upstream.  Because that's what this ultimately comes down to.

The OFA has already learned their lesson once with XRC.  I wonder if
they are getting ready to get hit with another lesson over this.  The
issue is if the OFA ships an API and it isn't upstream, then that API
needs to legitimately be a private, should never conflict with upstream
API.  If upstream then implements the same thing in a different way and
users are exposed to the rather unpleasant choice of code to OFA's API
or to upstream's API for the same thing, it creates a schism in the
user's code base around what API to use/support.  This is entirely
contrary to the OFA's stated goals about the end user experience of
people using their RDMA software.  So Intel can certainly make any cost
analysis they want about their hardware and the software to support it,
but the OFA is not Intel's personal software distributor and the OFA
must look at other, bigger picture issues than Intel.

> IMO, the only people who have legitimate complaints here are those
> people running Xeon Phi with Mellanox HCAs who are being forced to
> use OFED, rather than upstream code.

I suspect there are legitimate grounds to complain about the fact that
it is shipped in the OFA OFED and not limited to an Intel OFED
derivative similar to Mellanox OFED.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--hFHl8jlX5F9916h95i0IuEwXpMHCkqu0k--

--NoIDuAlhUAG0XRAkOOiivAqeHVj8JNUJB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZC3WWAAoJELgmozMOVy/dASsP/R+hvG6++DH4CEbmxOa5IeJ6
GCSBrEKEvB9kvEZesQm18m3BvdpkNHxyYL287wE01+gpUOYfgrggaENWAbOA0yWc
1+uHGJKZ/XrUX4Kfv+WeI4KPhoogqBMw5uvGgZDP66K+SR1xye520qvEDmt+GTAm
IZACMPitqxOpOjrnxy+hn2OH3eftsvmlAcKwnNzady7CS3OIsD/FwoZ6zDdxClst
tjLAAH7hOK19hhlMYpL4lSHGQ5OA0aPIokCzzC0+H4wA3ttxqdzPeoqK5Akqdei1
xePNW3TYJhuaaNYlBClvBDyMmKpsxE+WEpmTlG8Pvsd7AsOpFdAbfDjYd5T+xQ1z
EMnnUHX/DNx50JGchc9fmVKg+bdxaJnSuzFo3Zg5srfGhjiCgbzYlvGUcX7O763i
C/qo5Di9vRT3zU60QB+9ELo+X4rPmZDULzRETRnEjiElepIRZi/lSH1mWuFRb5cY
zGs6++P6OFj75ZnWZJUddurB9NpuyahO9Uub4t4k+jhx9BExm9sFRZ+plbqVDdbQ
Ym7DGyb+vNdu92L3dGowQ+NL3n0r3jklCDdULlxBvDLJLNPjEpvQpmbXfOdSLiVB
GnebZ0M1dqA8/Qtx6NpD2/WPnUtGjAtFDW1TfNgwy2suTPCTIE+hMZohJDbQqx87
5U/ZayTG4W+G4duq5H2P
=ugUw
-----END PGP SIGNATURE-----

--NoIDuAlhUAG0XRAkOOiivAqeHVj8JNUJB--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
