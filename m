Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB23D175A5;
	Fri, 28 Aug 2026 00:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787875960; cv=none; b=iBTkXJppEnvcA4143KJ4VQ+bS7xQPelUqQOPkJtUkOPNXj0ODuf7d29+NDUKyNpcezhOwFtoloch4gmmD9GmEuKYQM36Av34mzBNHmcI7/gLy6aL66p4XI3xAnkc29wQYn5636O8qFwhVjGnnMqR1Xvoga51bt2mDJnWnsr5I+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787875960; c=relaxed/simple;
	bh=2hHQDq8+RfNXkFmSZpp1GMkJiiuqB2/Xsh3zOp1xYcU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ozp4tWypOPaef6N/DdImk6zQj6Jr6qwdV99J5XYfD+9lfXZxH40hsv9tPoNQcoslaKzEvKodJgpzWIRpLgLrPcD8eEeiQzkZ53kIfdHHA28sHVImRQHE3w0ZuSxhcfv0EkceI6ygGM+aXaHgGqQpQyR2TcNY3mzLGBKKGX38Vio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id 5904E20B7167; Thu, 27 Aug 2026 17:12:05 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5904E20B7167
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
Subject: [PATCH net v2] net: mana: Clear RDMA teardown and suspend state in mana_rdma_probe()
Date: Thu, 27 Aug 2026 17:12:02 -0700
Message-ID: <20260828001202.2110938-1-longli@microsoft.com>
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

Clear both in mana_rdma_probe(). is_suspended is otherwise only touched
by mana_rdma_service_handle() on the ordered service workqueue, so clear
it while rdma_teardown still gates that handler and re-open the gate with
smp_store_release(), paired with smp_load_acquire() in the handler.

Fixes: 505cc26bcae0 ("net: mana: Add support for auxiliary device servicing events")
Signed-off-by: Long Li <longli@microsoft.com>
---
Changes in v2:
- No functional change; the diff is identical to v1, rebased on net/main.
- Target the net tree explicitly in the subject prefix; v1 omitted it and
  the netdev CI guessed net-next, where the Fixes: tag is not evaluated.

v1: https://lore.kernel.org/all/20260826235940.1869565-1-longli@microsoft.com/
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 7a1ac853e3abcd28c4a1e5c6987ec631a18ad840..56f426da728647e39f4c4ffa9c66123436297ac1 100644
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
@@ -4279,6 +4280,17 @@ int mana_rdma_probe(struct gdma_dev *gd)
 	if (err)
 		return err;
 
+	/* Clear the state left by a previous mana_rdma_remove() so servicing
+	 * events are handled again after a reset cycle.
+	 */
+	gd->is_suspended = false;
+
+	/* Publish is_suspended before re-opening the gate, so the handler
+	 * cannot act on a stale value.  Pairs with the smp_load_acquire()
+	 * in mana_rdma_service_handle().
+	 */
+	smp_store_release(&gd->rdma_teardown, false);
+
 	err = add_adev(gd, "rdma");
 	if (err)
 		mana_gd_deregister_device(gd);
-- 
2.43.0

