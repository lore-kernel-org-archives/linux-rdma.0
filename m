From: Parav Pandit <parav@mellanox.com>
Subject: RE: [PATCHv1] RDMA/core: Check error status of
 rdma_find_ndev_for_src_ip_rcu
Date: Thu, 4 Oct 2018 02:28:54 +0000
Message-ID: <VI1PR0501MB2271905AAC309C636C0B63B7D1EA0@VI1PR0501MB2271.eurprd05.prod.outlook.com>
References: <1537542022-4451-1-git-send-email-parav@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1537542022-4451-1-git-send-email-parav@mellanox.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Parav Pandit <parav@mellanox.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "leon@kernel.org" <leon@kernel.org>, "jgg@ziepe.ca" <jgg@ziepe.ca>, "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>, Daniel Jurgens <danielj@mellanox.com>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org

Hi Doug, Jason,

> -----Original Message-----
> From: Parav Pandit <parav@mellanox.com>
> Sent: Friday, September 21, 2018 10:00 AM
> To: linux-rdma@vger.kernel.org; linux-kernel@vger.kernel.org;
> leon@kernel.org; jgg@ziepe.ca; syzkaller-bugs@googlegroups.com; Daniel
> Jurgens <danielj@mellanox.com>; dledford@redhat.com
> Cc: Parav Pandit <parav@mellanox.com>
> Subject: [PATCHv1] RDMA/core: Check error status of
> rdma_find_ndev_for_src_ip_rcu
>=20
> rdma_find_ndev_for_src_ip_rcu() returns either valid netdev pointer or
> ERR_PTR().
> Instead of checking for NULL, check for error.
>=20
> Fixes: caf1e3ae9fa6 ("RDMA/core Introduce and use
> rdma_find_ndev_for_src_ip_rcu")
> Reported-by: syzbot+20c32fa6ff84a2d28c36@syzkaller.appspotmail.com
> Signed-off-by: Parav Pandit <parav@mellanox.com>
> ---
>  drivers/infiniband/core/addr.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/add=
r.c
> index c2ca9e4..3c07eeb 100644
> --- a/drivers/infiniband/core/addr.c
> +++ b/drivers/infiniband/core/addr.c
> @@ -513,8 +513,8 @@ static int rdma_set_src_addr_rcu(struct
> rdma_dev_addr *dev_addr,
>  		 * loopback IP address.
>  		 */
>  		ndev =3D rdma_find_ndev_for_src_ip_rcu(dev_net(ndev),
> dst_in);
> -		if (!ndev)
> -			return -ENODEV;
> +		if (IS_ERR(ndev))
> +			return PTR_ERR(ndev);
>  	}
>=20
>  	return copy_src_l2_addr(dev_addr, dst_in, dst, ndev);
> --
> 1.8.3.1

Can you please review this fix?
I got below report from syzbot that it tested the patch and reproducer didn=
't trigger.

Report:

syzbot has tested the proposed patch and the reproducer did not trigger =20
crash:

Reported-and-tested-by: =20
syzbot+20c32fa6ff84a2d28c36@syzkaller.appspotmail.com

Tested on:

commit:         41ab1cb7d1cd RDMA/cma: Introduce and use cma_ib_acquire_de.=
.
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git=
 =20
for-next
kernel config:  https://emea01.safelinks.protection.outlook.com/?url=3Dhttp=
s%3A%2F%2Fsyzkaller.appspot.com%2Fx%2F.config%3Fx%3D112cc1aec8b19ba4&amp;da=
ta=3D02%7C01%7Cparav%40mellanox.com%7Ce0a5662bb6aa4fdee43508d6298c9e60%7Ca6=
52971c7d2e4d9ba6a4d149256f461b%7C0%7C0%7C636742081267605003&amp;sdata=3DXiJ=
9F0gNuDvCWt0m2qzS6SbocXbFXIdWEHe%2BaJuvvcM%3D&amp;reserved=3D0
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
patch:          https://emea01.safelinks.protection.outlook.com/?url=3Dhttp=
s%3A%2F%2Fsyzkaller.appspot.com%2Fx%2Fpatch.diff%3Fx%3D10558231400000&amp;d=
ata=3D02%7C01%7Cparav%40mellanox.com%7Ce0a5662bb6aa4fdee43508d6298c9e60%7Ca=
652971c7d2e4d9ba6a4d149256f461b%7C0%7C0%7C636742081267605003&amp;sdata=3Dda=
0p6AW3YnXmFVrSaR%2FxSrB%2Bj%2Bml%2B5AXx%2B%2FKG4Kjb1M%3D&amp;reserved=3D0

Note: testing is done by a robot and is best-effort only.
