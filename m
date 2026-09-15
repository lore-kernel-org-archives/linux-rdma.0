Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D1E431499;
	Tue, 15 Sep 2026 04:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789446697; cv=none; b=MzUEF+Mn/99IcsXBv7o5u5X3PuSHiwBTujFb99za5+0HzNwRmLA8WSXeK/48SqRxeC+rt2Ib+GHMvx7kd0DnVWjc+1azC6EcZ7EdqIpRHcuqHJJrR9JThVobDNvLNFi/VrHAVhIhUffOa5Pnp+8rn8cvEfuceAMrJvZFiJ9r9M0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789446697; c=relaxed/simple;
	bh=kyzN3dg3O5j4C+ixXMm2PPn2r2u8wrUq+gKl+V1RvsI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=KTFfkwUfEQASVCvXbJOomwQyq1XFSX5BDj2wPH5cOlmNeOkx3RU/RHcO4gq2We/TZR62rMFKiREi6hObiPjnTAQQy5Loef2SVKEdR2EztE2jzpXd/UOz8+XuAXBOwCMosMA0GtMC7/l1akjx2tSn/c9ejERvwKWvDibodsfCzUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GCSxHa6b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GCSxHa6b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7D3E1F00893;
	Tue, 15 Sep 2026 04:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789446685;
	bh=ZX8p0xKhWvzdMr3cMuo+x22JfL3TAIzCrrx12gcubGI=;
	h=From:To:Cc:Subject:Date;
	b=GCSxHa6b6IMWGpMHqqle6pvir1NCwpqc7yuEqQ5a1PmqsgtKKJ1GvemvM8iSRPckp
	 tC0HCTdPpttqM6X/O3Z55dgKvJGy/66pcrB6BVD+kq7clGUoKb6aqsMCBN9l3OFewl
	 eF1sjSFj5KKjLCPYqg5AZcv5e6W49xZjH/pqUHyntjM2eb+e3NHqL5/4c15gGEkwLc
	 lNSLxywm23ygQAjthwviHZizbgXPeMFF2e0MZODpnWdTeaJF5pJAviuyVCynE5Zsze
	 l7aexr9HCKm8a7LY5Sclzki/ch2PtMAV8ljpPDNrZAkzcRAcswxHqIQVd1fwxhB+Vh
	 68ER1Q3wBxf0g==
From: Long Li <longli@kernel.org>
To: jgg@ziepe.ca,
	leon@kernel.org
Cc: weh@microsoft.com,
	kotaranov@microsoft.com,
	linux-rdma@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Long Li <longli@kernel.org>
Subject: [PATCH] MAINTAINERS: hand over MANA RDMA driver to Wei Hu
Date: Mon, 14 Sep 2026 21:31:21 -0700
Message-Id: <20260915043121.10370-1-longli@kernel.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Wei Hu takes over maintainership of the Microsoft MANA RDMA driver.

Signed-off-by: Long Li <longli@kernel.org>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3b2eb2a7a..ee9328178 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -18046,7 +18046,7 @@ F:	include/linux/cciss*.h
 F:	include/uapi/linux/cciss*.h
 
 MICROSOFT MANA RDMA DRIVER
-M:	Long Li <longli@microsoft.com>
+M:	Wei Hu <weh@microsoft.com>
 M:	Konstantin Taranov <kotaranov@microsoft.com>
 L:	linux-rdma@vger.kernel.org
 L:	linux-hyperv@vger.kernel.org
-- 
2.34.1

