From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Fri, 27 May 2016 11:14:12 -0400
Message-ID: <12fa9917-ebfc-60bd-09d7-a7478b56af9e@redhat.com>
References: <166c87fa-09ef-f170-7351-d18062bc25cf@redhat.com>
 <20160527045157.GW25500@leon.nu>
 <20160527114414.GA27420@phlsvsds.ph.intel.com>
 <20160527131357.GX25500@leon.nu> <57484C71.309@redhat.com>
 <20160527144427.GZ25500@leon.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="FjT02eIxK0tcwWbNeWFFvJQIm6bPIlbHv"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160527144427.GZ25500-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--FjT02eIxK0tcwWbNeWFFvJQIm6bPIlbHv
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 05/27/2016 10:44 AM, Leon Romanovsky wrote:
> On Fri, May 27, 2016 at 09:32:33AM -0400, Doug Ledford wrote:
>> On 5/27/2016 9:13 AM, Leon Romanovsky wrote:
>>> On Fri, May 27, 2016 at 07:44:15AM -0400, Dennis Dalessandro wrote:

>>> Separate char device? IOCTLs per-device vs. global IOCTLs per subsyst=
em?
>>> Role of the IB CORE code in the driver management?
>>
>> Really Leon?  The qib driver has the *exact* same issue, and it sits o=
ut
>> of staging.  If moving this driver out of staging somehow stops us fro=
m
>> making the new ABI while the qib driver not being in staging doesn't
>> prevent it, then we are a bunch of idiots.  This would appear to me to=

>> be a very disingenuous complaint on your part.
>=20
> Doug,
> Did you read my question?
>=20
> I feel that I need to repeat my main point again: "It is OK to move hfi=
1 driver
> out-of-staging"

Good, I'm glad that's settled.

> and repeat the question too: "Will the hfi1 interface
> decisions limit our ABI work?".

And I answered this already: If it does, we are idiots.  If you would
prefer the answer a different way.  Of course not.  Why would you think
it would?

> There is no politics here, just my PERSONAL opinion and believe that AB=
I work can be
> done in months time frame. And again, "It is OK to move hfi1 driver out=
-of-staging".

If you really didn't object to the driver coming out of staging, then
maybe asking these questions in response to my pull request, thereby
throwing this conversation in Linus' lap, was not the most appropriate
thing to do.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--FjT02eIxK0tcwWbNeWFFvJQIm6bPIlbHv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXSGREAAoJELgmozMOVy/dOo0P/0Kog3Zefwim1WvbaTj4SA3p
ThDdDx0OnCeFw+RhaoYJt7ufzquAqCRQFmBDucE0ggI1cwLMCbfq+8ZHjhtjVOTD
1Ssl8ad6zooFrDoZP1TFL4HNo/wfPuC6394kdLgxMmGkWLRoA8c5bgyRaUDiKIYU
DfshhjM8g4eDb1oqcCFsKwYaNbLSq/9YwgTB4/CP33O5LoDyx3GXJWQnLaFFZylQ
tKPqR7e2To6W2QCbUAvWjRn9/Cc0S9J2IpBi8IwI6gMD5Lk4zqjrdn+SAT1h6YTb
BN7mjwaWrj2gEZzoFjyuoDcFNjQ+acWY1WlL6Wtr3VYiyjWaSnbZyQXtloANTIhW
vc/nIOMTx28u7IE6Rtb/A2ZU1oX/W+IaOFDRa7my0tz2cGw9EsrENDLjWIajg/s8
M4cI2RDdvsmhAK9JSjYdaRKYMRu6FJV3EHqy1U+EIijCN21mh6Tc2QtYR4S3xytz
GTOzQQqne3TSdMEzoTjpzYD8EXRVX1a1veRxmPCU3HIxdvGmE42jnjgLfPBm5OKk
huCfeZwNG3USgD+gpklIFyD5+JMzNtg1W4bEPtVfrSz7J9cd4eAwL8XaQnRBMV02
bkIFYgHfsSRtISpkXIVvH9isQt4ufsm/hRlNhQEPq/nG539XUdRd5hUEGJXddRsQ
RQmI8ZI1E5d7DsvEEE82
=idW/
-----END PGP SIGNATURE-----

--FjT02eIxK0tcwWbNeWFFvJQIm6bPIlbHv--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
