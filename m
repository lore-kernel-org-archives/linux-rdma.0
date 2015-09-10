From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 0/3] libibverbs: On-demand paging support
Date: Thu, 10 Sep 2015 12:53:05 -0400
Message-ID: <55F1B571.7020808@redhat.com>
References: <1441292199-8371-1-git-send-email-haggaie@mellanox.com>
 <55EA2CA7.8000702@redhat.com> <55F19F09.7000407@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="NewAHV8kqOmra7cQQCBlVJiqLEBSN05IK"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55F19F09.7000407-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--NewAHV8kqOmra7cQQCBlVJiqLEBSN05IK
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 09/10/2015 11:17 AM, Or Gerlitz wrote:
> On 9/5/2015 2:43 AM, Doug Ledford wrote:
>> On 09/03/2015 10:56 AM, Haggai Eran wrote:
>>> This series adds userspace support for on-demand paging. The first
>>> patch adds
>>> support for the new extended query device verb. Patch 2 adds the
>>> capability and
>>> interface bits related to on-demand paging, and patch 3 adds example
>>> code to
>>> the rc_pingpong program to use on-demand paging.
>>>
>>>
>>> Eli Cohen (1):
>>>    Add support for extended query device capabilities
>>>
>>> Haggai Eran (1):
>>>    Add on-demand paging support
>>>
>>> Majd Dibbiny (1):
>>>    libibverbs/examples: Support odp in rc_pingpong
>> Hi Haggai,
>>
>> Series applied, thanks.
>=20
> Doug, in order to address your comments on the checksum offload
> submission, we'd like to leverage on these patches, e.g to enhance the
> extended query device - so WHERE is your tree containing these patches
> that you applied?
>=20
> I don't see it in your kernel.org tree [1]

Because I didn't push it yet.  I can push it now....

Push complete.

> and I didn't find a git hub
> libibverbs clone that belong to you
>=20
> It's very tired-ing that every now and then we are looking across
> multiple trees to find out where accepted patches are, really - can you=

> reduce the suffer here?
>=20
>=20
>=20
> Or.
>=20
> [1] http://git.kernel.org/cgit/libs/infiniband/libibverbs.git/
>=20
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--NewAHV8kqOmra7cQQCBlVJiqLEBSN05IK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV8bVxAAoJELgmozMOVy/dxCsQAJBqBc3o80I9XuKrPU7Y24uF
lgT6bibsxtBOioYpOt2aKzOdIjzLI12QBbeEnXNKS+RVQGLIQTd9rOW/bzQdQoJ2
hdMjXhe3IfuJWgfAmcubT+L8J1lqvS0044t4Uc1xj9/eVOjLWIyKi3eEjBbGAFke
Vk25U8BMpjSXxPHN3FjWhmdyDzMVqkb6P26Hsh1LL9C8sF7kaZi+oihNLGe2ETPr
Rhp3m9fcsNrFKF/7yjVnWtojqhFvFYnWgQ0OnpCBPSkHqPo14gEnI5P5E/R24Lbc
tm+PUqr4hQJ3zktgtaS0v3eMbtGUq0Xv/IC3u/8syOGR7KhYgyrZfjtGBdaPknQF
sGaSm1LWG0IbYYtSeFLZZoYGMAo1Gm8QTE+ms258Xf1dBFeVux6bWveu0aVcJed2
mXOuQ70VmffeJU3I4pgk5H8q1N0F8lvxKlGOfVlIvYf0gglAKm2NZ7QzG3AEanEZ
nCoo26hzU4MHopTE2blgV98RZ9yt3y1Hlj8/nrT6+yObdwvMo+hkPdEwLFj+3V0J
EnikZ/TRTquOWhBBrIeKlHx0oNKQyNQwdfx3ZEpfsZFyCmMwk7rLsPQUk5XNO369
0yCjcce8j+SMiNNxRUhYEBvzSk4z1DKe6tbIuMqXMCb9m1NCpRErzSMPWaQA3nL8
Lkn7H9GUlMCKhwGhq9DD
=CBqf
-----END PGP SIGNATURE-----

--NewAHV8kqOmra7cQQCBlVJiqLEBSN05IK--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
