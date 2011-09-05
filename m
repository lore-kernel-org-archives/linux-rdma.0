From: Tommi T <tommi_t77-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Subject: Re: mlx ipoib error
Date: Mon, 5 Sep 2011 03:00:27 -0700 (PDT)
Message-ID: <1315216827.75130.YahooMailNeo@web113912.mail.gq1.yahoo.com>
References: <1314869585.71072.YahooMailNeo@web113913.mail.gq1.yahoo.com> <CAAk-MO8jBpbV4+dwLxQbauwmFThFTi=Yg78NaPa9V21deL2pOg@mail.gmail.com>
Reply-To: Tommi T <tommi_t77-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAAk-MO8jBpbV4+dwLxQbauwmFThFTi=Yg78NaPa9V21deL2pOg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> The errors you saw are connected to the driver itself (FW commands) a=
nd not direct;y to the IPoIB module.
> Can you send more details about the card, the driver details etc / (y=
ou can run ofed_info)

Hi

Here are some details: (server itself is HP Proliant DL385 G6)

Network controller: Mellanox Technologies MT26418 [ConnectX VPI PCIe 2.=
0 5GT/s - IB DDR / 10GigE] (rev a0)

# modinfo mlx4_core
filename:=A0=A0=A0=A0=A0=A0 /lib/modules/2.6.18-238.5.1.el5/kernel/driv=
ers/net/mlx4/mlx4_core.ko
version:=A0=A0=A0=A0=A0=A0=A0 1.0
license:=A0=A0=A0=A0=A0=A0=A0 Dual BSD/GPL
description:=A0=A0=A0 Mellanox ConnectX HCA low-level driver
author:=A0=A0=A0=A0=A0=A0=A0=A0 Roland Dreier
srcversion:=A0=A0=A0=A0 C2356380EB2ABEA28EDACE0


# ibv_devinfo=20
hca_id: mlx4_0
=A0=A0=A0=A0=A0=A0=A0 transport:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 InfiniBand (0)
=A0=A0=A0=A0=A0=A0=A0 fw_ver:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 2.8.000
=A0=A0=A0=A0=A0=A0=A0 node_guid:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 0023:7dff:ff94:1698
=A0=A0=A0=A0=A0=A0=A0 sys_image_guid:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 0023:7dff:ff94:169b
=A0=A0=A0=A0=A0=A0=A0 vendor_id:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 0x02c9
=A0=A0=A0=A0=A0=A0=A0 vendor_part_id:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 26418
=A0=A0=A0=A0=A0=A0=A0 hw_ver:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0xA0
=A0=A0=A0=A0=A0=A0=A0 board_id:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 HP_09D0000008
=A0=A0=A0=A0=A0=A0=A0 phys_port_cnt:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 2
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 port:=A0=A0 1
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 s=
tate:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 PORT_ACTIVE (4=
)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 m=
ax_mtu:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 2048 (4)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 a=
ctive_mtu:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 2048 (4)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 s=
m_lid:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 4
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 p=
ort_lid:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 11
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 p=
ort_lmc:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0x00
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 l=
ink_layer:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 IB


# ofed_info=20
OFED-1.5.3.1:

compat-dapl:
http://www.openfabrics.org/downloads/dapl/compat-dapl-1.2.19.tar.gz

dapl:
http://www.openfabrics.org/downloads/dapl/dapl-2.0.32.tar.gz

ib-bonding:
http://www.openfabrics.org/downloads/ib-bonding/ib-bonding-0.9.0-42.src=
=2Erpm

ibacm:
http://www.openfabrics.org/downloads/rdmacm/ibacm-1.0.4.tar.gz

ibsim:
http://www.openfabrics.org/downloads/ibsim/ibsim-0.5-0.1.g327c3d8.tar.g=
z

ibutils:
http://www.openfabrics.org/downloads/ibutils/ibutils-1.5.7.tar.gz

infiniband-diags:
http://www.openfabrics.org/downloads/management/infiniband-diags-1.5.8.=
tar.gz

infinipath-psm:
http://www.openfabrics.org/downloads/infinipath-psm/infinipath-psm-1.14=
=2Etar.gz

libcxgb3:
http://www.openfabrics.org/downloads/cxgb3/libcxgb3-1.2.5.tar.gz

libehca:
http://www.openfabrics.org/downloads/libehca/libehca-1.2.2-0.1.g69e1a88=
=2Etar.gz

libibcm:
http://www.openfabrics.org/downloads/rdmacm/libibcm-1.0.5.tar.gz

libibmad:
http://www.openfabrics.org/downloads/management/libibmad-1.3.7.tar.gz

libibumad:
http://www.openfabrics.org/downloads/management/libibumad-1.3.7.tar.gz

libibverbs:
http://www.openfabrics.org/downloads/libibverbs/libibverbs-1.1.4-1.22.g=
7257cd3.tar.gz

libipathverbs:
http://www.openfabrics.org/downloads/libipathverbs/libipathverbs-1.2.ta=
r.gz

libmlx4:
http://www.openfabrics.org/downloads/libmlx4/libmlx4-1.0.1-1.18.gb810a2=
7.tar.gz

libmthca:
http://www.openfabrics.org/downloads/libmthca/libmthca-1.0.5-0.1.gbe5ee=
f3.tar.gz

libnes:
http://www.openfabrics.org/downloads/nes/libnes-1.1.1.tar.gz

librdmacm:
http://www.openfabrics.org/downloads/rdmacm/librdmacm-1.0.14.1.tar.gz

libsdp:
http://www.openfabrics.org/downloads/libsdp/libsdp-1.1.108-0.15.gd7fdb7=
2.tar.gz

mpi-selector:
http://www.openfabrics.org/downloads/mpi-selector/mpi-selector-1.0.3-1.=
src.rpm

mpitests:
http://www.openfabrics.org/~pasha/ofed_1_5/mpitests/mpitests-3.2-923.sr=
c.rpm

mstflint:
http://www.openfabrics.org/downloads/mstflint/mstflint-1.4-0.9.gc683022=
=2Etar.gz

mvapich:
http://www.openfabrics.org/~pasha/ofed_1_5_1/mvapich/mvapich-1.2.0-3635=
=2Esrc.rpm

mvapich2:
http://www.openfabrics.org/~perkinjo/ofed_1_5/mvapich2-1.6-2.src.rpm

ofa_kernel:
git://git.openfabrics.org/ofed_1_5/linux-2.6.git ofed_kernel_1_5
commit f160c14d4d3e8ced0d293b77d06ebf8704e5d106

ofed-docs:
git://git.openfabrics.org/ofed_1_5/docs.git ofed_1_5
commit d0c8a525eca39ac82c9be4dc31f117b6b241416d

open-iscsi-generic1:
http://www.openfabrics.org/downloads/iscsi/open-iscsi-generic-2.0-754.1=
=2Esrc.rpm

open-iscsi-generic2:
http://www.openfabrics.org/downloads/iscsi/open-iscsi-generic-2.0-869.2=
=2Esrc.rpm

openmpi:
http://www.openfabrics.org/~jsquyres/ofed_1_5/openmpi-1.4.3-1.src.rpm

opensm:
http://www.openfabrics.org/downloads/management/opensm-3.3.9.tar.gz

perftest:
http://www.openfabrics.org/downloads/perftest/perftest-1.3.0-0.42.gf350=
d3d.tar.gz

qlvnictools:
http://www.openfabrics.org/downloads/qlvnictools/qlvnictools-0.0.1-0.1.=
ge27eef7.tar.gz

qperf:
http://www.openfabrics.org/downloads/qperf/qperf-0.4.6-0.1.gb81434e.tar=
=2Egz

rds-tools:
http://www.openfabrics.org/downloads/rds-tools/rds-tools-2.0.4.tar.gz

rnfs-utils:
http://www.openfabrics.org/~swise/ofed_1_5/rnfs-utils/rnfs-utils-1.1.5-=
10.OFED.src.rpm

sdpnetstat:
http://www.openfabrics.org/downloads/sdpnetstat/sdpnetstat-1.60-0.3.gb6=
e7425.tar.gz

srptools:
http://www.openfabrics.org/downloads/srptools/srptools-0.0.4-0.1.gce1f6=
4c.tar.gz

tgt-generic:
http://www.openfabrics.org/downloads/iscsi/tgt-generic-0.1-20080828.src=
=2Erpm

ofed-scripts:
git://git.openfabrics.org/~vlad/ofed_scripts.git ofed_1_5

Installed Packages:
-------------------
compat-dapl-devel-1.2.19-1
dapl-utils-2.0.32-1
srptools-0.0.4-0.1.gce1f64c
dapl-devel-static-2.0.32-1
dapl-devel-2.0.32-1
libibverbs-utils-1.1.4-1.23.g6ccf63e
libmlx4-1.0.1-1.18.gb810a27
ibsim-0.5-0.1.g327c3d8
rds-tools-2.0.4-1
libibmad-static-1.3.7-1
libibmad-devel-1.3.7-1
kernel-ib-1.5.3-2.6.18_274.el5
opensm-devel-3.3.9_MLNX_20110704_c986c53-0.1
libibverbs-devel-1.1.4-1.23.g6ccf63e
kernel-ib-1.5.3.1-2.6.18_238.19.1.el5
librdmacm-1.0.14.1-1
libmthca-1.0.5-0.1.gbe5eef3
infinipath-psm-1.14-1
ibutils-1.5.7-1
qperf-0.4.6-0.1.gb81434e
mstflint-1.4-0.9.gc683022
ofed-scripts-1.5.3.1-OFED.1.5.3.1.
libipathverbs-devel-1.2-1
librdmacm-devel-1.0.14.1-1
infinipath-psm-devel-1.14-1
kernel-ib-devel-1.5.3-2.6.18_274.el5
libibverbs-1.1.4-1.23.g6ccf63e
compat-dapl-1.2.19-1
libibumad-1.3.7-1
dapl-2.0.32-1
libipathverbs-1.2-1
libmthca-devel-static-1.0.5-0.1.gbe5eef3
libibumad-static-1.3.7-1
libibcm-devel-1.0.5-1
perftest-1.3.0-0.47.ga001d5f
libibcm-1.0.5-1
librdmacm-utils-1.0.14.1-1
libibumad-devel-1.3.7-1
libsdp-devel-1.1.108-0.15.gd7fdb72
opensm-libs-3.3.9_MLNX_20110704_c986c53-0.1
compat-dapl-devel-static-1.2.19-1
libibmad-1.3.7-1
libsdp-1.1.108-0.15.gd7fdb72
ibacm-1.0.4-1
libmlx4-devel-1.0.1-1.18.gb810a27
infiniband-diags-1.5.8_MLNX_20110404_eb90f87-0.4
libibverbs-devel-static-1.1.4-1.23.g6ccf63e
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
