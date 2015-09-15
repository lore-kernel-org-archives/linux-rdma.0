From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-4.3] IB/ipoib: add module option for auto-creating
 mcast groups
Date: Tue, 15 Sep 2015 14:24:21 -0400
Message-ID: <55F86255.9080508@redhat.com>
References: <980e8b0a82042d7e5801e02bf16fe72a0bde6759.1441934465.git.dledford@redhat.com>
 <alpine.DEB.2.11.1509110920540.16357@east.gentwo.org>
 <20150911182115.GA546@obsidianresearch.com> <55F32E7A.3020105@redhat.com>
 <alpine.DEB.2.11.1509141200020.4192@east.gentwo.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="SRENiQ45nX0N73a5NWFgjMptF3BQAtHxh"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.11.1509141200020.4192-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--SRENiQ45nX0N73a5NWFgjMptF3BQAtHxh
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 09/14/2015 01:03 PM, Christoph Lameter wrote:
> On Fri, 11 Sep 2015, Doug Ledford wrote:
>=20
>>> At a minimum, when the socket that did the send closes the send-only
>>> could be de-refed..
>>
>> If we kept a ref count, but we don't.  Tracking this is not a small ch=
ange.
>=20
> We could call ip_mc_join_group() from ipoib_mcast_send() which would jo=
in
> it at the socket layer. That layer would do the tracking for us and lea=
ve the
> group when the process terminates. The join would be visible the same w=
ay
> as if one would have done an explicit setsockopt().

I actually think this is a step in the right direction, but I think we
are talking about a layering violation doing it the way you are
suggesting.  What's more, there are a few difficulties here in that I'm
fairly certain the core networking layer doesn't have the concept of a
send-only join, yet we would need it to have such.  If we had three apps
do send only sends, we would need to track all three of those sockets as
being send only socket joins, and then if someone did a full join, we
would need to automatically upgrade the join, and then if that app with
the full join left, we would need to gracefully downgrade to send only
again.  So, I think it would take work at the core level to get this
right, but I think that's probably the right place to do the work.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--SRENiQ45nX0N73a5NWFgjMptF3BQAtHxh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV+GJVAAoJELgmozMOVy/dfJ0P/0RWMr/Fzqjf27JIrSFMB3QT
8JV4eW9bcgPaPjb+AZIxEfa9/LTNG2p8ro3AmPTkMy97bQu+mK86KNg99SgBJmrc
Vc2SHWaBmczACYF5UXSIs5H14NI+FGh25zy4wfzLFNssTF0dxQ8nLW5uvMpJ4EKw
IE0biRIcoxySN3Qa4SxC5AGzATcGXgSQMIpCRMc6QwCX/qHe3FZtWxcZE/4QD/IX
QbxS/OrDcrOjWc9AwpT1yN4HYixpPMuybP7FJzYarPGXtrCIiiM47Pm3Zwsg+bIu
q3O1VSyjzKSEUAcKUZzCBcClnoFF5bm0D7KH0X4XWDhj8WSgtYVUi43fuAFYjy2K
nLSELNPXMO8/8C2/HF3OuUC+W5RBM+WSIQ4vGHYfWejzs4qcyuNmEh/+UzfJadDs
W3jRqVwqsQFG43XQWnhTgXg0fHHndDB+6LJTTpR0nxOkNSxgzVD5ZVCpI1NPkHFF
/SegCQTBRUvUV1LCsqQdBPgFfqkt+Y9huVw3f8wO4ckJlCybKgrNwf5kK6RuWFzA
KYb+ZMzwGt2cAncDOmldmWTi4naRLJseMg7FGDuamsQuje3Y8Ukb0hXYpWjcLxIx
NcKT5ZbWnXY3C3hGqRYO4lx64upwd7sXXXR7GcjvP8OC/cax1M4mKRo+WqT0U3cW
DYFKd66hXnEEOm6cpBk6
=lFjK
-----END PGP SIGNATURE-----

--SRENiQ45nX0N73a5NWFgjMptF3BQAtHxh--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
