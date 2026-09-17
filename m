Received: from outbound.baidu.com (mx24.baidu.com [111.206.215.185])
	by smtp.subspace.kernel.org (Postfix) with SMTP id 0796D4BCABB
	for <linux-rdma@vger.kernel.org>; Thu, 17 Sep 2026 11:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.206.215.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789643869; cv=none; b=d7bz+iDI1gTy3bCpbRUcTdEZDCdAxDmMaKTMbvRnT/nOXg8y/+FMsPiPf11jfVEH83OB5FY6wrfo5jEXpEC76Zn3w7gdYQOH56p8enqbp19MZBcuDAD+y4tBNFvNTI5vXpb9zzggW0apdNpL1qi9NLoN1J7BnvjljLk2/R5A3qA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789643869; c=relaxed/simple;
	bh=MsdIyxouh/c6cYiQ6pTypXGZYxgw9M+v1a1lYNI90eo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=kpJla54qBwbtGNkPFo4iK/e+jIvCNmkHFcAyifVJcZOiGpryfZ2DDLqvuAZAnAU2YKJh9K9VH0lDKaJdh/PlRvlQkFV65gGWTOGOZeahDMYDdtP1FBkRimdKcv5yOivWsff+TT3/jAr/mowbsEQ9dJtqPM72pMA5y8yEsAf9Cxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b=ZV9OJ5TZ; arc=none smtp.client-ip=111.206.215.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b="ZV9OJ5TZ"
X-MD-Sfrom: lirongqing@baidu.com
X-MD-SrcIP: 172.31.50.47
From: lirongqing <lirongqing@baidu.com>
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Zhu
 Yanjun <yanjun.zhu@linux.dev>, <linux-rdma@vger.kernel.org>
CC: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH] RDMA/mlx5: Restore flow_attr-first layout in leftovers flow rules
Date: Thu, 17 Sep 2026 19:17:22 +0800
Message-ID: <20260917111722.1723-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: bjhj-exc12.internal.baidu.com (172.31.3.22) To
 bjkjy-exc3.internal.baidu.com (172.31.50.47)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=baidu.com;
	s=selector1; t=1789643852;
	bh=DbrLmpV37UJa2ktAlCuKcn0PCbMh2xByDT15O5VN2Us=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type;
	b=ZV9OJ5TZuArI5xf7YC0gn9dFFTqIkLYRmp+ZjZiMbyffVzljeeGo4M5nsMqHmMsvd
	 zktf6kFR9yefR7ACxcNxEo5OgSQuNlQyWOYn0R7iqUB0AgfupaLdJamVUWgIoOie3S
	 J62Mo/yCeml4HTMTzz78l78Z7zfHb5KT9b8NW7mfldQUSyasMohbYcB6msglhGSNR1
	 Rou/1x6/YDACBJgeyXbeuX/RNYCAKMExgbrcubIvJ6SnN1ItSvKjrQP07oLjNWNiDc
	 RyYR4U3glGXJyq3g0rej8xHSdWZdeg8NwdTZgdsURPHZDBOS5Jy2cc0N46ct4YqpnD
	 QUkAwjVJ21VPA==

From: Li RongQing <lirongqing@baidu.com>

Commit e91fb8b9d0ed ("RDMA/mlx5: Avoid flexible array warning") split
the leftovers_specs[] array into two separate structs to silence the
"array of flexible structures" sparse warning, but in doing so
reversed the member order: eth_flow was placed before flow_attr.

_create_flow_rule() locates the flow specs with:

    ib_flow = (void *)flow_attr + sizeof(*flow_attr);

which expects the spec data to immediately follow the ib_flow_attr.
With the reversed order, flow_attr is the last member, so ib_flow
points past the end of the struct and the num_of_specs = 1 loop reads
out-of-bounds memory (whatever static data follows in the .data
section), producing incorrect flow rules or a crash.

Restore flow_attr as the first member so the eth_flow spec again sits
at the offset _create_flow_rule() expects.  The two structs are no
longer arrays, so the "array of flexible structures" warning does not
re-occur.

Fixes: e91fb8b9d0ed ("RDMA/mlx5: Avoid flexible array warning")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 drivers/infiniband/hw/mlx5/fs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/fs.c b/drivers/infiniband/hw/mlx5/fs.c
index 98cdc5c..034ab55 100644
--- a/drivers/infiniband/hw/mlx5/fs.c
+++ b/drivers/infiniband/hw/mlx5/fs.c
@@ -1651,8 +1651,8 @@ static struct mlx5_ib_flow_handler *create_leftovers_rule(struct mlx5_ib_dev *de
 	struct mlx5_ib_flow_handler *handler = NULL;
 
 	static struct {
-		struct ib_flow_spec_eth eth_flow;
 		struct ib_flow_attr	flow_attr;
+		struct ib_flow_spec_eth eth_flow;
 	} leftovers_wc = { .flow_attr = { .num_of_specs = 1,
 					  .size = sizeof(leftovers_wc) },
 			   .eth_flow = {
@@ -1662,8 +1662,8 @@ static struct mlx5_ib_flow_handler *create_leftovers_rule(struct mlx5_ib_dev *de
 				   .val = { .dst_mac = { 0x1 } } } };
 
 	static struct {
-		struct ib_flow_spec_eth eth_flow;
 		struct ib_flow_attr	flow_attr;
+		struct ib_flow_spec_eth eth_flow;
 	} leftovers_uc = { .flow_attr = { .num_of_specs = 1,
 					  .size = sizeof(leftovers_uc) },
 			   .eth_flow = {
-- 
2.9.4

