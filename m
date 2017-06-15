From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: rdma-core 13 fails to build on Ubuntu 16.04.1 LTS
Date: Thu, 15 Jun 2017 16:29:29 +0000
Message-ID: <CO2PR07MB2584B40776D19F8302B387F2F8C00@CO2PR07MB2584.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I failed to build rdma-core on Ubuntu 16.04.1 LTS.

Most errors looked like this: undefined reference to `udma_to_device_barrie=
r'.

e.g.:
[115/175] Building C object providers/mlx4/CMakeFiles/mlx4-rdmav2.dir/qp.c.=
o
../providers/mlx4/qp.c: In function 'set_data_seg':
../providers/mlx4/qp.c:206:2: warning: implicit declaration of function 'ud=
ma_to_device_barrier' [-Wimplicit-function-declaration]
=A0 udma_to_device_barrier();
=A0 ^
[115/175] Building C object providers/mthca/CMakeFiles/mthca-rdmav2.dir/qp.=
c.o
../providers/mthca/qp.c: In function 'mthca_tavor_post_send':
../providers/mthca/qp.c:115:2: warning: implicit declaration of function 'u=
dma_to_device_barrier' [-Wimplicit-function-declaration]
=A0 udma_to_device_barrier();
=A0 ^
[115/175] Building C object providers/i40iw/CMakeFiles/i40iw-rdmav2.dir/i40=
iw_uk.c.o
../providers/i40iw/i40iw_uk.c: In function 'i40iw_nop_1':
../providers/i40iw/i40iw_uk.c:79:2: warning: implicit declaration of functi=
on 'udma_to_device_barrier' [-Wimplicit-function-declaration]
=A0 udma_to_device_barrier(); /* Memory barrier to ensure data is written b=
efore valid bit is set */

rdma-core 14 works well, however.

Is this a known issue?

Thanks,
Ram



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
