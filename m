Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=101.71.155.101
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793456094;
	b=xOhlpfAS74L7uKXm5tyqdkJrsPJofiGu2YnWv6qhDa0vaFvhNFnGvos2FjUfvJzP8o75
	 KmBLZD1Fl5hqxX8+EUIos7mKO1hlCACL0anUkQn8qamK1nT54v7y2qOmwSXjBNQD8btMP
	 SUm35qmzpobZBJONSqpyxKwvinmLPnV8ZoIP06U3eVxTK1UYhCv8x8w7aCZmT3uOozSl3
	 gtxOXBvHnUPdgahl7HIP1i4/FoGJfW3ixWQaUU+Ihh+pQxhLmqG2mnLc3AH3aPt7uA2CN
	 HF0lQG4ENOq3Wqk+kA8WQFOtlx0717yC8ffJBPxZYr6MBjg2CUaJZeRSWDbZ/+/PU5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793456094;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-HM-Tid:X-HM-MType:
	 X-HM-Spam-Status:DKIM-Signature;
	bh=nQE+kY731hvXbr2q1nKgJpSmVlQMBl967e7BSiBAfHA=;
	b=xVypvHQo96OwUF6xzT8G7zq1jfchBN2gcKm+h/UgwrW/C4KsqbJCBuBYWhowld21zXcB
	 5QcIzKUc5X0SBqTd/Z8gbN9+ApcQJ8BPNoldgOzlbcXNYY5UTMguxZFqqaUqv1rztkMAm
	 bjETroLGWUu2a1WhmHOC52MteaRz+IwGSr2ylz0KV3JnOCIJ+HrAmi+otQDF2IBvDAqOe
	 +v1bJ3GQwGUB2plp3PkFE6khLmyLUrxEwcnT/WYJc7Oi1ke+dj804DIPRIsFujvLCpEAC
	 umYJjOeSnDhdxz/yFAlTOokl8vfdTssEUcTInv1YxVBywnQzMgf/vCQTe1KFmud057g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mail.sdu.edu.cn;
	spf=pass smtp.mailfrom=mail.sdu.edu.cn;
	dkim=pass header.d=mail.sdu.edu.cn header.i=@mail.sdu.edu.cn header.a=rsa-sha256 header.s=default header.b=Lhb5qPAY;
	arc=none smtp.remote-ip=101.71.155.101
Received: from mail-m155101.qiye.163.com (mail-m155101.qiye.163.com [101.71.155.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ED0D606A31A;
	Sat, 31 Oct 2026 14:14:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0ED0D606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mail.sdu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mail.sdu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mail.sdu.edu.cn header.i=@mail.sdu.edu.cn header.a=rsa-sha256 header.s=default header.b=Lhb5qPAY
Received: from lgs.. (unknown [101.76.249.61])
	by smtp.qiye.163.com (Hmail) with ESMTP id 53071d161;
	Sat, 31 Oct 2026 22:14:47 +0800 (GMT+08:00)
From: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>,
	stable@vger.kernel.org,
	"Md. Haris Iqbal" <haris.iqbal@ionos.com>,
	Jack Wang <jinpu.wang@ionos.com>,
	Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] RDMA/rtrs: Fix potential use-after-free on client sysfs setup failure
Date: Sat, 31 Oct 2026 22:14:46 +0800
Message-ID: <ddd08640709b149408b616c3eec8fee847af757e.1793455791.git.liguangshuo@mail.sdu.edu.cn>
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
X-HM-Tid: 0aa19250209103a1kunm24bc911186afc
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkZTUtMVkxKS0keQ0NOS0wdTFYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlKS0pVTE1VSU9CVU1KWVdZFhoPEhUdFFlBWUtVS1VLVUtZBg
	++
DKIM-Signature: a=rsa-sha256;
	b=Lhb5qPAYic70+h1+PEBwbGgHR1nCua+WkHNmFBR4RPjwfrIjfElXbogm43DV5yfzBWJ8uevdp0meuYiMqJyiX9iS/lmT7BBm4S/moqZVhzPHg90eDyT1MMg/Y/u5KbaG2NPreR0cCgxXbC19kTMx8hYB9+3Cm7bLa1TBUMZN8hM=; s=default; c=relaxed/relaxed; d=mail.sdu.edu.cn; v=1;
	bh=nQE+kY731hvXbr2q1nKgJpSmVlQMBl967e7BSiBAfHA=;
	h=date:mime-version:subject:message-id:from;

rtrs_clt_create_path_files() drops the path reference on failure, but
its callers still close connections and free the path. This can access
freed memory and free the path twice.

Keep the caller's path reference until its cleanup completes. Move
per-CPU stats cleanup to the path release callback and let the embedded
stats kobject hold a path reference until its own release callback, so
delayed kobject release cannot outlive the enclosing allocation. Keep
direct cleanup for failures before the path kobject is initialized.

This issue was found by our static analysis tool under development.

Fixes: 215378b838df ("RDMA/rtrs: client: sysfs interface functions")
Cc: stable@vger.kernel.org
Assisted-by: OpenAI:gpt-6-astra
Signed-off-by: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>
---
Build-tested the changed objects with x86_64 allmodconfig (W=1):
GCC with CONFIG_DEBUG_KOBJECT_RELEASE=n/y, and Clang with it enabled.
A host harness executing extracted cleanup functions passed 198
failure/teardown cases, including delayed release (also under ASan/UBSan).
No kernel runtime or RDMA hardware testing was performed.

 drivers/infiniband/ulp/rtrs/rtrs-clt-sysfs.c | 10 +++++++---
 drivers/infiniband/ulp/rtrs/rtrs-clt.c       | 14 ++++++++++----
 2 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt-sysfs.c b/drivers/infiniband/ulp/rtrs/rtrs-clt-sysfs.c
index f8b833bd81ad..44edc405f400 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt-sysfs.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt-sysfs.c
@@ -22,6 +22,7 @@ static void rtrs_clt_path_release(struct kobject *kobj)
 
 	clt_path = container_of(kobj, struct rtrs_clt_path, kobj);
 
+	free_percpu(clt_path->stats->pcpu_stats);
 	free_path(clt_path);
 }
 
@@ -32,11 +33,13 @@ static struct kobj_type ktype_sess = {
 
 static void rtrs_clt_path_stats_release(struct kobject *kobj)
 {
+	struct rtrs_clt_path *clt_path;
 	struct rtrs_clt_stats *stats;
 
 	stats = container_of(kobj, struct rtrs_clt_stats, kobj_stats);
 
-	free_percpu(stats->pcpu_stats);
+	clt_path = container_of_const(stats, struct rtrs_clt_path, stats[0]);
+	kobject_put(&clt_path->kobj);
 }
 
 static struct kobj_type ktype_stats = {
@@ -422,6 +425,7 @@ static const struct attribute_group rtrs_clt_path_attr_group = {
 	.attrs = rtrs_clt_path_attrs,
 };
 
+/* The caller retains the initial path reference on all exits. */
 int rtrs_clt_create_path_files(struct rtrs_clt_path *clt_path)
 {
 	struct rtrs_clt_sess *clt = clt_path->clt;
@@ -438,7 +442,6 @@ int rtrs_clt_create_path_files(struct rtrs_clt_path *clt_path)
 				   "%s", str);
 	if (err) {
 		pr_err("kobject_init_and_add: %pe\n", ERR_PTR(err));
-		kobject_put(&clt_path->kobj);
 		return err;
 	}
 	err = sysfs_create_group(&clt_path->kobj, &rtrs_clt_path_attr_group);
@@ -446,6 +449,8 @@ int rtrs_clt_create_path_files(struct rtrs_clt_path *clt_path)
 		pr_err("sysfs_create_group(): %pe\n", ERR_PTR(err));
 		goto put_kobj;
 	}
+	/* Keep the path alive until its embedded stats kobject is released. */
+	kobject_get(&clt_path->kobj);
 	err = kobject_init_and_add(&clt_path->stats->kobj_stats, &ktype_stats,
 				   &clt_path->kobj, "stats");
 	if (err) {
@@ -470,7 +475,6 @@ int rtrs_clt_create_path_files(struct rtrs_clt_path *clt_path)
 	sysfs_remove_group(&clt_path->kobj, &rtrs_clt_path_attr_group);
 put_kobj:
 	kobject_del(&clt_path->kobj);
-	kobject_put(&clt_path->kobj);
 
 	return err;
 }
diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index bf3a0377da3f..547313136598 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -2880,8 +2880,7 @@ struct rtrs_clt_sess *rtrs_clt_open(struct rtrs_clt_ops *ops,
 		if (err) {
 			list_del_rcu(&clt_path->s.entry);
 			rtrs_clt_close_conns(clt_path, true);
-			free_percpu(clt_path->stats->pcpu_stats);
-			free_path(clt_path);
+			kobject_put(&clt_path->kobj);
 			goto close_all_path;
 		}
 	}
@@ -3161,7 +3160,7 @@ int rtrs_clt_create_path_from_sysfs(struct rtrs_clt_sess *clt,
 
 	err = init_path(clt_path);
 	if (err)
-		goto close_path;
+		goto close_path_free;
 
 	err = rtrs_clt_create_path_files(clt_path);
 	if (err)
@@ -3169,12 +3168,19 @@ int rtrs_clt_create_path_from_sysfs(struct rtrs_clt_sess *clt,
 
 	return 0;
 
-close_path:
+close_path_free:
 	rtrs_clt_remove_path_from_arr(clt_path);
 	rtrs_clt_close_conns(clt_path, true);
 	free_percpu(clt_path->stats->pcpu_stats);
 	free_path(clt_path);
 
+	return err;
+
+close_path:
+	rtrs_clt_remove_path_from_arr(clt_path);
+	rtrs_clt_close_conns(clt_path, true);
+	kobject_put(&clt_path->kobj);
+
 	return err;
 }
 

base-commit: d89e1d186ec9271bf78e62771779e9fc03bf0fc3
