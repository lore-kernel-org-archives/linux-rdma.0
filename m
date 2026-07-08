Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B97D375ACF
	for <linux-rdma@vger.kernel.org>; Wed,  8 Jul 2026 21:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783544865; cv=none; b=rrjTYyiEjBkzkDMfYA2dAqxn7drrAq8Xn1157EQGVNH/bzlaIGbkIcuriScmJQNwLYvfjRObM2VTkVFfcrMZLWf01gswy4AzGrWViAoI1RxjRW4P3k+e2VL3GzQ/QUiaImRcdn2PT9kPZ0cm+9wUbs/Qg8hL3Xt7zFRk3s2C/GU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783544865; c=relaxed/simple;
	bh=IMHNEoRWhtaKXVCUzxCZAzRACGrePdRES3nv11Jehho=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mlL+ISD1ud0pj8CgDfGBPWPkdWIBzSJudaLbQJDMVjZNVDFcT3K4QwRHnCdHAwg22klrjhgPCa/7VQJA9E1NC0O7abFM8HYqmq2i85TJ2dgH+HzD1EBb8GpbN/fujKbuRVdLVLup4DbLLf7yR5PD+/WzW5jr39ql8mAhZt6Z++I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=POTbcMTG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="POTbcMTG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783544863;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=bvEVe0CqRuv9hsQsrY/AbyuQvLZon4/qzVcuCEZYrLI=;
	b=POTbcMTGQLGfP54Jcvuuz746CNUn7T8Jktvl0loICvsCByUHsOrWACsxwqUQS2uqiyIdfI
	jBhlhVQFtuYgpeIf7Q02V+aRf0msvzb2SMI+NecG0fuV58LKOxLAKUdhN9Io+cKnuedf6l
	wZXhFCR60sjJmJ24p7b5vknHEjop1yQ=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-64-SDADzve0NBelKm_84h6o6Q-1; Wed,
 08 Jul 2026 17:07:39 -0400
X-MC-Unique: SDADzve0NBelKm_84h6o6Q-1
X-Mimecast-MFC-AGG-ID: SDADzve0NBelKm_84h6o6Q_1783544858
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7D948195609D;
	Wed,  8 Jul 2026 21:07:38 +0000 (UTC)
Received: from lima-fedora43.redhat.com (unknown [10.22.88.195])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D45BC180066F;
	Wed,  8 Jul 2026 21:07:36 +0000 (UTC)
From: Kamal Heib <kheib@redhat.com>
To: linux-rdma@vger.kernel.org
Cc: Abhijit Gangurde <abhijit.gangurde@amd.com>,
	Allen Hubbe <allen.hubbe@amd.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Kamal Heib <kheib@redhat.com>
Subject: [PATCH rdma-next] RDMA/ionic: Remove duplicate IONIC_SPEC_HIGH definition
Date: Wed,  8 Jul 2026 17:07:34 -0400
Message-ID: <20260708210734.641411-1-kheib@redhat.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

The macro IONIC_SPEC_HIGH is defined twice - remove it.

Signed-off-by: Kamal Heib <kheib@redhat.com>
---
 drivers/infiniband/hw/ionic/ionic_ibdev.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/infiniband/hw/ionic/ionic_ibdev.h b/drivers/infiniband/hw/ionic/ionic_ibdev.h
index 63828240d659..53dab2d54844 100644
--- a/drivers/infiniband/hw/ionic/ionic_ibdev.h
+++ b/drivers/infiniband/hw/ionic/ionic_ibdev.h
@@ -33,7 +33,6 @@
 #define IONIC_MAX_QPID 0xffffff
 #define IONIC_SPEC_HIGH 8
 #define IONIC_MAX_PD 1024
-#define IONIC_SPEC_HIGH 8
 #define IONIC_SQCMB_ORDER 5
 #define IONIC_RQCMB_ORDER 0
 
-- 
2.54.0

