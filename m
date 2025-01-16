Received: from albert.telenet-ops.be (albert.telenet-ops.be [195.130.137.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7B0019006B
	for <linux-rdma@vger.kernel.org>; Thu, 16 Jan 2025 09:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.130.137.90
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737021411; cv=none; b=hMjQr+JVlPfUu4z+XYd8aai7+H7YKkKafu4+DYe5PpOIhidoT8JmKYpOAtlOxBWoP9WxqNHX3jmU4h+7T++4jIVV5jcWCwxGfg3LI2CklTTo5JSPRp6dhUT8+GbG+f2WA3TPWudpBaqm2/o9SXxtDTzKofQpkPJ5BcaL7losHh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737021411; c=relaxed/simple;
	bh=S3K9kalJZ89pB1T7GDfRp3JkvFZTWv7RBCn9IF3y4fM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Jt2fTY1PsDjpkqWj9tUW0IDMT0Binjal+2CngL6/rRCphWdT71JocBU3q9Ncqc+AlqMDtU05uMvumUhFnUpyzfPVBXqU+lD1PY0cx5XaxHG69s2nThs17IKkTl0Xbz7yavWrLEqNBr0N45FbcrGqikZZKM+aF/hsyJQUjlcQMF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=glider.be; spf=none smtp.mailfrom=linux-m68k.org; arc=none smtp.client-ip=195.130.137.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=glider.be
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux-m68k.org
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed80:dc22:1d0d:62b2:39be])
	by albert.telenet-ops.be with cmsmtp
	id 1lwg2E00D038l1s06lwg1x; Thu, 16 Jan 2025 10:56:41 +0100
Received: from rox.of.borg ([192.168.97.57])
	by ramsan.of.borg with esmtp (Exim 4.97)
	(envelope-from <geert@linux-m68k.org>)
	id 1tYMc5-0000000D3YR-0Gpj;
	Thu, 16 Jan 2025 10:56:38 +0100
Received: from geert by rox.of.borg with local (Exim 4.97)
	(envelope-from <geert@linux-m68k.org>)
	id 1tYMcA-00000004hpF-1JRC;
	Thu, 16 Jan 2025 10:56:38 +0100
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Maxime Ripard <mripard@kernel.org>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Friedrich Vock <friedrich.vock@gmx.de>,
	Tejun Heo <tj@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>
Cc: dri-devel@lists.freedesktop.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH next] cgroup/rdma: Drop bogus PAGE_COUNTER select
Date: Thu, 16 Jan 2025 10:56:35 +0100
Message-ID: <b4d462f038a2f895f30ae759928397c8183f6f7e.1737020925.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When adding the Device memory controller (DMEM), "select PAGE_COUNTER"
was added to CGROUP_RDMA, presumably instead of CGROUP_DMEM.
While commit e33b51499a0a6bca ("cgroup/dmem: Select PAGE_COUNTER") added
the missing select to CGROUP_DMEM, the bogus select is still there.
Remove it.

Fixes: b168ed458ddecc17 ("kernel/cgroup: Add "dmem" memory accounting cgroup")
Closes: https://lore.kernel.org/CAMuHMdUmPfahsnZwx2iB5yfh8rjjW25LNcnYujNBgcKotUXBNg@mail.gmail.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
Broken commit is in drm/drm-next
Partial fix is in drm-misc/for-linux-next

 init/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/init/Kconfig b/init/Kconfig
index 61f50cafa8151ed2..bd7630e75207e8dc 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1128,7 +1128,6 @@ config CGROUP_PIDS
 
 config CGROUP_RDMA
 	bool "RDMA controller"
-	select PAGE_COUNTER
 	help
 	  Provides enforcement of RDMA resources defined by IB stack.
 	  It is fairly easy for consumers to exhaust RDMA resources, which
-- 
2.43.0

