Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795002028;
	b=3AXZrXFiQHZIpUvGWgj8I1mMOvqGTgdi4RyCjIQm53fWU84NWoT3kTlTf2UDqvhr0l0C
	 e7Tev6foQ5edF7IYYk/nKurSA3Do/aqLhQMomQjLC4dbh/qBGhQcqkoSBPj/QlNzmwdjk
	 aKvVNSIg9ieHWR1q3WXJJH/xoM1LPlITbPYU8dkMM9qBtY95Jw9d8Rb/R9WAQ/AEqdnKn
	 vw3eQMIfn8lHVHFdGsT9bqgRnd36QFKxM19wJFvqe/SoVpmBb1Mtnv0UBsWvKCBjmhYra
	 8meRUVmqLEqhpea3srPMdqVZbCZeHDhHFMdpOC/YcY36o/FL4mvXWvhrbyg2Naymqdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795002028;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=joKPrh60l9RacrgiLaA7oi1DDDf9ZOY+t9J3WM0zaLk=;
	b=1bMq6svhTPBOZpW0tJsI7k/CPilfL2c7oqVVd2P1afISOqf0TH6Z1M5ObiQX5pbH2aKR
	 Ny4xm3MjfGR/tQhu1zYC1VsSZa30ySMV31QOyBYfGO/VPChIzeTkQnVFT68PthifFRxh/
	 TeB4f7Eq34SICBxO39FPy9Y9CC+JryoxMFdHP22a49Pjg2GAVsMMvCS4+HVZhaT6VTbnW
	 vPExVAAhUFAjMaEB1j5d44bCPVA6GQ2FuWX2SfuUvw6hnhzfFhAICPl4kzQSB6WyGVAof
	 Bveql1GoMN+hh+xniuSwe8baTf2AJBmyCmHHaG4SBvIj+/7ByeyGIB8xENe+uOZKhag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Ri4FMxE0;
	arc=none smtp.remote-ip=209.85.210.175
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77086606A31C
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 11:40:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 77086606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Ri4FMxE0
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-8b600fae14dso405741b3a.2
        for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 03:40:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795002028; x=1795606828; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=joKPrh60l9RacrgiLaA7oi1DDDf9ZOY+t9J3WM0zaLk=;
        b=Ri4FMxE0ENmt5ExlIpMFuucBbg8Ff7sKAf10q/8ianryZQyKtbi3YXq+ktSfczLSfu
         IctLlAj/ddfPqpMpLdJSQfghV9HsCVBQXGWEkWXn72XaqMlG1/eCJwwmgrY6/N3rntfN
         ZfpbOVhacSiGr87oYY/VR6SGrjRQ6qgHuYNfoBwiKRW/cuRuT2NWrM5Mu7Gx4VZAQNMu
         gxJRzVDdgVqV3Xko6LFK3vws1WamrlKSqKm9s8WgCUZWPHAPe/9bwG6Cn6uK0NqjWDH0
         EzCBn00mfADqxTRlXynqAz78TtowHCugr1TZsMaq4UJcPOVvGtmybUrhGNu/nFBP3gme
         pEEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795002028; x=1795606828;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=joKPrh60l9RacrgiLaA7oi1DDDf9ZOY+t9J3WM0zaLk=;
        b=qQGNBgjHZmBGRv4DfXckbKH2XoFVfyhWb4uFWkGmMENNJKkAX3M6yy15+M0jnMlp6Q
         /63QCaRcQSbDqIHEd4qbArWTOfKqAMFCmebqXUEjGjinre3ZcMw/5qRbkA/T5+rK0YSZ
         Z+oT5dGiHL/yJFO2ISrmsCjSiUkLnkjJKbrXqhuAny7P/XG7/8Eh/xrSftVQBw1gkUvi
         +yyIGO+nB3xEaG//NGgE3IyTO29+ACBChmA6nZF8nXvTZu60/6ez8vUf/AVPH8LvRqfa
         mXIW45tI+XuUvFh9HouDADcrE0BwgAccLMhEizDK9mzemK96XVrxk1n5JrpxI1L6quEH
         xV5g==
X-Gm-Message-State: APuU4Z++5h9HBwdC4WcMnqwBF7c5ldokYcqRs2lt/beqc8x4ho6HB5uf
	poaTgCh77eNQVEvdiXwlA2ijuY8T5pVIZBykMkP2dTmft76fp/yC1Dy+ZAHVw7B8VB8=
X-Gm-Gg: AYBFou1c9A6wpnO53WFtZL5LH8AvbfPsozZ4m/MIMJgK54GZjCQLRMbUmKlAsaZgx93
	OZ44netQSQpBolRmWjU98JmDn+iWsR6q2r+++5/dofXN36TqmGohbZVnUmEXZoVgYd/aeJKKc8H
	70qSeHVXIqmhq3glho7ztCslYc9TRQH6hh3WHe/2sazQcJqCaJq+5dxRiMQtRzO+idd3e/wR6cN
	eXOuSBkepHux5NBdcdXcaQy0if7zkEq99Ky7ld0UJg3ewqC23YKDAfDTKfv3/Ci4DVsOWvz51+a
	RPkydcRdkiSZ4ziOCD4iAsSLIs8NxrlVNcyQp8bgmxr94T28Ezim7ZWy3NOdzrmgPxHayNjn7YD
	beA4cLC1kH4uYYZedsMdRGtpuDN+DJhr4MWaiJ4qwbo+aFvVexnl8gzQfjkl4SM8EMhIcthUCAC
	UXxKuy/9Exfsy6QRiaQsG5P49k3s2AW5QomedtEvHQ72JYd08zFXG8C8DD9rJTQXzo1HgK6kElM
	jz7PSVSpjWjIhbA20jpAA0hdfQ75sqIj6PxUYx/RI82XUi58pn3DWb0qRZqwFc/CS9EUEfB12NW
	7Wvwo3+Awyhl/HEj3cfOC9tk8ytbgQQSgLBrziKA5HUyVg1zHF8CqYesx/F8J7UgPNWDlzEPapJ
	RHTqXwzHTWgjQXOC0nHEYf6K9qezOazXvnUpraw==
X-Received: by 2002:a05:6300:6690:b0:3fa:988:1ba7 with SMTP id adf61e73a8af0-3fe86bdc721mr2207986637.11.1795002027791;
        Wed, 18 Nov 2026 03:40:27 -0800 (PST)
Received: from localhost.localdomain ([2406:5900:1044:110c:e78e:f7f0:2120:34e7])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c5cb35db4esm1038189b3a.35.2026.11.18.03.40.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 03:40:27 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: sagi@grimberg.me,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] IB/isert: finish a Reject the target core allocated itself
Date: Wed, 18 Nov 2026 20:40:19 +0900
Message-ID: <20261118114019.2362132-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261116101108.1650132-1-yhlee@isslab.korea.ac.kr>
References: <20261116101108.1650132-1-yhlee@isslab.korea.ac.kr>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is superseded by v2:
  https://lore.kernel.org/all/20261118113905.2361969-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
