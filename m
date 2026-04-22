Received: from zg8tmja5ljk3lje4mi4ymjia.icoremail.net (zg8tmja5ljk3lje4mi4ymjia.icoremail.net [209.97.182.222])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2D151DF256;
	Wed, 22 Apr 2026 14:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.97.182.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776869982; cv=none; b=U/d6niO0X4xqvXdrPt18VvGmNRHCtGAj2J7z15VOjN01eyQdwm0sPe6GbyojZLMhykpeDaeDEn86Qcr+MYQwlkysIKGvi8Zo/ee4dq+0inphdOi5bNnF4nA3lgE5VB88Jk66FwWXYu4uEvxUq4KJDTnG0gWh6VLKPA5R6L6C0Dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776869982; c=relaxed/simple;
	bh=kzcZTAmiYCnOper7fgHnucgc5B7cthE64oz5bprM83A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oE6jNm0kAkKPViNX/mGvFkDYsVxOXjpmOhXHOApd66PKRve/eOXUPDZQ4li2X56XtAu+JFG49PdIQMjmycR6V5ENaybx1JKaJlGxYr87XOIStTnUQWlH/AWFiy4c9ujiFVGDBTh2IaPJ0MFJklRZ1/WBMZgpHil6NbNvf/blcrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn; spf=pass smtp.mailfrom=lzu.edu.cn; arc=none smtp.client-ip=209.97.182.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lzu.edu.cn
Received: from enjou-Legion-Y7000P-2019.coin-barley.ts.net (unknown [172.23.56.36])
	by app1 (Coremail) with SMTP id ygmowADnXwBF4uhpIuPaAA--.53802S3;
	Wed, 22 Apr 2026 22:59:18 +0800 (CST)
From: Ren Wei <n05ec@lzu.edu.cn>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	rds-devel@oss.oracle.com
Cc: achender@kernel.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	leon@kernel.org,
	santosh.shilimkar@oracle.com,
	jhubbard@nvidia.com,
	yuantan098@gmail.com,
	yifanwucs@gmail.com,
	tomapufckgml@gmail.com,
	bird@lzu.edu.cn,
	draw51280@163.com,
	n05ec@lzu.edu.cn
Subject: [PATCH net 1/1] net: rds: fix MR cleanup on copy error
Date: Wed, 22 Apr 2026 22:52:07 +0800
Message-ID: <79c8ef73ec8e5844d71038983940cc2943099baf.1776764247.git.draw51280@163.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1776764247.git.draw51280@163.com>
References: <cover.1776764247.git.draw51280@163.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:ygmowADnXwBF4uhpIuPaAA--.53802S3
X-Coremail-Antispam: 1UD129KBjvJXoW7uw4rJF15WrWfWrW7Xw45Awb_yoW8Gr1kpF
	Wa93ZrKFZxtryIk3WkKw12vF47WrsrCrWUG397Aa9Ik3Z0gr98Z34rK3s2qF1UCry2kF4Y
	vF1qvrnIkFs8ArUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUB01xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
	w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
	IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1l84ACjcxK6I8E
	87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c
	8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_
	Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwI
	xGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAa
	w2AFwI0_GFv_Wrylc2xSY4AK6svPMxAIw28IcxkI7VAKI48JMxAIw28IcVCjz48v1sIEY2
	0_Gr4l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8G
	jcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2I
	x0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK
	8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I
	0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjTRMXdjDUUUU
X-CM-SenderInfo: zqqvvuo6o23hxhgxhubq/1tbiAQAFCWnoi2EHngAAs-

From: Ao Zhou <draw51280@163.com>

__rds_rdma_map() hands sg/pages ownership to the transport after
get_mr() succeeds. If copying the generated cookie back to user space
fails after that point, the error path must not free those resources
again before dropping the MR reference.

Remove the duplicate unpin/free from the put_user() failure branch so
that MR teardown is handled only through the existing final cleanup
path.

Fixes: 0d4597c8c5ab ("net/rds: Track user mapped pages through special API")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Ao Zhou <draw51280@163.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
---
 net/rds/rdma.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/rds/rdma.c b/net/rds/rdma.c
index aa6465dc742c..61fb6e45281b 100644
--- a/net/rds/rdma.c
+++ b/net/rds/rdma.c
@@ -326,10 +326,6 @@ static int __rds_rdma_map(struct rds_sock *rs, struct rds_get_mr_args *args,
 
 	if (args->cookie_addr &&
 	    put_user(cookie, (u64 __user *)(unsigned long)args->cookie_addr)) {
-		if (!need_odp) {
-			unpin_user_pages(pages, nr_pages);
-			kfree(sg);
-		}
 		ret = -EFAULT;
 		goto out;
 	}
-- 
2.43.0

