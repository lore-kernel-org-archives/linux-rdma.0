From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/mlx4: Fix memory leaks related to updating GIDs
Date: Fri, 14 Aug 2015 16:36:37 -0400
Message-ID: <55CE5155.7050406@redhat.com>
References: <55BF9F11.6050708@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="MNsUV81WXpGjt3eIxF4BGO6Vcv6kx9eUn"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55BF9F11.6050708-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--MNsUV81WXpGjt3eIxF4BGO6Vcv6kx9eUn
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 08/03/2015 01:04 PM, Bart Van Assche wrote:
> Fix the memory leaks in update_gids_task() and reset_gids_task().
> kmemleak reported one of these leaks as follows:
>=20
> unreferenced object 0xffff88044576d668 (size 4096):
>   comm "softirq", pid 0, jiffies 4294942043 (age 976.560s)
>   hex dump (first 32 bytes):
>     00 02 00 00 00 00 00 00 70 d6 76 45 04 88 ff ff  ........p.vE....
>     70 d6 76 45 04 88 ff ff 60 d6 2d a0 ff ff ff ff  p.vE....`.-.....
>   backtrace:
>     [<ffffffff814f2f1e>] kmemleak_alloc+0x4e/0xb0
>     [<ffffffff811b0678>] kmem_cache_alloc_trace+0xc8/0x2d0
>     [<ffffffffa02e061e>] reset_gid_table+0x2e/0xe0 [mlx4_ib]
>     [<ffffffffa02e1c59>] mlx4_ib_netdev_event+0x449/0x450 [mlx4_ib]
>     [<ffffffff814011ca>] register_netdevice_notifier+0x8a/0x1c0
>     [<ffffffffa02e173b>] mlx4_ib_add+0x106b/0x1140 [mlx4_ib]
>     [<ffffffffa00dc3d1>] mlx4_add_device+0x41/0xa0 [mlx4_core]
>     [<ffffffffa00dc4bc>] mlx4_register_interface+0x8c/0xf0 [mlx4_core]
>     [<ffffffffa02fc056>] ext4_has_free_clusters+0x6/0x170 [ext4]
>     [<ffffffff8100211d>] do_one_initcall+0xad/0x1e0
>     [<ffffffff814f7238>] do_init_module+0x61/0x1ec
>     [<ffffffff810f95f2>] load_module+0x1d42/0x26b0
>     [<ffffffff810fa150>] SyS_finit_module+0x80/0xb0
>     [<ffffffff81502332>] entry_SYSCALL_64_fastpath+0x16/0x7a
>     [<ffffffffffffffff>] 0xffffffffffffffff
>=20
> Fixes: fa417f7b520e ("IB/mlx4: Add support for IBoE")
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org # v2.6.37

Thanks, I've picked this up.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--MNsUV81WXpGjt3eIxF4BGO6Vcv6kx9eUn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVzlFVAAoJELgmozMOVy/dpugP/i2ROyM6WWEarNIXxV+PtvFS
Fq53mQwaFMKeytqXgZXUXGxwhHhqesimAHBi2Guzkqah4QRQ/mw8Jh+Zg+9y6IyR
WUAbBTONkMhXHswR4379faMKbuI2JjmZiArZH3Wco7xTxWFIq10Tkc6MgPUg+59U
uGAAqm4SyR9FMEcZPt/Sv20GajtqpQ6kBWo1vIm2QqHVJCF82fz4bHFFY/RTRskr
75KcUZk8APKzJq2rVSf+XyaH2Q8ni0sZ35LUDhHypSyHZIdmRqh4fx/ervsYKrYF
RH20RAy8kepzZL7d+rvEmgFpznxRnig1cvOslZrGtE/zHTkAP0yuo0owGkhKt2eK
I+Hgg2VB2rkpK45p8hok6ljdt8+IDkiUPKDR/NKXM5chVSBp4YYZ6kmSZwwJoGxI
XTGec7sUgqfErtg1A21SXVd0tiReHfImfyxEGG4DNUfETsOYceyAZ7KROmEP2urn
MDeDSYB3bLXH02ywR9nuUkJpWcduD4eShdkvoWCvn1+pf4xswHKgcK9G5s21Bw4N
phKLFSODzE1k6PMYsKWtmCpFxmjd8axRKLII5iDeMFP92Yx3Jju8csUjdPtOaNDc
Bq3cZhTaAf0PVKqDalzvt1YO9f8LGoxNttillk7Yuiarstu42yTD8OHdVI6CfkSe
d6o3WZgpVrNDL1Wq/Tfk
=IgDQ
-----END PGP SIGNATURE-----

--MNsUV81WXpGjt3eIxF4BGO6Vcv6kx9eUn--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
