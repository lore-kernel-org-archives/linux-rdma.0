From: Marcel Apfelbaum <marcela-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH RFC 3/4] ib/mlx4: get extended active speed from port info
Date: Mon, 19 Sep 2011 18:03:13 +0300
Message-ID: <CAN+0-cYx2eBhgMc=tkL3VCrgPKK9zzxZhOxUEUmqEDwLxX=Nsw@mail.gmail.com>
References: <CAN+0-cZ+TGdZA_+e+2nbQdA3SYJRejf8_=tiA830exLre2tx_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAN+0-cZ+TGdZA_+e+2nbQdA3SYJRejf8_=tiA830exLre2tx_Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

mlx4_ib: Add extended link speeds support

This patch implements IB spec extension of the PortInfo attribute:

Component =A0: LinkSpeedExtActive
Used By =A0 =A0: (All X's except base SP0)
Access =A0 =A0 : RO
Length =A0 =A0 : 4
Offset =A0 =A0 : 496
Description: If PortInfo:CapabilityMask.IsExtendedSpeedsSupported
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (according to IBTA RefID 4720),=
 currently
=A0 =A0 =A0 =A0 =A0 =A0 active extended link speed, indicated as follow=
s:
0: No extended speed active
1: 14.0625 Gbps (FDR)
2: 25.78125 Gbps (EDR)
3-15: Reserved

Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Signed-off-by: Marcel Apfelbaum <marcela-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Reviewed-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
drivers/infiniband/hw/mlx4/main.c | =A0 =A02 +-
1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/infiniband/hw/mlx4/main.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- a/drivers/infiniband/hw/mlx4/main.c =A0 =A0 =A0 =A0 =A0 =A0 =A02011=
-09-14
13:49:58.000000000 +0300
+++ b/drivers/infiniband/hw/mlx4/main.c =A0 =A0 =A0 =A0 =A0 2011-09-14
13:50:52.408510900 +0300
@@ -202,7 +202,7 @@ static int ib_link_query_port(struct ib_
=A0 =A0 =A0 =A0 =A0 =A0 =A0 props->subnet_timeout =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =3D out_mad->data[51] & 0x1f;
=A0 =A0 =A0 =A0 =A0 =A0 =A0 props->max_vl_num =A0 =A0 =3D out_mad->data=
[37] >> 4;
=A0 =A0 =A0 =A0 =A0 =A0 =A0 props->init_type_reply =3D out_mad->data[41=
] >> 4;
-
+ =A0 =A0 =A0 =A0 =A0 =A0 props->ext_active_speed =3D out_mad->data[62]=
 >> 4;
=A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
}
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
