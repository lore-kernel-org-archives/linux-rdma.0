Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D02EC35AC11;
	Wed,  2 Sep 2026 17:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788371564; cv=none; b=j8FEb3cXkMXuJjz6xiwFScvJbvck/VrmYRYzhUchXal/c25VBTbH7B4bfeyrq2DfjR0PvfJcVhA/bMdIcAdVzwW97GpKcXOChC9TjbWHS3fgt3IRiE9qF4XH3hiUSkIMvZVDqD20fbPL/acNt2U7ciUCNnCs48r7glSvlzk0MM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788371564; c=relaxed/simple;
	bh=YVNtSg2MyyFvAtx+ywzZAiw3i0NgncKT5WbHKGDdgNo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ufkpnfzknmAo43f3obMiMwfewYh9CQryb1n7FbTjYnwd1LWy7Snnd4sgvqudf3EmuPkSQexbIbOdjCW9kdUaVD8fh5nDVWHp117pwpjHu5TvzMSimiGiP4DZnqCmGIvwViD/110C3XKIG+/F4V8y1LUgJK0yLWRQbmP7E4FOFr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id B469A20B712B; Wed,  2 Sep 2026 10:52:05 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B469A20B712B
From: Long Li <longli@microsoft.com>
To: Long Li <longli@microsoft.com>,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	shradhagupta@linux.microsoft.com,
	Simon Horman <horms@kernel.org>,
	ernis@linux.microsoft.com,
	stephen@networkplumber.org,
	shirazsaleem@microsoft.com
Cc: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net v3] net: mana: Clear RDMA teardown and suspend state in mana_rdma_probe()
Date: Wed,  2 Sep 2026 10:51:53 -0700
Message-ID: <20260902175153.3410560-1-longli@microsoft.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mana_rdma_remove() sets gd->rdma_teardown to stop
mana_rdma_service_handle() from acting on servicing events, but nothing
ever clears it. A hardware service reset (GDMA_EQE_HWC_RESET_REQUEST)
goes through mana_gd_suspend() -> mana_rdma_remove() and mana_gd_resume()
-> mana_rdma_probe(), so from the first reset onwards every
GDMA_EQE_HWC_SOC_SERVICE event returns early and RDMA suspend/resume
servicing is silently dropped for the life of the device.

gd->is_suspended has the same problem: it is set when servicing removes
the adev and is cleared only by a matching resume. A reset while RDMA is
suspended re-adds the adev but leaves is_suspended set, so a later resume
event calls add_adev() on top of a live gd->adev and leaks it. This is
currently masked by the rdma_teardown bug.

Clear both in mana_rdma_probe(). On the reset path mana_rdma_remove()
has closed the gate and drained the service workqueue, so clear
is_suspended first and re-open the gate with smp_store_release(), paired
with smp_load_acquire() in the handler, so the handler cannot observe an
open gate with a stale is_suspended. On the initial probe path the gate
was never closed and both flags are already clear.

This does not order gd->adev, which add_adev() publishes afterwards. A
servicing event arriving in that window is still dropped, as it is in
mainline today on the initial probe path; closing it needs probe and the
handler to be serialized and is left to a separate change.

Fixes: 505cc26bcae0 ("net: mana: Add support for auxiliary device servicing events")
Signed-off-by: Long Li <longli@microsoft.com>
---
Changes in v3:
- Reword the comment and commit message so they only claim what holds:
  the "gate is still closed" justification applies to the reset path,
  not to the initial probe path where gc is zeroed and the gate was
  never closed. Note that the release/acquire pair orders is_suspended
  but not gd->adev. Reported by the AI review of v2.
- No functional change.

Changes in v2:
- Target the net tree explicitly in the subject prefix; v1 omitted it and
  the netdev CI guessed net-next, where the Fixes: tag is not evaluated.
- CC Shiraz Saleem, the author of the commit named in the Fixes: tag, as
  reported by netdev/cc_maintainers.

v2: https://lore.kernel.org/all/20260828001202.2110938-1-longli@microsoft.com/
v1: https://lore.kernel.org/all/20260826235940.1869565-1-longli@microsoft.com/
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 7a1ac853e3abcd28c4a1e5c6987ec631a18ad840..d8e847df7a44b2758b428d49b2b060bfd94b0e58 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -3983,7 +3983,8 @@ static void mana_rdma_service_handle(struct work_struct *work)
 	struct device *dev = gd->gdma_context->dev;
 	int ret;
 
-	if (READ_ONCE(gd->rdma_teardown))
+	/* Pairs with the smp_store_release() in mana_rdma_probe(). */
+	if (smp_load_acquire(&gd->rdma_teardown))
 		goto out;
 
 	switch (serv_work->event) {
@@ -4279,6 +4280,21 @@ int mana_rdma_probe(struct gdma_dev *gd)
 	if (err)
 		return err;
 
+	/* Clear the state left by a previous mana_rdma_remove() so servicing
+	 * events are handled again after a reset cycle.
+	 */
+	gd->is_suspended = false;
+
+	/* Publish is_suspended before re-opening the gate, so the handler
+	 * cannot observe an open gate with a stale is_suspended.  Pairs
+	 * with the smp_load_acquire() in mana_rdma_service_handle().  This
+	 * matters on the reset path, where mana_rdma_remove() closed the
+	 * gate and drained the workqueue; on the initial probe path the
+	 * gate was never closed and both flags are already clear.  It does
+	 * not order gd->adev, which add_adev() publishes below.
+	 */
+	smp_store_release(&gd->rdma_teardown, false);
+
 	err = add_adev(gd, "rdma");
 	if (err)
 		mana_gd_deregister_device(gd);
-- 
2.43.0

