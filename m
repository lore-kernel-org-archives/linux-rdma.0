From: Mike Marciniszyn <mike.marciniszyn@intel.com>
Subject: [PATCH] IB/hfi1: Incorrect sizing of sge for PIO will OOPs
Date: Wed, 02 Jan 2019 09:59:10 -0800
Message-ID: <20190102175907.18332.56448.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: stable@vger.kernel.org
Cc: linux-rdma@vger.kernel.org, stable-commits@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Michael J. Ruhl <michael.j.ruhl@intel.com>

Upstream commit dbc2970caef74e8ff41923d302aa6fb5a4812d0e.

An incorrect sge sizing in the HFI PIO path will cause an OOPs similar to
this:

BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [] hfi1_verbs_send_pio+0x3d8/0x530 [hfi1]
PGD 0
Oops: 0000 1 SMP
 Call Trace:
 ? hfi1_verbs_send_dma+0xad0/0xad0 [hfi1]
 hfi1_verbs_send+0xdf/0x250 [hfi1]
 ? make_rc_ack+0xa80/0xa80 [hfi1]
 hfi1_do_send+0x192/0x430 [hfi1]
 hfi1_do_send_from_rvt+0x10/0x20 [hfi1]
 rvt_post_send+0x369/0x820 [rdmavt]
 ib_uverbs_post_send+0x317/0x570 [ib_uverbs]
 ib_uverbs_write+0x26f/0x420 [ib_uverbs]
 ? security_file_permission+0x21/0xa0
 vfs_write+0xbd/0x1e0
 ? mntput+0x24/0x40
 SyS_write+0x7f/0xe0
 system_call_fastpath+0x16/0x1b

Fix by adding the missing sizing check to correctly determine the sge
length.

Fixes: 7724105686e7 ("IB/hfi1: add driver files")
Cc: <stable@vger.kernel.org> # 4.9.x+
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
---
 drivers/infiniband/hw/hfi1/verbs.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index a365089..b7257d7 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -919,6 +919,8 @@ int hfi1_verbs_send_pio(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 
 				if (slen > len)
 					slen = len;
+				if (slen > ss->sge.sge_length)
+					slen = ss->sge.sge_length;
 				rvt_update_sge(ss, slen, false);
 				seg_pio_copy_mid(pbuf, addr, slen);
 				len -= slen;
