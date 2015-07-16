From: Alexey <alukardd-2mZicLuE2MBg9hUCZPvPmw@public.gmane.org>
Subject: QLogic driver problem (ib_qib)
Date: Thu, 16 Jul 2015 18:31:56 +0300
Message-ID: <82fd80bcd97dae02558e4122b7c6964f@alukardd.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello.

I have issue with stuck ib_srp module because ib_qib driver is too old.
 From dmesg about srp_daemon:
[Mon Jul 13 18:16:01 2015] srp_daemon      D ffff880be35fa8f0     0=20
20491      1 0x00000000
[Mon Jul 13 18:16:01 2015]  ffff880be35fa8f0 0000000000000000=20
ffff880c097ae150 0000000000013b40
[Mon Jul 13 18:16:01 2015]  0000000000013b40 ffff880be35fa8f0=20
ffff8800bad5ffd8 0000000000000000
[Mon Jul 13 18:16:01 2015]  7fffffffffffffff 7fffffffffffffff=20
0000000000000002 ffff8818047ba870
[Mon Jul 13 18:16:01 2015] Call Trace:
[Mon Jul 13 18:16:01 2015]  [<ffffffff813e20e6>] ?=20
console_conditional_schedule+0xf/0xf
[Mon Jul 13 18:16:01 2015]  [<ffffffff813e2102>] ?=20
schedule_timeout+0x1c/0xec
[Mon Jul 13 18:16:01 2015]  [<ffffffff813e28d7>] ?=20
_raw_spin_lock_irq+0xa/0x15
[Mon Jul 13 18:16:01 2015]  [<ffffffff813e0e9c>] ?=20
__wait_for_common+0x124/0x163
[Mon Jul 13 18:16:01 2015]  [<ffffffff81069d57>] ?=20
try_to_wake_up+0x1a8/0x1a8
[Mon Jul 13 18:16:01 2015]  [<ffffffff813e2903>] ?=20
_raw_spin_unlock_irqrestore+0xc/0xd
[Mon Jul 13 18:16:01 2015]  [<ffffffffa04f4e9b>] ?=20
srp_destroy_qp+0xe5/0xee [ib_srp]
[Mon Jul 13 18:16:01 2015]  [<ffffffffa04f54d4>] ?=20
srp_free_ch_ib+0x97/0x14f [ib_srp]
[Mon Jul 13 18:16:01 2015]  [<ffffffffa04f923b>] ?=20
srp_create_target+0xa2c/0xac5 [ib_srp]
[Mon Jul 13 18:16:01 2015]  [<ffffffff811394fc>] ?=20
path_cleanup+0x1a/0x33
[Mon Jul 13 18:16:01 2015]  [<ffffffff8113d370>] ?=20
path_openat+0x418/0x46d
[Mon Jul 13 18:16:01 2015]  [<ffffffff81121361>] ? __kmalloc+0xe5/=E2=81=
=A00xf7
[Mon Jul 13 18:16:01 2015]  [<ffffffff81186a25>] ?=20
kernfs_fop_write+0x60/0x128
[Mon Jul 13 18:16:01 2015]  [<ffffffff81186aa1>] ?=20
kernfs_fop_write+0xdc/0x128
[Mon Jul 13 18:16:01 2015]  [<ffffffff811323f2>] ? vfs_write+0x9c/=E2=81=
=A00x11e
[Mon Jul 13 18:16:01 2015]  [<ffffffff8113263c>] ? SyS_write+0x51/=E2=81=
=A00x85
[Mon Jul 13 18:16:01 2015]  [<ffffffff813e2ce9>] ?=20
system_call_fastpath+0x12/0x17

Bart Van Assche help us and resulting patch you can see below:
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c=20
b/drivers/infiniband/ulp/srp/ib_srp.c
index c5af67a..470eb54 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -59,6 +59,7 @@
  #include "../../../../include/scsi/scsi_transport_srp.h"

  #include "ib_srp.h"
+#include <linux/delay.h>

  #define DRV_NAME	"ib_srp"
  #define PFX		DRV_NAME ": "
@@ -621,11 +622,7 @@ static void srp_destroy_qp(struct srp_rdma_ch *ch)
  	if (ret)
  		goto out;

-	init_completion(&ch->done);
-	ret =3D ib_post_recv(ch->qp, &wr, &bad_wr);
-	WARN_ONCE(ret, "ib_post_recv() returned %d\n", ret);
-	if (ret =3D=3D 0)
-		wait_for_completion(&ch->done);
+	msleep(100);

  out:
  	ib_destroy_qp(ch->qp);

But with mlx driver all works fine.


My current installation is:
linux 3.19.1
qib 1.11
ib_srp 2.0.32
InfiniBand: QLogic Corp. IBA7322 QDR InfiniBand HCA (rev 02)


I hope you can help fix ib_qib driver and we can remove this ugly patch=
=20
from our source of ib_srp.

Regards,
Alexey Mochkin
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
