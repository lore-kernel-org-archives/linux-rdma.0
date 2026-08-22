Received: from mxct.zte.com.cn (mxct.zte.com.cn [58.251.27.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59D23375AC3
	for <linux-rdma@vger.kernel.org>; Sat, 22 Aug 2026 07:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=58.251.27.85
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787384543; cv=none; b=broiBbyrBphUeqEGzI2QVIZ9z8ev7t7yCTxM3Y4dB6oLUpAukVpWFKjy4YeJO46K5vOWQ0qy8tsdXEngFqzUI8ptwSEdh753qygc5xPOAw29fqZsv2auNjEZTi3WgH7NK8R0sQRqH3TEK7jnBKRr0jaUuUGHMGEam0q8mFo3dZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787384543; c=relaxed/simple;
	bh=uoPI94RVqcZFSyRTnzMtI+ZJ6+NwCdA0xZGuIS1bp+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X12H9F/aPqGbB35yPD7iyftmZs4bLoNqPjhSlE07lUANiHnNFl/A88BA6beZKaY7jvCQXCl7BCCwXVqMJEyTbz7OuZskttkGLyUXW4GUwHqpGnQW4SI+6qgbuPZ33VTibBRyYfgtgLsR74YPWsVot0phab2NBsCf4ylBVY8bg54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn; spf=pass smtp.mailfrom=zte.com.cn; arc=none smtp.client-ip=58.251.27.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mxde.zte.com.cn (unknown [10.35.20.165])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4hRpzS1cLVzChCX
	for <linux-rdma@vger.kernel.org>; Sat, 22 Aug 2026 15:42:12 +0800 (CST)
Received: from mxhk.zte.com.cn (unknown [192.168.250.138])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxde.zte.com.cn (FangMail) with ESMTPS id 4hRpzG6hmJz5TCG0
	for <linux-rdma@vger.kernel.org>; Sat, 22 Aug 2026 15:42:02 +0800 (CST)
Received: from mxct.zte.com.cn (unknown [192.168.251.13])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4hRpz56s0tz5B0qD
	for <linux-rdma@vger.kernel.org>; Sat, 22 Aug 2026 15:41:53 +0800 (CST)
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4hRpyv2PlXz52SFx;
	Sat, 22 Aug 2026 15:41:43 +0800 (CST)
Received: from szxlzmapp03.zte.com.cn ([10.5.231.207])
	by mse-fl2.zte.com.cn with SMTP id 67M7faVv044701;
	Sat, 22 Aug 2026 15:41:36 +0800 (+08)
	(envelope-from zhang.yanze@zte.com.cn)
Received: from localhost.localdomain (unknown [192.168.6.15])
	by smtp (Zmail) with SMTP;
	Sat, 22 Aug 2026 15:41:38 +0800
X-Zmail-TransId: 3e816a89529f016-91997
X-Zmail-LocalSMTP: 1
X-Zmail-RealSender: zhang.yanze@zte.com.cn
From: Yanze Zhang <zhang.yanze@zte.com.cn>
To: jgg@nvidia.com, leon@kernel.org
Cc: linux-rdma@vger.kernel.org, Yanze Zhang <zhang.yanze@zte.com.cn>
Subject: Re: [PATCH rdma v5 0/7] RDMA/zrdma: Add ZTE Dinghai Ethernet Protocol Driver for RDMA
Date: Sat, 22 Aug 2026 15:36:08 +0800
Message-ID: <20260822073608.3165439-1-zhang.yanze@zte.com.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260811093740.2607476-1-zhang.yanze@zte.com.cn>
References: <20260811093740.2607476-1-zhang.yanze@zte.com.cn>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ZMAIL-USEORIGINALEMLTOOUTBOUND: 1
Content-Transfer-Encoding: 8bit
X-MAIL:mse-fl2.zte.com.cn 67M7faVv044701
X-TLS: YES
X-ENVELOPE-SENDER: zhang.yanze@zte.com.cn
X-SOURCE-IP: 10.35.20.165 unknown Sat, 22 Aug 2026 15:42:12 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A8952D2.002/4hRpzS1cLVzChCX

Hi Jason, Leon,

Gentle ping on this series [1]. I understand we are in the rc phase
and new drivers will likely be queued for the v7.3 merge window.
Just wanted to make sure nothing was missed or needs further action
from my side.

[1] https://lore.kernel.org/linux-rdma/20260811093740.2607476-1-zhang.yanze@zte.com.cn/

Thanks,
Yanze
