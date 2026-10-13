Received: from mail-pg1-f227.google.com (mail-pg1-f227.google.com [209.85.215.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D6733905F0
	for <linux-rdma@vger.kernel.org>; Tue, 13 Oct 2026 08:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791881018; cv=none; b=Y1BxQsnGj7Rk4WR5gNjG7JzZBpyHlcCOFyQdAZvliHGxDktZu/qEQr3Y6r6tqwtHjHGF0Rdy7pGbzbJm+olPg6R8QXAo9fP2YTCFlzAo/icpybisS6RWQNu4xMHOYiNmzziDyR465U9tFfeiSg2Z2zQqW3s5ekQbA6rxi2jXKJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791881018; c=relaxed/simple;
	bh=Lda77e22lvxXn8FBwq4rOKsKDrffQjDQgr/O4joee+8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=SuEyBniFzq65Z43uwUnDjQqy7CZWBQP5m7Hadq0ys8KnSREY7vDnj2TAJEK6cK2PBvVIaNqZiQFdK/I/ULoOZFWNLIeTVZ15ytFuxt1mFVoB3uHseO6UjeKVIs4+1PYgOZY1y3QdIKpjjoqOae+LES4Cl+FtiFnGif4NUe+gNaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=LZf9GIup; arc=none smtp.client-ip=209.85.215.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="LZf9GIup"
Received: by mail-pg1-f227.google.com with SMTP id 41be03b00d2f7-cc7d154ec4fso933983a12.0
        for <linux-rdma@vger.kernel.org>; Tue, 13 Oct 2026 01:43:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791881016; x=1792485816;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=HRRFUiA40QiuWF5Jp7a03VWk4jRPS9aV1/E8o9K4VMw=;
        b=ZEF+z3vxZnqRXgmmZXH08Oey/yuuS+HCBIvHgegjXy8OAwNgdbLVxs4l2G+0JOdQVM
         Nh3wvRpMH48cHAajUn9DYSqFBCXUR4A+GNzQl6HiQAxmDg7xaykDMU+aLrPSz+0OfADG
         4VwogP2vIrJ+/lzGnpm2SdazclRF6KFUp00d4m12eKwpRS/7bN/dC952iHxiKbmuzeMy
         lZfU/ynlkkG3piV9JkXDk1GdBI9Hw+8U3Qus4Qri7Dqijbom9sX3wvzQEhrblkO7rd9L
         GwJHlxHEIjOgCrkzWFQctiqQhYtp86MZ5/DT+VnPe9DGVxhE7ikjbW8LHQGDKSSmj9Hv
         /1SQ==
X-Gm-Message-State: AFq9FYLhhrXvGn0LKROiiLclfIiVPc7ImXscl/CgnM+Fj7/NOUrWWtKq
	dwilR2OYSwnG3R/EMe/l+zt1v9kAsOuE9HGWVqkyFw2xlmG4hkG/K77LazbV4iEzBl/FQhUIQOk
	A6DVlPYLbEvWlKAngXMS4WR7zoeCGeUGDiHla5/S7xEbnFaPVFFz+f1cL8vzhS/Q+tXnWIKUQ7u
	up3PbVPWf8wlvxt/odeOkrEM7A3qINWoLe2hLkxbxNNJGDCB4jy20nh11wZzbql4/0ROzBg6CAK
	njxZgXUN1i4l7EpIg==
X-Gm-Gg: AYBFou01UgjEHeFo93xiO/eSW0jpXs1CFh6iCXqoxTLIiK80YgEiaxn1nRb7jDi9wVW
	D2BN/wTOGd4R17VebifNkCMRdWdSeW9ceBBxUk1WvcJVa7ICTGdbInRUvX4L/iKrJzUFqqJ3G47
	opsoJQqpu4SB8x8nVE1ftGBcH9GNmYjlW2aCo2B6p2bicjk4jDCvNJKvjg0k4OKiiNWiH086qHf
	rbK981lOJ/LnTMM9KuS9LaucVCGZ8dHZtsrSP1AE6p2PZNFkpbkoy/X+OujZphIdgLjyof5VVe0
	nMVZHRpos3u85cY9DqK0txnV7xKOxkFamXzsQ5rR4E7Im+h+/vj1u7/yXE8cIlLTDj6FUQ2Yrmz
	/rvlPT9KAry9Xswnr55TuAX6Xrcfb2Edt7YVMZXM2X+Mftsu8e6x0OLW0W8LqEQWw7JrKioCzni
	YyNqaGU8HQUVxR21QgguW7DPkiRckZ//Tz25hZSJw=
X-Received: by 2002:a17:90b:3b90:b0:3ac:17c:6e72 with SMTP id 98e67ed59e1d1-3ac017c6fc4mr4471635a91.11.1791881016348;
        Tue, 13 Oct 2026 01:43:36 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-125.dlp.protect.broadcom.com. [144.49.247.125])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3ab3780aac3sm7051508a91.3.2026.10.13.01.43.35
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Oct 2026 01:43:36 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dl1-f71.google.com with SMTP id a92af1059eb24-151ba226e1bso2632300c88.0
        for <linux-rdma@vger.kernel.org>; Tue, 13 Oct 2026 01:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1791881015; x=1792485815; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=HRRFUiA40QiuWF5Jp7a03VWk4jRPS9aV1/E8o9K4VMw=;
        b=LZf9GIupMXJIMXWc2CmUwIXMtXv4NsNMo59RaeeCcolz9hIqn+vkJGxMhdrX/thRgq
         E/8W45+cuMZNyVzqkxW8Cd7/KWNER0s6u2WWdfC2c3bQIYRNyA3rZ6b+wHDn/IB0KUi3
         iFBQsYPd0u+Lu8DjVgr2BX9ilecsoDq38UsEo=
X-Received: by 2002:a05:7022:28f:b0:14f:99a2:1715 with SMTP id a92af1059eb24-16a612bc067mr18426584c88.39.1791881014570;
        Tue, 13 Oct 2026 01:43:34 -0700 (PDT)
X-Received: by 2002:a05:7022:28f:b0:14f:99a2:1715 with SMTP id a92af1059eb24-16a612bc067mr18426537c88.39.1791881013635;
        Tue, 13 Oct 2026 01:43:33 -0700 (PDT)
Received: from dhcp-10-123-156-114.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1698de65af7sm40209556c88.0.2026.10.13.01.43.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 01:43:33 -0700 (PDT)
From: Selvin Xavier <selvin.xavier@broadcom.com>
To: leon@kernel.org,
	jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com,
	kalesh-anakkur.purayil@broadcom.com,
	Selvin Xavier <selvin.xavier@broadcom.com>
Subject: [PATCH for-rc 0/2] RDMA/bnxt_re: Fix QP table fixes
Date: Tue, 13 Oct 2026 07:04:25 -0700
Message-Id: <20261013140427.256612-1-selvin.xavier@broadcom.com>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

This series fixes couple issues with the QP table
allocation/teardown.

Please review and apply

Thanks,
Selvin Xavier

Abhishek Mohapatra (1):
  RDMA/bnxt_re: Use kvzalloc for QP table allocation

Selvin Xavier (1):
  RDMA/bnxt_re: Unpublish QP table before freeing it

 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c |  4 ++++
 drivers/infiniband/hw/bnxt_re/qplib_res.c  | 14 +++++++++++---
 2 files changed, 15 insertions(+), 3 deletions(-)

-- 
2.39.3

