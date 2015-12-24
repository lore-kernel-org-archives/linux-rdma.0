From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next V2 0/5] User-space time-stamping support for
 mlx5_ib
Date: Wed, 23 Dec 2015 23:35:36 -0500
Message-ID: <567B7618.5000106@redhat.com>
References: <1450204213-5630-1-git-send-email-matanb@mellanox.com>
 <CAJ3xEMiJJ0HcxDn_xfPDRK8V1cfN5HNVm9dt6gPaw2iJwD8jhA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="5tGTigFdapqwotBreqdC7wSpKKmqfOP4P"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMiJJ0HcxDn_xfPDRK8V1cfN5HNVm9dt6gPaw2iJwD8jhA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--5tGTigFdapqwotBreqdC7wSpKKmqfOP4P
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 12/23/2015 12:16 PM, Or Gerlitz wrote:
> On Tue, Dec 15, 2015 at 8:30 PM, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrot=
e:
>=20
>> This patch-set adds user-space support for time-stamping in mlx5_ib.
>> It implements the necessary API:
>> (a) ib_create_cq_ex - Add support for CQ creation flags
>> (b) ib_query_device - return timestamp_mask and hca_core_clock.
>=20
>> We also add support for mmaping the HCA's free running clock.
>> In order to do so, we use the response of the vendor's extended
>> part in init_ucontext. This allows us to pass the page offset
>> of the free running clock register to the user-space driver.
>> In order to implement it in a future extensible manner, we  use the
>> same mechanism of verbs extensions to the mlx5 vendor part as well.
>=20
> Hi Doug,
>=20
> As Matan is now the maintainer of the mlx5_ib driver and this series
> doesn't add any IB/core changes, we see no reason that it can't go
> into 4.5. make sense?

I didn't see anything wrong with the set.  It's been picked up for 4.5.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--5tGTigFdapqwotBreqdC7wSpKKmqfOP4P
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWe3YYAAoJELgmozMOVy/dAn4QAIz9lop4AxE2gbj+Jd9z7w/w
k1N8gSJetWORGN6xXhKe747+qsgeRUG8lcl/yoZlU4p7W7I+4d/wSSnxV/ckvKnO
r8AgX9wdrPZVqe33VxxajWm2Kyok/RobpkHy+3R1p36tR6OH46AJIKgoAP+YQ3wi
X9ankTeBvaxjUMGFs7N+lGktsoLa3A4L9iGkOnlz9i07/FBfRZ2klvVr8juyFeq9
A7FGYy8Ax4XEJQ3nWQPAQ5nX53IUDoEc19ICBw9zpu0c1d7MEdJWDk1FIzvqHpGy
T6eKJ6bACfsVvsXcDk7tyhAbYEN3KGwlHw5FM9I93dLQtX2zwBKuf/fe+njyMmYr
bmJNhTXhdfiq/Hp5QuC8QuNHisGqN7dewHAFxNBzfxS8JhK2zoicTKzkp8UVj38z
FVP5sqH+DREqrE93KveYJXuVuqbedNVDqrYkgBNAiZB/RJ8wv4xx05u6Sso3bQjJ
hhrCwffq+/HgXarAJGolLr9qJUSPNNhN38pv4PygxE+MEncc4/yqxfEaPb2OdjUg
Iap3APo58WTp0xHEbsY0mG3+zOU5vuLgGVebP4OAvH3PdT1wpka2nqF2PcAtzPbR
CtOa9Yt3x9no9KLeBe5apB869Xt8VDaVXyG3wCmE8ACDp/KY2E0jbNeNJJoP8IWf
1rIRbNZtYnW+70OXxQmP
=IWId
-----END PGP SIGNATURE-----

--5tGTigFdapqwotBreqdC7wSpKKmqfOP4P--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
