Received: from mail-wr2-f9.google.com (mail-wr2-f9.google.com [74.125.225.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53034766B3
	for <linux-rdma@vger.kernel.org>; Mon, 14 Sep 2026 13:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789391158; cv=none; b=CN8dcHkYrET1rAqGli1+iDF9sV8Def5MZYaLk2vi2kBlf1snRt12YFB1ssnzZbkDXGOFDLe9Lnsfeq8tYJVkoyPXHpAEMnZRbvjl2dQRG60bXsbv3rVOyrCP4KoUjcoyt3urJzi7dMbA3XBA55sNkaRtLqLMQaCFnqDF3X0a02Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789391158; c=relaxed/simple;
	bh=+ot06/esph++ISFoL95/F/SezXZW3wAoizYDA/ZXE4s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oDjWlvD4hj8HV3xQw//1esO4jVPyayDs+rQ6lXZUgk3mk1AfMitcCMjJvc6Ijij59WSSqh4HoqgI/nAuYe7Dc0gtuidxTQ6HrjjmuGrutXw6QsB9Op3NOUOuCpK2GxsoM3Ordvk5pbw2ydDOb/ADDgZ0yapKmdFVO+NIvfAAGxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IQSD2/J5; arc=none smtp.client-ip=74.125.225.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IQSD2/J5"
Received: by mail-wr2-f9.google.com with SMTP id ffacd0b85a97d-484392e3450so288434f8f.0
        for <linux-rdma@vger.kernel.org>; Mon, 14 Sep 2026 06:05:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789391155; x=1789995955; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=s4bb1Qf4ZN2oQ0J+b8ooyhKAW2X1wwD7W1Q4Zbnoqvc=;
        b=IQSD2/J5iRNkrn/HtQNzL0kpqSvWQsblJ31UhQ+T03H/YIlTIkbMZTlkhQWX4V3ph5
         R5qGmIUP7RRi1i4wCp1nx40viTQOcsBzwos+TH0EJ+HVgbFy5wKzFs/8eM87Xjk1tqg2
         sSvnpoJAcISVx8/yx6kiJf+9kUJcOdsH6+1d96Ce63Vbcvtj9QpDPJVraSPjyr//oAcx
         5PAkuaAfCqRwIGS5UGtR8uOCSusQtyRvjm3Opp48M3A1cXZteSmeVK/xryPge5Pg0rAM
         AVJ1E03Gv7h7vTUVizvU1t6JfJm2GaLB/QpJEDxtix9J3bmC7QbzQh1SRDZluLWNBzOj
         teew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789391155; x=1789995955;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=s4bb1Qf4ZN2oQ0J+b8ooyhKAW2X1wwD7W1Q4Zbnoqvc=;
        b=LRJwwi602QC3VuKRqkGtCJATMWuI+xb/DN+ym9x0+6bfKBsBQ5h+ysoVCFRF0zKLqV
         lXBPu/s7E8+RRNqH1Kxf+SW5JYlEKWjdsVP+u6ZB6iHQFG5/uzZncfPoBg6oyX9Qa2G9
         bMGnd4fJz/3B9RaMuZRMYUAU/svsUDpztO8UMvGbcISyB/EuCM38BmzG9sK2ITzG8IJa
         ikbwTaY5xSYvmglVRa4yxHmTLclXFhB6MDjvwkueSdqRCAp2Y3n8i9mdWX2YCl7xdv5c
         xfG9vLf5BXolDq+tWIGDrVT7s5i83W2I2IvLACCS9dH7AIAISSRhHULkbYKi8lD4PpGZ
         ajKg==
X-Forwarded-Encrypted: i=1; AKwUvBxBScx7EGRUUEYks8Al7C5UxHB/tb3WoZNSK5dlYbJiYuFIlszKgCkRkRd7YKrXyJOtMggTljpns4Sn@vger.kernel.org
X-Gm-Message-State: AFuF++mgjnponIMkkiURYisV74YDsrm2LFFniN3jSJ28GHybvmQOc8yV
	qVA7vuqKUm7HY+eFTdjqSd4FRCtLxYTSYB46vV106ceUcgWtDkI0+EvJ0mrQMEZepGA=
X-Gm-Gg: AYBFou078b+xdBM/t0xrBAQ+JBFt6L6GyIE4mUl5juLNlW76cfR8QAqF8EPH8vLOVfi
	JVsDwRZ82J2PJWdf2APM3QVxwkfKUWyoVZ1KU24hbBpHKcMVQODapCQU91hbLSPiE3usX03wXuy
	2XBvYWXu4jr8mxnSNEeys8RgsPJYTfIYsDFwdJlwYI9kJKa64yI9taBgrD5AfRie4HnUA3dQ5Lc
	o4aaqdD6zShgZREGC+iYRU++/F7iZAVzgj4joXdRIbS0m9qrehBThlHlrVcDOnDcubX0n0Sa8wE
	UeXHtj7J9mTPgqaUvwnsQEkgWepYhW9pvyihsGQ5jv3M570snyzBEwl+CPGxUMidLHh66CUeFcb
	8nz81F/XIeEfkWeEFe/fm1QF3s1vLYY1lCnmoQPWofY8PX1Yu525uhdw9Fg6IWlDgW4IpXm7e4C
	HzJ1qCSroFN2Tu9lrXMAvl/gpEPJaBDbpV5uh/veKE1lBYu2AR7j79uCsTfQVDijdF9CIZdFQ8T
	ZQd5fFwU7hKR2I=
X-Received: by 2002:a05:600c:8b2f:b0:49e:65f2:db64 with SMTP id 5b1f17b1804b1-49e7a657446mr26349045e9.5.1789391154592;
        Mon, 14 Sep 2026 06:05:54 -0700 (PDT)
Received: from serhat-ubuntu.home ([212.253.192.148])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49e62225628sm234119165e9.3.2026.09.14.06.05.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 06:05:53 -0700 (PDT)
From: Serhat Kumral <serhatkumral1@gmail.com>
To: bvanassche@acm.org
Cc: jgg@ziepe.ca,
	leon@kernel.org,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Serhat Kumral <serhatkumral1@gmail.com>
Subject: [PATCH] RDMA/srpt: Fix srp_sq_size documentation
Date: Mon, 14 Sep 2026 16:05:36 +0300
Message-ID: <20260914130536.19769-1-serhatkumral1@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace "Shared receive queue (SRQ)" with "Send queue".

Signed-off-by: Serhat Kumral <serhatkumral1@gmail.com>
---
 drivers/infiniband/ulp/srpt/ib_srpt.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index 4c46b301eea1..506c11b84359 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -350,7 +350,7 @@ struct srpt_nexus {
  * struct srpt_port_attrib - attributes for SRPT port
  * @srp_max_rdma_size: Maximum size of SRP RDMA transfers for new connections.
  * @srp_max_rsp_size: Maximum size of SRP response messages in bytes.
- * @srp_sq_size: Shared receive queue (SRQ) size.
+ * @srp_sq_size: Send queue size.
  * @use_srq: Whether or not to use SRQ.
  */
 struct srpt_port_attrib {
-- 
2.53.0

