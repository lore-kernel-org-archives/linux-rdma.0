From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch] IB/cma: allocating too much memory in make_cma_ports()
Date: Tue, 19 Jan 2016 15:59:15 -0500
Message-ID: <569EA3A3.5080105@redhat.com>
References: <20160112092921.GB29804@mwanda>
 <CAAKD3BDw8422EjzChtU23u4gKx-vegCxBuwKkLhXL1ySmACRxw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="0lcCE47kENjhicin0fW5G06J4v6lhmKWk"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAAKD3BDw8422EjzChtU23u4gKx-vegCxBuwKkLhXL1ySmACRxw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--0lcCE47kENjhicin0fW5G06J4v6lhmKWk
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 01/12/2016 08:08 AM, Matan Barak wrote:
> On Tue, Jan 12, 2016 at 11:29 AM, Dan Carpenter
> <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>> The issue here is that there is a cut and paste bug.  When we allocate=

>> cma_dev_group->default_ports_group we use "sizeof(*cma_dev_group->port=
s)"
>> instead of "sizeof(*cma_dev_group->default_ports_group)".
>>
>> We're bumping up against the 80 character limit so I introduced a new
>> local pointer "ports_group" to get around that.
>>
>> Fixes: 045959db65c6 ('IB/cma: Add configfs for rdma_cm')
>> Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> ---
>> Not tested.
>>
>> diff --git a/drivers/infiniband/core/cma_configfs.c b/drivers/infiniba=
nd/core/cma_configfs.c
>> index bd1d640..18b112a 100644
>> --- a/drivers/infiniband/core/cma_configfs.c
>> +++ b/drivers/infiniband/core/cma_configfs.c
>> @@ -158,6 +158,7 @@ static int make_cma_ports(struct cma_dev_group *cm=
a_dev_group,
>>         unsigned int i;
>>         unsigned int ports_num;
>>         struct cma_dev_port_group *ports;
>> +       struct config_group **ports_group;
>>         int err;
>>
>>         ibdev =3D cma_get_ib_dev(cma_dev);
>> @@ -168,12 +169,9 @@ static int make_cma_ports(struct cma_dev_group *c=
ma_dev_group,
>>         ports_num =3D ibdev->phys_port_cnt;
>>         ports =3D kcalloc(ports_num, sizeof(*cma_dev_group->ports),
>>                         GFP_KERNEL);
>> +       ports_group =3D kcalloc(ports_num + 1, sizeof(*ports_group), G=
FP_KERNEL);
>>
>> -       cma_dev_group->default_ports_group =3D kcalloc(ports_num + 1,
>> -                                                    sizeof(*cma_dev_g=
roup->ports),
>> -                                                    GFP_KERNEL);
>> -
>> -       if (!ports || !cma_dev_group->default_ports_group) {
>> +       if (!ports || !ports_group) {
>>                 err =3D -ENOMEM;
>>                 goto free;
>>         }
>> @@ -187,15 +185,16 @@ static int make_cma_ports(struct cma_dev_group *=
cma_dev_group,
>>                 config_group_init_type_name(&ports[i].group,
>>                                             port_str,
>>                                             &cma_port_group_type);
>> -               cma_dev_group->default_ports_group[i] =3D &ports[i].gr=
oup;
>> +               ports_group[i] =3D &ports[i].group;
>>         }
>> -       cma_dev_group->default_ports_group[i] =3D NULL;
>> +       ports_group[i] =3D NULL;
>> +       cma_dev_group->default_ports_group =3D ports_group;
>>         cma_dev_group->ports =3D ports;
>>
>>         return 0;
>>  free:
>>         kfree(ports);
>> -       kfree(cma_dev_group->default_ports_group);
>> +       kfree(ports_group);
>>         cma_dev_group->ports =3D NULL;
>>         cma_dev_group->default_ports_group =3D NULL;
>>         return err;
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" =
in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
> Hi,
>=20
> This is already fixed in [1].
> Anyway, I'm fine with either one of them.
>=20
> Acked-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> Regards,
> Matan
>=20
> [1] http://www.spinics.net/lists/linux-rdma/msg32152.html
>=20

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--0lcCE47kENjhicin0fW5G06J4v6lhmKWk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWnqOjAAoJELgmozMOVy/dDsgP/13T7uARtNVjvUu0hZ7IbV8P
331yZHL4aZZXlifOPjJwOTdGJsw7WS0p/2A/JdpZ4qYNL6qVFv1AI9H4rUBk4q74
1Ad1UB3DG7PD+fE2o0D0LIGFB/pjYORHHRepwp2arDOLrvwC6BiRnfMdU1MuYg6W
85IUDUXcfRaCt78gnn0e45ugf4zVqLkqnBfZVE9ksHHzQ2v7T0JxzGGkj89YvC8E
qn9CRt0tFHh+Fesffy+vRsXg2RK74D5wk2Yo+OaR3emHe9cmpKNlRsMzCFQQ831I
RSimpVWe/AgLL9w30LGJbptbwydzh3t5BsJrnTrcoD65bfBKPUFyvMGkTBz9A5Ue
aHZyhbTNhxRB6/owgxvH/Mct6AezkROQYJ9aY7PEY7FMPVbjJobbh0h3YGcS5rYM
wLBZCBHK5qZ0Bv5nz2SKyRqsqJVLK1XOrCM3ajzpvBbrzY2SBuutSYjQmU/6i40B
tDVupIbPH4/+pMHBdUMrEaFj1e343BnDuMbYGE2iJzz4OkyFl6tr+AV9FqBgPyX9
aTXfytqYdw8byHpXWgN2eRxzPmxKQznM2Ggirx9gjVaKtI8W5rdt20+q8EVgJSid
6S599Oop1eVXwNc5N0ArqeRSeSTTA4+qIHpZFa9jI7dNQJDh4tu75u05L1pMUkhz
NgaXPpZ5uKLZKwSGyQ4E
=OgvA
-----END PGP SIGNATURE-----

--0lcCE47kENjhicin0fW5G06J4v6lhmKWk--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
