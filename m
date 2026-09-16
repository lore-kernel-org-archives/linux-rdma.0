Received: from outbound.baidu.com (mx24.baidu.com [111.206.215.185])
	by smtp.subspace.kernel.org (Postfix) with SMTP id C495A443E2F;
	Wed, 16 Sep 2026 07:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.206.215.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789543875; cv=none; b=jWAOCQjQw7J1bp3cTAeit0v62h4kFmKQqZyOSliwSCKGB3WPEPHRhOK78dE5dIkRzHvxLlXZt/GQEgoy0MMya/FKFNgCTkOwdXqNWkgIg37R72gzjpL/9DRrK2Sg/HXxw6xmZg/yZorIaw4J94fqjURvWttyZULRyOqttwFZtk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789543875; c=relaxed/simple;
	bh=nmgzhAxG/1BLeS25qzz/DszH+5Gn9uTtERnArjl5gVo=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=nUJA2BvpGT/osak5PhAinSqqXX0A3ew1uao7huxgFh49fg7Gq8R6FVEjyvOY/YeK7+/pE9RXvMg6Hc8o/Psac6iz4jA6SDB81P2wzejmKQ+3YxahLA0lhn4fZEyfRFTqwhjTY3F9T+RcPxhVOyC44gAbHXhdq4OXJrJ1Tbm6bAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b=a768tHeL; arc=none smtp.client-ip=111.206.215.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b="a768tHeL"
X-MD-Sfrom: lirongqing@baidu.com
X-MD-SrcIP: 172.31.50.47
From: lirongqing <lirongqing@baidu.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, Li
 RongQing <lirongqing@baidu.com>, Patrisious Haddad <phaddad@nvidia.com>, Kees
 Cook <kees@kernel.org>, Yonatan Nachum <ynachum@amazon.com>, Kalesh AP
	<kalesh-anakkur.purayil@broadcom.com>, Chiara Meiohas <cmeiohas@nvidia.com>,
	<linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] RDMA/restrack: Don't set RESTRACK_DD mark after a failed xa_insert()
Date: Wed, 16 Sep 2026 15:30:42 +0800
Message-ID: <20260916073042.1746-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: bjhj-exc14.internal.baidu.com (172.31.4.12) To
 bjkjy-exc3.internal.baidu.com (172.31.50.47)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=baidu.com;
	s=selector1; t=1789543851;
	bh=GNptu5ITDF3pa2rw3Uk3PKgDV80MUjDRgFbWGET7mRY=;
	h=From:To:Subject:Date:Message-ID:Content-Type;
	b=a768tHeLWOmII8q2RULIz7IpFnOR+RnrIQDFdiF/cGIK94lDhdOc+tkVSQTV4QJNw
	 GxkI5c/7ilganiCDABwWVCxho3LmIIuhi1QNMHrHqaG8MqVpX/P8nrfjrIUbvBwhcH
	 +Rlzf8SA6+izKzoC7Rra2UCnBcqNHPLrTLQKbmganwg6omzRzXxUGXUsZmQIbUFJfo
	 WHOrQacADQdiPxHm5W+HnDEydAPVxJkpnxz+KhIMb1HXO0bKcj7DEnSgENs5W2FH7K
	 2HLLGL7CNSpQLxdDlRU2F/9I5QPW3f88++I7fh8eE2Jz7Ps08V4Fo1BIGgSAKfroCO
	 eRe++TJbrJ6UA==

From: Li RongQing <lirongqing@baidu.com>

When adding a QP to the restrack xarray, rdma_restrack_add() does:

	ret = xa_insert(&rt->xa, res->id, res, GFP_KERNEL);
	if (ret)
		res->id = 0;

	if (qp->qp_type >= IB_QPT_DRIVER)
		xa_set_mark(&rt->xa, res->id, RESTRACK_DD);

The xa_set_mark() call is not guarded by "!ret".  When xa_insert() fails
(possible on a qp_num collision or memory pressure), res->id is reset to
0, yet the mark is still applied to index 0.  If a legitimate QP whose
qp_num is 0 already occupies that slot - e.g. a normal QP or the SMI QP
- it is spuriously tagged as driver-private (RESTRACK_DD), and the
netlink dump path res_get_common_dumpit() then hides it from "rdma res"
output whenever the caller does not request driver details.

Only set the mark when the insertion actually succeeded by folding the
mark into the non-failure branch.

Fixes: e18fa0bbcedf8 ("RDMA/core: Add an option to display driver-specific QPs in the rdmatool")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 drivers/infiniband/core/restrack.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/restrack.c b/drivers/infiniband/core/restrack.c
index f89a81d..a8b838f 100644
--- a/drivers/infiniband/core/restrack.c
+++ b/drivers/infiniband/core/restrack.c
@@ -250,8 +250,7 @@ void rdma_restrack_add(struct rdma_restrack_entry *res)
 		ret = xa_insert(&rt->xa, res->id, res, GFP_KERNEL);
 		if (ret)
 			res->id = 0;
-
-		if (qp->qp_type >= IB_QPT_DRIVER)
+		else if (qp->qp_type >= IB_QPT_DRIVER)
 			xa_set_mark(&rt->xa, res->id, RESTRACK_DD);
 	} else if (res->type == RDMA_RESTRACK_COUNTER) {
 		/* Special case to ensure that cntn points to right counter */
-- 
2.9.4

