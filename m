Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=216.71.153.144
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794139323;
	b=pEgXUw91ZFcl33+Bc2RbVAFdOWKzAbHUI14JYsqO5dWpncXEwy0xClc3LPiTDFfkTRuc
	 64r3FHIdopSuYpSCtcMtO7mdt5Ehy79+hV7xQVw3WmPSEIeA/V8Bc1EH+D5p3ey56m4Rn
	 HR3Q7mYY5s1MNx42GvrjJSIbzadUyZL2oRop7McOFi7E58j4ovZHNZvy9Af8vgaFgjfV8
	 11pqczsusIO7/etVGc36TZKuvfqtEMg1V0+6hlQDSr7T0zFHjP23vgWm6wfunmPnceFJo
	 Q53/FRhwv+q6YsRDsdfnNZj6y5a4aMWYunT6GP/qx21w612HdrwLzXl/jPqAZgJQu4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794139323;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 IronPort-SDR:Received:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 WDCIronportException:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=tLCFMiSIks5DPLg6euHvMe58ubzuaKQx3twJFEtnd1A=;
	b=zSPZdDnt30iMF+nIi3pZUWteGSfzywpfBz3FbZLJff0LtWMu/qZw2mTXaOhpoG4dSsGE
	 TJL5vmvHfpj7RQcs3ucF7WNdVLtDNGwpMtneVZT0A9u49lhpnl+0e5tWgjGNBPtH2hCio
	 Y2XTHXYGriigSZrnxL5p+R7Hnb0Cug0tl7zL3GMTLBhG2noHeVpsV3lOX3/U4V25JkN/K
	 esJzWy70wki/7eywbadb9Bb9Bfqt+MOmf9ybec5zhKZtMBcyPSuKv42w7Dmfw1Z4YqHb9
	 fiW61cdpeWmbJwsfmgL/PJMFtFd2Ld6wUDoTPwM+Uu7Sn2EdSIuRgrVa7MLBb0jqL9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=VwXP4uOh;
	arc=none smtp.remote-ip=216.71.153.144
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CFDD606A31C
	for <linux-rdma@vger.kernel.org>; Sun,  8 Nov 2026 12:02:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7CFDD606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=VwXP4uOh
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794139329; x=1825675329;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=H87s+Riz/TDE+YQSsKMT66/4xfi1kh+zCrO4tlQ/Ezs=;
  b=VwXP4uOh9kjLEqwldQ3lKYEJFw5bYo6pN7RSobN8jZL3WftHSJgShbuA
   LE7RFBSTOEhWEo4RGQ6XN0mN8dtHjNBImUsZr4W2/ziMGM0RLvmN9UN6E
   KPKMJAPuWzSdSgA0wyy2VTVUtvGGivkCbHGIXwHV2W7QErQnHa1uS2h4y
   6rIFiz7K0FWphJCtbkW0D8W2cu+5wJBZCiXQji3Hwz9hXyUMSXTCTdFoV
   wru4UNUDAya+Er+j/47nwMIwxtsvuHoWe19g76EOMBnCKXl2V3T3Mp/Gm
   PIyHlas1NTNWF4b98xMCl/tpzODrS0Jp0jE+U26Iv55jj1AbzIR2A5Wsd
   Q==;
X-CSE-ConnectionGUID: DD5ZPYELRJ+Bad9c44d0/Q==
X-CSE-MsgGUID: ajp04s0KQPebL6EGmlOnbA==
X-IronPort-AV: E=Sophos;i="6.27,202,1786982400"; 
   d="scan'208";a="159266832"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-esad3-o.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Nov 2026 20:02:03 +0800
X-CSE-ConnectionGUID: Ombwg6/HRjuT0RPeBx/s9g==
X-CSE-MsgGUID: 2jFxvmGYQFCH7kQbrV/wDw==
IronPort-SDR: 6af064b4_Y0PRsfA0toSyIU6UM9d9RPoDxE9FG0/YCrRsbhQKf4HiL0T
 5IMpOC0tlJn1OXB/uUh4SjDmZ5JvYrJtHLLOECg==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad3-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Nov 2026 04:01:56 -0800
X-CSE-ConnectionGUID: 4lnsgi1ZTbKOldmeke/xIA==
X-CSE-MsgGUID: mxvThsusTDmIMIQS1GXa1g==
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-esai1-o.wdc.com with ESMTP; 08 Nov 2026 04:01:55 -0800
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: linux-rdma@vger.kernel.org,
	linux-nvme@lists.infradead.org
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Keith Busch <kbusch@kernel.org>,
	Surabhi Gogte <sgogte@purestorage.com>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH RFC 0/2] RDMA/cma, nvmet-rdma: fix a lockdep WARN
Date: Sun,  8 Nov 2026 21:01:52 +0900
Message-ID: <20261108120154.148824-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since the commit 2a8513091d2f ("nvme-rdma: parallelize I/O queue
allocation and startup"), the blktests test cases nvme/004 and nvme/031
often fails with rdma transport due to a lockdep WARN, which is a false-
positive. Please refer to the first patch for the details of the WARN.

This series addresses the failure by reclassifying the handler_mutex of
the port listening cm_id. The first patch introduces
rdma_reclassify_id_for_listen() to RDMA/cma, which sets a dedicated
lockdep class to the handler_mutex of the specified cm_id. The second
patch calls it from nvmet-rdma for the port listening cm_id.

I made this series as RFC, because I was not so sure whether adding a
new function is the best approach. Another idea was to add a new
argument to rdma_create_id() to tell the cm_id created is for listen
of not, but it will touch a number of drivers. Yet another idea was to
add another work in nvmet-rdma to defer the connection establishment
[1], but adding a new work for the false-positive WARN is not desirable.
Then I think this patch series is the best solution at this moment.

Any comments will be welcomed. Thanks.

[1] https://lore.kernel.org/linux-nvme/at36um4zrsfOr3kh@shinmob/


Shin'ichiro Kawasaki (2):
  RDMA/cma: Add rdma_reclassify_id_for_listen()
  nvmet-rdma: use a separate lockdep class for the listening cm_id

 drivers/infiniband/core/cma.c | 13 +++++++++++++
 drivers/nvme/target/rdma.c    |  2 ++
 include/rdma/rdma_cm.h        |  6 ++++++
 3 files changed, 21 insertions(+)

-- 
2.56.0

