From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next V6 0/5] HW Device hot-removal support
Date: Thu, 30 Jul 2015 13:15:00 -0400
Message-ID: <55BA5B94.8060406@redhat.com>
References: <1435659967-27173-1-git-send-email-yishaih@mellanox.com>
 <55BA54FC.8060905@redhat.com> <20150730165014.GD16659@obsidianresearch.com>
 <55BA57F2.5040207@redhat.com> <20150730170934.GA25181@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="fvlbDnX6Q2G164QugvjrHECaj82pEE54m"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150730170934.GA25181-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--fvlbDnX6Q2G164QugvjrHECaj82pEE54m
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 07/30/2015 01:09 PM, Jason Gunthorpe wrote:
> On Thu, Jul 30, 2015 at 12:59:30PM -0400, Doug Ledford wrote:
>> On 07/30/2015 12:50 PM, Jason Gunthorpe wrote:
>>> On Thu, Jul 30, 2015 at 12:46:52PM -0400, Doug Ledford wrote:
>>>
>>>> I've pulled this series in for 4.3.  There were some additional item=
s in
>>>> some of Jason's comments that ought to be looked into, but I think t=
his
>>>> patch set has reached the point where it's no worse than existing in=

>>>> terms of locking, there were just some existing issues that should b=
e
>>>> addressed too.
>>>
>>> Eh? V6 corrupts random kernel memory if you use the hot-removal.
>>
>> I didn't see that in there.  Did I read through the discussion too fas=
t?
>>  I'll go recheck...
>=20
> For a char device you absolutely cannot kfree the cdev in the file
> release callback.
>=20
> The file still holds a ref on cdev and it will guarenteed use
> after-free on cdev during core code struct file cleanup.

OK, I see what happened.  The early discussion for patch 3/5 (the
problem patch) happened on list without me on Cc:, only the last few
messages had me on Cc:.  The net result is that I had seen yours and
Or's responses in my Inbox some weeks ago and that had leaked out of my
head, and what was in my linux-rdma folder didn't have those messages,
so when I read through this thread there, it was missing part of that
context.  When I re-read it via patchworks, all of the messages were in
one place.

Yishai, I currently have this code in my tree, but I'm going to cull it
and wait for a v7 that fixes this problem.  Please move that forward if
you want to make 4.3.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--fvlbDnX6Q2G164QugvjrHECaj82pEE54m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVuluUAAoJELgmozMOVy/dCmIP/jZLNL+3XT0IlSxMrREShiBC
qI7LB53/Qe688DjS07ykBtPGuwSUrSeFZj2BvIrVKeGuTvDiszQmdl5TPyi3yx0+
UIf7ZR2mc7DUwDpIgyPHTNLoBf5PBBodomDZaY7qG5tuBmU67NWqgJb129ezYXpd
mekzZnCEMLblS7UHCMPvFpVC2dMGJFZ6aaVIkH8KR5aftth0ZbWJnfllT3pUzk0E
Wyk/1QderTIgd4T9o/lSDeHD6RnlxaQaYg388SXo+up0RlK03rgpU7zZeaOSriLs
3/0waQPbLW8VAMEH3YMMqfL1TnHO9AghutJxfJybF51ZitE5GnnsHfdViM4vhnAY
eB1QC2Q88eQ6EaEdYUhktI/4AGY6R3cocDbPkXyYS8/J/FXZPqfSVs4Xp0njt4vj
jAAGNPj5PeWibMTAHZceZgvHvvDgHB69yh2/Nq7rn35c++MB/qEuCM0cD6hUrvIr
uXn2P+7Gq/wLKPU4G6z5tDq7S1LVwxKLr7eShRfWIW88GSRARGsQa5FuXDwWMzer
7Tz9GZnabF+Y5y42mbpQACBLW8TpW0LHNfdZw3Bwp0MqqaPmXj7U9fpALgLpfSHN
PaxmBajraCeL5nF+XiaK2ZBtFalq85xKkT+p4AUmI5PP3imcKesxPcd6DqIC1UmF
f9rgNrrvAbsCMv3cUZiS
=mLkO
-----END PGP SIGNATURE-----

--fvlbDnX6Q2G164QugvjrHECaj82pEE54m--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
