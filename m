Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B80275A0E9;
	Thu, 11 Jan 2024 23:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxonhyperv.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxonhyperv.com header.i=@linuxonhyperv.com header.b="sgJhtYqj"
Received: by linux.microsoft.com (Postfix, from userid 1004)
	id 56C0320B3CC5; Thu, 11 Jan 2024 15:57:36 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 56C0320B3CC5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
	s=default; t=1705017456;
	bh=NhxGRohCG2d8qbgwEKxLa5IMv9vQBy7R7+Z0UyLVSR0=;
	h=From:To:Cc:Subject:Date:Reply-To:From;
	b=sgJhtYqjRJRf3a9DQJGolmw7LPKGW3dkWjd328i1Xr7rMfF/cWj2T++bWgSbTlwbK
	 iNwDzFAIOFP8IDEcOmxOKCI6UTcvblKET8W+xDuZ20hYSJwmc8sOI9s8mnsgEaz6wi
	 7vqLswJISeg6GOES7G4Psw/vot1jZJrwa3uZjVvE=
From: longli@linuxonhyperv.com
To: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Ajay Sharma <sharmaajay@microsoft.com>,
	Konstantin Taranov <kotaranov@microsoft.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: linux-rdma@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Long Li <longli@microsoft.com>
Subject: [PATCH] MAINTAINERS: update maintainer for Microsoft MANA RDMA driver
Date: Thu, 11 Jan 2024 15:57:18 -0800
Message-Id: <1705017438-20417-1-git-send-email-longli@linuxonhyperv.com>
X-Mailer: git-send-email 1.8.3.1
Reply-To: longli@microsoft.com
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

From: Long Li <longli@microsoft.com>

Ajay is no longer working on the MANA RDMA driver.

Konstantin Taranov will take the responsibility of fixing bugs, reviewing
patches and developing new features for MANA RDMA driver.

Signed-off-by: Long Li <longli@microsoft.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 463c097e01af..135471cbc144 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14527,7 +14527,7 @@ F:	include/uapi/linux/cciss*.h
 
 MICROSOFT MANA RDMA DRIVER
 M:	Long Li <longli@microsoft.com>
-M:	Ajay Sharma <sharmaajay@microsoft.com>
+M:	Konstantin Taranov <kotaranov@microsoft.com>
 L:	linux-rdma@vger.kernel.org
 S:	Supported
 F:	drivers/infiniband/hw/mana/
-- 
2.17.1

