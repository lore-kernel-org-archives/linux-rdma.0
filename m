From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4] IB Core: RAW ETH support
Date: Thu, 17 Jun 2010 09:58:49 -0400
Message-ID: <4C1A2A19.8020905@redhat.com>
References: <E113D394D7C5DB4F8FF691FA7EE9DB4439A76E8632@MTLMAIL.mtl.com>
	<1276513450.30132.51.camel@alst60.voltaire.com>
	<aday6eguhfn.fsf@roland-alpha.cisco.com>
	<4C18DB37.6050501@opengridcomputing.com>
	<20100616170234.GA2932@obsidianresearch.com>
	<4C1905E6.2000304@opengridcomputing.com>
	<20100616175259.GF4630@obsidianresearch.com>
	<4C19195B.1080003@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0215906774=="
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
In-Reply-To: <4C19195B.1080003-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
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
--===============0215906774==
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigEB596EDDE6F413D16588A568"

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigEB596EDDE6F413D16588A568
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 06/16/2010 02:35 PM, Steve Wise wrote:
> Jason Gunthorpe wrote:
>> On Wed, Jun 16, 2010 at 12:12:06PM -0500, Steve Wise wrote:
>>
>> =20
>>>>> Granted our dev process may not be documented, but I always assumed=

>>>>> the general idea was to get changes accepted upstream, then pull
>>>>> into ofed. OFED is just a mechanism to make top-of-tree linux work
>>>>> on distro kernels. There are some exceptions, but this stuff
>>>>> shouldn't be an exception.
>>>>>        =20
>>
>> =20
>>>> That is what many people wish for, me included, but it is not at all=

>>>> what generally happens :(
>>>>
>>>> In my observation the typical flow is:
>>>>  - A patch is written, it may or may not be sent to the list
>>>>  - 'business drivers' get it slammed into OFED right away
>>>>  - A patch is finally sent for proper review
>>>>  - It is not merged, there are comments..
>>>>  - Interest in doing anything is lost because it is already in
>>>>    OFED and that is all that matters, right?
>>>>  - People complain.
>>>>
>>>> For instance, the iWarp thingy we were just discussing fits this
>>>> process rather well.
>>>>      =20
>>
>> =20
>>> You're wrong.  I started that iWARP change in 2007 on LKLM.  I
>>> proposed  a few ideas and show the pros/cons of each.  And it was
>>> NAKed 100% by  mister miller.    It was then included in OFED as a
>>> last resort only  because I couldn't get any help with trying to add
>>> this upstream in any  form.  I even spent a few weeks developing a
>>> way to administor "iwarp  only" ipaddresses, but Roland didn't like
>>> that scheme for various  reasons.  So please don't mention that
>>> particular patch as a "bad  process" unless you want to argue with me=

>>> some more about it.
>>>    =20
>>
>> Uhm, what you just described does fit my process outline:
>>
>>  #1 - Patch written, sent to LKML. Check.
>>  #3 - Patch sent for proper review - in 2007. Check.
>>  #4 - Not merged. NAK by DM. Check.
>>  #2 - 'business drivers' force it into OFED - 'last resort' ie, iWarp
>>       cards can't be used without some fix. Check.
>>  #5 - Interest is lost. Yep, this was done in 2007, and it was idle
>>       till now. Check.
>>  #6 - People Complain. Hmm. Yep. Check.
>>
>>  =20
>=20
> Note the ordering is different.  IE I tried very hard to get the "right=
"
> solution designed and agreed-upon upstream.  But failed.  That's my
> bad.    I did, however help with the iWARP core code including neighbou=
r
> update net events which did go in upstream before ofed.
>=20
>> Don't think I'm being critical toward only you, or singling out that
>> little iWarp patch. But it really isn't special, or different, or an
>> exception. Pick nearly any patch in OFED and someone will rush to its
>> defense with a 'we tried to follow the process and it failed, so we
>> did it anyway' argument.
>>
>> I also didn't say this is the only way that RDMA development goes,
>> lots and lots of stuff goes into mainline first, from everyone.
>>
>> Jason
>>  =20
>=20
>=20
> OFED maintainers should be more rigid, perhaps, with requiring that
> changes be accepted upstream first.  One observation is that there is n=
o
> "OFED RDMA maintainer", aka a Roland Dreier, for the OFED code.  So eac=
h
> driver maintainer pretty much has free reign to do the right thing or
> the wrong thing...

Yep, no doubt that has an impact on things.  It's for this very reason
that our next operating system is not following OFED but instead is
using upstream as its basis.  That will be true from now on with our
products.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enigEB596EDDE6F413D16588A568
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAkwaKiIACgkQg6WylM+/8ZS8SACgr4/f60Gpx5X2K80faYIAVb4n
yoMAnR73XNaYbmspojzq4qyKZcqtMRBQ
=qhjG
-----END PGP SIGNATURE-----

--------------enigEB596EDDE6F413D16588A568--

--===============0215906774==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
ewg mailing list
ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg
--===============0215906774==--
