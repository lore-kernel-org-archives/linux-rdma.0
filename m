From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH v2] RDMA/iwpm: Fix uninitialized error code in iwpm_send_mapinfo()
Date: Wed, 29 Nov 2017 09:47:33 +0100
Message-ID: <1511945253-29296-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tatyana Nikolova <Tatyana.E.Nikolova@intel.com>, Roland Dreier <roland@purestorage.com>, Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
List-Id: linux-rdma@vger.kernel.org

With gcc-4.1.2:

    drivers/infiniband/core/iwpm_util.c: In function ‘iwpm_send_mapinfo’:
    drivers/infiniband/core/iwpm_util.c:647: warning: ‘ret’ may be used uninitialized in this function

Indeed, if nl_client is not found in any of the scanned has buckets, ret
will be used uninitialized.

Preinitialize ret to -EINVAL to fix this.

Fixes: 30dc5e63d6a5ad24 ("RDMA/core: Add support for iWARP Port Mapper user space service")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
v2:
  - Use -EINVAL instead of zero,
  - Move the preinitialization to just before the loop, to catach future
    early offenders,
  - Drop RFC state.
---
 drivers/infiniband/core/iwpm_util.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/core/iwpm_util.c b/drivers/infiniband/core/iwpm_util.c
index 3c4faadb8cddd7fd..81528f64061a49df 100644
--- a/drivers/infiniband/core/iwpm_util.c
+++ b/drivers/infiniband/core/iwpm_util.c
@@ -654,6 +654,7 @@ int iwpm_send_mapinfo(u8 nl_client, int iwpm_pid)
 	}
 	skb_num++;
 	spin_lock_irqsave(&iwpm_mapinfo_lock, flags);
+	ret = -EINVAL;
 	for (i = 0; i < IWPM_MAPINFO_HASH_SIZE; i++) {
 		hlist_for_each_entry(map_info, &iwpm_hash_bucket[i],
 				     hlist_node) {
-- 
2.7.4
