Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795085603;
	b=aQVxPFM7QtmcE8sp1vWjRjFKccXm/r7QJFqBFEyZPIBak092vVTOBbXOukNTWQo/RBFc
	 hnIDNAcRCApYo+9jpHDM0wzbUXuMxAjYD2W5ofKA2Pt+MvHZh+S+dic6zsREDvL1S6q2Z
	 BRBbk4rjLP51ozW83vDn5kqaZvY6KeDwaZvadUPpKPxDTNSUqZZmksfP2IVwhJ4klSAo3
	 hvHbQ0wTHc4DWwnfL3En9z4SuQlV9NSuJOGy1gUDRdgki0ajOqgVP4QM4PYyBWz6extGV
	 YrXBork7utArRdeUfHahqXbSnRsY7HK6nfm03XLLxjiv7ouJgbBYlLi+UZbSkb9heAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795085603;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=u82m5XYfOkixN+Gu4sy3x8jwpD0ueQ6BxZtFc7iLOis=;
	b=xd/VhQ5iA4K2/eTtR31qucHS5JWTSXO0/VktKfbYbwGkdMDxAhXb1dYqEIVplR0bLQOe
	 Z7lNlaNB8dhq9xSQqAR1vKeNqBHVPL8nraUOFamZToi9kRJ3paQOgGy5C4pv2i7N7MI2N
	 VhfZfGJoMZtIYN5z4fJJ36Kyx7STnFpPX357JzXCd/gtlOXDhL03JtvXaxQjXH228Q4LH
	 7b7nzm2JrmEidAYz8dBbW3kaM7oxeqeYD4XxgAuX48FCzJj9yMTI9V8zVqDU1iqNX/G81
	 n6X/DESwjYHr+pPJGmHqZkjxpk3fBP00CdYstV67I31DSZOGQPQEJncJhcV5U0FgQXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=iQ6rUIIV;
	arc=none smtp.remote-ip=209.85.216.52
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15F09606A32F
	for <linux-rdma@vger.kernel.org>; Thu, 19 Nov 2026 10:53:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 15F09606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=iQ6rUIIV
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-3b405d8f1cfso214529a91.3
        for <linux-rdma@vger.kernel.org>; Thu, 19 Nov 2026 02:53:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795085602; x=1795690402; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=u82m5XYfOkixN+Gu4sy3x8jwpD0ueQ6BxZtFc7iLOis=;
        b=iQ6rUIIV7M0UsUNIRA6NKN+GN+fSa8/ME/likVRUE5Bdb5g7Llp4kUXaNoFBFNOhBu
         F4l18R77EQ4LI3ORH9xbQFWnh3o6HuJKmiN0ciN6PEOTrv1IRf18GHrX2bRj/lKoek7t
         hmNB/zpCbM49xuUBktNQrmcoJ5zqomNzHzsqXTLF2iBDCAP6nsSVdeGU7R0jmF2GSPhS
         dA9NJl+y+nu6Ad8KkMo+5eCE9mSYpFxcvJTBEnQ55zbs6Y9UuJrshRrWTCo1cQhOwY1E
         z5WVZg6ZJLHx7WbdXSp0e5YnIwhwyAwlkQO8deuDe0o32wdEcvaysTjliRP98bQgfJOf
         4VuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795085602; x=1795690402;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=u82m5XYfOkixN+Gu4sy3x8jwpD0ueQ6BxZtFc7iLOis=;
        b=g6JO7MfCSWfgbxPUQCAPG4RzJdo0GO3nNohiIkB5h6baF3E3fxEDpm6VOoBpmx31rA
         qKDK+RhUg29C67ShHUAvPvXWbHD6/vlcPH6nRnUsdWh1hE0/8K2mW3Y0fl1JkjqCpkF4
         itLPuNvbVQSQkPHNZRZh5q+z/SGiuGC01TRplxxJflWWGs0u2RnZ4BCKhi5Ix613sCJ3
         B7x83i4RiVM2ePeVT6KKYplb3KV89qCoMSjwSl5Zfx5vvzqM/TBCQPznVSAvF8v+iQFP
         0v1aJ/L3qG8gu6/Zv1qhuy4iOtv3LW8PYRuaVsFWkR7oNCZlNhh9ODVxxbjFqjRizBOv
         VweA==
X-Forwarded-Encrypted: i=1; AL+hErFubpjGjVkVL1F3afOOwYgxnzZeQWJDPf/ibnv32eAcGrG5Zi0cdIbqlqPk9qv3OwDd5FwAFH1is2CK@vger.kernel.org
X-Gm-Message-State: APuU4Z9u/Vxd66NLfPruWZAa8VXVpqQ0u0okySEw58QVAfL98vOYsf4N
	ivTQRK3i4M5+B0kI6gNNlMrpJXTbPj0UhhozOjLlTeul4KqOCBlmbhE0qBPbXasowMo=
X-Gm-Gg: AZFdTZf6zk5qF3qXbL2LT5D54rsgYdjgPGIWAl6Ft6dSUzbWmqOeEzaXMxsXzdC+nSZ
	8qag/KR1Q8+BKJ7MNRsqzWHkmYkm/xWTkOCc56fsId4m0Rp3nboTdBL37Lo08NZ5kOA6EKTsBt/
	68QKfmleTgb9XHEwoQSFgvY4WStqNWOAGvIy7NxV0AWWl+zNx5FnRAlqTcqOkOj8dkjpk2FuI4s
	5eDBEGLDTQZDSybeNrzYTVelR3zbvynUfYnvk0QZJTVI8rsodS6yt7U5Svialr+vkidgtUk0llG
	2sFPuj1wPo9Fxo2Xj5JHN6G/95GnpLSLQp63ppPB5luieq2UqxdI7n85tjxKQP3qB7RR+JobL43
	92/yCpC4UaNFsQyOXtEdzF0TEHv3Cmmwrc56oEoRPIfoo0VEFrLz4k02vVwkJFCcpkkveXzGArV
	DLvLSsFdqYMJJ9UxIMHCcP0OINEObcNEs7EVK6uufnHadWWeck1LVZYBqZOiYodqCGxfKlJx5fD
	5e3AGQKINDcm3X8ZAU/a8PbwycedgdOOmDFCiv/q7dz8LnvsvNQs+ZnGYsMhYtMu0Ip2fC2rX9U
	LYLofTKA4En3gGp0KW3Gq8RwBcVAoDokoSz/FZ7y+FtkmxGzXaS6Ip2S97sYdVTCUE6oQ5xBM1N
	3dL1G0qSRai/FNRI/kz0xe6GNVUDNCGmKR0pLKA==
X-Received: by 2002:a17:90b:4fc6:b0:3ac:7e3a:1033 with SMTP id 98e67ed59e1d1-3b3d07d9ff7mr5928287a91.59.1795085602395;
        Thu, 19 Nov 2026 02:53:22 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:e78e:f7f0:2120:34e7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b405d639fdsm2246604a91.10.2026.11.19.02.53.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 02:53:21 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: alibuda@linux.alibaba.com,
	dust.li@linux.alibaba.com,
	sidraya@linux.ibm.com,
	mjambigi@linux.ibm.com
Cc: tonylu@linux.alibaba.com,
	guwen@linux.alibaba.com,
	guangguan.wang@linux.alibaba.com,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v7 2/3] net/smc: bound the peer rkey counts in SMC-Rv2 LLC messages
Date: Thu, 19 Nov 2026 19:53:08 +0900
Message-ID: <20261119105308.2567241-2-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260820023347.9D5461F00A3D@smtp.kernel.org>
References: <20260819023306.644849-1-yhlee@isslab.korea.ac.kr> <20260819023306.644849-3-yhlee@isslab.korea.ac.kr> <20260820023347.9D5461F00A3D@smtp.kernel.org>
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

Three of the points above are about code this series did not add.  Where
they stand on current mainline:

- The memcpy() into lgr->wr_rx_buf_v2 is gone.  3/3 made
  smc_llc_rmt_delete_rkey() read the queue entry instead, and nothing on
  the CPU writes to that buffer any more.

- The v2 spillover buffer is still shared by every receive WR of the
  link group.  3/3 narrowed the window to the copy in
  smc_llc_rx_handler(), but if two LLC messages with extensions arrive
  before the receive tasklet runs, the first one's tail can already be
  overwritten by the second when it is copied.  The result is the wrong
  rkeys being processed for the same peer; the copy stays inside the
  8 KiB buffer.  Closing it needs a spillover buffer per WR or per link,
  which gives back the memory 27ef6a9981fe saved, so I am leaving that
  decision to you.

- smc_rtoken_delete() runs without rmbs_lock, and so do smc_rtoken_add()
  and smc_rtoken_set2() in smc_llc_rmt_conf_rkey() and smc_rtoken_add()
  on the CLC path; only the three smc_rtoken_set() callers take it.  As
  far as I can tell from smc_llc_flow_start(), a remote DELETE_RKEY flow
  is not held back by a local ADD_LINK flow, so it can clear an rtoken
  slot while smc_llc_save_add_link_rkeys() is filling that table.  The
  rtokens are a fixed array, so this ends in a lost or mismatched rkey
  rather than a memory error.  Taking the lock in the LLC event path is
  not a one-line change either: smc_llc_cli_rkey_exchange() and
  smc_llc_srv_rkey_exchange() hold it for writing across smc_llc_wait().

Best regards,
Yehyeong Lee
