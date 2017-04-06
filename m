From: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH] IB/rxe: Don't clamp residual length to mtu
Date: Thu,  6 Apr 2017 14:49:44 +0200
Message-ID: <20170406124944.11074-1-jthumshirn@suse.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Linux Kernel Mailinglist <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>, Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

When reading a RDMA WRITE FIRST packet we copy the DMA length from the RDMA
header into the qp->resp.resid variable for later use. Later in check_rkey()
we clamp it to the MTU if the packet is an  RDMA WRITE packet and has a
residual length bigger than the MTU. Later in write_data_in() we subtract the
payload of the packet from the residual length. If the packet happens to have a
payload of exactly the MTU size we end up with a residual length of 0 despite
the packet not being the last in the conversation. When the next packet in the
conversation arrives, we don't have any residual length left and thus set the QP
into an error state.

This broke NVMe over Fabrics functionality over rdma_rxe.ko

The patch was verified using the following test.

 # echo eth0 > /sys/module/rdma_rxe/parameters/add
 # nvme connect -t rdma -a 192.168.155.101 -s 1023 -n nvmf-test
 # mkfs.xfs -fK /dev/nvme0n1
 meta-data=/dev/nvme0n1           isize=256    agcount=4, agsize=65536 blks
          =                       sectsz=4096  attr=2, projid32bit=1
          =                       crc=0        finobt=0, sparse=0
 data     =                       bsize=4096   blocks=262144, imaxpct=25
          =                       sunit=0      swidth=0 blks
 naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
 log      =internal log           bsize=4096   blocks=2560, version=2
          =                       sectsz=4096  sunit=1 blks, lazy-count=1
 realtime =none                   extsz=4096   blocks=0, rtextents=0
 # mount /dev/nvme0n1 /tmp/
 [  148.923263] XFS (nvme0n1): Mounting V4 Filesystem
 [  148.961196] XFS (nvme0n1): Ending clean mount
 # dd if=/dev/urandom of=test.bin bs=1M count=128
 128+0 records in
 128+0 records out
 134217728 bytes (134 MB, 128 MiB) copied, 0.437991 s, 306 MB/s
 # sha256sum test.bin
 cde42941f045efa8c4f0f157ab6f29741753cdd8d1cff93a6b03649d83c4129a  test.bin
 # cp test.bin /tmp/
 sha256sum /tmp/test.bin
 cde42941f045efa8c4f0f157ab6f29741753cdd8d1cff93a6b03649d83c4129a  /tmp/test.bin

Signed-off-by: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Cc: Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_resp.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index c9dd385..58764df 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -478,8 +478,6 @@ static enum resp_states check_rkey(struct rxe_qp *qp,
 				state = RESPST_ERR_LENGTH;
 				goto err;
 			}
-
-			qp->resp.resid = mtu;
 		} else {
 			if (pktlen != resid) {
 				state = RESPST_ERR_LENGTH;
-- 
2.10.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
