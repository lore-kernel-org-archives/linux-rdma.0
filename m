Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4230B38BF69
	for <linux-rdma@vger.kernel.org>; Wed, 19 Aug 2026 01:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787102322; cv=none; b=ComKsG475GmuMMSleIL+3CUwhqMCzq4W/P8jbxDtB3SxWMdrlvzOmOzhpWIcVzE2evmHPXE59AWHBjPxpA3EKFrGnqFhf81GH0/wKMuqYVLkPHEKDCSYJ8BPj3YJeHCbjLRaMfYFAJG9aGeYYd27ryHZXtlK89PlGOjnQcOt92w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787102322; c=relaxed/simple;
	bh=gp6W0886F0bWnxI+oCubdAK4tqRp0th6G8HGXi6ADKU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eMbgV2zHNyNCU8eZuDEaN8VRIUWemP772O/1WOlSr2H1cf0UEIYoFPTqhxlcSIU9N/b4V06y4F4gHBx2EaXo75CFlutBHSsjUnQqvmPZ5YUW0g0fbNeRPegu0H9VIpgrKEpQ6levLWIgRSFlrsAS6aI54ocbwTuW5zkwmTY3gKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=VCAJQpwC; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="VCAJQpwC"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-84a652535dcso353368b3a.3
        for <linux-rdma@vger.kernel.org>; Tue, 18 Aug 2026 18:18:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1787102320; x=1787707120; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=3N2depe7bxyaMi94bj9Bc9basZqXm7sDUHf9Pucaa9c=;
        b=VCAJQpwCRnjlly+5QVAcq8+SZ6weWduZAmuRrIJdqtvtpntB7g0F0/QOQECI6IlI2U
         avG5WOyrQAHLinUQou+orrifLy5UhqJ70g9NvTOHfl+mvWil6UFFlnvXCEbBIoZKCU1d
         ifateVUuNIdBPqqwvZ8Ba1tpeG5hJ2LlAkbFfuB+u7P+9f74QbZhaaJFMtH9HmQUBkG4
         AkZoX1IdkDPQOaBtD0YOqEb+cBBxQTrywxRHFuAKMCjoFXnD2LBskE/pf4PD62zQSSX1
         xXt1aAvrBmVurzXjZq675OIj/73/2Vi/PyhOs17aAzgkzyhgukUJcgBDDk6hMP8NvcHI
         6m2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787102320; x=1787707120;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3N2depe7bxyaMi94bj9Bc9basZqXm7sDUHf9Pucaa9c=;
        b=TxaQ/0XQe5t6VsU80rF0gw/twCx0jSwuU/TlVxazYZaN72MF7crHOrR1slbjXVQx/W
         +6kCPQNgoTbENQh8TvNHZ2UiR0Er4KItL+eGSO+sgc1WTW1bQviKPTtan86qrRQFm6YP
         5DgwS6z1XvB3LN1u3P9/pHynIjano6Q2ne/eCKDvpD89uJrcgZyuS/UeuKSZ5FZabWDN
         t9AvMrJV26lu70HFy0PctyULbgOSMTgVvW+P+USYKC5I96RC5QqBxe8b3fDi9EWW78HX
         oWefDz43DHUyWTnkhnjyl/rQ4KVmCeF6YOG46GD25P02h2USb1gywOGsYqYRkWiDfbwX
         UJUw==
X-Forwarded-Encrypted: i=1; AHgh+Rq8+QXUw3QbBKj17ehbHFIFBtDfRmqP71GJYNnADlbZiE7sfEjtz5URhOTjmuclbcatur9lq+lR9c09@vger.kernel.org
X-Gm-Message-State: AOJu0YyH/K9jNZbohrK+8f08pD2Oa1CaouJ3TUjcKTLlplx3FFMOCzrA
	RYX9bdSWyqrbpH2fWPs+TKn0+qs5P/rJhUfBYtJ8Rub47dSNx5DuumQw/FHh6OL0JXI=
X-Gm-Gg: AR+sD1183gah/++P4ei75gvWs+L/IV+g0p0w7BE4+e2IVk8lPiComUpyMrNc7BMrclf
	y9GMpwNkqqeMLYHL4K6y8ymhhj0BWtm9z58NcNcVEnS3hFg4E/i8Q9EKP69eN43pCHa/312SlWJ
	W/G18qU+9I6YdHYaRs6vMs6zSSzntY9mdLOSNGQzeHyKXvBQUmhxaVRE7wDinGZ3EAnRAjCGfcg
	Kxz4J1+yGJs/s8NWSyOFJcncHMdIuWuzqmeRjaBzpfhOlYlQnv955vbyWOMa0ud2Zp9pCIFaMjQ
	kwGin2sXhs+nMfsTvhXjctS51NQyNgGW2h3MoTim8D0tFjwt8nDzWkR7iVjs0aJ3wv3XqslSYCB
	0HTNdu6/6hwaWWNA8DO1QGbR3zSqWtzrZyYpkCR3ivVlvNWtl3V/m6ZAt1Av1UkQCDeqUWRagKm
	eTkSqqIDWocfCKN+DlZJRl+vFC1k4RLEEvY8YcyKJSu5s9aM2AxUSrYLQH72JIhPUYq/6nMFLK0
	zumEW0=
X-Received: by 2002:a05:6a00:1d9d:b0:84f:a7bf:8fb9 with SMTP id d2e1a72fcca58-851d38203c9mr1524927b3a.3.1787102320506;
        Tue, 18 Aug 2026 18:18:40 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-851d33627f7sm74382b3a.11.2026.08.18.18.18.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 18:18:40 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: mgurtovoy@nvidia.com
Cc: sagi@grimberg.me,
	jgg@ziepe.ca,
	leon@kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dledford@redhat.com
Subject: Re: [PATCH] IB/iser: skip an unregistered direction on remote invalidation
Date: Wed, 19 Aug 2026 10:18:30 +0900
Message-ID: <20260819011830.642018-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v2 implements this:
https://lore.kernel.org/linux-rdma/20260819010804.641772-1-yhlee@isslab.korea.ac.kr/

I re-measured the repeated invalidations I reported against this form
earlier.  They do not reproduce: the session came back up zero times in
ten runs, and the connection error counts overlap between the two forms.
