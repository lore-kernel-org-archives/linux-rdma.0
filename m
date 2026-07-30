Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E678F384CC4
	for <linux-rdma@vger.kernel.org>; Thu, 30 Jul 2026 11:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785411877; cv=none; b=Hyxn8sAhcu0qpIrA3Bey7oEWeEM9CaGsWMF+DopT2i/BYYTv3iDnRk0ZMNnFtdvrwkdnmU5W18ItOJGADAN6hvWvVSvD6XTd/5jfNM7ipJHml1H/lWZYrMz6nLtdmyopdFmzLzXwBa7rBBBFSJUhrH4KXD7caoUDWrIJjOVRrEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785411877; c=relaxed/simple;
	bh=k2DFnSUAYjUcmbd+6TchyY8n8uA7dVzhzQtvixzuO68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f1gVlCjOdi9ePX42jsN0eFbLqidwP9X6bT16ahChuwfZnC15PvX5zJBBvZzW4w0Ji0oA0x2Qvs/D5aVCL8ZqgAoRutNgkByMNeFpYJ+9ZPBz/QHJvVqgEE3X0Q+QTu7Ryekg4IGakUaUSQc2aFVTR4pAVg1RTqrYbBZjlSr9PKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=XXl20C3Y; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="XXl20C3Y"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-8485ef63b68so2303056b3a.1
        for <linux-rdma@vger.kernel.org>; Thu, 30 Jul 2026 04:44:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1785411875; x=1786016675; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZI/MFyfx0WYz9jr3ngUFK+Bz6mDWD6yJMRG/ycoLydg=;
        b=XXl20C3YzK/Ks/8u94jLe6pO4Doh1pNlHfD9Z+cNqlZb6IbBOQwek3PqW0RkXZGeLV
         KcAVzqVgT88f2mxSbx41EPzUTPOuEwCX+B4xZOmDH5wXk8dxtALqut0yJ96GUfg79D50
         KqqooKPj9vijnbSoF0+HEEKYobAWrVBEWSP7kiqUIXnxpGayd2yqkcXguZ9TDJ07yePO
         LGCQ8n1qLnVhfjCe73WvmOYM9HbG7PkLqI2KSmxV9GOQ6EcGhTwEwPBXE9llEqhNMUYo
         J1jw87bZ92EwESTVBncIJp4McJtecD9PN16VLqiX21CEfcUnxTCVQWmv1QrVLdGxKJOo
         EMGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785411875; x=1786016675;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZI/MFyfx0WYz9jr3ngUFK+Bz6mDWD6yJMRG/ycoLydg=;
        b=KulA7YA/Zr0cZ6//pEOlorAHltjgOL4/lW61jS68cBC8GPUeqlAqRXA76OkHHWQu4b
         O+A+eWWPOw99O14Cyu+CUstyzDPJulIIRFYRtSIzodL5pCbuY6us7ePDjLO1yZI9UDxX
         4/sqlYt19g063MhDAXLPVY9Hgq/rGW/h4bqBNdWi2BuU/bxsben34xgk8vxifvOl/MaM
         kwe7BwPCQam8OtiqzetyGOkfNwx85jcYmPArjxIqVRwcX4penOYhDePysQ95PuRB8y4p
         fQvPbOjCKg8c3vLOUWXOeyPtBngJYooqijERhPSE3IPh3//U01ZSbnUCdU7F6GbagBK+
         jLCA==
X-Forwarded-Encrypted: i=1; AHgh+RqEej7Bb7oKZ1pKvKGli8oabWVFYck1TC/N731uq3s192yuU9CYh4KVEnhI4FsDRT1PorVoumiQ/bkG@vger.kernel.org
X-Gm-Message-State: AOJu0YxslCsss0IJ5ty3r8s7eCJk7us5ac3yYoTQMV54bZx41Y0nYXUs
	7nE74N9B6ZgK47qAPfMPU3V+rnFDbLfnO5FJxdw0aiFRrhc07xeircvs255jLweuhpQ=
X-Gm-Gg: AR+sD12qoYN1DCbMD7Fvu8uEQ9xgFCCB1QYiAlKHTpvnaghiXLTMJyKW6voUJnM1MlJ
	ux8aKScrfj/ipeb4tLBxWhJLbNSmEe/LG12vNqae42vwtpqM6w0VlX/QBKF11uK5vqoxwZEg5az
	XfRBoHDJGGlHVsYHM+N1oR82rjBL9MemoFHWqB0MNnMwOMbzTLDp4S5l+deI4xpsvoUg893kG0/
	JsN27QZ5tKIxmTNaPX5IsE00gk779HuQCdhL5DkCOhEQWKLOfgCcakkG416cB7tTwdUtdmLP1PA
	DNJekt02YTZ+TqjLt4m6LhduDMAYUcZZhCmJ+3SzImpN6FUzyDxAQVn9rksqKUazhqqSgyZER9P
	8B8QGTK5t6FobbHh6EizNHelOaWVzAHYPHMFo7j1GcYbmG8MfPgxk9KmYGIUnM40ckSNAxg5sQ2
	W/ix5iwpRBPSHr20H0BU3cFRkv228k4IGZvRY+2bYSpH9SHSuf+jUcO7SeMDbXuJmWHd+Z
X-Received: by 2002:a05:6a00:240a:b0:848:3d18:2700 with SMTP id d2e1a72fcca58-84ebc46f7a8mr2193712b3a.71.1785411875276;
        Thu, 30 Jul 2026 04:44:35 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84ea02fa4c9sm2999201b3a.32.2026.07.30.04.44.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 04:44:34 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: sagi@grimberg.me,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: michael.christie@oracle.com,
	martin.petersen@oracle.com,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] IB/isert: delay the final Login Response until the session is registered
Date: Thu, 30 Jul 2026 20:44:21 +0900
Message-ID: <20260730114421.1605304-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260730063124.1554460-1-yhlee@isslab.korea.ac.kr>
References: <20260730063124.1554460-1-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Sashiko flagged two things on this v2, so please do not apply it as it
stands.

1/2 leaks the login_tx_desc DMA mapping when the connection is torn down
before isert_get_rx_pdu() posts the delayed response.  Nothing unmaps it:
isert_login_send_done() never runs, and isert_connect_release() does not
touch login_tx_desc.dma_addr.

2/2 reads isert_conn->state with READ_ONCE() in isert_recv_done().  A
control dependency does not order the loads that follow, so the se_tpg
dereference in isert_rx_opcode() can be hoisted ahead of the check; it
needs smp_load_acquire().

I will send v3 with both, and with the error path logging the value it
actually tested.

Best regards,
Yehyeong
