Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=34.218.115.239
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794212044;
	b=QKgm/Qe4mHfPjakjuiKWWl1boYhGfdGt6Igkvd9AYrDy+5lV0hq1n2tX8/yYb6qdD3xx
	 Ypo6qazan4WjshWLU5CT2NPzzDSKmtDzXSJ+nk5jumWZgGrZG9h80TeJAAfA0iTzs6MPm
	 bG825UaFk0Kup9vDaXChiDHBx6av2PzaobPZ8a6lEmiDy68Y92uxBJ6OrdZGBWEsdRTRP
	 XzRR/Nw8A/TfR/b5WJjbh4mSpAd7i0q1VKPGwD4fJqGQdeutZDbOPPUMedPW/R8qc3IOc
	 3Kp+H0RTO6NOMnZ75LrmWWXLLiZfqPGul1UOFqu/9iytHJaUQMkYWUgCjLbWs56FfZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794212044;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:Received:X-Farcaster-Flow-ID:Received:Received:
	 From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=ZZ1q7cLs+ShsRj0dtKjXSwODZ3L7V2yMDW+mmlZugYs=;
	b=NIzQBbCUfDkGgdp6s29R+3NFgJ2nVAL6ksn3VgWL9/ydUFKrOmzDvJeG2gH325ajERCK
	 s3/mdY64XhpCqaDwc8k4sAzp2iJ2SGnGgLWRmIWCpQ0xh3jUMSsQ5DBw/0/NBAfii6stS
	 Fn5/qP/OmloudJKd8QGXjpJjYpjW4HZwtSWwBzK/8OYjsU0GvwzZ/QjcElyrJ7I4/RgBE
	 bjFrsBN2mOUS3XCUfsq2djyEmh8/xp0zpXsBXflp1q1Zg+FUUgDCLO8qJ3p1+vm24YUbz
	 GWm4kbdYF9c+sy5Yv7cp1prwOOPp59yQ5gA8nnul9gpn13SG/ez3C8byEcZUStSFzvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amazon.com;
	spf=pass smtp.mailfrom=amazon.com;
	dkim=pass header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b="N/HBdNhN";
	arc=none smtp.remote-ip=34.218.115.239
Received: from pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com [34.218.115.239])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44EB0606A330
	for <linux-rdma@vger.kernel.org>; Mon,  9 Nov 2026 08:14:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 44EB0606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=N/HBdNhN
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794212044; x=1825748044;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZZ1q7cLs+ShsRj0dtKjXSwODZ3L7V2yMDW+mmlZugYs=;
  b=N/HBdNhNBUJocecRC5zJOwr5w6Raqe8m9PyDn83cjngqIsNrfACFwLx/
   10Uk6xNBVZCE5M5M9VQhAjTqj8R+4DFU5x8JLh8fofeDFOuOlxlUVi9LE
   tiYwPlLyjdGuP2k6oJikzjfWdfW4qI5P9WEJJpk+8VJ17WrrQU85vQsTN
   /AGjNqSMCjoJobImfKas5qKaY+tvgtnYy1WtAuP9BkjzD+N2ha+VKq2Ee
   n3RdExEFUohdV4+gwbqcDNiTWKdCZj4t37NT36g7g6mUWVLm0AfFgLBNS
   rZfopWZ51+QLluffxWlamImxvbm+p2imjMtKQtmHLrLdZAAQbutxCTyZS
   Q==;
X-CSE-ConnectionGUID: 7Vgij9BWSMOO9mvs8HIWEA==
X-CSE-MsgGUID: kaKr5d2USp+cuvG+XqtDpw==
X-IronPort-AV: E=Sophos;i="6.27,203,1787011200"; 
   d="scan'208";a="33274802"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 08:14:01 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.178:11183]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.16.231:2525] with esmtp (Farcaster)
 id c329f4a7-23e7-4fc0-b0ae-ce141d74dc71; Mon, 9 Nov 2026 08:14:01 +0000 (UTC)
X-Farcaster-Flow-ID: c329f4a7-23e7-4fc0-b0ae-ce141d74dc71
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Mon, 9 Nov 2026 08:14:01 +0000
Received: from dev-dsk-ikolomin-1a-673563de.eu-west-1.amazon.com
 (172.19.125.167) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Mon, 9 Nov 2026
 08:13:59 +0000
From: Ilia Kolominsky <ikolomin@amazon.com>
To: <jgg@nvidia.com>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>
CC: <sleybo@amazon.com>, <matua@amazon.com>, <gal.pressman@linux.dev>,
	"Michael Margolin" <mrgolin@amazon.com>, Yonatan Nachum <ynachum@amazon.com>
Subject: [PATCH for-next 2/3] RDMA/efa: Report the admin RESOURCE_BUSY status as EBUSY
Date: Mon, 9 Nov 2026 08:13:48 +0000
Message-ID: <20261109081349.27316-3-ikolomin@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261109081349.27316-1-ikolomin@amazon.com>
References: <20261109081349.27316-1-ikolomin@amazon.com>
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
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWC004.ant.amazon.com (10.13.139.246) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

The device completes a command with RESOURCE_BUSY when the object it
targets is still in use, for example a destroy of an object that other
objects still reference. Map that status to EBUSY instead of the generic
EINVAL so that callers can tell the two apart.

Reviewed-by: Michael Margolin <mrgolin@amazon.com>
Reviewed-by: Yonatan Nachum <ynachum@amazon.com>
Signed-off-by: Ilia Kolominsky <ikolomin@amazon.com>
---
 drivers/infiniband/hw/efa/efa_com.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/efa/efa_com.c b/drivers/infiniband/hw/efa/efa_com.c
index 9c59d127e..e8045b43f 100644
--- a/drivers/infiniband/hw/efa/efa_com.c
+++ b/drivers/infiniband/hw/efa/efa_com.c
@@ -584,6 +584,8 @@ static int efa_com_comp_status_to_errno(u8 comp_status)
 	case EFA_ADMIN_ILLEGAL_PARAMETER:
 	case EFA_ADMIN_UNKNOWN_ERROR:
 		return -EINVAL;
+	case EFA_ADMIN_RESOURCE_BUSY:
+		return -EBUSY;
 	default:
 		return -EINVAL;
 	}
-- 
2.47.3

