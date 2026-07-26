Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D516C37BE99;
	Sun, 26 Jul 2026 12:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785068512; cv=none; b=pQB7fHLLJw0okGd6yebU8+Zrwj7h6iF+qIgxdwjBwUAKD/woo3Ed83xunKn+R9CxsX6Yn6ITmM8IMNAfc3zdBTPSJVfowz+aGeu3PPNOhcOVG9fpOv7WvgMoOV2CznHycStV25zz6JyAGgUJ8S8uKwm8KRI1/QMh6xk3XCU+KLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785068512; c=relaxed/simple;
	bh=6nfvXZAD3VQBzDBm/BCcAbpDk5VR+8pFF+Z6sJIKACk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=nQBYAjtKMDySVF7mVx3iqxtfNVS8cncl9W+/za8mdefYcbgdUCGz/htB79sGdPTNpZ0Fge7VC+p/125s5WYvvpJ0A0VfrDv3XubSS1kQqX6UThcoxEKxdhHNtSq5Is979STW6q+HGYVoaVnbcAxBzhnsYeWNX8rO9tJfJGE4Tec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ei3s7Ice; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ei3s7Ice"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B396D1F00A3A;
	Sun, 26 Jul 2026 12:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785068510;
	bh=W5YwKmO26z3afWdA570hbju3GWlIHMjHpHahFjCd6L4=;
	h=From:To:Cc:Subject:Date;
	b=ei3s7IceWTPamOnyRPLmAs7hYUqLhornIteEfQoA6mlL6uANwMXpkLivGPDaK/Bwz
	 JDotAUCe90a5GcHwdLwoWRFBT+PG9B9xB+aGQ1ko/Ge3clpau2lpYgSa5Veam19JrY
	 9sjvx6cI8YdNaDKuIcdE1AEuc22tC/LXqPzF7hsIG4OA9DkTuU1VK23rN+riISOIMO
	 8FSGCl1HlsHYFCnX7D5VQmu/M87LDarySrzpR1lCtQq6QhVpsOCFCIsvlyUw9Q642+
	 qrualfltX9EIsZfvRvIFEkhXke57HEKEMiEq5ZaP2T6tNTU/LpEWhHREf9G5cZlq8t
	 nxPk3tIRhJpGQ==
From: Leon Romanovsky <leon@kernel.org>
To: Potnuri Bharat Teja <bharat@chelsio.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Steve Wise <larrystevenwise@gmail.com>,
	Roland Dreier <roland@purestorage.com>,
	Vipul Pandya <vipul@chelsio.com>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next] RDMA/cxgb4: free STAG index when TPT entry write fails
Date: Sun, 26 Jul 2026 15:21:44 +0300
Message-ID: <20260726-leak-of-allocated-stag-idx-in-write-v1-1-72e0c401fc1a@nvidia.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Change-ID: 20260726-leak-of-allocated-stag-idx-in-write-3eb7938e4636
X-Mailer: b4 0.15-dev-18f8f
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

write_tpt_entry() allocates a new STAG index with c4iw_get_resource() and
bumps stats.stag.cur before programming the entry.  When
write_adapter_mem() fails, it returns the error without releasing the index
or reversing the statistic.  No MR is inserted into rhp->mrs, so
deregistration never reclaims it, leaking the index until device teardown.

Record whether this call allocated the index and, on a failed write, return
it to tpt_table and decrement stats.stag.cur.  Key the rollback on both the
write error and that flag, not the error alone: a non-reset update carries
a caller-owned STAG that this call did not allocate and must not free.

Fixes: ec3eead21718 ("RDMA/cxgb4: Remove kfifo usage")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/cxgb4/mem.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/hw/cxgb4/mem.c
index dc2f494b1007..562dba759df4 100644
--- a/drivers/infiniband/hw/cxgb4/mem.c
+++ b/drivers/infiniband/hw/cxgb4/mem.c
@@ -271,6 +271,7 @@ static int write_tpt_entry(struct c4iw_rdev *rdev, u32 reset_tpt_entry,
 	int err;
 	struct fw_ri_tpte *tpt;
 	u32 stag_idx;
+	bool stag_idx_allocated = false;
 	static atomic_t key;
 
 	if (c4iw_fatal_error(rdev))
@@ -292,6 +293,7 @@ static int write_tpt_entry(struct c4iw_rdev *rdev, u32 reset_tpt_entry,
 			kfree(tpt);
 			return -ENOMEM;
 		}
+		stag_idx_allocated = true;
 		mutex_lock(&rdev->stats.lock);
 		rdev->stats.stag.cur += 32;
 		if (rdev->stats.stag.cur > rdev->stats.stag.max)
@@ -327,7 +329,7 @@ static int write_tpt_entry(struct c4iw_rdev *rdev, u32 reset_tpt_entry,
 				(rdev->lldi.vr->stag.start >> 5),
 				sizeof(*tpt), tpt, skb, wr_waitp);
 
-	if (reset_tpt_entry) {
+	if (reset_tpt_entry || (err && stag_idx_allocated)) {
 		c4iw_put_resource(&rdev->resource.tpt_table, stag_idx);
 		mutex_lock(&rdev->stats.lock);
 		rdev->stats.stag.cur -= 32;

---
base-commit: a273210687f255b12c2f6baf8f25ff80cdbb29ed
change-id: 20260726-leak-of-allocated-stag-idx-in-write-3eb7938e4636

Best regards,
--  
Leon Romanovsky <leonro@nvidia.com>

