From: David.Wein-iQUyExClMxnQT0dZR+AlfA@public.gmane.org
Subject: IBV_WC_LOC_QP_OP_ERR for IBV_WR_RDMA_READ
Date: Wed, 28 Sep 2011 19:33:01 -0500
Message-ID: <OF5E15DBF2.C8CD7129-ON8825791A.0002FEBE-8625791A.00030605@sybase.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I'm going a little crazy here.  I am getting IBV_WC_LOC_QP_OP_ERR when 
trying to do an IBV_WR_RDMA_READ.  My IBV_WR_RDMA_WRITE operations 
succeed, no problems.  The read and write cases go down an identical code 
path, the only difference is the OP code.  I feel like it has to be 
something obvious, but I am not seeing it.  All memory has been registered 
with local write, remote write, and remote read.  Any help is appreciated.

I get this error on the console:

local QP operation err (QPN c8040c, WQE @ 00001303, CQN 3e0083, index 
17593)
  [ 0] 00c8040c
  [ 4] 00000000
  [ 8] 00000000
  [ c] 00000000
  [10] 026800cc
  [14] 00000000
  [18] 00001303
  [1c] ff100000

Here is the ibv_send_wr I am passing to ibv_post_send():

(dbx) print swr
swr = {
    wr_id              = 5826396576U
    next               = (nil)
    sg_list            = 0x1596827a0
    num_sge            = 1
    opcode             = IBV_WR_RDMA_READ
    send_flags         = 2
    imm_data           = 0
    wr                 = {
        rdma   = {
            remote_addr = 46912519049216U
            rkey        = 3255056896U
        }
        atomic = {
            remote_addr = 46912519049216U
            compare_add = 7550024192U
            swap        = 5778783872U
            rkey        = 1499998064U
        }
        ud     = {
            ah          = 0x2aaaac089000
            remote_qpn  = 3255056896U
            remote_qkey = 1U
        }
    }
    xrc_remote_srq_num = 1482849088U
}
(dbx) print swr->sg_list[0]
swr.sg_list[0] = {
    addr   = 6127460352U
    length = 4096U
    lkey   = 3255057152U
}
(dbx) 

Environment is as follows:

[generic]$ ibv_devinfo
hca_id: mthca0
        transport:                      InfiniBand (0)
        fw_ver:                         1.2.0
        node_guid:                      0002:c902:002a:9460
        sys_image_guid:                 0002:c902:002a:9463
        vendor_id:                      0x02c9
        vendor_part_id:                 25204
        hw_ver:                         0xA0
        board_id:                       MT_03F0110001
        phys_port_cnt:                  1
                port:   1
                        state:                  PORT_ACTIVE (4)
                        max_mtu:                2048 (4)
                        active_mtu:             2048 (4)
                        sm_lid:                 1
                        port_lid:               1
                        port_lmc:               0x00
                        link_layer:             IB

hca_id: mthca1
        transport:                      InfiniBand (0)
        fw_ver:                         1.2.0
        node_guid:                      0002:c902:002a:add4
        sys_image_guid:                 0002:c902:002a:add7
        vendor_id:                      0x02c9
        vendor_part_id:                 25204
        hw_ver:                         0xA0
        board_id:                       MT_03F0110001
        phys_port_cnt:                  1
                port:   1
                        state:                  PORT_ACTIVE (4)
                        max_mtu:                2048 (4)
                        active_mtu:             2048 (4)
                        sm_lid:                 1
                        port_lid:               2
                        port_lmc:               0x00
                        link_layer:             IB

[generic]$ uname -r
2.6.18-128.1.6.el5

[generic]$ ofed_info
OFED-1.5.1:

compat-dapl:
http://www.openfabrics.org/downloads/dapl/compat-dapl-1.2.16.tar.gz

dapl:
http://www.openfabrics.org/downloads/dapl/dapl-2.0.27.tar.gz

ib-bonding:
http://www.openfabrics.org/~monis/ofed_1_5/ib-bonding-0.9.0-42.src.rpm

ibsim:
http://www.openfabrics.org/downloads/ibsim/ibsim-0.5-0.1.g327c3d8.tar.gz

ibutils:
http://www.openfabrics.org/downloads/ibutils/ibutils-1.5.4-0.1.g0464fe6.tar.gz

infiniband-diags:
http://www.openfabrics.org/downloads/management/infiniband-diags-1.5.5.tar.gz

libcxgb3:
http://www.openfabrics.org/downloads/cxgb3/libcxgb3-1.2.5.tar.gz

libehca:
http://www.openfabrics.org/downloads/libehca/libehca-1.2.1-0.1.g0a82a52.tar.gz

libibcm:
http://www.openfabrics.org/downloads/rdmacm/libibcm-1.0.5.tar.gz

libibmad:
http://www.openfabrics.org/downloads/management/libibmad-1.3.4.tar.gz

libibumad:
http://www.openfabrics.org/downloads/management/libibumad-1.3.4.tar.gz

libibverbs:
http://www.openfabrics.org/downloads/libibverbs/libibverbs-1.1.3-0.6.g932f1a2.tar.gz

libipathverbs:
http://www.openfabrics.org/downloads/libipathverbs/libipathverbs-1.2.tar.gz

libmlx4:
http://www.openfabrics.org/downloads/libmlx4/libmlx4-1.0-0.7.g2432360.tar.gz

libmthca:
http://www.openfabrics.org/downloads/libmthca/libmthca-1.0.5-0.1.gbe5eef3.tar.gz

libnes:
http://www.openfabrics.org/downloads/nes/libnes-1.0.1.tar.gz

librdmacm:
http://www.openfabrics.org/downloads/rdmacm/librdmacm-1.0.11.tar.gz

libsdp:
http://www.openfabrics.org/downloads/libsdp/libsdp-1.1.100-0.1.g920ea31.tar.gz

mpi-selector:
http://www.openfabrics.org/downloads/mpi-selector/mpi-selector-1.0.3-1.src.rpm

mpitests:
http://www.openfabrics.org/~pasha/ofed_1_5/mpitests/mpitests-3.2-916.src.rpm

mstflint:
http://www.openfabrics.org/downloads/mstflint/mstflint-1.4-0.3.gf304647.tar.gz

mvapich:
http://www.openfabrics.org/~pasha/ofed_1_5_1/mvapich/mvapich-1.2.0-3635.src.rpm

mvapich2:
http://www.openfabrics.org/~perkinjo/ofed_1_5/mvapich2-1.4.1-1.src.rpm

ofa_kernel:
git://git.openfabrics.org/ofed_1_5/linux-2.6.git ofed_kernel_1_5
commit 17badd753b40fb1046dc2e5474739357a921fb86

ofed-docs:
git://git.openfabrics.org/~tziporet/docs.git ofed_1_5
commit 4b7a81073731c630427e97a3013efd6cafa537ac

open-iscsi-generic1:
http://www.openfabrics.org/downloads/iscsi/open-iscsi-generic-2.0-754.1.src.rpm

open-iscsi-generic2:
http://www.openfabrics.org/downloads/iscsi/open-iscsi-generic-2.0-869.2.src.rpm

openmpi:
http://www.openfabrics.org/~jsquyres/ofed_1_5/openmpi-1.4.1-2ofed.src.rpm

opensm:
http://www.openfabrics.org/downloads/management/opensm-3.3.5.tar.gz

perftest:
http://www.openfabrics.org/downloads/perftest/perftest-1.2.3-0.10.g90b10d8.tar.gz

qlvnictools:
http://www.openfabrics.org/downloads/qlvnictools/qlvnictools-0.0.1-0.1.ge27eef7.tar.gz

qperf:
http://www.openfabrics.org/downloads/qperf/qperf-0.4.6-0.1.gb81434e.tar.gz

rds-tools:
http://www.openfabrics.org/~vlad/ofed_1_5/rds-tools/rds-tools-1.5-1.src.rpm

rnfs-utils:
http://www.openfabrics.org/~swise/ofed_1_5/rnfs-utils/rnfs-utils-1.1.5-10.OFED.src.rpm

sdpnetstat:
http://www.openfabrics.org/downloads/sdpnetstat/sdpnetstat-1.60-0.2.g8844f04.tar.gz

srptools:
http://www.openfabrics.org/downloads/srptools/srptools-0.0.4-0.1.gce1f64c.tar.gz

tgt-generic:
http://www.openfabrics.org/downloads/iscsi/tgt-generic-0.1-20080828.src.rpm

ofed-scripts:
git://git.openfabrics.org/~vlad/ofed_scripts.git ofed_1_5

Thanks,
Dave

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
