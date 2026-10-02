Received: from outbound.baidu.com (mx24.baidu.com [111.206.215.185])
	by smtp.subspace.kernel.org (Postfix) with SMTP id 9F6C2488D84
	for <linux-rdma@vger.kernel.org>; Fri,  2 Oct 2026 11:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.206.215.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790939043; cv=none; b=oTJabxpA5GEA4E5ZCuMpzTATatZDWTkyqucl6TTD3nPUYhxycZOkfK69NocXH9smZhfxTBcmwGB410TSXRHiWvoR8DGAfG6glXqZqrTMk+I38dFYyDcIR1k89TgLFK7JA+XfgegB4x1J2IP91ULERL/MASS11rIKf9H8oK3oDow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790939043; c=relaxed/simple;
	bh=qsRw7LQx8p19ZvpMrZkZpoe9DfiyAwPADmJYAbUUVK0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=DF43pZxG7Vfarjl09bwaKQQRJgy0p7eFI+NFNBjhwLbzjY9NZaZ0kLbQc0MbQAJmkurQkUv3iy55jWQ7Bx0P7bA5uMb6mUf3amQeaBrp2dI/q6Qsq3eEnib9JQxhwPae/k0l/NGra2TASScI04moCNB2DwF/fmXIHr9YAVIl7kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b=jx/QFEJW; arc=none smtp.client-ip=111.206.215.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b="jx/QFEJW"
X-MD-Sfrom: lirongqing@baidu.com
X-MD-SrcIP: 172.31.50.47
From: lirongqing <lirongqing@baidu.com>
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	<linux-rdma@vger.kernel.org>
CC: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH] RDMA/mlx5: Fix NULL deref in del_sa_roce_rule() on allocation failure
Date: Fri, 2 Oct 2026 19:03:29 +0800
Message-ID: <20261002110329.2350-1-lirongqing@baidu.com>
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
	s=selector1; t=1790939026;
	bh=kZMRB66FeUR6H80WPDVAk0CnHPzPxiW67ZMlqZS3rQ8=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type;
	b=jx/QFEJWkMuKnfiBnWntcnpOvAiK9tFxqOygvLffIQ2qERi4Vv22tsBv3cB7XRVF5
	 imvqBlEkvbum2aVGjE877oTipcJuZREAvevQSo1MwtDhUdSmUaJ9y9Kz6UzEdnf9WX
	 U2Sa3WXG9jMe7O3uy1y2iT8xqpsBj7BMjgAesGG3bHDyYLpp1AFF0xBfbaGs7tEDCu
	 B0bhsDPeh0AfHYR5uf9PEdDJHLOrwgCZhTSJ1G/AQOYpESEouGet2AZ+ovqghwUSxv
	 s9FGzyDJzBDpbKJ0dqk8Re5JBpHwKYs5quSd7uXGJN+wKVzdJAiNi9UomFTPD11+In
	 wm6D49xstg9DQ==

From: Li RongQing <lirongqing@baidu.com>

get_macsec_device() allocates and links a new mlx5_macsec_device when
the macdev has no existing entry, and returns NULL when that allocation
fails.  del_sa_roce_rule() only flagged the NULL case with WARN_ON() and
kept dereferencing macsec_device, so a MACsec SA delete event for a
macdev that was never set up by the RoCE GID path would dereference NULL
under memory pressure.

Return after the warning so the SA delete event is dropped instead of
oopsing.

Fixes: 58dbd6428a68 ("RDMA/mlx5: Handles RoCE MACsec steering rules addition and deletion")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 drivers/infiniband/hw/mlx5/macsec.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/macsec.c b/drivers/infiniband/hw/mlx5/macsec.c
index 4732be5..37394ea 100644
--- a/drivers/infiniband/hw/mlx5/macsec.c
+++ b/drivers/infiniband/hw/mlx5/macsec.c
@@ -119,7 +119,8 @@ static void del_sa_roce_rule(struct list_head *macsec_devices_list,
 	struct mlx5_macsec_device *macsec_device;
 
 	macsec_device = get_macsec_device(data->macdev, macsec_devices_list);
-	WARN_ON(!macsec_device);
+	if (WARN_ON(!macsec_device))
+		return;
 
 	mlx5_macsec_del_roce_sa_rules(data->fs_id, data->macsec_fs,
 				      &macsec_device->tx_rules_list,
-- 
2.9.4

