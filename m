From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Latest for-4.14
Date: Thu, 27 Jul 2017 14:32:48 -0400
Message-ID: <7aad42cd-05be-b7a7-9e85-2c13f5d489d3@redhat.com>
References: <20170726053749.GV3259@mtr-leonro.local>
 <b337a2ae-40ff-a207-82fa-fd3c7d2e1083@intel.com>
 <20170726130350.GW3259@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="q88oFNdDrkMKEHWTEdMifeFhwCH1RIg7b"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170726130350.GW3259-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--q88oFNdDrkMKEHWTEdMifeFhwCH1RIg7b
Content-Type: multipart/mixed; boundary="enRuMbXgLhLfPBVntqLsIJo7KEifvUu0B";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
 Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Message-ID: <7aad42cd-05be-b7a7-9e85-2c13f5d489d3-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Latest for-4.14
References: <20170726053749.GV3259-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
 <b337a2ae-40ff-a207-82fa-fd3c7d2e1083-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
 <20170726130350.GW3259-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
In-Reply-To: <20170726130350.GW3259-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>

--enRuMbXgLhLfPBVntqLsIJo7KEifvUu0B
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 7/26/2017 9:03 AM, Leon Romanovsky wrote:
> On Wed, Jul 26, 2017 at 08:24:44AM -0400, Dennis Dalessandro wrote:
>> On 7/26/2017 1:37 AM, Leon Romanovsky wrote:
>>> Reply to: "Re: [PATCH for-next 7/9] IB/core: Allow QP state transitio=
n from reset to error"
>>>
>>> On Sun, Jul 23, 2017 at 09:14:02AM -0400, Doug Ledford wrote:
>>>> On 7/23/2017 9:04 AM, Leon Romanovsky wrote:
>>>
>>> <snip>
>>>
>>>>> BTW, when will you post for-4.14 branch so we will be able to base =
our
>>>>> submission queue for the -next?
>>>>
>>>> Tomorrow.  I wanted to base it on 4.13-rc2 so it would get all of th=
e
>>>> fixes that went in this week.
>>>
>>> Any news on the matter?
>>>
>>
>> Check Doug's GitHub, I see a 4.13-rc2 based "for-next" branch there.
>=20
> Are you referring to this branch?
> https://github.com/torvalds/linux/compare/master...dledford:k.o/for-nex=
t
>=20
> It doesn't have most of mlx5/mlx4/cavium/core/e.t.c features.

I created a for-next and then I've been making various other branches
through the week and sending them to github to be checked by 0day
testing.  Once they pass 0day, I merge them into the for-next and push
one more time to make sure the combination of everything merged together
passes 0day, and once I get confirmation that the build is good, I'll
push it to k.o where it will be considered unrebaseable, and so any
fixes after that may require incremental patches, reverts, etc.  The
slowdown this week has largely been the turnaround time on 0day testing.
 That's been taking in excess of 10 hours from a push to test results
:-/.  I pushed what I want to push to k.o this morning about 8am, not
sure when I'll get my 0day results back.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--enRuMbXgLhLfPBVntqLsIJo7KEifvUu0B--

--q88oFNdDrkMKEHWTEdMifeFhwCH1RIg7b
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZejHQAAoJELgmozMOVy/deLEP+wZK92jDA5py9cOkFTt95BHz
bzTrPa+NfoWuayUbKTOgrxwGdQYbeTD4HAKYgKcdcdOHAoQAIqrF65sBd4AGQiyt
YB+NUNaKkosju58mQwUKjt6uplviJXWk+WKD7S9UNL3WPVewdHg/HxZabMV0sqKQ
VsYqZ6QSU3e4cl0xUG944grM6M8GlqVeOGuGThDiagW2cXgtKiElaegRPwIfST0p
JtUDoh3V5Gyy8VqllG5V9q6qTkB131CdceXT9iCiqLUsPyRYCi3OqtCR1I71Ian9
xMvlhl6jHzg6N9XwocDg0kclSDBTEBsckkeKqs+cQlSxFkXLLTy98/txxjOXdS0o
tPyJxNdrRJJypK0maOzrh6PIodQNSQhxz9ujMgjbWhbMKfWARQfctWphlxXT2Dw0
x7mUGtxaGv5r/pI4mb+j6n7ZzGRBnHByBSH/hJTNXcjcD8TuEnPW6sxk+P5WOgpH
6gzow2FNIasjAQMm7e0EqJIc4zSHfeRkUDcxJb5l/JVx+30m84h7vsxLzB5U5HAB
1rFiFgZ4CQcBcRA2dHLuBRGfFRFfcMiwQjtMQSR53OK9CX0LreIdZzrtwtyqDTaa
RJSGJ0DQD5Zz6WmVX/jn2RJ7ODStBH9CSWm3KiEKKKvgJGkf/6w1Et036z9Mw/II
obT2V5AFxj4mWGhK8ZLm
=6GwD
-----END PGP SIGNATURE-----

--q88oFNdDrkMKEHWTEdMifeFhwCH1RIg7b--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
