From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: IBV_WC_LOC_QP_OP_ERR for IBV_WR_RDMA_READ
Date: Thu, 29 Sep 2011 09:53:52 -0700
Message-ID: <CAL1RGDV96BDbqhB54hvvT39N1P_c-Ruu3OK==fWgkpgJyoz=_g@mail.gmail.com>
References: <OF5E15DBF2.C8CD7129-ON8825791A.0002FEBE-8625791A.00030605@sybase.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <OF5E15DBF2.C8CD7129-ON8825791A.0002FEBE-8625791A.00030605-iQUyExClMxnQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David.Wein-iQUyExClMxnQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

How are you initializing the QP?

Do you set max_rd_atomic (and set IB_QP_MAX_QP_RD_ATOMIC) in your
qp_attr when going to RTS (I think that's the state transition where
it matters)?

On Wed, Sep 28, 2011 at 5:33 PM,  <David.Wein-iQUyExClMxnQT0dZR+AlfA@public.gmane.org> wrote:
> I'm going a little crazy here. =A0I am getting IBV_WC_LOC_QP_OP_ERR w=
hen
> trying to do an IBV_WR_RDMA_READ. =A0My IBV_WR_RDMA_WRITE operations
> succeed, no problems. =A0The read and write cases go down an identica=
l code
> path, the only difference is the OP code. =A0I feel like it has to be
> something obvious, but I am not seeing it. =A0All memory has been reg=
istered
> with local write, remote write, and remote read. =A0Any help is appre=
ciated.
>
> I get this error on the console:
>
> local QP operation err (QPN c8040c, WQE @ 00001303, CQN 3e0083, index
> 17593)
> =A0[ 0] 00c8040c
> =A0[ 4] 00000000
> =A0[ 8] 00000000
> =A0[ c] 00000000
> =A0[10] 026800cc
> =A0[14] 00000000
> =A0[18] 00001303
> =A0[1c] ff100000
>
> Here is the ibv_send_wr I am passing to ibv_post_send():
>
> (dbx) print swr
> swr =3D {
> =A0 =A0wr_id =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D 5826396576U
> =A0 =A0next =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D (nil)
> =A0 =A0sg_list =A0 =A0 =A0 =A0 =A0 =A0=3D 0x1596827a0
> =A0 =A0num_sge =A0 =A0 =A0 =A0 =A0 =A0=3D 1
> =A0 =A0opcode =A0 =A0 =A0 =A0 =A0 =A0 =3D IBV_WR_RDMA_READ
> =A0 =A0send_flags =A0 =A0 =A0 =A0 =3D 2
> =A0 =A0imm_data =A0 =A0 =A0 =A0 =A0 =3D 0
> =A0 =A0wr =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D {
> =A0 =A0 =A0 =A0rdma =A0 =3D {
> =A0 =A0 =A0 =A0 =A0 =A0remote_addr =3D 46912519049216U
> =A0 =A0 =A0 =A0 =A0 =A0rkey =A0 =A0 =A0 =A0=3D 3255056896U
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0atomic =3D {
> =A0 =A0 =A0 =A0 =A0 =A0remote_addr =3D 46912519049216U
> =A0 =A0 =A0 =A0 =A0 =A0compare_add =3D 7550024192U
> =A0 =A0 =A0 =A0 =A0 =A0swap =A0 =A0 =A0 =A0=3D 5778783872U
> =A0 =A0 =A0 =A0 =A0 =A0rkey =A0 =A0 =A0 =A0=3D 1499998064U
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0ud =A0 =A0 =3D {
> =A0 =A0 =A0 =A0 =A0 =A0ah =A0 =A0 =A0 =A0 =A0=3D 0x2aaaac089000
> =A0 =A0 =A0 =A0 =A0 =A0remote_qpn =A0=3D 3255056896U
> =A0 =A0 =A0 =A0 =A0 =A0remote_qkey =3D 1U
> =A0 =A0 =A0 =A0}
> =A0 =A0}
> =A0 =A0xrc_remote_srq_num =3D 1482849088U
> }
> (dbx) print swr->sg_list[0]
> swr.sg_list[0] =3D {
> =A0 =A0addr =A0 =3D 6127460352U
> =A0 =A0length =3D 4096U
> =A0 =A0lkey =A0 =3D 3255057152U
> }
> (dbx)
>
> Environment is as follows:
>
> [generic]$ ibv_devinfo
> hca_id: mthca0
> =A0 =A0 =A0 =A0transport: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
InfiniBand (0)
> =A0 =A0 =A0 =A0fw_ver: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 1.2.0
> =A0 =A0 =A0 =A0node_guid: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
0002:c902:002a:9460
> =A0 =A0 =A0 =A0sys_image_guid: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0002:c=
902:002a:9463
> =A0 =A0 =A0 =A0vendor_id: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
0x02c9
> =A0 =A0 =A0 =A0vendor_part_id: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 25204
> =A0 =A0 =A0 =A0hw_ver: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 0xA0
> =A0 =A0 =A0 =A0board_id: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
MT_03F0110001
> =A0 =A0 =A0 =A0phys_port_cnt: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A01
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0port: =A0 1
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0state: =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0PORT_ACTIVE (4)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0max_mtu: =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A02048 (4)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0active_mtu: =A0 =A0 =A0=
 =A0 =A0 =A0 2048 (4)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sm_lid: =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 1
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0port_lid: =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 1
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0port_lmc: =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 0x00
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0link_layer: =A0 =A0 =A0=
 =A0 =A0 =A0 IB
>
> hca_id: mthca1
> =A0 =A0 =A0 =A0transport: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
InfiniBand (0)
> =A0 =A0 =A0 =A0fw_ver: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 1.2.0
> =A0 =A0 =A0 =A0node_guid: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
0002:c902:002a:add4
> =A0 =A0 =A0 =A0sys_image_guid: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0002:c=
902:002a:add7
> =A0 =A0 =A0 =A0vendor_id: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
0x02c9
> =A0 =A0 =A0 =A0vendor_part_id: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 25204
> =A0 =A0 =A0 =A0hw_ver: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 0xA0
> =A0 =A0 =A0 =A0board_id: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
MT_03F0110001
> =A0 =A0 =A0 =A0phys_port_cnt: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A01
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0port: =A0 1
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0state: =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0PORT_ACTIVE (4)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0max_mtu: =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A02048 (4)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0active_mtu: =A0 =A0 =A0=
 =A0 =A0 =A0 2048 (4)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sm_lid: =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 1
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0port_lid: =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 2
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0port_lmc: =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 0x00
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0link_layer: =A0 =A0 =A0=
 =A0 =A0 =A0 IB
>
> [generic]$ uname -r
> 2.6.18-128.1.6.el5
>
> [generic]$ ofed_info
> OFED-1.5.1:
>
> compat-dapl:
> http://www.openfabrics.org/downloads/dapl/compat-dapl-1.2.16.tar.gz
>
> dapl:
> http://www.openfabrics.org/downloads/dapl/dapl-2.0.27.tar.gz
>
> ib-bonding:
> http://www.openfabrics.org/~monis/ofed_1_5/ib-bonding-0.9.0-42.src.rp=
m
>
> ibsim:
> http://www.openfabrics.org/downloads/ibsim/ibsim-0.5-0.1.g327c3d8.tar=
=2Egz
>
> ibutils:
> http://www.openfabrics.org/downloads/ibutils/ibutils-1.5.4-0.1.g0464f=
e6.tar.gz
>
> infiniband-diags:
> http://www.openfabrics.org/downloads/management/infiniband-diags-1.5.=
5.tar.gz
>
> libcxgb3:
> http://www.openfabrics.org/downloads/cxgb3/libcxgb3-1.2.5.tar.gz
>
> libehca:
> http://www.openfabrics.org/downloads/libehca/libehca-1.2.1-0.1.g0a82a=
52.tar.gz
>
> libibcm:
> http://www.openfabrics.org/downloads/rdmacm/libibcm-1.0.5.tar.gz
>
> libibmad:
> http://www.openfabrics.org/downloads/management/libibmad-1.3.4.tar.gz
>
> libibumad:
> http://www.openfabrics.org/downloads/management/libibumad-1.3.4.tar.g=
z
>
> libibverbs:
> http://www.openfabrics.org/downloads/libibverbs/libibverbs-1.1.3-0.6.=
g932f1a2.tar.gz
>
> libipathverbs:
> http://www.openfabrics.org/downloads/libipathverbs/libipathverbs-1.2.=
tar.gz
>
> libmlx4:
> http://www.openfabrics.org/downloads/libmlx4/libmlx4-1.0-0.7.g2432360=
=2Etar.gz
>
> libmthca:
> http://www.openfabrics.org/downloads/libmthca/libmthca-1.0.5-0.1.gbe5=
eef3.tar.gz
>
> libnes:
> http://www.openfabrics.org/downloads/nes/libnes-1.0.1.tar.gz
>
> librdmacm:
> http://www.openfabrics.org/downloads/rdmacm/librdmacm-1.0.11.tar.gz
>
> libsdp:
> http://www.openfabrics.org/downloads/libsdp/libsdp-1.1.100-0.1.g920ea=
31.tar.gz
>
> mpi-selector:
> http://www.openfabrics.org/downloads/mpi-selector/mpi-selector-1.0.3-=
1.src.rpm
>
> mpitests:
> http://www.openfabrics.org/~pasha/ofed_1_5/mpitests/mpitests-3.2-916.=
src.rpm
>
> mstflint:
> http://www.openfabrics.org/downloads/mstflint/mstflint-1.4-0.3.gf3046=
47.tar.gz
>
> mvapich:
> http://www.openfabrics.org/~pasha/ofed_1_5_1/mvapich/mvapich-1.2.0-36=
35.src.rpm
>
> mvapich2:
> http://www.openfabrics.org/~perkinjo/ofed_1_5/mvapich2-1.4.1-1.src.rp=
m
>
> ofa_kernel:
> git://git.openfabrics.org/ofed_1_5/linux-2.6.git ofed_kernel_1_5
> commit 17badd753b40fb1046dc2e5474739357a921fb86
>
> ofed-docs:
> git://git.openfabrics.org/~tziporet/docs.git ofed_1_5
> commit 4b7a81073731c630427e97a3013efd6cafa537ac
>
> open-iscsi-generic1:
> http://www.openfabrics.org/downloads/iscsi/open-iscsi-generic-2.0-754=
=2E1.src.rpm
>
> open-iscsi-generic2:
> http://www.openfabrics.org/downloads/iscsi/open-iscsi-generic-2.0-869=
=2E2.src.rpm
>
> openmpi:
> http://www.openfabrics.org/~jsquyres/ofed_1_5/openmpi-1.4.1-2ofed.src=
=2Erpm
>
> opensm:
> http://www.openfabrics.org/downloads/management/opensm-3.3.5.tar.gz
>
> perftest:
> http://www.openfabrics.org/downloads/perftest/perftest-1.2.3-0.10.g90=
b10d8.tar.gz
>
> qlvnictools:
> http://www.openfabrics.org/downloads/qlvnictools/qlvnictools-0.0.1-0.=
1.ge27eef7.tar.gz
>
> qperf:
> http://www.openfabrics.org/downloads/qperf/qperf-0.4.6-0.1.gb81434e.t=
ar.gz
>
> rds-tools:
> http://www.openfabrics.org/~vlad/ofed_1_5/rds-tools/rds-tools-1.5-1.s=
rc.rpm
>
> rnfs-utils:
> http://www.openfabrics.org/~swise/ofed_1_5/rnfs-utils/rnfs-utils-1.1.=
5-10.OFED.src.rpm
>
> sdpnetstat:
> http://www.openfabrics.org/downloads/sdpnetstat/sdpnetstat-1.60-0.2.g=
8844f04.tar.gz
>
> srptools:
> http://www.openfabrics.org/downloads/srptools/srptools-0.0.4-0.1.gce1=
f64c.tar.gz
>
> tgt-generic:
> http://www.openfabrics.org/downloads/iscsi/tgt-generic-0.1-20080828.s=
rc.rpm
>
> ofed-scripts:
> git://git.openfabrics.org/~vlad/ofed_scripts.git ofed_1_5
>
> Thanks,
> Dave
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
