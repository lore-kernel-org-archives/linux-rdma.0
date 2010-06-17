From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4] IB Core: RAW ETH support
Date: Thu, 17 Jun 2010 10:10:46 -0400
Message-ID: <4C1A2CE6.1040305@redhat.com>
References: <E113D394D7C5DB4F8FF691FA7EE9DB4439A76E8632@MTLMAIL.mtl.com>
	<1276513450.30132.51.camel@alst60.voltaire.com>
	<aday6eguhfn.fsf@roland-alpha.cisco.com>
	<4C18DB37.6050501@opengridcomputing.com>
	<20100616170234.GA2932@obsidianresearch.com>
	<4C1905E6.2000304@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0901172507=="
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
In-Reply-To: <4C1905E6.2000304-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Mime-version: 1.0
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: "ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org" <ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--===============0901172507==
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigED0FE7AD2B6EA0E173BD7C67"

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigED0FE7AD2B6EA0E173BD7C67
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 06/16/2010 01:12 PM, Steve Wise wrote:
> Jason Gunthorpe wrote:
>> On Wed, Jun 16, 2010 at 09:09:59AM -0500, Steve Wise wrote:
>>
>> =20
>>> Granted our dev process may not be documented, but I always assumed
>>> the general idea was to get changes accepted upstream, then pull into=

>>> ofed. OFED is just a mechanism to make top-of-tree linux work on
>>> distro kernels. There are some exceptions, but this stuff shouldn't
>>> be an exception.
>>>    =20
>>
>> That is what many people wish for, me included, but it is not at all
>> what generally happens :(
>>
>> In my observation the typical flow is:
>>  - A patch is written, it may or may not be sent to the list
>>  - 'business drivers' get it slammed into OFED right away
>>  - A patch is finally sent for proper review
>>  - It is not merged, there are comments..
>>  - Interest in doing anything is lost because it is already in
>>    OFED and that is all that matters, right?
>>  - People complain.
>>
>> For instance, the iWarp thingy we were just discussing fits this
>> process rather well.
>>
>>  =20
>=20
> You're wrong.  I started that iWARP change in 2007 on LKLM.  I proposed=

> a few ideas and show the pros/cons of each.  And it was NAKed 100% by
> mister miller.    It was then included in OFED as a last resort only
                                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Which, of course, is the problem.  Once you have a solution besides "get
it upstream", you throw whatever you feel like into OFED instead of
whatever upstream will accept.  How long has OFED shipped the XRC stuff
now while it *still* isn't upstream?

> because I couldn't get any help with trying to add this upstream in any=

> form.=20

Again, OFED is part of the reason this failed.  That users had someplace
else to get "working" code besides upstream meant that you didn't have
end users putting pressure on the upstream kernel folks to accept *some*
form of solution.  So, your job was harder because there were no users
present to put pressure on mister miller or others, and then you
perpetuated the issue by caving and going back to OFED "as a last
resort".  It has become a "last resort" so often now that trying to get
things upstream first is just a sort of private joke amongst some people
I think.

> I even spent a few weeks developing a way to administor "iwarp
> only" ipaddresses, but Roland didn't like that scheme for various
> reasons.  So please don't mention that particular patch as a "bad
> process" unless you want to argue with me some more about it.
>=20
> Also, the chelsio iWARP driver has 100% been upstream first, then
> ofed.   Some of us are indeed trying to do the right thing.
>=20
> <steps off soap box>

OFED just needs to go away.  It's been far too abused for far too long
and it's mere existence is hindering upstream development.  I appreciate
that you attempt to do the right thing most of the time, but it really
needs to be all of the time, and you need your users right there beside
you in order to carry the weight you need in order to get solutions
designed and accepted instead of running into the brick wall you ran
into before.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enigED0FE7AD2B6EA0E173BD7C67
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAkwaLOYACgkQg6WylM+/8ZQpWACfV6uF4oBYMMFrVkxEUxXFpc8W
4e0AoISZDf0Qua5WtZZrY4Aax5Kflaj+
=dx7X
-----END PGP SIGNATURE-----

--------------enigED0FE7AD2B6EA0E173BD7C67--

--===============0901172507==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
ewg mailing list
ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg
--===============0901172507==--
