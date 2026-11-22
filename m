Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.225.138
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795355678;
	b=2t1POoxfNv+CoyTvSXLbo7m9B07NlpaR41nYqVXf7p4AkR79IPs36TYucbroIRadC9q2
	 yiFAQ3xZfv4WFLdcxcvZBhydrqWEkIxb2K4YMjY+bNNX4SnphFuo+LVp8Ky6oNceuUjJH
	 6pC74JBKGoyZTo8mWtaQavicbYo6RHDbZ7jr5THXkzK+VeXEkwn2MGJ3OuBhKRbqnAOAq
	 OfP2Fl/LyRPPQANQDzHgkZSCXQNqcML9SInQnBumeWh3lLWzqveO8PT+5L70UgYMPEIIj
	 BvgbUPxQT/qTUAwsaqrep3DoL52bheag3UEfs5ZW3O4WAIlUHyHLyYIz0PlUCxa0VXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795355678;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=nZw1kMwP9fH2O45yvl78uLJ7cEROYRLhfKonQzWVgKc=;
	b=ZSVhbluJ8+LJKKWJ9prMKtZIsrw0IXCDGI2Pe046OoFz3ezZYmQdWdVcBZIjwz2NuDaW
	 4hGR2ttexpg1RgcKVUqu1+zf+nlV8NOt4lPyhdJYTwFKGaKzzDqVZPTH7PtGPCgYo/2nO
	 fMLA5mKOgsNRClh/nWgy0pRDOzMogKn2GFtEl2MBAertc7jev6rCD6rGNbOHMdPDZONpb
	 wFhAGHy/ubxtZhzmYybLjGfxzYahdo4LawhfR+bJNT28qjPZDUafeXksmO4EF9rdrJ4um
	 NGKh9fio6keZNZnznTgdF3tTTvhVk7OftlTcfUi5t2m3VSAtHL0bu78KL7ZpJ1GfAbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="E/LMX/r8";
	arc=none smtp.remote-ip=74.125.225.138
Received: from mail-wm2-f10.google.com (mail-wm2-f10.google.com [74.125.225.138])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A23606A32A
	for <linux-rdma@vger.kernel.org>; Sun, 22 Nov 2026 13:54:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B0A23606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=E/LMX/r8
Received: by mail-wm2-f10.google.com with SMTP id 5b1f17b1804b1-4b76b2f6bd9so5094105e9.0
        for <linux-rdma@vger.kernel.org>; Sun, 22 Nov 2026 05:54:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795355676; x=1795960476; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=nZw1kMwP9fH2O45yvl78uLJ7cEROYRLhfKonQzWVgKc=;
        b=E/LMX/r8h+vcgcz8NTkmTAUqO5bvVA9u3NlSp/+SKFrXbUBsIZs3pqcJRfEntXSemG
         /TitcHwe87DkbcGMXW28wmp7qEN7oykPVOsf+FL+BwlCEf9Od2EhiXoARBocsAGTkhb1
         nUivqTkV6sp5Hwo5ZOATk3Jkuz8sxkjQ3pfKeGeLZVKv9upyKy9DX0GfAguG05u8CtBA
         cSReoMIQ4EkNmmkx8deuNUsj6NCOIwUqAPJdXlwzuipfnHsLwl0ycLgkM1zDV+c677CE
         M3UNq9oY0tdyxrxqI7gfBopbKVNzItQecV5YlDo4wCOFyrUX8UzVQVd2hxTWaG3IcvFp
         Jz1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795355676; x=1795960476;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nZw1kMwP9fH2O45yvl78uLJ7cEROYRLhfKonQzWVgKc=;
        b=VqNY6QJ+zeKF+8A14jBN5QD3gq14zba0OZ0mFbgiUcF/2KtYI8KxCKdVunu6+Ce85k
         N0hYJF82UNoR2egaYIwEVJ//SyAxyzm1Cxb+P/Ophgz3Nr/GNgX4rdxA6h/0bdLcBztD
         OdGNo2yI2amECEHvM91Ejf7ndlMmMngMGj/u5ydxZvWB/n4tGoFViNHamw/y7ZSb8z4F
         o70Ncvcmg/BVIbIl/6mG5Vr1Zkpjtgybs6ugc/MTs8tJw0Wh4iIrfFs/E3eSBmHajHwa
         HJX22nEF0E5lxJIiUeerh2CVcULdZW/pD4EIrt18hRhUVNcSvGSuAzYFiHNPgaMc+fUE
         /68w==
X-Gm-Message-State: APuU4Z/k+z8bTN+XEqjGuZaZkhD+wASRPq+hyrKXPLBpmKiRsOMsD7qG
	jWqjYWz7ghXHqhjbPgeR9rnASQit8H9euy+Qn0a8b2YBetrt0Wz+80mCKxaO5nZg
X-Gm-Gg: AZFdTZdTfl7C4uOOWyws0JCskcYZD/NPFxm4+HwtQkpjfsUTxrGQpJj4SzdroVbNeiT
	YxsgQJxs39R32LpInSnCOtXVwiYaeirqaZJ5aYoTSiY5Z5is8Jlcy+Bl1eiySYxLwnVmiUFH8q+
	zDtLoYRbArZKNUjhsjHnW2Ax08MZPQB3ee1xdbPsHYKFytBpd0F7/Vu4bl2d0SOJFJNbF5amzkZ
	PepnajUcwYV4T4Z49t/8ILZYmymKD2J2htmCAbv8xr4ualiWPo2FIEh1R1pWppL5dOzCjqYkjTV
	WyITp4skirvoc4/XNEDsv7VVqVY4DH3A2wFbUltsa05+NXwnqI8oSl+b+pRPuo31Zql4Uc8Y6+L
	CRSiv/DAx9XrTZ86jXg9+Ul33yNngACtTIyKc0lE5bV4NZoO3ujDvEtqni/6QUeqcNu2oa2pUeC
	U1CrejSnJAgFuvO9oHsHUG6/Qe0cFpf0tfd7VRRAlb9sHrGojelujr/RM139BVjBex8vYeQYshl
	oJbOJDhQ50vbZS6mKEY2AjzS+k3cO2hKSk3lzzi2vymMovtITnLQAb8ynDbtCHIrDjYPCqRlaYp
	PBQc2xAgJnAgjwB7ICDgQ1ndj60zgPHDmSoVV1USjW4K
X-Received: by 2002:a05:6000:4028:b0:4a6:bc53:246c with SMTP id ffacd0b85a97d-4abb3956374mr18211349f8f.42.1795355675529;
        Sun, 22 Nov 2026 05:54:35 -0800 (PST)
Received: from serhat-ubuntu.home ([212.253.223.71])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab658e2d55sm16662164f8f.5.2026.11.22.05.54.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2026 05:54:35 -0800 (PST)
From: Serhat Kumral <serhatkumral1@gmail.com>
To: linux-rdma@vger.kernel.org,
	Potnuri Bharat Teja <bharat@chelsio.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Roland Dreier <rolanddreier@rivian.com>,
	Steve Wise <larrystevenwise@gmail.com>,
	linux-kernel@vger.kernel.org,
	Serhat Kumral <serhatkumral1@gmail.com>
Subject: [PATCH] RDMA/cxgb4: Unmap BAR2 when c4iw_rdev_open() fails
Date: Sun, 22 Nov 2026 16:54:13 +0300
Message-ID: <20261122135413.93813-1-serhatkumral1@gmail.com>
X-Mailer: git-send-email 2.53.0
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

c4iw_alloc() maps BAR2 on T5/T6 devices or its on-chip queue region
on T4 devices. If c4iw_rdev_open() fails, c4iw_alloc() releases the
IB device but leaves the mapping in place.

Unmap the mapped region before releasing the IB device.

Fixes: c6d7b26791a2 ("RDMA/cxgb4: Support on-chip SQs")
Fixes: fa658a98a2d0 ("RDMA/cxgb4: Use the BAR2/WC path for kernel QPs and T5 devices")
Signed-off-by: Serhat Kumral <serhatkumral1@gmail.com>
---
 drivers/infiniband/hw/cxgb4/device.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index 24ac9871ce67..35dacf379294 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -1046,6 +1046,10 @@ static struct c4iw_dev *c4iw_alloc(const struct cxgb4_lld_info *infop)
 	ret = c4iw_rdev_open(&devp->rdev);
 	if (ret) {
 		pr_err("Unable to open CXIO rdev err %d\n", ret);
+		if (devp->rdev.bar2_kva)
+			iounmap(devp->rdev.bar2_kva);
+		if (devp->rdev.oc_mw_kva)
+			iounmap(devp->rdev.oc_mw_kva);
 		ib_dealloc_device(&devp->ibdev);
 		return ERR_PTR(ret);
 	}
-- 
2.53.0

