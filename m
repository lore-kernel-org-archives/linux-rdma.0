Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76EC1382F18
	for <linux-rdma@vger.kernel.org>; Sun,  5 Apr 2026 21:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775426279; cv=none; b=OET8VjSj79oNUsvrqg57pUMtXry9/CwXtNq0qRn77l1Ly5rzHY9+xD9Z0PXXgSnO8nMvHKdFXMnEIAMC7bS2v1qvXE9CkPcr5FifPpJ781nwFHVI8ld0POReOPJ7U/MFmqg/Qgw0UmauPrpHfQAE4r1BlNHOfrRkah73ssG59qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775426279; c=relaxed/simple;
	bh=uFe0BS9nIwlNQLOaXhof9AdRSoCSOGLtYXd5e8z7Tl4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lXP6xw93TySz1tm16oGoj7l1tV08ew8XCAWZ++yEGz/bNhTpFqDaklbRGb8taQaQ2xjvfbTym4P9+36c2vX7M7TmT9LV8TvidW0o14l/F4d35Ag0dJI/EbHeoabM3QhnMEZAHwc8ecvqa4qZWdARfj9rB/gU4Z4FD7cCbfUJ5nM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Bj9ml0z7; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bj9ml0z7"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-483487335c2so34271525e9.2
        for <linux-rdma@vger.kernel.org>; Sun, 05 Apr 2026 14:57:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775426276; x=1776031076; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ABbgCzppaW1tFyIqmtlKlRa6pt5yFPCBT+4g9lle4Tk=;
        b=Bj9ml0z7kcf9qdZTs/ZT4mH+wQ2J5ajk5na3YGadjp0nP9k6fuAXfPRvOiYEradgKI
         uUOIdjyyDk5Mj8cYdPILz5OLUGHjIz0d71FPdzs00IgS5nIfDi4pP4QBELTPj1EibFu+
         ICkV+j/8pyY1hvsSZOtAiZ7hn2fhwLX5N8JwNV813mUnYGs3JL5uP1tfWfYuw6iZY0XR
         BV945mscxHRPlvsZbB0KwObFISss/VUYwXU4ldQ7L7X274iAJ9Rai1UD0yVSpG0Tg/PM
         /IoLPDePet13GsMYj4DcwQ4FbEy4Q0UDDmnjrcKIe0UjTh8RAhGWDqQ0Ln4uQfinMOJC
         kjaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775426276; x=1776031076;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ABbgCzppaW1tFyIqmtlKlRa6pt5yFPCBT+4g9lle4Tk=;
        b=rLlYMrLgv0NLkjqYHKJ7Nh8YD/jx8IjzPjXnir3kLdvy4NG5/rYGN198rSrMIUjbsr
         +B7ryM2j7amQnh+Z7t+PBCb7aPwTuPxGVlfZDYqQIxaQb2jnqOozTvjYsz0SVZUi+q/I
         rVuEX3G+afEEAuoVvmdbwD7C+CWQEle9fp1lTPHtvkvrtXixEtMAvtzXQjJovOK7XupJ
         rXBu2aLQPsIF9B5V6XgTEy9k1ZbzJMdhguLioeau4Se/zIUMt6IbcxN092Tx0J6ufC4n
         j6OvAmD3S/cJAQrWgRUXPSIDJDTqpye0L+Hof5EzoGCydW0yWsENQfA4hgzXj/02PP0T
         gw+Q==
X-Gm-Message-State: AOJu0YwkOEzV6LmP25F74TXGRzvHFEa3JGRwHa+wH8Zigq66UCjxLnS9
	ZMlKTEixtKYBi7zy9VExX7kXfNMhjnTgZ2hVk71kImPwf1ldybrr9Uur6Akl1eSJ
X-Gm-Gg: AeBDiethnVVWABJ4nh9sjj+cQC9A6+Tp+eqDCMlDqhs9qcKu7KnU/RGdAcOqa650UfR
	ypd8Vo9WzSmGkXb7eTr9ghDPZlaFugf8QGyRIgq61syL0ZwZg03dCMSuU0ZnXe7yqiwh4I5/ec5
	us/Ye2YKsFSrCQo8J6/peZrmNyRYT8/D4jwk7yDGS8V4rT6B9i6r9C0Oqm5VYbQU5ugdpou3xCV
	aeWldZ8phJCXya8GtY2PE4T7Lew5yj7rvlnpFBFt1Zr9GpsULA6VaCLB/Rli4d+v9Cmdd6t24v4
	pBtXxlJAAvzqxdEwnVuQ4goXbdVhTkux0mYcU5d9bwIhOXLXludqix3YVzcHi019V5wIMcZ8dNh
	QMAYwPfuhMpj5ILPOpDZKpPF7DDwHyimLnYPnHgGsEDH+TCDoDzf8b3BJMlyuRtW9OakccPgUZg
	AuG5i81Sq+843WjY3Kb3NvmpeSiKtLZXP5b93G/eIUjrEpjwrkHkuD0o3MhHcUCcYyJEn3SjMsD
	oMzyb+u87UAZcjufR9hes+Sv03XG9d5qIoYtuIUzULfUkPy
X-Received: by 2002:a05:600c:1396:b0:486:fb0b:ad79 with SMTP id 5b1f17b1804b1-488997d10ffmr157413395e9.20.1775426276317;
        Sun, 05 Apr 2026 14:57:56 -0700 (PDT)
Received: from DESKTOP-NQ2T5I7.localdomain (heme-13-b2-v4wan-167795-cust403.vm32.cable.virginm.net. [81.108.45.148])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4887e822227sm479479095e9.4.2026.04.05.14.57.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 14:57:55 -0700 (PDT)
From: Prathamesh Deshpande <prathameshdeshpande7@gmail.com>
To: linux-rdma@vger.kernel.org
Cc: prathameshdeshpande7@gmail.com,
	dledford@redhat.com,
	haggaie@mellanox.com,
	jgg@ziepe.ca,
	leon@kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v8 0/2] Fix loopback leaks and return paths
Date: Sun,  5 Apr 2026 22:57:16 +0100
Message-ID: <20260405215718.19301-1-prathameshdeshpande7@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series fixes a return-value bug in the transport domain allocation 
path and refactors the loopback enablement logic to resolve reference 
count leaks and premature hardware deactivation.

In v7, the patchset is split into two parts:
1. A direct fix for the return-value bug and mutex initialization.
2. A refactor of the loopback state machine to ensure symmetric counter 
   updates and correct hardware toggling at zero-count transitions.

The split allows for cleaner bisection and separates the immediate 
bug fixes from the lifecycle improvements identified during review.

Prathamesh Deshpande (2):
  IB/mlx5: Fix success return path and mutex initialization
  IB/mlx5: Fix loopback refcounting leaks and premature disable

 drivers/infiniband/hw/mlx5/main.c | 45 ++++++++++++++++---------------
 1 file changed, 23 insertions(+), 22 deletions(-)

-- 
2.43.0

