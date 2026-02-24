Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA9A222580
	for <linux-rdma@vger.kernel.org>; Tue, 24 Feb 2026 00:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771893097; cv=none; b=rPG2scjHmAhP1RsxjMZeNUy+UbnvFREskow8BcCDRoTNJFhipNH7MvxB0U4pd6+6GGa+5cH1ox/TmiZ5qHvuwABNGgTsocxf9qh9jXKD4+dXBplMNUQ5jEqgWBtThSCqg4c8GqFjKOfVr/zZLum1Mx45FZuKF3qIPtlBRtd1cBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771893097; c=relaxed/simple;
	bh=OuBi71DAYGB9LJ23qmVd3SXF+Tl6BjkbZW/iUuwEdMc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JeWzLB3REQ2Uek8fEMnXSrXqFreeJLhB415LaFh3HUX411N6QbIsuzEQeZMQJBr9ajyvMpMFvShpC6OKnpKspY2vQfzY0GZey4D1Hew5WA7ONucmRtbmQ3/rik1TjRM8WCXU3gYLmtUrdDykdzgPSOl80gk6Z8FRa7I5Ojs97cM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BwbN41HV; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BwbN41HV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=lg9bXRp/MQXTD8HN7CuqehAbC4hk8/Cr3R2uyIuQpjU=; b=BwbN41HVD/bZdjMOLzIZy4rHNM
	zxkWdbuvoRADly7+zJvGDkvTpcSaROdW88oPylYpeM5PjL+X2PoHwE4p7sS0k56/RaQKxGSGeibmT
	yi0I6RMHdmdzSmY21tAOWtkZxu/lSx8lTSSphoLEqgfKVyzjJf668RuLmazR8QcnfaYon1Dy49wFV
	WUk8KECIObn1XjV5XKY9Sj+a/MKDQJ9bO7UtmXA6YvCKO/TdpDq0L+22KKDWhoVAGoHur7UpG0G29
	W6LNjBn/+EBda85NYewmwYsKOfZgPeGXPyIkRAVMcsJXGSPJvOV0L0HrtzXgjpCXuc3eAUPOyqavt
	JPfiHMLg==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vugKt-00000001F7u-29UC;
	Tue, 24 Feb 2026 00:31:35 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-rdma@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>
Subject: [PATCH] RDMA/iwcm: fix some kernel-doc issues in iw_cm.h
Date: Mon, 23 Feb 2026 16:31:34 -0800
Message-ID: <20260224003134.3174856-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the "typedef" keyword as needed.
Correct 2 function parameter names.

Warning: include/rdma/iw_cm.h:42 function parameter 'iw_cm_handler' not
 described in 'int'
Warning: include/rdma/iw_cm.h:42 expecting prototype for iw_cm_handler().
 Prototype was for int() instead
Warning: include/rdma/iw_cm.h:53 function parameter 'iw_event_handler' not
 described in 'int'
Warning: include/rdma/iw_cm.h:53 expecting prototype for
 iw_event_handler(). Prototype was for int() instead
Warning: include/rdma/iw_cm.h:104 function parameter 'cm_handler' not
 described in 'iw_create_cm_id'
Warning: include/rdma/iw_cm.h:158 function parameter 'private_data' not
 described in 'iw_cm_reject'

(not adding missing return value kernel-doc descriptions)

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Leon Romanovsky <leonro@nvidia.com>

 include/rdma/iw_cm.h |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- linux-next-20260205.orig/include/rdma/iw_cm.h
+++ linux-next-20260205/include/rdma/iw_cm.h
@@ -33,8 +33,8 @@ struct iw_cm_event {
 };
 
 /**
- * iw_cm_handler - Function to be called by the IW CM when delivering events
- * to the client.
+ * typedef iw_cm_handler - Function to be called by the IW CM when delivering
+ * events to the client.
  *
  * @cm_id: The IW CM identifier associated with the event.
  * @event: Pointer to the event structure.
@@ -43,9 +43,9 @@ typedef int (*iw_cm_handler)(struct iw_c
 			     struct iw_cm_event *event);
 
 /**
- * iw_event_handler - Function called by the provider when delivering provider
- * events to the IW CM.  Returns either 0 indicating the event was processed
- * or -errno if the event could not be processed.
+ * typedef iw_event_handler - Function called by the provider when delivering
+ * provider events to the IW CM.  Returns either 0 indicating the event was
+ * processed or -errno if the event could not be processed.
  *
  * @cm_id: The IW CM identifier associated with the event.
  * @event: Pointer to the event structure.
@@ -97,7 +97,7 @@ enum iw_flags {
  * iw_create_cm_id - Create an IW CM identifier.
  *
  * @device: The IB device on which to create the IW CM identier.
- * @event_handler: User callback invoked to report events associated with the
+ * @cm_handler: User callback invoked to report events associated with the
  *   returned IW CM identifier.
  * @context: User specified context associated with the id.
  */
@@ -147,7 +147,7 @@ int iw_cm_accept(struct iw_cm_id *cm_id,
  * iw_cm_reject - Reject an incoming connection request.
  *
  * @cm_id: Connection identifier associated with the request.
- * @private_daa: Pointer to data to deliver to the remote peer as part of the
+ * @private_data: Pointer to data to deliver to the remote peer as part of the
  *   reject message.
  * @private_data_len: The number of bytes in the private_data parameter.
  *
