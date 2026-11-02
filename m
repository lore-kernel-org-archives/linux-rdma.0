Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=117.135.210.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793607507;
	b=QFlBdSXA3ERWXJeWyhkgyr1mcGHOVijUDmUOmz3XFI78Dhu30vlXNEjyAIRoTYg7Nlfs
	 QAXOuwQInzlL1cL8BbmenZpCu++vIRzbELiC9zf4GmydJocK0E4vrZnj1YPpfIeLl8IlY
	 UWJjcm2V0SSFzyqtl6tr37LrooTKgAKCcocPEvBU2cMcupbAXygx6Tjabq24x1M655cTD
	 SHjUjhkGcYO36kBYPjAyFt7hg5phSqNbbtJmd5qUM70nVcY6BgQQU+p+dCDwUHiw08WZ0
	 fkX5WEFBVnTxo6n8pGK5RqTxKc+HgvElTuf1Pnmn80Cr0LZbSpyId+s3rEzX7pJNYzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793607507;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-CM-TRANSID:X-Coremail-Antispam:X-CM-SenderInfo;
	bh=FYdFc44IQikX6J1CTFDnvhjQzgd+C32LDt8NR+Ki3Fk=;
	b=2xogotwbbUs3JHXXy0z4hcVUxstESCfKGdvB2yE/3RVuZp2WLsTeHM232JgMiyzFlluQ
	 gbwdXunbWZN2ThN3ipfK1YGf8xLj6DgtlKCVQvxu3AQtKCjSOKz2I+rzNT2v7QQd7bkFS
	 ozrlmChLxAGCVQzOt1U3uZfjqK9P6rAoEFo5pz5Z/ecqVzbQo5/ybki/yYfO57jlgnPDW
	 Pb01JV6XGTRo2Ma9Vd2Anc77l506ORJ027ZUbvBIzcYARs+4/Z7FIvWYeFf9E1a5NOqa1
	 VIBcidVOQur+GgkkkWGD/nKcKxq1rY5j25tTcNYDABY5BTY7YiTJg5vzKP8B1fc2EPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=dle2+n6E;
	arc=none smtp.remote-ip=117.135.210.5
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 097E2606A324;
	Mon,  2 Nov 2026 08:18:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 097E2606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=dle2+n6E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=FY
	dFc44IQikX6J1CTFDnvhjQzgd+C32LDt8NR+Ki3Fk=; b=dle2+n6ELVXVk8SvAO
	2TRW7qbtC0xM/R2qdAcCl4bbwyUxkBvV4h0ZK1HRwGly5dnAjHQOM35NmGhepOgH
	V+44yKC7mnfUUYY+P/ST8Yf0YeCKwZcfQmrP6p0GAwL5VdZj5nIb+Ug5j8t1/hdt
	uW5j62SIuPETAomxMg5HVoPng=
Received: from colol4bi5.localdomain (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wDn1jhGR+hqZ3mIEg--.61514S2;
	Mon, 02 Nov 2026 16:18:15 +0800 (CST)
From: Binbin Deng <18983559317@163.com>
To: jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Binbin Deng <18983559317@163.com>
Subject: [PATCH v1] RDMA/iwpm: Fix use-after-free in mapping info dump
Date: Mon,  2 Nov 2026 16:18:13 +0800
Message-ID: <20261102081813.37754-1-18983559317@163.com>
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
X-CM-TRANSID:_____wDn1jhGR+hqZ3mIEg--.61514S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxXryDAw4DKr1DZryUCryrCrg_yoW7Jryxpr
	WFqF90kF1vvFn29rZ7G34xWF47Gw1qgFsrJayxGw4xAr15Xry2g3Z3CF909FykAF17Jr1x
	ArZ2v3Z8AFZ8ZF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pi8uctUUUUU=
X-CM-SenderInfo: jprymmytvvmjmrxbiqqrwthudrp/xtbC3we3m2roR0cRbAAA3L

iwpm_send_mapinfo() walks the mapinfo hash table while holding
iwpm_mapinfo_lock, but when the current skb is full it temporarily drops
that lock to send the skb and allocate another one.  The hlist iterator is
not protected across that window:

CPU0                                                CPU1
iwpm_send_mapinfo()
spin_lock_irqsave(&iwpm_mapinfo_lock, flags)
hlist_for_each_entry(..., map_info, ...)
  map_info points at map_info A
  fill the current skb
  spin_unlock_irqrestore(&iwpm_mapinfo_lock,flags)
  send the skb / allocate the next skb
                                                    iwpm_remove_mapinfo()
                                                    spin_lock_irqsave(&iwpm_mapinfo_lock,flags)
                                                    find map_info A
                                                    hlist_del_init(&A->hlist_node)
                                                    kfree(A)
                                                    spin_unlock_irqrestore(&iwpm_mapinfo_lock, flags)
spin_lock_irqsave(&iwpm_mapinfo_lock, flags)
hlist_for_each_entry() reads A->hlist_node.next

CPU0 then resumes an iterator whose object has been freed, producing a
use-after-free.  The race is reachable with many mapped iWARP CM IDs when
the port mapper hello path dumps the mapinfo table concurrently with
teardown of the ID at the iterator position.  It can be reported by KASAN
or lead to memory corruption and a panic.

The spinlock still protects the hash table itself, but it cannot protect
an iterator that is retained across an unlock.  Add a mutex which covers
the complete dump and also serializes individual removal and full-table
cleanup.  The netlink dump and CM ID teardown paths can sleep, so this
outer lock is appropriate.

Found during a static-analysis-assisted audit: candidate sites were
surfaced by a Coccinelle rule, and the reader/writer paths were
confirmed by deep code inspection. Due to a lack of hardware
infrastructure, the issue was not observed at runtime.

Fixes: 30dc5e63d6a5 ("RDMA/core: Add support for iWARP Port Mapper user space service")
Assisted-by: Coccinelle
Signed-off-by: Binbin Deng <18983559317@163.com>
---
 drivers/infiniband/core/iwpm_util.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/infiniband/core/iwpm_util.c b/drivers/infiniband/core/iwpm_util.c
index 51af8c1c49f9..be5c77356c78 100644
--- a/drivers/infiniband/core/iwpm_util.c
+++ b/drivers/infiniband/core/iwpm_util.c
@@ -45,6 +45,8 @@ static DEFINE_SPINLOCK(iwpm_nlmsg_req_lock);
 static struct hlist_head *iwpm_hash_bucket;
 static DEFINE_SPINLOCK(iwpm_mapinfo_lock);
 
+static DEFINE_MUTEX(iwpm_mapinfo_mutex);
+
 static struct hlist_head *iwpm_reminfo_bucket;
 static DEFINE_SPINLOCK(iwpm_reminfo_lock);
 
@@ -159,6 +161,7 @@ int iwpm_remove_mapinfo(struct sockaddr_storage *local_sockaddr,
 	unsigned long flags;
 	int ret = -EINVAL;
 
+	mutex_lock(&iwpm_mapinfo_mutex);
 	spin_lock_irqsave(&iwpm_mapinfo_lock, flags);
 	if (iwpm_hash_bucket) {
 		hash_bucket_head = get_mapinfo_hash_bucket(
@@ -182,6 +185,7 @@ int iwpm_remove_mapinfo(struct sockaddr_storage *local_sockaddr,
 	}
 remove_mapinfo_exit:
 	spin_unlock_irqrestore(&iwpm_mapinfo_lock, flags);
+	mutex_unlock(&iwpm_mapinfo_mutex);
 	return ret;
 }
 
@@ -193,6 +197,7 @@ static void free_hash_bucket(void)
 	int i;
 
 	/* remove all the mapinfo data from the list */
+	mutex_lock(&iwpm_mapinfo_mutex);
 	spin_lock_irqsave(&iwpm_mapinfo_lock, flags);
 	for (i = 0; i < IWPM_MAPINFO_HASH_SIZE; i++) {
 		hlist_for_each_entry_safe(map_info, tmp_hlist_node,
@@ -206,6 +211,7 @@ static void free_hash_bucket(void)
 	kfree(iwpm_hash_bucket);
 	iwpm_hash_bucket = NULL;
 	spin_unlock_irqrestore(&iwpm_mapinfo_lock, flags);
+	mutex_unlock(&iwpm_mapinfo_mutex);
 }
 
 static void free_reminfo_bucket(void)
@@ -654,6 +660,7 @@ int iwpm_send_mapinfo(u8 nl_client, int iwpm_pid)
 		goto send_mapping_info_exit;
 	}
 	skb_num++;
+	mutex_lock(&iwpm_mapinfo_mutex);
 	spin_lock_irqsave(&iwpm_mapinfo_lock, flags);
 	ret = -EINVAL;
 	for (i = 0; i < IWPM_MAPINFO_HASH_SIZE; i++) {
@@ -712,17 +719,20 @@ int iwpm_send_mapinfo(u8 nl_client, int iwpm_pid)
 				skb = NULL;
 				if (ret) {
 					err_str = "Unable to send map info";
+					mutex_unlock(&iwpm_mapinfo_mutex);
 					goto send_mapping_info_exit;
 				}
 				if (skb_num == IWPM_MAPINFO_SKB_COUNT) {
 					ret = -ENOMEM;
 					err_str = "Insufficient skbs for map info";
+					mutex_unlock(&iwpm_mapinfo_mutex);
 					goto send_mapping_info_exit;
 				}
 				skb = dev_alloc_skb(NLMSG_GOODSIZE);
 				if (!skb) {
 					ret = -ENOMEM;
 					err_str = "Unable to allocate skb";
+					mutex_unlock(&iwpm_mapinfo_mutex);
 					goto send_mapping_info_exit;
 				}
 				spin_lock_irqsave(&iwpm_mapinfo_lock, flags);
@@ -731,6 +741,8 @@ int iwpm_send_mapinfo(u8 nl_client, int iwpm_pid)
 	}
 send_mapping_info_unlock:
 	spin_unlock_irqrestore(&iwpm_mapinfo_lock, flags);
+	mutex_unlock(&iwpm_mapinfo_mutex);
+
 send_mapping_info_exit:
 	if (ret) {
 		pr_warn("%s: %s (ret = %d)\n", __func__, err_str, ret);
-- 
2.43.0

