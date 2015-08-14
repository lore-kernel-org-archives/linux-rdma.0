From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] IB/srp: Do not create an all physical insecure rkey by
 default
Date: Fri, 14 Aug 2015 16:58:13 -0400
Message-ID: <55CE5665.9080309@redhat.com>
References: <20150804185640.GA10934@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Q8c9EmxiKJlNcNo8rRJr36UNkUqg5HLDV"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150804185640.GA10934-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eric Van Hensbergen <ericvh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ido Shamay <idos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Simon Derr <simon.derr-6ktuUTfB/bM@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Q8c9EmxiKJlNcNo8rRJr36UNkUqg5HLDV
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 08/04/2015 02:56 PM, Jason Gunthorpe wrote:
> The ULP only needs this if the insecure register_always performance
> optimization is enabled, or if FRWR/FMR is not supported in the driver.=

>=20
> This is a WIP for this functionality, there are several WARN_ONs in
> this patch that can be hit under certain work loads. Additional patches=

> will be needed to re-arrange each of those cases appropriately.
>=20
> This patch also changes the default mode to FRWR as FMR will always
> hit a WARN_ON.
>=20
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

Dropped the 9/12 from the original patchset, skipped this one, grabbed
the 8 patch series from Bart and tacked it onto the branch with your
other 11 patches.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--Q8c9EmxiKJlNcNo8rRJr36UNkUqg5HLDV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVzlZlAAoJELgmozMOVy/djpoP/R5M3dJ1yMzKmCAMsp/irNMi
a6Ll9KcJrLwXynD1RlyIr8OWvIJ9NGwlWnNtihRJzj97tYBV2kw7zKLE41a1z3PS
aQtYwPqktYy/KrlO2cPc5EySJvYivYpKBna08oH4GAXQmo/4h11jIFCLrC1ax+1A
0MrXuZNY41H1Fsj1S9qg9wgl846B11V+u94nhs51qACZHYx9taWTohwtgAMbhtVE
Nu/ahuQLXThWCGVsWUg26Le/C+mONc7aOV+NKHpkaoIGZu0fhL/shdgY51wU/unJ
UdkZV+Q3qCR/AJvAFYvs50rxUY0Utsj4ZEA9i6Udf0OPzB1QbgnskFKW5Lf3X/M7
4iuFiY2rcHRkP8F+joglrf23Uv9f7n5G9BOVEjEOXbUUgNRxtenSnWDYusKp27vM
9h3C7E4YzO76ZMvZHUSx3K6EhCuhTqhf6Fr02AyozoEuPRNFSlvaKgqphlAt9XUX
ZSciB80GnNS9b7/3QDLQgKf3xdWPcvLlG9SXAkO8L46G7E6552tOyU6xUdlDjdzb
rHMFt4skJ6NS3eh7UCCl9RCEfIokyMZZsuFReZ7BGjIH/SCf3ysU5H3qx3rSRHG+
84su0dZ/1Qn2I/9CR60Ae3uogYZKd2fJZ2vNDuinxktQR2rOI9QxJNEnUq212XzX
NpX+6g/2RpPv7kzHKEsP
=GJII
-----END PGP SIGNATURE-----

--Q8c9EmxiKJlNcNo8rRJr36UNkUqg5HLDV--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
