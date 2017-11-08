From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: =?utf-8?Q?=E3=80=90OFED_bug_confirm?= =?utf-8?B?44CR?=
Date: Wed, 8 Nov 2017 07:27:29 +0200
Message-ID: <20171108052729.GP18825@mtr-leonro.local>
References: <700cdd5e-3342-792e-506b-7ef9f60097ba@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Osvg0bgWkLaeQPMj"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <700cdd5e-3342-792e-506b-7ef9f60097ba-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Osvg0bgWkLaeQPMj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 08, 2017 at 11:20:06AM +0800, oulijun wrote:
> Hi, everyone
>    I am test CM based kernel-4.14-rc5 and met a bug.
>    I analyse that it maybe is a ib core bug. hence, I find a patch and this patch is not exist in kernel-4.14-rc5
>     IB/CM: fix memory corruption by avoiding unnecessary memset

Yes, I sent that patch to rdma-next, because it needs go to stable@.

Thanks

>
>
> the calltrace print as follows:
> [  784.353974] ------------[ cut here ]------------
> [  784.361184] WARNING: CPU: 0 PID: 25 at ./include/rdma/ib_verbs.h:3799 cm_req_handler+0xcd8/0xd18 [ib_cm]
> [  784.371032] Modules linked in: hns_roce_hw_v2 hns_roce rdma_ucm rdma_cm iw_cm ib_uverbs ib_cm ib_core
> [  784.382150] CPU: 0 PID: 25 Comm: kworker/0:1 Not tainted 4.14.0-rc5-g25886d7-dirty #34
> [  784.391263] Workqueue: ib_cm cm_work_handler [ib_cm]
> [  784.396734] task: ffff80003d969c00 task.stack: ffff000009308000
> [  784.403499] PC is at cm_req_handler+0xcd8/0xd18 [ib_cm]
> [  784.409439] LR is at cm_req_handler+0x32c/0xd18 [ib_cm]
> [  784.415022] pc : [<ffff000000a28b88>] lr : [<ffff000000a281dc>] pstate: 00c00149
> [  784.422704] sp : ffff00000930bca0
> [  784.426308] x29: ffff00000930bca0 x28: ffff80003d982100
> [  784.432184] x27: ffff8000081f98b0 x26: ffff8000081f98c8
> [  784.438014] x25: ffff80003d8ce400 x24: ffff800007f6a6e8
> [  784.443830] x23: 0000000000000000 x22: ffff000000a2b600
> [  784.449641] x21: ffff8000081f9600 x20: ffff800007f6a6e8
> [  784.455435] x19: ffff8000081f9800 x18: 0000000000000001
> [  784.461244] x17: 0000000000000000 x16: ffff000008b56c30
> [  784.467024] x15: 0000000000000000 x14: 0000004000000000
> [  784.472835] x13: ffff00000903ef80 x12: ffffffffffffffff
> [  784.478634] x11: 0000000000000040 x10: 0000000000000a00
> [  784.484469] x9 : 0000000000000000 x8 : ffff8000081f9c00
> [  784.490262] x7 : 0000000000000000 x6 : 0000000000123456
> [  784.496061] x5 : ffff80003d8ce400 x4 : 5348060100000000
> [  784.501842] x3 : ffff800007f6a668 x2 : 0000000000000000
> [  784.507638] x1 : 00000000665f736e x0 : 00000000665f736e
> [  784.513489] Call trace:
> [  784.516363] Exception stack(0xffff00000930bb60 to 0xffff00000930bca0)
> [  784.523257] bb60: 00000000665f736e 00000000665f736e 0000000000000000 ffff800007f6a668
> [  784.531488] bb80: 5348060100000000 ffff80003d8ce400 0000000000123456 0000000000000000
> [  784.539718] bba0: ffff8000081f9c00 0000000000000000 0000000000000a00 0000000000000040
> [  784.547934] bbc0: ffffffffffffffff ffff00000903ef80 0000004000000000 0000000000000000
> [  784.556124] bbe0: ffff000008b56c30 0000000000000000 0000000000000001 ffff8000081f9800
> [  784.564343] bc00: ffff800007f6a6e8 ffff8000081f9600 ffff000000a2b600 0000000000000000
> [  784.572548] bc20: ffff800007f6a6e8 ffff80003d8ce400 ffff8000081f98c8 ffff8000081f98b0
> [  784.580749] bc40: ffff80003d982100 ffff00000930bca0 ffff000000a281dc ffff00000930bca0
> [  784.588945] bc60: ffff000000a28b88 0000000000c00149 0000000200000040 0000000007f6ffff
> [  784.597146] bc80: ffffffffffffffff ffff000000a280e4 ffff00000930bca0 ffff000000a28b88
> [  784.605790] [<ffff000000a28b88>] cm_req_handler+0xcd8/0xd18 [ib_cm]
> [  784.612783] [<ffff000000a28c98>] cm_work_handler+0xd0/0x11a8 [ib_cm]
> [  784.620007] [<ffff0000080df030>] process_one_work+0x128/0x2b0
> [  784.626144] [<ffff0000080df20c>] worker_thread+0x54/0x3c8
> [  784.632199] [<ffff0000080e4eb4>] kthread+0x100/0x12c
> [  784.637752] [<ffff000008085314>] ret_from_fork+0x10/0x18
>
> thanks
> Lijun Ou
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--Osvg0bgWkLaeQPMj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloClcEACgkQ5GN7iDZy
WKeQCRAAmq4rfxiPtY6+fDcDM24U7spYC17+oKwN6Jb1e+xF1wPFj0VeZcO/AX0x
6Xh1qqKPMyoC7+XXma49xRz7qfuE9tGjrM9vmxoYrNZW/3S7kB3byuLvd5f5UJoK
QkMFc7C4c4aNZIWPKQxfsfIVUc1YX1x2InXf+rBKFaNQm7BMuzTLa2lA8dqYSBgx
iXtW8qXRNqJ2KYkUv1Oe3+ICjG5WHTOmd24frwzZBqCfioW6hXJInfNWgP4c/Tnr
DL0qraDpt0j7csHyDTQ8EL6Ed1EdUKh90F1F2Ny4Bg6a/bSpfyemyflb48b6pCyB
SWqdKzK4Xc5wu2W78wnIrK9Q/HCYrKU2lZdfVtosSnFkt0ovZapKcoJfeUJsY/F2
oE5MZnCXQ/OdYlNLJ0fSWI7S+YqVvu6F0aZjYybihlFnh9eRXYZ+mUeEE2Pt/Nkw
G9Uazipv+6kBfHnTl8yZDN/LneiD5pgfdIL2OZ7s1bVUrJitBz8+13nPqL6z6QoD
zll6PrOG/sQ9x5/Gm+7N1yf9un3F9k/rvC5Sji54bC/9bej9g6y9Fm2zgpyhWSir
oeS3dQjUOj/C+CkUR+G+TBElezGTV1voyw8r23I+aOiTq7NDN5cXT/jeLEprOnq9
3vgA1JGIXQP222JKopn9IMPDu0pLO+UJU0GSNospZVIwra/opNI=
=4BWc
-----END PGP SIGNATURE-----

--Osvg0bgWkLaeQPMj--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
