Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD0813A3808;
	Wed, 25 Mar 2026 10:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774435261; cv=none; b=CrrEsqyGXHtCx/Wo50BdadmIBAmhpo0moNNid+fOxBoSG606b7TwH3D7j7WsYMcBHP63Z6oc4hHkit0iNMiOuGLDGNTBDZuIEthXC3zUSwuugbMJbmsEkMoClGf9J6IrJKaIZ0ovi/fsDbaE1/OSf9q3tISK1gdvEiG6dGI3hDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774435261; c=relaxed/simple;
	bh=BcDi6nzVlQg2U3KmKSOB/wadPQ2QPbC8tRKQEuEiMYM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=bBidy2QLy5S8z+pJ2qLjGpxunxAShbJEE0npO7eLIM2u0JzTngQ+AGgLShhG1IM9xLyypeX3H3jHn5+CwBDIE6j3HU/5P905ywif0brhsvUcS1Zokm0wHVtXa6FMCS/drKs7NM38gchfX3gIk7bCjy2x2rKaS0T9yWjYb62AV0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=6icw1ztY; arc=none smtp.client-ip=113.46.200.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="6icw1ztY"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=M1G5PSptWXXzPLH9d87A5P5m9OW3Nt2u+CyKoMXaMeo=;
	b=6icw1ztYu295iNl9URcLYFKLnLJkQ37jl0EUZsh07i+gqmYgw5UxctCRRDBTVi1t/RC4+t1lA
	b13Aad1xfLWYs+AODVUzko+D3rTO3KY7eH8InFZ/kqM+p8/ENsiK2c7xcaSk4xlJpGF7lLF5g4R
	/A90cNHQSF0PpezVksdyjxA=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4fgjvw1ZZPz1K96l;
	Wed, 25 Mar 2026 18:34:52 +0800 (CST)
Received: from kwepemj500018.china.huawei.com (unknown [7.202.194.48])
	by mail.maildlp.com (Postfix) with ESMTPS id 8278F4055B;
	Wed, 25 Mar 2026 18:40:55 +0800 (CST)
Received: from huawei.com (10.50.85.128) by kwepemj500018.china.huawei.com
 (7.202.194.48) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 25 Mar
 2026 18:40:54 +0800
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
Subject: [PATCH net 0/2] net/smc: fix potential UAF in smc_pnet_add_ib
Date: Wed, 25 Mar 2026 19:03:50 +0800
Message-ID: <20260325110352.3833570-1-lixiasong1@huawei.com>
X-Mailer: git-send-email 2.34.1
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

This series fixes potential use-after-free issues in smc_pnet_add_ib()
where the device pointer could be freed between find and apply operations.

The race occurs because smc_pnet_find_ib() and smc_pnet_find_smcd()
release the mutex before returning the device pointer. If the device is
removed (e.g., via smc_ib_remove_dev() or smcd_unregister_dev()) before
smc_pnet_apply_ib() or smc_pnet_apply_smcd() is called, the freed
pointer will be accessed.

Patch 1 fixes the issue for ib device, and patch 2 fixes the same issue
for smcd device.

Li Xiasong (2):
  net/smc: fix potential UAF in smc_pnet_add_ib for ib device
  net/smc: fix potential UAF in smc_pnet_add_ib for smcd device

 net/smc/smc_pnet.c | 121 ++++++++++++++++++++++++++++-----------------
 1 file changed, 75 insertions(+), 46 deletions(-)

-- 
2.34.1

