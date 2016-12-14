From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core] qede: fix general protection fault may occur on
 probe
Date: Wed, 14 Dec 2016 11:26:24 -0500
Message-ID: <e7a2c128-6564-bf6b-b97d-99b55f0b41fe@redhat.com>
References: <1477400039-16925-1-git-send-email-Ram.Amrani@cavium.com>
 <SN1PR07MB2207D200A1EF95EBFAAEBCFFF8BD0@SN1PR07MB2207.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Vaxqd9049S0k9A60AoqPBfHpWgQbNRiWK"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <SN1PR07MB2207D200A1EF95EBFAAEBCFFF8BD0-mikhvbZlbf8TSoR2DauN2+FPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Mintz, Yuval" <Yuval.Mintz-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Vaxqd9049S0k9A60AoqPBfHpWgQbNRiWK
Content-Type: multipart/mixed; boundary="5WOAgK8QCdMNJgVt0NvsDCumdkARX7Dgj";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>,
 "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>,
 "Mintz, Yuval" <Yuval.Mintz-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>,
 "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <e7a2c128-6564-bf6b-b97d-99b55f0b41fe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core] qede: fix general protection fault may occur on
 probe
References: <1477400039-16925-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
 <SN1PR07MB2207D200A1EF95EBFAAEBCFFF8BD0-mikhvbZlbf8TSoR2DauN2+FPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
In-Reply-To: <SN1PR07MB2207D200A1EF95EBFAAEBCFFF8BD0-mikhvbZlbf8TSoR2DauN2+FPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>

--5WOAgK8QCdMNJgVt0NvsDCumdkARX7Dgj
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 11/13/2016 11:42 AM, Amrani, Ram wrote:
>> The recent introduction of qedr driver support in qede causes a GPF wh=
en
>> probing the driver in a server without a RoCE enabled QLogic NIC. This=
 fix avoids
>> using an uninitialized pointer in such a case. Caught by the kernel te=
st robot.
>>
>> Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
>> ---
>>  drivers/net/ethernet/qlogic/qede/qede_roce.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/qlogic/qede/qede_roce.c
>> b/drivers/net/ethernet/qlogic/qede/qede_roce.c
>> index 9867f96..4927271 100644
>> --- a/drivers/net/ethernet/qlogic/qede/qede_roce.c
>> +++ b/drivers/net/ethernet/qlogic/qede/qede_roce.c
>> @@ -191,8 +191,8 @@ int qede_roce_register_driver(struct qedr_driver *=
drv)
>>  	}
>>  	mutex_unlock(&qedr_dev_list_lock);
>>
>> -	DP_INFO(edev, "qedr: discovered and registered %d RoCE funcs\n",
>> -		qedr_counter);
>> +	pr_notice("qedr: discovered and registered %d RoCE funcs\n",
>> +		  qedr_counter);
>>
>>  	return 0;
>>  }
>> --
>> 1.8.3.1
>=20
>=20
> Hi Doug,
> Can you update if this patch taken and if not, when do you expect it wi=
ll be?

This patch no longer applies.  But, more importantly, it's a patch to
the ethernet side of the driver and should go through Dave Miller anyway.=



--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--5WOAgK8QCdMNJgVt0NvsDCumdkARX7Dgj--

--Vaxqd9049S0k9A60AoqPBfHpWgQbNRiWK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYUXKwAAoJELgmozMOVy/dgmgP/0+XzQ0UMojoURzmgO8iVC97
ZSJjxVek35DxfwyIWUzQQFlrZJsWYMi1+HAPjhYJLU0GxJYMMBbZbTfoMWaXbShd
Y3af48YTzQbvdUchfwdmTEYpIablrFd2lS9MaN6KLnXjuSNMLwPhZIeJkWY5NE4s
NeoZXEGTL+quPmrEMKvAdOG7Kgcq7Gf/u2d5X4NTDOeLdQvniVA8xHN4QMC4NGKu
RVREmHwU9FD6u/0csoBd1hROrrpih7DPIiCODUVkxY6ZuNkhS+i9OfT5XePlKK2/
pgqsg41jhpIOhjHCeiYiL9HOCVKmvmg5IzOwMnQIbkyziFlB/8a9gfBFM+DFcTCd
XhOeua1zQ3Pn2WsiuqSw3mbVkpwtcSg/qsehHVjaJMUwccQmVDR0pYBZxw96CCLx
7akYqOo7O9qcOgda/W+7gRPQtMoBUeVo+fj00R6rIPImA87V7X65uhIBFPYtdlHh
a3qp0VA6V8mn8uxblu0m5bLtVGEnRYPordZhIs7jZJm6Qf6QXjbja00DLAAuUfG7
FyOGGONLWLpCDEzERnm31gc96Eg3wHUfTlR9yAmHSAvm8KpUikRXT4VeG/txKsCp
BCRcbsDLThWcIBBwVM+GxY36PekqYwWsg+nWPNynG85L5VfkovTGnb52sX9GmUHi
XPNc6Pgc2v/dKgmRLOUM
=zDga
-----END PGP SIGNATURE-----

--Vaxqd9049S0k9A60AoqPBfHpWgQbNRiWK--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
