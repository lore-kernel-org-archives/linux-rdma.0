Received: from mail-qk1-f202.google.com (mail-qk1-f202.google.com [209.85.222.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F40BD3469E7
	for <linux-rdma@vger.kernel.org>; Tue, 30 Jun 2026 15:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782834909; cv=none; b=JmKH2n9NskXkwazgqbDnOGJ5z9fy82ZKSWUiHsJt/XiTpuyjMIeNsYRpMdbQGY7VIxtRAVnCPxKfrOhTrBOIX4Y6ubq0+Oyzd5eWiLbPjAiAlVdb+1GxkTQyUMrYgR6WIlTR+lme9Ps2W3nIKIA/2qksltcqDY8hwj7OgxUY/04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782834909; c=relaxed/simple;
	bh=hpE1qd60nSvYqbT58JQmyFCtsPJovKEQNy9fFOTzjco=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=GO85KXk8wnWdVub1OYlzNHdpaSYiRQE9H0ihPkugEmw8Gn+YwVp8hZLAfyEPC3AVeFsK+SEsKRMdhfnEBhb6mlCk0nMDEdrkYLzbU80f4jOAVACJqcQWcXa+M1gfCZcyon5RND09tflYc5Hrwavz8pdN9YGWFZKvGv40liXoyJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TMEzVclt; arc=none smtp.client-ip=209.85.222.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TMEzVclt"
Received: by mail-qk1-f202.google.com with SMTP id af79cd13be357-91931144870so1020368285a.1
        for <linux-rdma@vger.kernel.org>; Tue, 30 Jun 2026 08:55:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782834907; x=1783439707; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=NHDCiOLfLa6C7sUWe34+IV/lFLM2TnuwmY4WSN2nh5E=;
        b=TMEzVcltRWnp5NzyCBGhyMM1QNgPs9r/hYpVz9gtuIZceYDOqZZiWkue5dh6LdVICr
         HJrHfkZ9IhbXXnFktq+hVMtoJPTbbuUeQRcvmK0zDyqZbe4mV2pw7qo/pMl4rwJy6QqE
         XENsXyzQE02LdRXtoiwtredPnzd1Y5ArUlLCqXOlHTPiBL6fa4EzQ8RKHUGwl4jrIhH+
         DSCzhTEo25FQo8N8XUf49TEPbCNZCvj67KeBpfIP27IsEKT5uC5xhKDnFyUa5LXqNffW
         lIZtGdVNiP5CkxXtq1hat/IlG8z+cEbjAxUNM1avgRLRP1a0vK8x7DK2Q7gNf1ogR5yZ
         M98g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782834907; x=1783439707;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NHDCiOLfLa6C7sUWe34+IV/lFLM2TnuwmY4WSN2nh5E=;
        b=Ge7s2N5Wec8y9baKWd3ek5qeJBhTtS9tyW/M2SqzwkW1pvo7V1FqFGEd0w+tFd2vXu
         Yfr/c1Ra2FsFoauf73gZn/owVXRqhgCEcSAzSOWU1MQTqRIQO6vC509aGfGSXHfq4sox
         FzG6VT7uvkj5SDJFAo33NTLnkkL4X2BKQOGbshIpLlrskDhbAfVZoZxGkGamdjvd2SM1
         igAIrVVXQ6uh9u6jh+iECdxQnzXi+O1dVObB0rybQmm30eqTQhuyKDrTEsvkRZArpvCa
         F4vnkcmjVZWPI42uAk6qQpTvQowCa7ibuGVKt3sB8XtdX9TA5W5AHcnvn1W7ywioIHdX
         gYyQ==
X-Gm-Message-State: AOJu0YzKd0TGA+1pe0d3YNCPTjVO8zFrnUEaVF5obrXoHIoD/HoZDb3W
	jRQutOx0V+UMgh/mfcqhlcDXNyvteSSgdLdpPZj/6q1l0MFHl8BPJxrXaOmaasW3Z1MLGENEeR9
	JN2x/RmEWhA==
X-Received: from qknvm6.prod.google.com ([2002:a05:620a:7186:b0:92e:6dfa:48a6])
 (user=jmoroni job=prod-delivery.src-stubby-dispatcher) by 2002:a05:620a:a190:20b0:92e:6e55:cc66
 with SMTP id af79cd13be357-92e6e55e500mr121127185a.47.1782834906470; Tue, 30
 Jun 2026 08:55:06 -0700 (PDT)
Date: Tue, 30 Jun 2026 15:55:05 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260630155505.1707193-1-jmoroni@google.com>
Subject: [PATCH] RDMA/mthca: Check for null udata during reg_user_mr
From: Jacob Moroni <jmoroni@google.com>
To: jgg@ziepe.ca, leon@kernel.org
Cc: linux-rdma@vger.kernel.org, Jacob Moroni <jmoroni@google.com>
Content-Type: text/plain; charset="UTF-8"

The mthca driver was unconditionally checking udata->inlen,
but udata could be null if the user intentionally triggers
the UVERBS_METHOD_REG_MR ioctl. Prevent the potential null
deref by adding a check.

Signed-off-by: Jacob Moroni <jmoroni@google.com>
---
 drivers/infiniband/hw/mthca/mthca_provider.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
index f90f67afc8f..6005ed40665 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -863,6 +863,9 @@ static struct ib_mr *mthca_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	if (dmah)
 		return ERR_PTR(-EOPNOTSUPP);
 
+	if (!udata)
+		return ERR_PTR(-EINVAL);
+
 	if (udata->inlen < sizeof ucmd) {
 		if (!context->reg_mr_warned) {
 			mthca_warn(dev, "Process '%s' did not pass in MR attrs.\n",
-- 
2.55.0.rc0.799.gd6f94ed593-goog

