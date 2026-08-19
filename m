Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82138282F1E
	for <linux-rdma@vger.kernel.org>; Wed, 19 Aug 2026 02:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787105631; cv=none; b=esH5YJi+q6STeABK3jsBJRrqOO/wd/76cJTxNeYoK3LedTxxVNikDK+68uPCpozQfKlJFlhV5/t2ViX3aQPCGhEudxaoGguou+dpWtizDtNHJpptcmeujlpeRTnDUIApinD/T2iCapmzjXmzz0XebzUHKWjhX2cfPzudFa0V3OQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787105631; c=relaxed/simple;
	bh=S1T+7tbeDVWpCaFut2poBxPI58YlKhZ9d10jZJSlg4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lkYuN5CZrkdZIsChrOV7kbuYpmfewpUZbI9OjL7Isky3BHoHZ7XvyLeoJzdy1u3xj+lDDI0rOBnIk18KmALRkLLUPvGFF5NbCCndQvwSQg5GaoM/Vz8WGPqPYsuhRnC6YFaElcH8z3ESVz10nCHPktP5V5T6HUjxqN6o9KloCpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=Jhpq5nt4; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="Jhpq5nt4"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-38dc4553f62so851966a91.0
        for <linux-rdma@vger.kernel.org>; Tue, 18 Aug 2026 19:13:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1787105630; x=1787710430; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=S1T+7tbeDVWpCaFut2poBxPI58YlKhZ9d10jZJSlg4k=;
        b=Jhpq5nt42Di75bCPZB0qVAhRouF+cw6KUFVxBVoTbFP8ELoUWVACFCNylQv3izaf+5
         Lu9bMhtxsmIRfCIFGZIh6s8PyBjwjj5W9VowMkefGret/fpe28vDY8KwUejWFSi7xE7w
         eQzFEmmqBI2otVImBQBm48QLor6/BK1JAou1KSKUJdFXEG6SmpbOgOIq9zVZOXwIOtOf
         dPWdjwtIrS+8pN7S5T+V84FmplYlYtFHAQZB7ue6DQmTiQePnPC9BS7A2BUQ07vkdD4J
         kg/1b3YBcjc1UdrCsgDqIPXW2SU3MWH6ijAyN6aMF+tLUnGbNRxdjOSPGbG0ovHtpq8Y
         QiQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787105630; x=1787710430;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=S1T+7tbeDVWpCaFut2poBxPI58YlKhZ9d10jZJSlg4k=;
        b=VIWDou8lLXHpO/HU+WZE8S0nhpFYkUL0xMUthEyjbg93Ze2F0eBh2Cd9kESRuT94/T
         Zz6X3aSrTalSLBu9FUZsl2d0b0QUxn3f21vd2mcTYdmsHDyKGY8Q4qX0SCBni63NUtVj
         qSgU237WACNCMxmXWLuzVyamlZ37M8b5dtBFJByPun5Ke4WhftDxuPOjEIdWljUYLXoo
         3sgijnVY+VUBmTjNdkB7AgLkW2iRq5QRRop3E2pUjItZqBYt32rJD5nMt0beVl40lQrD
         PUPK4ZqudvRJnzQAxR27yG7uQdukjjysDPG136wIo5ORqdydag7gxZJD8iceEwll99TK
         GlcA==
X-Forwarded-Encrypted: i=1; AHgh+RrYxMOTtOdtxxm5iWQz9K9IjjuowibYg95Ih38s3XmHk7jNzj+c6JfjK5X9t7V1LjqHQmfzGZBPakgQ@vger.kernel.org
X-Gm-Message-State: AOJu0YwmM0kjVlfSVVe91KkWPkQPuub+7llmMiWBHKMeBIx/obs4N8i/
	AJWapmBXNm7EqcIqkCznuwKM3gkFzCxkq+s+u+AXy0FOhK9kS5rqz7Or1gKQRTEc1jc=
X-Gm-Gg: AR+sD10G+tQI2AV6qhMODRs1Eoy/pDPbnQckhBnwe7hInb1Rpajrel1GC6KAdA0qq8a
	ou1VNcP+BnE/AvvUhJqO20ua13x0tzLcoYlRircuQ41vYcbTNb/cLJRzTOV8jEJR4FQR3gMUexP
	NAfoYpPaWC+34uhNZsrYZ+fHIrJt0cfkI/q89QGKIFiIFJPlObEu0G13Tb4JmNgum195o/rlnup
	NDihTU+wXT77z510LKveSZHczdrQF9ci/gIEKfEGNz5OmEeS5MSDRxb/Jbr3miPMj3p5jBeo5ch
	cR4XJHok1EkM6PfRZYughDBkAZTmTnB7b5V6o3h0jOm7q77YF0ltcOoXbY4WxOgWCSOCx+oeFdE
	JxIeB985wxCiX2IfnQb82c/Xt/c/q+Zv8FcYnGCpk53D6xi06cFVVF37DRD9FZma2zvE+hrv3kb
	KdcQlALKcjtRDNJwwNVyd2UelU2tX0pdVgIWgSxASWRk1bw6nQfUywtnfWzb/uBaA9Um0D
X-Received: by 2002:a17:90b:6c6:b0:38e:1497:af5b with SMTP id 98e67ed59e1d1-39580a5053cmr2573628a91.1.1787105629680;
        Tue, 18 Aug 2026 19:13:49 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3957faf726dsm716919a91.12.2026.08.18.19.13.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 19:13:49 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: mgurtovoy@nvidia.com
Cc: Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	sagi@grimberg.me,
	jgg@ziepe.ca,
	leon@kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dledford@redhat.com
Subject: Re: [PATCH] IB/iser: skip an unregistered direction on remote invalidation
Date: Wed, 19 Aug 2026 11:13:40 +0900
Message-ID: <20260819021340.642773-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <DS0PR12MB7558FE82AD2039A8A4B00E57DEA62@DS0PR12MB7558.namprd12.prod.outlook.com>
References: <DS0PR12MB7558FE82AD2039A8A4B00E57DEA62@DS0PR12MB7558.namprd12.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

My reply went out without In-Reply-To and started its own thread:

https://lore.kernel.org/linux-rdma/20260819011830.642018-1-yhlee@isslab.korea.ac.kr/

Best regards,

Yehyeong Lee
