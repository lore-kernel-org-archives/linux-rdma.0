Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C76F81EB1AA;
	Fri, 17 Jul 2026 02:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784256890; cv=none; b=eIYpOqXbTgrdyuQlZALkhoi0yM3VVo3GGo+VhK6uZ0r6U57NpXX83NG1mQaG75atB+WmDb4FcS32nM1l/+nuVx5fljggWgs6z2QF33xhoBFczXPhpM9h6nt8xB0sb5SNWj7MTNmFOdibjkd4u4bq5hTsafkwVbEWxvwKxigF/UE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784256890; c=relaxed/simple;
	bh=ruUowAkyqKA7NKa3m7eil0W2+uoXBzWKb8QGDGBChgY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=E4aDqWQzwJt5jNjcsO4gvQVsDK5BkTdG1vUBaCKNT6fFwVMqK+33JO/nbng15vFeRKttf6T0Lf/HzYeKJ155mwqZj23l2BR261I0pMBYIyfrPGYTRkmOLOdE2uJ1gdeAnyHR+GIkSLLwFtYuHO5K6bKhk1T1JxO7gXZcn4tbB0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=ZOLimY0k; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="ZOLimY0k"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=9Y
	cwQVqszbwi7hoEczqm77ptCr5GT38QypRMSU2uiRc=; b=ZOLimY0khr/6A3s8aS
	hVaLIzmkC3ezVgrLUOW0E32ee+5y1jbLcViZz5QfCRwrxHU6v5cG0FH6extvUwtu
	9433G1ETGu58k1oYwyH0CpwqqP64LHnB/CBV4+wLTaQx6UGKqt0Ua/Hug4F3n1Sq
	MJKW9I/SqC0TMGUnm3VxQJdBw=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wA39tRKmVlq+Q4FKA--.32863S2;
	Fri, 17 Jul 2026 10:54:03 +0800 (CST)
From: kensanya@163.com
To: linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org
Cc: bvanassche@acm.org,
	jgg@ziepe.ca,
	leon@kernel.org
Subject: [QUESTION] RDMA/srpt: is target_send_busy() safe before target_init_cmd()?
Date: Fri, 17 Jul 2026 10:54:02 +0800
Message-Id: <20260717025402.64054-1-kensanya@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wA39tRKmVlq+Q4FKA--.32863S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7KF17uF1rWFW3Xw4fJr13Jwb_yoW8Xry7pa
	90q3sFkrs5trWSyws7Xa17ArW8t34Uur4jyF4Sqw1kAa1rKry3Ar18KrWaqF97AFW8ua48
	Wan7Z3Z0yFWDGaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07ULL0OUUUUU=
X-CM-SenderInfo: 5nhq2txq1dqiywtou0bp/xtbCwgxqRmpZmUw+wgAA34

Hi,

While working on an unrelated target/stat change, Sashiko flagged a
pre-existing issue in ib_srpt.c:
  https://lore.kernel.org/all/20260709073426.5E7021F000E9@smtp.kernel.org/

I would like to confirm with RDMA/srpt maintainers whether this is a real
bug.

In srpt_handle_cmd():
  rc = srpt_get_desc_tbl(...);
  if (rc)
          goto busy;
  rc = target_init_cmd(...);
  if (rc != 0)
          goto busy;
  ...
busy:
  target_send_busy(cmd);
srpt_get_send_ioctx() zero-initializes se_cmd with memset(). cmd->se_tfo
appears to be set only later in target_init_cmd() -> __target_init_cmd().

So if srpt_get_desc_tbl() fails, target_send_busy() may run with
cmd->se_tfo still NULL:
  target_send_busy()
    -> cmd->se_tfo->queue_status(cmd)
Also, target_send_busy() is documented as:
  "Only call this function if target_submit_cmd*() failed."

That seems to cover the target_init_cmd() failure path, but not the
srpt_get_desc_tbl() failure path before init.

This goes back to:
  8b8807b9e982 ("scsi: RDMA/srpt: Fix handling of command / TMF submission failure")

Questions:
1. Is calling target_send_busy() before target_init_cmd() intentional /
   known-safe?
2. If not, should ib_srpt.c send a fabric-local SRP_RSP BUSY (or otherwise
   free the send ioctx) when se_tfo is unset, and keep target_send_busy()
   only for the post-init failure path?

I have not reproduced a crash on hardware yet; this is from code review of
the Sashiko report.

Thanks,
TanZheng

