Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 209D93BBFD3
	for <linux-rdma@vger.kernel.org>; Tue, 18 Aug 2026 03:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787025168; cv=none; b=iHR76qkcZinvRNR0rQXjGsxp0dOMxkLSdFd4IavzDi67twWiVYHzLNs5UNHqVKIzH5VPrJfyLOHflM1v95KVwQZ645V91GeM2SkkngfFYJuhsOJ/EzPOADrucijICVUwDsnrhEYwnJp0CaPERuS0dLGDEMuCgHKY045+YN5iObc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787025168; c=relaxed/simple;
	bh=I7DqftSRWmLEh+ZeBQr2dn3QNGZxOJhsYR6awXazSxs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MQlWLUVEVUI/QoNfKBicaO0b74+0EVRbIF0G6IBrs544Ab9E/I16DODYsHNxVoNFxM9Z7lSI32TwF1ExyhbA0cf6g8qPfM8myLnC7VtaDp4H0VEsK74rUuA8OqxdLKtwgIzXAmTHgFkeKoKn1U/On5E9eZC3S3vhf4LcwtDbJMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=vYT53YR9; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="vYT53YR9"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-8518b3ff3e9so2401211b3a.2
        for <linux-rdma@vger.kernel.org>; Mon, 17 Aug 2026 20:52:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1787025165; x=1787629965; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=WwkuAJMtaXCNE2gc9vnunBUfht1y4rBZmvILNBB4iRQ=;
        b=vYT53YR9N2eI0Cdx3aQpV/Ox8inElec8Y/PcTfH93uz3MyikhE59aPlCwRcqdJa2vR
         1SrpRaxnV/xQxKIbW0mJU72y+Al39ki4o54orgAfAjOxzl4Gd2aZrYaBO/gVbDhNQkR7
         jrazOmxr3V4MIvzf8VkgkOL18UysCvrnOSc95hnOo9lbkVe7ZzSWR3RfZR2BA9Whu7qF
         8xRtprC34nwY1vc1hEvxwpUCkE1MeFOlgM7rhFHTTrmev90FB9b/lhw3mWntryDT9ylW
         YSr1Cbv6PNFV46dHgayDegkhX2MemY6Mn50aB100mU8kPc5vsB5sW5y1w4KFHBc3aqCC
         JvVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787025165; x=1787629965;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WwkuAJMtaXCNE2gc9vnunBUfht1y4rBZmvILNBB4iRQ=;
        b=BIMggAbVaSftwJUHsu0eRWUL7fB2fMftpNeRTBDvLY6QL1zBnNiWwTb+nLXyuCQLv7
         NplMXCtahpFllgED41+qIq0KiXAhE1cCn+bhLjOsFw88dlxc28WDn048ra6O8bPmw3iv
         1O+bN4ubiSoZ/bw6yI+Ss2Lyc6MuLSEAmAVazrn9WnFHGwU1NSUK/7Rbh61XL25cM/hx
         YS0OHWikhaZ/GIY1MedglunnZL+mAqxRnkLypBSKoYIjrHF0Oc6MRIwphbRCyd/Cc6RC
         aKYMtTPO6+klLxrj/vrcOYdl9teFp44I6U+KNpCOWdKN0rwt/yWc35VZEzO51BAzK3Tn
         Xa8g==
X-Gm-Message-State: AOJu0Yx2mXn1G4XqYWPXvvC8KBsSFnnXdCgCmcNgz1sMufvebGVVcu5H
	5TvJoOnSloymWg2ru1BcH+oJI4xi98adrIzp4Llxs471IdLWwQmYtZQhAjeV5ei23a5R+tOw49a
	X4aAd
X-Gm-Gg: AR+sD10BfrkAKT2pqqmUgHtUVzH/wgM6wYXXETboFj1JVEMwfEWbS9if+tfO0/Vpto3
	g+gIIyAmmRPGGXRkkzVU2kqB3ex/Ezfuh5pl3rGauHjlzHHROOOhC1TXHoWojnOyAQBhG/y3Mw4
	YJjJz46SFYSvLKnyMmn6yzhx84UM4ECd9VnzBPIH7xk4KvzU/cHLDESsH9uJbx7pXFznQtCxIks
	LKid8SapqvF8bowoItSkYItR3WguRKpIg7v/WiCWy+Hc6QqVPZLVKG1mIuRE9iuNQFRRjP/NZwa
	8+a8drRLWfd6wmZuBDkziMWVTLFiLn/8dGvItnrkn/yUXel9cN2Zrj7XdVFRkEp/y+1l1xd3ltZ
	MBpgK7JsY6qjq+ZjLIU3CyH4eRFEXX7zQc5BlABl8FG/WCdCxEOohefZFcxnBPOCxiEXH3se7sU
	+7g2nYBHsURDQLJKhEPbJhwtDWJpavReOaLsjY/hMETORkU1pnIJZnWBnMJ9uOaJjE4CCj
X-Received: by 2002:a05:6a00:330d:b0:84e:2f2e:8def with SMTP id d2e1a72fcca58-851b87eaa90mr6161098b3a.6.1787025165159;
        Mon, 17 Aug 2026 20:52:45 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-851b6f8bf71sm985058b3a.32.2026.08.17.20.52.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 20:52:44 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: linux-rdma@vger.kernel.org
Cc: bvanassche@acm.org,
	jgg@ziepe.ca,
	leon@kernel.org,
	linux-kernel@vger.kernel.org,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Subject: [PATCH v2 0/2] RDMA/srp: fix use-after-free of a request in srp_destroy_qp()
Date: Tue, 18 Aug 2026 12:52:27 +0900
Message-ID: <20260818035229.505098-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Bart asked whether reordering srp_remove_target() also fixes the crash.
It does.  Against the same test target, the report appears in 5 of 5
runs without his patch and in 0 of 5 with it.  The drain still finds
the same two completions; the request pool now outlives it.  A
conforming target was unchanged over 5 runs each way.  Both patches
applied together behave the same way.  I never reached the SCSI error
handler.

Each patch stops the crash on its own, so this series carries both.
Patch 1 takes the shared ib_cqe out of the request; it is tagged for
stable.  Patch 2 is Bart's, carried as posted.  Whether it should go to
stable too is his call.

Two notes on patch 2, from source only.  srp_stop_rport_timers() is
documented as "Must be called after srp_remove_host() and
scsi_remove_host()" (scsi_transport_srp.c:789); patch 2 calls it before
both.  And the host now stays SHOST_RUNNING until the end, so a device
added by a late scan would miss the cache sync.  Its commands fail with
DID_NO_CONNECT, so that is a lost sync, not a crash.

v1: https://lore.kernel.org/linux-rdma/20260812190418.200337-1-yhlee@isslab.korea.ac.kr/

Bart Van Assche (1):
  RDMA/srp: Fix srp_remove_target()

Yehyeong Lee (1):
  RDMA/srp: fix use-after-free of a request in srp_destroy_qp()

 drivers/infiniband/ulp/srp/ib_srp.c | 30 +++++++++++++++++------------
 drivers/infiniband/ulp/srp/ib_srp.h |  8 +++++++-
 2 files changed, 25 insertions(+), 13 deletions(-)

-- 
2.43.0

