From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] IB/cxgb4: Mark symbols static for _free_qp
Date: Fri, 2 Sep 2016 13:23:47 -0400
Message-ID: <496842ea-a04f-431b-5eee-6ef6535375ee@redhat.com>
References: <1472396231-16937-1-git-send-email-baoyou.xie@linaro.org>
 <004001d20201$448119e0$cd834da0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="hfXHp4maHOdWL5oCO7CotNmMbBDcNsJhV"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <004001d20201$448119e0$cd834da0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Baoyou Xie' <baoyou.xie-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, arnd-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, xie.baoyou-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--hfXHp4maHOdWL5oCO7CotNmMbBDcNsJhV
Content-Type: multipart/mixed; boundary="QdmxHnDg005JeXkGWhlpjqqqH4lKqx6Mg";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>,
 'Baoyou Xie' <baoyou.xie-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org,
 hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 arnd-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, xie.baoyou-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org
Message-ID: <496842ea-a04f-431b-5eee-6ef6535375ee-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] IB/cxgb4: Mark symbols static for _free_qp
References: <1472396231-16937-1-git-send-email-baoyou.xie-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
 <004001d20201$448119e0$cd834da0$@opengridcomputing.com>
In-Reply-To: <004001d20201$448119e0$cd834da0$@opengridcomputing.com>

--QdmxHnDg005JeXkGWhlpjqqqH4lKqx6Mg
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 8/29/2016 10:26 AM, Steve Wise wrote:
>> Subject: [PATCH v3] IB/cxgb4: Mark symbols static for _free_qp
>>
>> We get 1 warning when build kernel with W=3D1:
>> drivers/infiniband/hw/cxgb4/qp.c:686:6: warning: no previous prototype=
 for
>> '_free_qp' [-Wmissing-prototypes]
>>
>> In fact, this function is only used in the file in which it is declare=
d
>> and don't need a declaration, but can be made static.
>> so this patch marks it 'static'.
>>
>> Signed-off-by: Baoyou Xie <baoyou.xie-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> Ignore my comment on v2...
>=20
> Acked-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
>=20

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--QdmxHnDg005JeXkGWhlpjqqqH4lKqx6Mg--

--hfXHp4maHOdWL5oCO7CotNmMbBDcNsJhV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXybWjAAoJELgmozMOVy/d89QP/3I5hCXed95bL2FNubOhHuQF
0MeU6jCQkFnYHYsKIbIEyCI0b63VzOCN/HqglyWj5DNj+NarZsUQOGCB1Q5wybot
Fhc3h+WZirkLCSDpfvbqjlGraW9MQ6D07o2qjYZbiaucMIxgKAlfYh1BABYzonUv
q/x+ADjM0bUTt2oGWE3olLehua+7fJ42MV9jvnIomedrskWTmWi7k39KjT+d8BV2
aHl8kMiPCmP3JFo5qzMyAtOPIepOvGJqqhvWd6x68vdrmn01mSJOl4LWZXETjtIg
SYgBYgrSS2apB0axOhNh5wU6a8GLZZndYOgjNrYy8nMJVUCm4ShByx8BZewzuzqx
lQ3+GMza/VP+9ufOfztt66YC+vUJsdQotKHDG/dt5TdD9r8wC9lOCk2a/Xtmu173
sF2/x+HOuKFc8kazJbeVpokB6WDlFkIMGvq0ijeIB412vnLtaXN/mdMj0HUHV44F
q8kJgHHFPBoqvqWYdoP68NrTfkjF+KK8rh73xWdMwtgkmzqFhJLxDv1+nAxh/i+9
Su/qomo/DGeVT55YQuM3Pagg1iqzklcS23FqyrBaMthAqluPEggSv0GmNT3aJSnK
8tphBL9/NInfGc2h0scJ7OqkbchS9HuwETiW52cW8pXcvU2+KvbJDiIrngKAbJCK
w1QPkWQoCJtvCuX641op
=ddK6
-----END PGP SIGNATURE-----

--hfXHp4maHOdWL5oCO7CotNmMbBDcNsJhV--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
