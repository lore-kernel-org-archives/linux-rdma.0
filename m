Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B293BB9F6;
	Wed, 25 Mar 2026 10:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774435261; cv=none; b=Th1HmdI3GCJ2MYdqt2QktuJokrf/qU+zR4nN/aq5JZKr2BhtilkqFwSEkCoxcllTniQvxkO2GiAucdJvJ/URfjaV7i2l9M7fOX7F7RJe30H/9VVtj4LXWjmH+FnlDVpHulqMXyaLi2KHuyJ7MWdfto4uxaINUZlLQIU4jGk0A7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774435261; c=relaxed/simple;
	bh=tZCOGB1Juv3CYG/AkkF+tXpBfRxAnEO0JPjpHr9bevI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IHMHyM7C57PN+e6EEXk+uT8h52BZtxUsWRKHdxNDCY9AO3kVPZyY+/36TWNCBZ0i2rV6m67QR/ZMHznQshKmn13UZrcLXag7KJP6SIhq+zMC+q3p52BE13H/Kp1zzVN4bjrjP/kE7QTvNgGV2NdG/jezL2RvLM+OkDeSHALZa3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=OgyP8qaR; arc=none smtp.client-ip=113.46.200.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="OgyP8qaR"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=DqCbZt5seHQqOT6l50iys6LoGplZkiKlohxPQFUtJv8=;
	b=OgyP8qaRU7zvE/R0WPguFj+P/RbwyQUX9QjF+6DeIF3GMvweSp+XvvSzdprzWdIYXPg1jLSgw
	rf/nkpcRGN5TBUePnl92Mg25Hrd94d7KfChyN40X09p3SBcP07mZSh6CEU4GOfVTBNlJO064C8X
	IivZ4qL+xTOPx2sbkYeYfVo=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4fgjwT0GPpzpSty;
	Wed, 25 Mar 2026 18:35:21 +0800 (CST)
Received: from kwepemj500018.china.huawei.com (unknown [7.202.194.48])
	by mail.maildlp.com (Postfix) with ESMTPS id EA4A240569;
	Wed, 25 Mar 2026 18:40:56 +0800 (CST)
Received: from huawei.com (10.50.85.128) by kwepemj500018.china.huawei.com
 (7.202.194.48) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 25 Mar
 2026 18:40:56 +0800
From: Li Xiasong <lixiasong1@huawei.com>
To: "D. Wythe" <alibuda@linux.alibaba.com>, Dust Li
	<dust.li@linux.alibaba.com>, Sidraya Jayagond <sidraya@linux.ibm.com>, Wenjia
 Zhang <wenjia@linux.ibm.com>, Mahanta Jambigi <mjambigi@linux.ibm.com>, Tony
 Lu <tonylu@linux.alibaba.com>, Wen Gu <guwen@linux.alibaba.com>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub
 Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman
	<horms@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <linux-s390@vger.kernel.org>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<yuehaibing@huawei.com>, <zhangchangzhong@huawei.com>,
	<weiyongjun1@huawei.com>
Subject: [PATCH net 2/2] net/smc: fix potential UAF in smc_pnet_add_ib for smcd device
Date: Wed, 25 Mar 2026 19:03:52 +0800
Message-ID: <20260325110352.3833570-3-lixiasong1@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260325110352.3833570-1-lixiasong1@huawei.com>
References: <20260325110352.3833570-1-lixiasong1@huawei.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemj500018.china.huawei.com (7.202.194.48)

smc_pnet_find_smcd() returns an smcd device pointer and releases the
lock, then smc_pnet_apply_smcd() is called to use this pointer. The
device could be removed between these two calls, leading to a potential
use-after-free when accessing the freed smcd pointer.

    CPU 0                           CPU 1
    ----                            ----
    smc_pnet_add_ib()
      smcd = smc_pnet_find_smcd()
        mutex_lock(&smcd_dev_list.mutex)
        list_for_each_entry() ...
        mutex_unlock(&smcd_dev_list.mutex)
                                    smcd_unregister_dev()
                                      mutex_lock(&smcd_dev_list.mutex)
                                      list_del_init(&smcd->list)
                                      mutex_unlock(&smcd_dev_list.mutex)
                                      kfree(smcd)
      smc_pnet_apply_smcd(smcd)
        smcd->pnetid                   <- UAF (smcd already freed)

Fix this by introducing smc_pnet_find_smcd_apply() which performs both
find and apply under the same lock, preventing the device from being
removed in between.

Also refactor smc_pnet_apply_smcd() into __smc_pnet_apply_smcd()
(without lock) and smc_pnet_apply_smcd() (with lock) for reuse.

Fixes: 69baaac9361e ("dibs: Define dibs_client_ops and dibs_dev_ops")
Signed-off-by: Li Xiasong <lixiasong1@huawei.com>
---
 net/smc/smc_pnet.c | 58 ++++++++++++++++++++++++++++------------------
 1 file changed, 36 insertions(+), 22 deletions(-)

diff --git a/net/smc/smc_pnet.c b/net/smc/smc_pnet.c
index 91c0b1c473b2..a1603740167b 100644
--- a/net/smc/smc_pnet.c
+++ b/net/smc/smc_pnet.c
@@ -270,16 +270,22 @@ static bool smc_pnet_apply_ib(struct smc_ib_device *ib_dev, u8 ib_port,
 
 /* Apply pnetid to smcd device when no pnetid is set.
  */
-static bool smc_pnet_apply_smcd(struct smcd_dev *smcd_dev, char *pnet_name)
+static bool __smc_pnet_apply_smcd(struct smcd_dev *smcd_dev, char *pnet_name)
 {
-	bool applied = false;
-
-	mutex_lock(&smcd_dev_list.mutex);
 	if (!smc_pnet_is_pnetid_set(smcd_dev->pnetid)) {
 		memcpy(smcd_dev->pnetid, pnet_name, SMC_MAX_PNETID_LEN);
 		smcd_dev->pnetid_by_user = true;
-		applied = true;
+		return true;
 	}
+	return false;
+}
+
+static bool smc_pnet_apply_smcd(struct smcd_dev *smcd_dev, char *pnet_name)
+{
+	bool applied;
+
+	mutex_lock(&smcd_dev_list.mutex);
+	applied = __smc_pnet_apply_smcd(smcd_dev, pnet_name);
 	mutex_unlock(&smcd_dev_list.mutex);
 	return applied;
 }
@@ -351,23 +357,39 @@ static bool smc_pnet_find_ib_apply(char *ib_name, u8 ib_port, char *pnet_name)
 }
 
 /* Find an smcd device by a given name. The device might not exist. */
-static struct smcd_dev *smc_pnet_find_smcd(char *smcd_name)
+static struct smcd_dev *__smc_pnet_find_smcd(char *smcd_name)
 {
 	struct smcd_dev *smcd_dev;
 
-	mutex_lock(&smcd_dev_list.mutex);
 	list_for_each_entry(smcd_dev, &smcd_dev_list.list, list) {
 		if (!strncmp(dev_name(&smcd_dev->dibs->dev), smcd_name,
 			     IB_DEVICE_NAME_MAX - 1) ||
 		    (smcd_dev->dibs->dev.parent &&
 		     !strncmp(dev_name(smcd_dev->dibs->dev.parent), smcd_name,
 			      IB_DEVICE_NAME_MAX - 1)))
-			goto out;
+			return smcd_dev;
+	}
+	return NULL;
+}
+
+/* Find an smcd device by name and apply pnetid under lock. */
+static bool smc_pnet_find_smcd_apply(char *smcd_name, char *pnet_name)
+{
+	struct smcd_dev *smcd_dev;
+	bool rc = true;
+
+	mutex_lock(&smcd_dev_list.mutex);
+	smcd_dev = __smc_pnet_find_smcd(smcd_name);
+	if (smcd_dev) {
+		if (!__smc_pnet_apply_smcd(smcd_dev, pnet_name))
+			rc = false;
+		else
+			pr_warn_ratelimited("smc: smcd device %s applied user defined pnetid %.16s\n",
+					    dev_name(&smcd_dev->dibs->dev),
+					    smcd_dev->pnetid);
 	}
-	smcd_dev = NULL;
-out:
 	mutex_unlock(&smcd_dev_list.mutex);
-	return smcd_dev;
+	return rc;
 }
 
 static int smc_pnet_add_eth(struct smc_pnettable *pnettable, struct net *net,
@@ -437,22 +459,14 @@ static int smc_pnet_add_ib(struct smc_pnettable *pnettable, char *ib_name,
 			   u8 ib_port, char *pnet_name)
 {
 	struct smc_pnetentry *tmp_pe, *new_pe;
-	bool smcddev_applied = true;
+	bool smcddev_applied;
 	bool ibdev_applied;
-	struct smcd_dev *smcd;
 	bool new_ibdev;
 
 	/* try to apply the pnetid to active devices */
 	ibdev_applied = smc_pnet_find_ib_apply(ib_name, ib_port, pnet_name);
-	smcd = smc_pnet_find_smcd(ib_name);
-	if (smcd) {
-		smcddev_applied = smc_pnet_apply_smcd(smcd, pnet_name);
-		if (smcddev_applied) {
-			pr_warn_ratelimited("smc: smcd device %s applied user defined pnetid %.16s\n",
-					    dev_name(&smcd->dibs->dev),
-					    smcd->pnetid);
-		}
-	}
+	smcddev_applied = smc_pnet_find_smcd_apply(ib_name, pnet_name);
+
 	/* Apply fails when a device has a hardware-defined pnetid set, do not
 	 * add a pnet table entry in that case.
 	 */
-- 
2.34.1

