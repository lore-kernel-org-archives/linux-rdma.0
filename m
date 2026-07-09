Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A6DD347BAF
	for <linux-rdma@vger.kernel.org>; Thu,  9 Jul 2026 22:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783634646; cv=none; b=jlFMJpB8RSl/09WilnfR+E+U2pjC3cGQ4XgZZbrWtJqxkTWMMm/QZXEmJlD8xi92W2vadf6JI++4Z75Gyezhchqw5O6wYhD2D34FD8xSZNgt0P0HAHhcTQ/ploGRPplZU11BpYQQPrrLeR+shgm6ML5CEhiyGU7IjmD9akKDzjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783634646; c=relaxed/simple;
	bh=8CTuY0rp+50ttcUxPczEqakrirHL7DDnHRxTRnmunmE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=axJ2CQqmkWLThSf114a+lu9xh7B4xWDgdihnT85YLSRseD14RheZTyr37sY0ppSGaDPkPH74T18/UYOPoh9r9Tfzsp71oiKc7MvX/RIUfbFowy2rtQqxS/1z9mJWkDFtl8VQvDnvpWJyFsdmtP0LPn6s60uKT4jhBt46SCW2GoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BTa3unaj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BTa3unaj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783634644;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=JZ6eTJbXFUyCCa7AiotM1+arUJd8tq+Ft2Kk/lg135E=;
	b=BTa3unajyNKAkfSzjbdMxpcqZ2f80SwJSo3WDv1WvUUybe6jTReIOokvtRQc7RJKoL2y00
	0FA+IUW7EPzuTDnfROeDrzUdv78J2B6GBQLr/BVjfBDJHA8oc6VgrgEtEoVeX//kaayqly
	j0MUMuOUIbPvDg4wUWOvxh8+ymDa0nA=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-88-6z0XyiXfPMOQBrmOIEStig-1; Thu,
 09 Jul 2026 18:04:00 -0400
X-MC-Unique: 6z0XyiXfPMOQBrmOIEStig-1
X-Mimecast-MFC-AGG-ID: 6z0XyiXfPMOQBrmOIEStig_1783634639
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1F15C1955F19;
	Thu,  9 Jul 2026 22:03:59 +0000 (UTC)
Received: from lima-fedora43.redhat.com (unknown [10.22.80.56])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 69A2E18004D4;
	Thu,  9 Jul 2026 22:03:57 +0000 (UTC)
From: Kamal Heib <kheib@redhat.com>
To: linux-rdma@vger.kernel.org
Cc: Abhijit Gangurde <abhijit.gangurde@amd.com>,
	Allen Hubbe <allen.hubbe@amd.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Kamal Heib <kheib@redhat.com>
Subject: [PATCH rdma-rc 0/2] RDMA/ionic: Fix NULL pointer dereferences
Date: Thu,  9 Jul 2026 18:03:51 -0400
Message-ID: <20260709220353.729951-1-kheib@redhat.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Fix two potential NULL pointer dereferences in the ionic driver by
adding the missing NULL checks before dereferencing netdev pointers.

Kamal Heib (2):
  RDMA/ionic: Fix potential NULL pointer dereference in
    ionic_query_device
  RDMA/ionic: Fix potential NULL pointer dereference in
    ionic_create_ibdev

 drivers/infiniband/hw/ionic/ionic_ibdev.c | 8 ++++++++
 1 file changed, 8 insertions(+)

-- 
2.55.0

