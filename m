Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792892850;
	b=2hlbKa4iR4V8YtwsUmq2R9ptbj4SW1ZtdIQwi3nOk9xPVbnLhl40jPKsTzNBWbN6kg6A
	 D5O4xWtG2LHJ9bTq2Etn56GN8lZj2kmJu1U2GYQPyY6E13pDuBVdPvWdSoI2eSR7FjfHM
	 QW27dHPanY4fzZ8bZ5J5RI4KtgS5D/1xqqTxut3VfCncWSLen35ozDbFNTuK9W/Vjvbgz
	 Bhzn+DpoUaOJZO6VF0R+SreKAG7Udru3FfgC26vYpu/JX8BfHg4JcKgvfZ9NDALlPPqEr
	 0FaAouhlKf9aZNUF+tlFGpaXQhuW4ukfAcOB+ov5PuFp7FcKxZgyUWhcHM9zRRijxIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792892850;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IQf90Fr1RalRueEZp8ReRjoKdVflHnZWV+h6rhgdLt0=;
	b=EQQJSvq8D/yS8aNj8lME07WYMYhgRQyA2BmYeHYNE4GrvkIuu0XtpoyyfFir4zNYORp/
	 nAxAFFqb1cJe5qGXM18hTf7daTVKTiRUHw+GrstBNbqTSEpt3Fc2TPKzpaSvUXliqg+Cx
	 69GWks8yMx/5q4ndGdliIf6fcUjkGn/r/hTIUikKn9oUoUK9/3IYx28egMLN8zcfVAo8X
	 biuAU05UZhdN0zYNsSX/f7M3lM3h5yWhvjg2Yb+Xa7nd8npml1KJsDFV563HlcxJQfU06
	 45m88QOKSBMlM3DCBGfZJvp+u8ywSzCvuNFYBgS/YR5+/gSfvptg4uHYHDnxTT/zZlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=o2UWtj12;
	arc=none smtp.remote-ip=74.125.82.48
Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CACF4606A324
	for <linux-rdma@vger.kernel.org>; Sun, 25 Oct 2026 01:47:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CACF4606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=o2UWtj12
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-1931ff67a29so4026703c88.1
        for <linux-rdma@vger.kernel.org>; Sat, 24 Oct 2026 18:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792892844; x=1793497644; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IQf90Fr1RalRueEZp8ReRjoKdVflHnZWV+h6rhgdLt0=;
        b=o2UWtj1296BSHQ/u/6Ehf7EmeG+tCGM9noKdhbkd1+gqIxX5ZCzGJc2/vZObhDCNWS
         iCzFnC8RaSYazTwUjDjTT7yV6neSMC8ZffOk86YWle/3DEePiazSKSGC8LaR/tU/xbn3
         q4wirtVEhraNnHrW4NL8tXb1AlR0SPyi/P49NiHq+mPe4Of0gW0UvR6wLwFC+x3dPPBw
         YhKY5gjrScIVF9yzrvzcLHRN9US7WODXvKStReQ/FJ5NGanEMdqOf8IpMrKpW+ySI+qg
         A1Xi/0DTUQtFivHXdx70LPoUT2KADDlXuVYfiaN8BUX1Fy/ALxZ+UzChGq7ktVsSRQKu
         aSXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792892844; x=1793497644;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=IQf90Fr1RalRueEZp8ReRjoKdVflHnZWV+h6rhgdLt0=;
        b=F/ZotrAL/mFhlEWLxs+2AJ5ifefWywiNjcOSGNQB8lnuVqKi+V+wlDDQ4ObT4Pouam
         34AOkI2X88Js63rmX5BUk+2AYPnu+b8PQHzAVAW7qFciFVJGBzuuESwkvxxWOeJqaZrS
         HstIHnDiTft7HWqgInMFqYpKzyB4W1KUMiK1bp76xhURdZ3+VjAjnMdZ1fJfxfdnD9xP
         BcAYaOqGSBqSSg+cVu+KpLedS9Z66S65U+XCsg4zCa+893rcjpPMnERkFBoIrdeVWkzp
         HdlbaL3jb6WYjXqLR4mwnxM85yoNUsBBF9DL4b+z/mj3CkF43gFSmmlZfW5/V3BHwsuJ
         Vjvw==
X-Forwarded-Encrypted: i=1; AKwUvBwoCo71eoekO1nxPSS9NX5hSvhDpir+I2uYguCrjS9KDPeqPEa+iQqI4EIp0y1lmy6Sc+v/UfW2a4pP@vger.kernel.org
X-Gm-Message-State: AFq9FYIPMYeEDTcwrs/KOvKXALn+OqNkSKVzpnmDAU2zBotveShER/CU
	GAKsjhDcYbeCYXsuWqiSwj/P7n4Z26ObKYk6LypjjiwgmEkkr016RDOHj9I4W8Hel5A=
X-Gm-Gg: AYBFou1PTHYQ9GmQYMx8qzjrS4wgGWlkQV9zbFxx9xWdgD5SLA/LC9jAl14VSeSFc7K
	nt0sBz9oar4El6KwazXXqFSz4jG6IBzcbLvBKiGSyY6klXzBRAQ3O8fYufg36YfDb43266UXyu5
	2+fAZVWK8f80SmbV0xY2JEGdKMFAlLBIi0FhPyoJXpMDviS0GSyQtIkxpCGhDA+YeS2+1IFEMDt
	PxIqxJqQnr4cLM1ZdplLOkNK89AGLmglUnMPLBX9gtyS1NSAsYrKB/NLMl1BxKwzUG53XYjknv8
	N5Ou2w9305OGydZTcXj827wlVQmekvGxPBwz8AJRJ6nyeILEOf/1cnfkl1SzPnVPm4tTczrUBzv
	I+HSa0+OjV83dofPDpdVCeEQNUvN2lQDuTvrucmstSy2LWGzvhs1h8MW6/+Z+Tx0pguyMJI5QK/
	sU9dyo7CSFHz7mfzWdSLkx607MLrmSpJ/KQ2vHTUObfTfUeGrIeguK1QhsLrTtuPGweJcqiZ0+y
	0yNdjPWqRT9UeqogV7l2+C3rgtyGBau+fCeCn2f2xpUAdQSDf/+iJ7RXbw83gt8BqlVVFQxvHXN
	nF/n7S/3ugPD7ZG+2XrZHbQP3PuazkpMjYTKOyQOXLIGcmFVlrKKOrCzTiyR1iMU7g==
X-Received: by 2002:a05:7022:3f01:b0:19d:255d:1767 with SMTP id a92af1059eb24-19d255d1787mr1959370c88.20.1792892843907;
        Sat, 24 Oct 2026 18:47:23 -0700 (PDT)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:dba3:be57:a674:a67f])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-198a2a5a515sm10149517c88.19.2026.10.24.18.47.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2026 18:47:23 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: Re: [PATCH v4 2/2] RDMA/srpt: widen the indirect RDMA context counters
Date: Sun, 25 Oct 2026 10:47:17 +0900
Message-ID: <20261025014717.3756503-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <75465b8f-1109-4a83-84ab-f4b464f187e3@acm.org>
References: <20261024162852.3528224-1-yhlee@isslab.korea.ac.kr> <20261024162852.3528224-3-yhlee@isslab.korea.ac.kr> <75465b8f-1109-4a83-84ab-f4b464f187e3@acm.org>
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

Thanks for the review. I carried your Reviewed-by into 3/3 of v5.

v5: https://lore.kernel.org/linux-rdma/20261025013748.3755639-1-yhlee@isslab.korea.ac.kr

Thanks,
Yehyeong
