From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] nes: handling failed allocation when creating workqueue
Date: Thu, 18 Feb 2016 12:45:43 -0500
Message-ID: <56C60347.7040506@redhat.com>
References: <1455732393-11029-1-git-send-email-wuninsu@gmail.com>
 <20160218045905.GF30450@leon.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="fFViqQ1N8EBhP0UU4xSSCE2FJQAqThgJC"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160218045905.GF30450-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Insu Yun <wuninsu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, taesoo-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org, yeongjin.jang-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org, insu-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org, changwoo-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--fFViqQ1N8EBhP0UU4xSSCE2FJQAqThgJC
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 2/17/2016 11:59 PM, Leon Romanovsky wrote:
> Please see my minor comments below.
> Reviewed-by: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
>=20
> On Wed, Feb 17, 2016 at 01:06:33PM -0500, Insu Yun wrote:
>> Since create_singlethread_workqueue uses kzalloc internally,=20
>> it can be failed in memory pressure, so need to handle it.
>=20
> s/can be failed/can fail/
>=20
>>
>> Signed-off-by: Insu Yun <wuninsu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>>  drivers/infiniband/hw/nes/nes_cm.c | 13 ++++++++++++-
>>  1 file changed, 12 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/h=
w/nes/nes_cm.c
>> index cb9f0f2..23afad6 100644
>> --- a/drivers/infiniband/hw/nes/nes_cm.c
>> +++ b/drivers/infiniband/hw/nes/nes_cm.c
>> @@ -2833,7 +2833,7 @@ static struct nes_cm_core *nes_cm_alloc_core(voi=
d)
>>  	/* alloc top level core control structure */
>>  	cm_core =3D kzalloc(sizeof(*cm_core), GFP_KERNEL);
>>  	if (!cm_core)
>> -		return NULL;
>> +		goto enomem_3;
>=20
> IMHO, there is no need to define goto label for one return.

I made the touchups Leon suggested, and a touchup of my own, but it is
now applied, thanks.



--fFViqQ1N8EBhP0UU4xSSCE2FJQAqThgJC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWxgNHAAoJELgmozMOVy/d1rAP/2FsU02Cd3gI7lITXF2wed34
GY9F1yyWCZjw1Q2unJuvW24P269vwMruGQYnc8hi3bc0ZJ45pZij/o3u2CtWtdQ+
5J1k3NhPExT22dQe2xkaXsayQrviFrO4AEUQEPA4FMmSJzgTCtJEW/eBk12nBsRO
s1nvhuEdOWRpV6QDZE4f7QnRsVZwd2NEJ7+sa8fgRzSFIYmQSQsUOyDqZccZTU6N
NeAWXO6dKjMcZtjpmu8pBoEnRIm6VgOmmNxgo+kzgRPFV983f8NiZypxwB96/XiG
fgeHZG+Sv9W5tmE9eOm9QEzAfAYerOAyndRNfvcnq6HSovaU5hRmfBpVCOjunUhZ
3mPPZ3gYBu/Yymfpfg1AMKsYkvIcHwdg+8Qv72PySRymTtJ+s5qMaAgULtbemFYI
OREoEb/Z6OLrFI4uauFT9hLmm+ATkgbvJr73E1xcZhyRC6O6tFP4mxJ3D/t/2rrb
v4bUeqYPTCwe+bUKxkGB09++nwGLAiXpngVQnEPadIBFzkwG325b0XHz4sH03Uz3
dtEMuedF7X7MQQIjwNdiYgJUqyiHqHViGETtHYFZJODwV/4soOyG9e/9izKgh9n5
mx6/zrDASKgfZdxlThLnaXaMig0NfjvxyCGilJKKF4vBmrBIlkjOzJDuxUKpo8ck
swh56WSsH5PtKAf/2N3D
=m+N3
-----END PGP SIGNATURE-----

--fFViqQ1N8EBhP0UU4xSSCE2FJQAqThgJC--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
