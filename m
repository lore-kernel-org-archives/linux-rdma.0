From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/cm: Do not queue a work when the device is going to
 be removed
Date: Thu, 09 Jul 2015 10:45:03 -0400
Message-ID: <559E88EF.4040303@redhat.com>
References: <1435241602-12104-1-git-send-email-erezsh@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="KPAu3dLBue0cO7tdSohfj1uJivAwfk9ce"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1435241602-12104-1-git-send-email-erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--KPAu3dLBue0cO7tdSohfj1uJivAwfk9ce
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 06/25/2015 10:13 AM, Erez Shitrit wrote:
> Whenever ib_cm gets remove_one call, like when there is a hot-unplug
> event, the driver should mark itself as going_down and confirm that no
> new works are going to be queued for that device.
> so, the order of the actions are:
> 1. mark the going_down bit.
> 2. flush the wq.
> 3. [make sure no new works for that device.]
> 4. unregister mad agent.
>=20
> otherwise, works that are already queued can be scheduled after the mad=

> agent was freed.
>=20
> Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks, applied.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--KPAu3dLBue0cO7tdSohfj1uJivAwfk9ce
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVnojvAAoJELgmozMOVy/d1cwP/AylB7dN61lhs47CpuCaQAtC
KpS6JidxIHCd6dSSt7VNLYdRGgHTPkA7t+fTKKvPPxA9vbFdRmJejIqWqCn54+KK
JFqPqieY3EIteubDZrP97Kxa6HB6B0nRrirkJdK2fNxBw2qt9sEiRwc8GYOmpB99
JMEIqfUOzkugIDTAibkhSMWeR6By1IPQTFrBXHwQ1ErFllWxNIkGmFHIFGFtt+69
0NOFLIUiFK8pDIK6b6Jg++eODGRr1x/cj92vr/ccc82PJTjgrFzRq13EBKIw+XTh
3QZnQd1D5O9YT6Jglm6XhXadAuQcEXCwsmQhz11r42wwzyVKpGq9WwxqVRrd/HEh
cgYmB3u9H6vrOt7fg585NXcOL9hGiIfVJ5dJYWJgqwnW3UISILba5nZwvSvwbPfV
QGmrrW+Oqi8E3XljG9PRFZDjRCBVN0g1cknbmTY/cgs32LtqA108lN/J5pPOVms5
XWBEldXiV/PQLvtLHC2P8sCrO72a8GF+iO5DMtyG3di5LNfCLlPSx1t9sqf2Gvqt
Y42OJQIzJD28of9qlbT4oLCXB0BRguOuCnLsYEmjYNAY4i085aaPNbnOemVn64z+
f+qjPRiAyqNT6sQHS25V37IF1wnL9B5kC/wXQaTXdToD96MkOnzHp16nwc8rLBpp
hNr6+FFn1KasytbVZVvr
=FAxb
-----END PGP SIGNATURE-----

--KPAu3dLBue0cO7tdSohfj1uJivAwfk9ce--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
