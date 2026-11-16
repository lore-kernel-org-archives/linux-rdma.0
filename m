Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=220.197.31.3
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794834607;
	b=kJsusB2oc+Hx0NrTqA8aq67XP1xkKV8tgfN05aRqM24BxzpebFkjm1q8yon+SvuLT1a2
	 ggMnvTl5hojBzfMihFH5p+QJdoJATHdQgC/IY2RIohhU8bk6y3ihq53X8FzKgn88Rn7lk
	 BhSmI3ZyIFb7GaiotlXjUF3cKJJItVBobcA60mqrLGmwhBeI7VL9B/wPoJC+H0mMRqnhj
	 J7BdO5Mwiu6vvSQUXsD3c2XbUunEwh+cy6gZyL4ooJOARqlP+bLfCzDHlGhWzMYsEYZWB
	 C8QF8ZwnHAJ2B/CGyUyevkza+HKz7qgVvPmmKhEUEilXmXoxZ8CJd9hDgkgSUHKtt2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794834607;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-CM-TRANSID:X-Coremail-Antispam:X-CM-SenderInfo;
	bh=b68FNTlzlmlqrTbHaH7Dck2gPJT6FeXJ2H/HqfqMPDg=;
	b=bKiZuj87UXRKtrCDS8eF1w28t6qY5Btuf0zEKG5sBQS/V6OrsVU9WA2ByyJzcCW8X/ye
	 Q7eIVC5nuoximYDPDEwV+cFEjSloUBafnHuwCRxHwY6N7KaT1D7aZ5a/3PAOfO+FToaE3
	 CHfUEXWcymEqtBkUIYxWoiSeaYHytKLD5quYEn51YBmowRG5sdcRY7IPoecTc3Ql3Hh56
	 NwVqVAom7RX0ijZ3OHxgo0ihT3dhm9IBGTMd2OPA743Orz9SC8DcRmBwpEvUC1vdYr51f
	 K860MgOmhhOsoB3HTPdB0IYsO0mRLG02bliVQaagGjHfBNu8N4N9Ii0ErskpzrWfZOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=fFxSLqLE;
	arc=none smtp.remote-ip=220.197.31.3
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDC53606A323;
	Mon, 16 Nov 2026 13:10:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BDC53606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=fFxSLqLE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=b6
	8FNTlzlmlqrTbHaH7Dck2gPJT6FeXJ2H/HqfqMPDg=; b=fFxSLqLEjF7k4sjK0S
	24Tek8u5UiCtcOU5zaM8W856vS1Jc8XJI+cYyQkP4EiaENEX5qq117wYRcLrzrwN
	m7KP+0i4OTIhtnohhc2+WmHdJD5tMH7cVcRQazh5pY7xQmKqK61perXAbqnQucKX
	cXxZ32572K6vfsRM1tsAKCvFc=
Received: from user-VMware-Virtual-Platform.localdomain (unknown [])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wD3f_WVAPtqHE8VIA--.30076S2;
	Mon, 16 Nov 2026 21:09:41 +0800 (CST)
From: Ziheng Wei <zihengw03@163.com>
To: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] RDMA/hfi1: free CPU to SDMA map nodes after an RCU grace period
Date: Mon, 16 Nov 2026 21:09:40 +0800
Message-ID: <20261116130940.1629295-1-zihengw03@163.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3f_WVAPtqHE8VIA--.30076S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxWrWxWr47CFy5Wr43tr45trb_yoWrZw4kpF
	Z5Ka4Ykws2yF1ruwn3Jrs7AFyfWFn3Xa17Wa4DuF4fCrn5Xws3tr10kFy7Wrn8GFy8Arn5
	Xrn0gw1rCry8JrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jt8nOUUUUU=
X-CM-SenderInfo: p2lkv0ljzqjqqrwthudrp/xtbC7hW+D2r7AJUGkAAA3Y

sdma_select_user_engine() looks up the per-CPU sdma_rht_node in
dd->sdma_rht under rcu_read_lock() and reads rht_node->map[vl],
map->mask and map->sde[].  sdma_set_cpu_to_sde_map(), called when the
cpu_list sysfs attribute of an SDMA engine is written, removes a node
whose maps have become empty with rhashtable_remove_fast() and then
kfree()s the maps and the node right away.  There is no RCU grace
period between the removal and the free, so a user SDMA submission on
that CPU can read the node and the map after they have been freed.  If
the memory has been reused, the map pointer and the engine pointer read
from it are arbitrary, and the caller goes on to use that engine.

Writing cpu_list requires CAP_SYS_ADMIN.  The reader is reachable by any
user that can open /dev/hfi1_N, when the task submitting user SDMA
requests is pinned to a single CPU.  So this needs an administrator to
change the SDMA engine CPU lists while jobs are running.

The debugfs dump in sdma_seqfile_dump_cpu_list() has the same problem,
and in addition does not hold the RCU read lock at all while walking
the node, because rhashtable_lookup_fast() drops it before returning.

Free the node and its maps from an RCU callback, as is already done for
dd->sdma_map, and do the debugfs lookup and walk inside an RCU read-side
critical section.  hfi1_free_devdata() calls rcu_barrier() before
sdma_clean(), so no callback can still be pending when the hash table
is destroyed.

Found by LLM-assisted static analysis.  Not reproduced, as I have no
Omni-Path hardware; build tested only.

Fixes: 0cb2aa690c7e ("IB/hfi1: Add sysfs interface for affinity setup")
Fixes: af3674d62d34 ("IB/hfi1: Add new debugfs sdma_cpu_list file")
Cc: stable@vger.kernel.org
Signed-off-by: Ziheng Wei <zihengw03@163.com>
---

Notes:
    The changelog was drafted with an AI assistant from my analysis;
    I have reviewed the code, the fix and the text.

 drivers/infiniband/hw/hfi1/sdma.c | 45 ++++++++++++++++++-------------
 1 file changed, 27 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/sdma.c b/drivers/infiniband/hw/hfi1/sdma.c
index a71fc8f2d..bf9e362f1 100644
--- a/drivers/infiniband/hw/hfi1/sdma.c
+++ b/drivers/infiniband/hw/hfi1/sdma.c
@@ -801,6 +801,7 @@ struct sdma_rht_node {
 	unsigned long cpu_id;
 	struct sdma_rht_map_elem *map[HFI1_MAX_VLS_SUPPORTED];
 	struct rhash_head node;
+	struct rcu_head rcu;
 };
 
 #define NR_CPUS_HINT 192
@@ -886,6 +887,22 @@ static void sdma_cleanup_sde_map(struct sdma_rht_map_elem *map,
 	}
 }
 
+static void sdma_rht_free(void *ptr, void *arg)
+{
+	struct sdma_rht_node *rht_node = ptr;
+	int i;
+
+	for (i = 0; i < HFI1_MAX_VLS_SUPPORTED; i++)
+		kfree(rht_node->map[i]);
+
+	kfree(rht_node);
+}
+
+static void sdma_rht_free_rcu(struct rcu_head *head)
+{
+	sdma_rht_free(container_of(head, struct sdma_rht_node, rcu), NULL);
+}
+
 /*
  * Prevents concurrent reads and writes of the sdma engine cpu_mask
  */
@@ -1027,10 +1044,11 @@ ssize_t sdma_set_cpu_to_sde_map(struct sdma_engine *sde, const char *buf,
 							     sdma_rht_params);
 				WARN_ON(ret);
 
-				for (i = 0; i < HFI1_MAX_VLS_SUPPORTED; i++)
-					kfree(rht_node->map[i]);
-
-				kfree(rht_node);
+				/*
+				 * sdma_select_user_engine() may still be
+				 * using the node under rcu_read_lock().
+				 */
+				call_rcu(&rht_node->rcu, sdma_rht_free_rcu);
 			}
 		}
 	}
@@ -1055,17 +1073,6 @@ ssize_t sdma_get_cpu_to_sde_map(struct sdma_engine *sde, char *buf)
 	return strnlen(buf, PAGE_SIZE);
 }
 
-static void sdma_rht_free(void *ptr, void *arg)
-{
-	struct sdma_rht_node *rht_node = ptr;
-	int i;
-
-	for (i = 0; i < HFI1_MAX_VLS_SUPPORTED; i++)
-		kfree(rht_node->map[i]);
-
-	kfree(rht_node);
-}
-
 /**
  * sdma_seqfile_dump_cpu_list() - debugfs dump the cpu to sdma mappings
  * @s: seq file
@@ -1081,10 +1088,10 @@ void sdma_seqfile_dump_cpu_list(struct seq_file *s,
 	struct sdma_rht_node *rht_node;
 	int i, j;
 
-	rht_node = rhashtable_lookup_fast(dd->sdma_rht, &cpuid,
-					  sdma_rht_params);
+	rcu_read_lock();
+	rht_node = rhashtable_lookup(dd->sdma_rht, &cpuid, sdma_rht_params);
 	if (!rht_node)
-		return;
+		goto out;
 
 	seq_printf(s, "cpu%3lu: ", cpuid);
 	for (i = 0; i < HFI1_MAX_VLS_SUPPORTED; i++) {
@@ -1107,6 +1114,8 @@ void sdma_seqfile_dump_cpu_list(struct seq_file *s,
 	}
 
 	seq_puts(s, "\n");
+out:
+	rcu_read_unlock();
 }
 
 /*

base-commit: 97d73c8251226cf27cc6656b4c542869bb8c69fa
-- 
2.43.0

