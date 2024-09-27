Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3DE21C6A5;
	Fri, 27 Sep 2024 14:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727445996; cv=none; b=dInvQRp7mdSO2v3+19GU7dOoTkoCWcaWzsr//hqWLl7oqYcXllwCBlrha4UtLzQapOmEml8WcKLbz5d9mYUTrqo4F6+BfC1YMit6/OvYbWQyx4FoWvC70PV49E2ki5dfX0NyTle3s/pZRCjrcbCjneDL2GwzGgUgit8V+B12VIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727445996; c=relaxed/simple;
	bh=aC0TxgrhZHUTChxkXc9EvwUvF8VBrHt5psIyCgaIAqs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nJh/BafbdZn+NJWJZAzCqltV33b6ppl5srvDakuwhG2JOgRghQ/j3FyS2xZPaBnded78JmSXY73Hz54U65JCtCwf69Lm+Ui1nNJBlh/M8ZA5YnQnZQU+aE41MtTY/48ZVyxu4LruOesBjv+wPQzf+a965DmSQTurZlETUiTHQ78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=VG+MnshA; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="VG+MnshA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:Subject:Message-ID:MIME-Version:
	Content-Type; bh=XouRcwFqOZE9bIJUqu6gKwF2et2ukORfgR4iVk6tkbM=;
	b=VG+MnshADyC57I5ak/1y4dpkDWqCTiPXWux0pCmaLlRf3MwIZiM+WVnECJVkwT
	VvGUCE2O4sHofnV0Vdg1dGYYyxAcmpR+hZxWtsP6B970zO3UWkYbThrSv6tVEBxA
	pv6nFVRiRVnQirnumMiHDTmxsL35+UveIPFr1YSuuffSs=
Received: from localhost (unknown [120.26.85.94])
	by gzsmtp1 (Coremail) with SMTP id sCgvCgBHr6LVu_Zm3nNSAQ--.3767S2;
	Fri, 27 Sep 2024 22:06:14 +0800 (CST)
Date: Fri, 27 Sep 2024 22:06:13 +0800
From: Qianqiang Liu <qianqiang.liu@163.com>
To: leon@kernel.org
Cc: jgg@ziepe.ca, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] RDMA/nldev: Fix NULL pointer dereferences issue in
 rdma_nl_notify_event
Message-ID: <Zva71Yf3F94uxi5A@iZbp1asjb3cy8ks0srf007Z>
References: <20240926143402.70354-1-qianqiang.liu@163.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240926143402.70354-1-qianqiang.liu@163.com>
X-CM-TRANSID:sCgvCgBHr6LVu_Zm3nNSAQ--.3767S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrZrW8WrWDtr4DXr4xCw4UArb_yoWfJFcEgr
	y0qFykJr1jkF1Skwn5Ar1fXFyvqw1Fv3Z5uanFgr95Jryava90qwn2vrWDZ348KF4kKFy7
	J3y3uw4ru3y8GjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUezpB3UUUUU==
X-CM-SenderInfo: xtld01pldqwhxolxqiywtou0bp/1tbiLx5namb2tM1sSwAAsy

nlmsg_put() may return a NULL pointer assigned to nlh, which will later
be dereferenced in nlmsg_end().

Fixes: 9cbed5aab5ae ("RDMA/nldev: Add support for RDMA monitoring")
Signed-off-by: Qianqiang Liu <qianqiang.liu@163.com>
---
 Changes since v1:
 - Add Fixes tag
---
 drivers/infiniband/core/nldev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 39f89a4b86498..7dc8e2ec62cc8 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -2816,6 +2816,8 @@ int rdma_nl_notify_event(struct ib_device *device, u32 port_num,
 	nlh = nlmsg_put(skb, 0, 0,
 			RDMA_NL_GET_TYPE(RDMA_NL_NLDEV, RDMA_NLDEV_CMD_MONITOR),
 			0, 0);
+	if (!nlh)
+		goto err_free;
 
 	switch (type) {
 	case RDMA_REGISTER_EVENT:
-- 
2.39.5

