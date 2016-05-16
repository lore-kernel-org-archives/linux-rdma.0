From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next] IB/mlx5: Support RAW Ethernet when RoCE is
 disabled
Date: Mon, 16 May 2016 11:14:03 -0400
Message-ID: <f0e2e407-5a32-b5fb-1ff0-86a9bb4faa88@redhat.com>
References: <1463317066-29900-1-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="jld2kf9NKl7XuseQOD0NTCegQOLr2sGAJ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1463317066-29900-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--jld2kf9NKl7XuseQOD0NTCegQOLr2sGAJ
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 05/15/2016 08:57 AM, Or Gerlitz wrote:
> On some environments, such as certain SRIOV VF configurations, RoCE is
> not supported for an Ethernet port. Currently, the driver will not
> open IB device on that port.
>=20
> This is problematic, since we do want user-space RAW Ethernet (RAW_PACK=
ET
> QPs) functionality to remain in place. For that end, enhance the releva=
nt
> driver flows such that we do create a device instance in that case.
>=20
> Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

So this device is still going to present itself as a uverbs# device and
libibverbs is still going to try and access it, but when it comes time
for user applications to try and use it they will simply fail all QP
types except for RAW?  Is there no way to distinguish between a device
with RoCE enabled and without?


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--jld2kf9NKl7XuseQOD0NTCegQOLr2sGAJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXOeO7AAoJELgmozMOVy/d/z4P/RYssssLP2eWTB2wmr69XUP6
YlFQv4rwLAiguZ4rM6bqmta8GKvI/p3WeSFiIAtyJLOpo1Cnmhky895nt7H77v6M
Zf5bDKNGBd4EPcJOluBSoCfhPLhGoXr93DkqZ8ZB5jV7XU9KaJDIfwuM6DH9jBGv
t/fFGVFgKIzLwNy52A70ks3QFtN+YcC6krd8zPKPnbgRy//lBM6wMeCDx+D7Xb47
A1IrXUdrLeWH07W5xWUv+oo/CNOOtLFV8VfUS0x7+BKqGeORjtrQceVvyvLzhbzJ
wOgfdQS0yUY7ylwBkBVwd6X3Xa0UxcCZZ5dyFNdLPPMPWL3FV8gzAyP3jSILRsJs
M95dTy3vK7iqE+z4B+47n1SuGgEM9eNbOHrK2HdjMlQmGO409UMP2/x1bZOWpJyv
ooesgeCtisWCM0wg4M4v8LTb3w8GaiF3jlw1UBGVz/1bZzPWghAPnRWwLEKH7Uhx
VhJaNbCo5klwUtWNeftFHB3cdxZTpFQB/vRCjAqHeQxf6+lfkFQ7j5daWw4RQ08O
QLHNwXL9MiOYAagTd8AfLcyYzdOzJhL9F9z0KbUR8apYN5OJhZPwtKnzWu+XO9oS
lRC0KoDROXIBqaz5swfpYjWbvW9zCvXqF6ypFg4CrD6RujbEO2kv+NBfgj+kF6/A
n7GYeN5Tuy40cqV/YDgb
=vMkj
-----END PGP SIGNATURE-----

--jld2kf9NKl7XuseQOD0NTCegQOLr2sGAJ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
