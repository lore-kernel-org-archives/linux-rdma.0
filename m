From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v2 00/26] IB: Optimize DMA mapping
Date: Fri, 13 Jan 2017 20:18:06 +0000
Message-ID: <1484338667.2679.15.camel@sandisk.com>
References: <20170112190718.6728-1-bart.vanassche@sandisk.com>
         <F3529576D8E232409F431C309E29399336C5FF0F@CRSMSX102.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <F3529576D8E232409F431C309E29399336C5FF0F@CRSMSX102.amr.corp.intel.com>
Content-Language: en-US
Content-ID: <8D695168DFD75A4C9B819DD78D4E0F9F@sandisk.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "alex.estrin@intel.com" <alex.estrin@intel.com>, "dledford@redhat.com" <dledford@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 2017-01-13 at 18:27 +0000, Estrin, Alex wrote:
> This series applied to 4.10-rc3 breaks hfi1 sdma engines.
> [=A0=A0=A034.712343] hfi1 0000:82:00.0: hfi1_0: SDMA (0) engine error: 0x=
21
> state s50_HwHaltWait
> [=A0=A0=A034.722752] hfi1 0000:82:00.0: hfi1_0: SDMA (0) descq_head: 0
> descq_tail: 3 freecnt: 2044 FLE 0
> [=A0=A0=A034.733933] hfi1 0000:82:00.0: hfi1_0: SDMA sdmadesc[0]: flags:-=
-F-
> addr:0x00008808248c8000 gen:0 len:36 bytes
> [=A0=A0=A034.746595] hfi1 0000:82:00.0: hfi1_0:=A0=A0=A0=A0=A0=A0=A0desc0=
:0x80248808248c8000
> desc1 0x0000000000000000
> [=A0=A0=A034.757218] hfi1 0000:82:00.0: hfi1_0:=A0=A0=A0=A0=A0=A0=A0aidx:=
 0 amode: 0 alen: 0
> [=A0=A0=A034.765448] hfi1 0000:82:00.0: hfi1_0: SDMA sdmadesc[1]: flags:-=
---
> addr:0x0000880829fd5000 gen:0 len:24 bytes
> [=A0=A0=A034.778184] hfi1 0000:82:00.0: hfi1_0:=A0=A0=A0=A0=A0=A0=A0desc0=
:0x0018880829fd5000
> desc1 0x0000000000000000
> [=A0=A0=A034.788941] hfi1 0000:82:00.0: hfi1_0: SDMA sdmadesc[2]: flags:-=
H-L
> addr:0x0000880829fd5018 gen:0 len:440 bytes
> [=A0=A0=A034.801849] hfi1 0000:82:00.0: hfi1_0:=A0=A0=A0=A0=A0=A0=A0desc0=
:0x41b8880829fd5018
> desc1 0x0000000000000001
> ...etc
>=20
> BTW, what was the base for this series, as 19/26 did not apply cleanly to
> 4.10-rc3?

Hello Alex,

Sorry for this. Can you check whether the patch below fixes this regression=
?

diff --git a/drivers/infiniband/sw/rdmavt/vt.c
b/drivers/infiniband/sw/rdmavt/vt.c
index 6a81b179f631..f7fcd015ec09 100644
--- a/drivers/infiniband/sw/rdmavt/vt.c
+++ b/drivers/infiniband/sw/rdmavt/vt.c
@@ -778,8 +778,7 @@ int rvt_register_device(struct rvt_dev_info *rdi)
=A0	}
=A0
=A0	/* DMA Operations */
-	if (rdi->ibdev.dma_device->dma_ops =3D=3D NULL)
-		set_dma_ops(rdi->ibdev.dma_device, &dma_virt_ops);
+	set_dma_ops(rdi->ibdev.dma_device, &dma_virt_ops);
=A0
=A0	/* Protection Domain */
=A0	spin_lock_init(&rdi->n_pds_lock);
--=A0
2.11.0

I will make sure that this series applies cleanly on top of v4.10-rc3 when =
I
repost it.

Bart.=
