Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA0E451AFD4;
	Thu, 15 Oct 2026 11:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792065553; cv=none; b=qSQU3mWooe9AqBxrB8xa9Gg1yoRzNrAKDm4Wa3o8mVzz7dtxCeItFsba00lbpILKmWv2Vf7O5TDWy42GYcyhQ39VsEzFgk8mARWsdjK/pT32lv13e1WCpRb5WvC7cnz1RyePHaV+OqYm7TGxjyMdIHDJmZaQm73G1jTt6vF8g6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792065553; c=relaxed/simple;
	bh=IvAfagLE/2HvxwOXAeMTmE3kmfX5bY3EKj7eSW5Ms+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u3bQGoxkmeOkf5YmEBSHBlHYBv1H+usSraRg/tBowDRjT/iNAQMK8VG8UP3Qf2xDCLSSSwKqfN2hCqkVhGTPYF3/wRgkMLXJ43drOiDKFGZtr703qU06fMK1dQhOBAsvKfGusakkRhiDMx0ffcTpz32rLWTPAjFn3p4FnJzKdQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KkkPgVeQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KkkPgVeQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F0061F000C4;
	Thu, 15 Oct 2026 11:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792065552;
	bh=54R/QTxbdRc0fzOcYRIHBCQQXPaQ6YtemGXEeDOpCss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KkkPgVeQWo1G6VLpFw6lA9n7R6ho8jUWu4HsX57lWO2AYKuiReTEG0K1ZClGz9Q4v
	 wf9QVy+oaiXBM18VkHF3M2ejNocqFlxG1U4/hQ5XmPSPlIsgo3mLCu/sJ0j72m1+jn
	 /9tBhxr1JUn82BmwSPUHdqo5su6EG1vWElkS5d8eTMuovddPFAv8puwCedyHWE/LFZ
	 cLyx5+JnZzS3JrWDJ19oBjYO0yePm/alK/pFSghrmwRwm1zfqPcA4D5zNQCNJ1cN2j
	 LDDAUbvr5xoYQO1XCvSPY7h760Lq3vhqJuVsYdKqRlrmDDgkDRcvA+8wG8IjqdFRip
	 4JuwKq+Fi2R3A==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>,
	Maor Gottlieb <maorg@mellanox.com>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next 2/3] RDMA/core: Free unpublished port statistics after initial-read failure
Date: Thu, 15 Oct 2026 14:59:01 +0300
Message-ID: <20261015-ib-core-fixes-v1-2-60f6da3ddec3@nvidia.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261015-ib-core-fixes-v1-0-60f6da3ddec3@nvidia.com>
References: <20261015-ib-core-fixes-v1-0-60f6da3ddec3@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-18f8f
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

An initial port counter read can fail after allocating its statistics
buffer and wrapper. Free these both allocations.

Fixes: 467f432a521a ("RDMA/core: Split port and device counter sysfs attributes")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/core/sysfs.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index 69df8b703cbd..4cd861b5d953 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -996,8 +996,8 @@ static int setup_hw_port_stats(struct ib_port *port,
 					    data->stats->num_counters);
 	if (ret != data->stats->num_counters) {
 		if (WARN_ON(ret >= 0))
-			return -EINVAL;
-		return ret;
+			ret = -EINVAL;
+		goto err_free_data;
 	}
 
 	data->stats->timestamp = jiffies;
@@ -1031,6 +1031,11 @@ static int setup_hw_port_stats(struct ib_port *port,
 
 	port->hw_stats_data = data;
 	return 0;
+
+err_free_data:
+	rdma_free_hw_stats_struct(data->stats);
+	kfree(data);
+	return ret;
 }
 
 struct rdma_hw_stats *ib_get_hw_stats_port(struct ib_device *ibdev,

-- 
2.55.0

