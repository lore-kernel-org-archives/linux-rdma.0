Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35094390CAD
	for <linux-rdma@vger.kernel.org>; Fri,  5 Jun 2026 17:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780679700; cv=none; b=qn0PmwCIQMN36xRUFpjF2ZJuK12SlhAL9WYA6vV4xLw9jgGEqG+vuiz3bkkBI3Q7/SAsXTd5cTTkkmOf5EMU+0BiM8ay/BtdKxd0MjlYF75jlSfCwT+cCDTsr8XGL6YRMVaGk7LEET8fP1tytnJBvqqYcjpA2Kw49CUhcsY0rFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780679700; c=relaxed/simple;
	bh=NZBogo6csdHRo0ECRnQXqFzw+Ujg4cMJ7QOPVWvpRAc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=h+1G1L8uHatqEh3DHNJ50EeTg1eapEpOPQwGIt4lw4xJYtbyQOZ5/1NFGXf2xZrBAGWyejpDgMO3Rx+r+nf3rw/TjcIeIdvlKH0Cu+MRwpa+a7PhtvBOmJKAFU7FiHiPk9wiOEUvOAoar3iXdR+d/NOE/F0kRngbjb2eSuzFJmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dO4pY9Re; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dO4pY9Re"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5aa5e9a64b4so2425947e87.3
        for <linux-rdma@vger.kernel.org>; Fri, 05 Jun 2026 10:14:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780679694; x=1781284494; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vJIc+ZW4x5FMrpduKc7fLE6NQN1WP6A0QKK3016XahQ=;
        b=dO4pY9ReDpAvPUB6D16MBwtQ0gXcL7va/KkobYmJsZdBzmbRHkg2UieMIwCGW/PLit
         6J9WC6L090tGM3aPUlALnvMZ/1KntOofEDg+dnFOKn/4cjtwYJoOh7ijKeJfIkIEGkGf
         VSMp7jqgFJfEe5apS7lFFXe9KCqJMV5gKUPnseDJWfQWtz3gbDrWEyokbtEoZp7KCzLT
         UzvYZbtjmz9hokzkKeyVt3Pxhj6J0Jw+Umr5ZjVcfWk0kMJ6bVKKmLFhPIMidBt8KUnz
         vyf6CTtJ1fTryPmMA09lWaJD/kQolT50Hl71xZkClobPDkn6nGsmXJDahxnLOWE1EBuD
         flzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780679694; x=1781284494;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vJIc+ZW4x5FMrpduKc7fLE6NQN1WP6A0QKK3016XahQ=;
        b=hq0DxE5PvtoYAKlkmGP8UFl8Iil29CmYjs8U80+U6NMXohVuT8mwN2yps1EpaWf0GY
         E2zGZ1erQERXZSUzumO6Aes3lA3xeElJS+NZUMJBwogViU8qHveqR94dCOoZRb+0kfi4
         00eF4R7ThA7PFIWthiNLCyeAzimps6LPj5H72fyFrtLD9E7O9V55YDOZstfUYgDaVZDi
         Jg9Yp47cv19PZ7XprNDwWi5ff6Fi/RJq3mnBfakb3lCZd1SUi/12PfpQjrDIdR3wKmEd
         zj9xOoLM0zlOoLpG1BhJ1s/C4HdLnr9l+tkDXISh2g17v6h+Fah8IjJksLdCwxmPGvvh
         t7Dw==
X-Forwarded-Encrypted: i=1; AFNElJ9MydfuIk2PJ9xLb4172TDkq4a5eWAhAT7gxkk6D4V8EWs8hyq4ANQh3xmWaYrRTcCAn0/xh8GNEUMN@vger.kernel.org
X-Gm-Message-State: AOJu0Yze8stgKfVVtYXRQkdPUUrV0vgNtTfTeHNvWblfAs/n4oeAS4Ox
	f97pPhlx9ApNaMj9Snm9yEPeBBceF743pN8a48zBJa40WkHXpxoo6fiD
X-Gm-Gg: Acq92OF8cMMYa7YimHkBH4+S3Oy4UjaQfnto6KpGLnlKtu+T53RJsDs5hMK9XY8SOqZ
	MAHlO9eYX7D/1KyJZXTe42Tg9KAZ1bQxvXeu2oxp4nNiytCiRUDnhg/ImIXLQs3PxedmP6LOxwB
	W/9nuWbkqO24711IWOOkRx7rjn8ZPJBVrDbuuwKQGd2FyV98w6LoIka80EYiVfBeg7mRDehcB75
	H2fKcT18JykO3pC/GEbOgmJvHLndtmbEEBdnD0obOrN3oc4PrAyuRoiLcY9Hq115uY+xTZXfBZq
	3rXmdNRVP4Ff5t8ODC7HeilvCGlMIQPxjc5hKzx4f3fFNnFrBvrOkc81yd5UibyxVFAWpuVqGjk
	GUvx2xSzABoxPS+EZXIzFv8gy2XORtepItfqI2oLoLY4ebPhw9LI/HwXXbeiC43Q7TWBwRB3Bju
	mJLTbzHteZpOG5Q5bkYI2bcnA46wsXhNzjvFwptA9JJNOE96iCQogY7naogXuABFBFFO3U
X-Received: by 2002:a05:6512:239f:b0:5aa:6c05:f0a with SMTP id 2adb3069b0e04-5aa87c03936mr1280571e87.35.1780679693999;
        Fri, 05 Jun 2026 10:14:53 -0700 (PDT)
Received: from c0624c666cc5.devsec.astralinux.ru ([93.188.205.42])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5aa7b991b4bsm1991133e87.73.2026.06.05.10.14.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2026 10:14:53 -0700 (PDT)
From: Vladislav Nikolaev <vlad102nikolaev@gmail.com>
To: stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Vladislav Nikolaev <vlad102nikolaev@gmail.com>,
	Zhu Yanjun <zyjzyj2000@gmail.com>,
	Doug Ledford <dledford@redhat.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Haggai Eran <haggaie@mellanox.com>,
	Kamal Heib <kamalh@mellanox.com>,
	Amir Vadai <amirv@mellanox.com>,
	Moni Shoua <monis@mellanox.com>,
	Yonatan Cohen <yonatanc@mellanox.com>,
	Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zhu Yanjun <yanjunz@nvidia.com>,
	lvc-project@linuxtesting.org
Subject: [PATCH v3 5.10/5.15 0/2] Backport RDMA/rxe task and timer cleanup fixes
Date: Fri,  5 Jun 2026 20:14:41 +0300
Message-ID: <20260605171449.1760-1-vlad102nikolaev@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series backports two upstream RDMA/rxe fixes to linux-5.10.y and
linux-5.15.y.

The first patch fixes cleanup of RXE tasks that may not have been
initialized on the rxe_create_qp() error path. The second patch fixes
the same class of lockdep issue for RC timers by checking that both
timers were initialized before deleting them.

In linux-5.10.y and linux-5.15.y the relevant task and timer cleanup
still lives in rxe_qp_destroy(), so the 1c7eec4d5f3b backport applies
the timer guard there and keeps del_timer_sync().

Zhu Yanjun (2):
  RDMA/rxe: Fix the error "trying to register non-static key in
    rxe_cleanup_task"
  RDMA/rxe: Fix "trying to register non-static key in rxe_qp_do_cleanup"
    bug

 drivers/infiniband/sw/rxe/rxe_qp.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

-- 
2.39.5
