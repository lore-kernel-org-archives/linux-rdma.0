From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next V1 2/3] IB/core: RoCE GID management separate
 cleanup and release
Date: Fri, 14 Aug 2015 17:56:11 -0400
Message-ID: <55CE63FB.9080809@redhat.com>
References: <1438607342-11964-1-git-send-email-matanb@mellanox.com>
 <1438607342-11964-3-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="VFHhNKDej8aC0cbq8NiD9mVUQrdUeP3VK"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438607342-11964-3-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Somnath Kotur <Somnath.Kotur-idTK6quXuVSLFuii7jzJGg@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--VFHhNKDej8aC0cbq8NiD9mVUQrdUeP3VK
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 08/03/2015 09:09 AM, Matan Barak wrote:
> Separate the cleanup and release IB cache functions.
> The cleanup function delete all GIDs and unregister the event channel,
> while the release function frees all memory. The cleanup function is
> called after all clients were removed (in the device un-registration
> process).
>=20
> The release function is called after the device was put.
> Although vendor drivers aren't expected to use IB cache in their
> removal process, we postpone freeing the cache in order to avoid
> possible use-after-free errors.
>=20
> Squash-into: 'IB/core: Add RoCE GID table management'
> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

I squashed this after applying Jason's follow-up patch first in the
series and fixes up the conflicts.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--VFHhNKDej8aC0cbq8NiD9mVUQrdUeP3VK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVzmP7AAoJELgmozMOVy/d5JsQALCD99UJXrddeT3aXuQTY/8Z
YvwE+8sZR+wCA6Xw/N3LxBFKQhiZ5C4j0KcNzCbJMTMp8T0senHov6vVSfh3ovYQ
zKiGL9JKMdJpOlT4Apozu6rv9DszalFctPTVvUVJCoVmPnsKOzNTuwAgJ3ZCXVcR
xJ6t/6EKd99eaz1W7ElursGhKf80u5uCHhP4fzIO7h8AW1uQAbW3nrVFovQp9G8m
sXVqwm0G34/dghKq63X7Brg66PuBco2sHdqxmn8FfquZCSS/sLlBKTp+/xwFkf0l
A4vmOqHFAE94K2GUdVDM2W15SMj6dEz2JRo47Xmdoexi21Xzh6CT4jrR4cuX/Wbr
3+6c7ewBKJZcyg8VbFkU8bohDUzrpojsEqwMTMWXJfU407kLTAwWx1dIKVOmKQoq
D1fmQEVk15Z5FKVBVb9GDQO6dGafu4bkw1XjqDBXXiumHrxfJhEe0qn5LlwcMsgR
gSltowDj1DaAYtfG/yU94FQLbFqM/0Q8a/cItBjYJHszwUMd91ksCZ2GiQDdSVOQ
4Wqriv694lrdgRwxmGGo9+GiS35HCZ63Rg0dL+p/JmXklliXhvjP7Z5JRM9/dTIQ
npSBMEmsCA0Vr3GktNbjPxVJTcddVflIPC0p7+GZnm0WoA2fZqNd6a/cgVyq99a1
J8ascp0YpBoeRF6oW+To
=bmXR
-----END PGP SIGNATURE-----

--VFHhNKDej8aC0cbq8NiD9mVUQrdUeP3VK--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
