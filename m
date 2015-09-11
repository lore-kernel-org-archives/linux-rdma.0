From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-4.3] IB/ipoib: add module option for auto-creating
 mcast groups
Date: Fri, 11 Sep 2015 15:41:46 -0400
Message-ID: <55F32E7A.3020105@redhat.com>
References: <980e8b0a82042d7e5801e02bf16fe72a0bde6759.1441934465.git.dledford@redhat.com>
 <alpine.DEB.2.11.1509110920540.16357@east.gentwo.org>
 <20150911182115.GA546@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="lv0has5hPco223G6Q88hO8qHRqI08UfpN"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150911182115.GA546-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--lv0has5hPco223G6Q88hO8qHRqI08UfpN
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 09/11/2015 02:21 PM, Jason Gunthorpe wrote:
> On Fri, Sep 11, 2015 at 09:40:25AM -0500, Christoph Lameter wrote:
>> On Thu, 10 Sep 2015, Doug Ledford wrote:
>>
>>> +		 * 1) ifdown/ifup
>>> +		 * 2) a regular mcast join/leave happens and we run
>>> +		 *    ipoib_mcast_restart_task
>>> +		 * 3) a REREGISTER event comes in from the SM
>>> +		 * 4) any other event that might cause a mcast flush
>>
>> Could we have a timeout and leave the multicast group on process
>> exit?
>=20
> At a minimum, when the socket that did the send closes the send-only
> could be de-refed..

If we kept a ref count, but we don't.  Tracking this is not a small chang=
e.

> But really send-only in IB is very similar to neighbour discovery, and
> should work the same, with a timer, etc. In my mind it would be ideal
> to even add them to the ND table, if the core would support that..
>=20
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--lv0has5hPco223G6Q88hO8qHRqI08UfpN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV8y56AAoJELgmozMOVy/do3YP+wbmOQ+K330ssGFjcYUJGjL2
7xpPCdWzHNjpmHgxW19c+3uzx7rJ8YUqAq2mhYpDrYbCo2Y4rwLL0ADU7wsing3R
0H4bl1NllTIRyQBwnq/IIEmMiGmB7MMyq9/kqxtTS3U7Sc5vaaKQLxXg/9FDuZr/
2K94JDQPP5fR2SY6tPAo9Hz/qXIcx48wdjmfPu6FSdHuybdWoQyFHwRMjnAAU1So
tGmqkgDQIqPixiyklF8vjaNn52ykxugVAdWOUqJNF41Gc6B/xAAYkYL6RI+lFxG+
Jm1OnSyrxxn5J6LBCAaOnMJsGl3cdeSWsUdLi9bevaOKbyeRbFhxvHxWOfoxWQCr
kjw+as0pEOaGE/C3RAuohFurrXOnoQJxQ26gqRa8MKsaznI3n0x0K8dRjrQIzJS4
IZ4INsI/hB48L8bDextsuC7+P2JSY1dHdUrZulQhCWhA7jiy4ckm5qMBzKupOYVy
11tCSLwnmSszt1Fz6PSm5zmdM6fBeEABHXCOCpofRgSfb2aILS9R8diktbenuRJL
irshAk2waxd9oORUi4whuEAOmO+ZwpMlefkKMVozwCZA6yWl4DYIqSUk3J29uFoP
SHiIvvtX4SREW9lBJad7Z7RNeU/m1OL7MYpAud3AdKwZ09dmcTCLiUbynSfqRUq7
ZI3K0I+zQE8dFoB8t+Hd
=zgZ1
-----END PGP SIGNATURE-----

--lv0has5hPco223G6Q88hO8qHRqI08UfpN--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
