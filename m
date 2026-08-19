Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBF90392C3D
	for <linux-rdma@vger.kernel.org>; Wed, 19 Aug 2026 02:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787106801; cv=none; b=axU7nxgs6DwFPu+JSOKUl7hGRL2fm5wqkQUicS45DFkfSvt+6+vSjRALKgGSM3kIPmKZ+rqdmgwvUe64ThTis8DDeBWRSUyalhnkVynv2XylN2sNcBG0IDm8Ed0Qkp8hVtDVrAHViuM3rOKzRUlonGo2fulrwECxZP3stNfoQ7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787106801; c=relaxed/simple;
	bh=KbiaYdST825OypEoV7XDa2SfQ25BArmjG8UWZpsc8wE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oQfqyksuLXCEiR3FRfwEBjRAlNmRF3PWk/q+QEm9M2OWC9Jfuc0/+w1hGVqWcBRh6nVeaB/GvYL11ed801uBX9F+GnvEhN4YtUplBXtRM290hpwnh21Y4g7GBl3smj1YbS6c6ouDMQ5C9LuoI6WNx6W8gM3Ydbrn9TukH6V6VMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=OalL/Zzb; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="OalL/Zzb"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-38e07ebd263so436319a91.1
        for <linux-rdma@vger.kernel.org>; Tue, 18 Aug 2026 19:33:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1787106799; x=1787711599; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=hgYieFKziqFiGeOaqNKzx6X27Iiom9cGSOGSf1oWB94=;
        b=OalL/ZzbEQ8h8NLaW8PHeu+f08u50MSzBjnDN1shqp1cL/4Z6bhPf+BBBh96YLGNuR
         +5Y5q5KBk7lT8oYqDkhLkKTAjofnelXfy1e9YVee0+ONSaPSbQyhJetNNr7ESKRyQ93f
         2qgQ8gFummxVxm4gf27p66VSxPO81DEOrKRqekvLlo8V01x34QJtRCeOHCj2GBMExc2O
         gacisGsQ5WpDQ1B2mKX98AA0raOloVvum7c2m6md3rs8QtMnwU15/mEY26Js0WDPh3QJ
         DYaTl9XxD7b0Rde53Ekt9krbx9quWY6OPeuo/EQSjoxwg4XcR/2YMi7mVZ3mQqOJames
         JIYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787106799; x=1787711599;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hgYieFKziqFiGeOaqNKzx6X27Iiom9cGSOGSf1oWB94=;
        b=P9DlaG17S3ExYtK0iLAX9HYdcQ9bhZJDSFjROHB07LoOQXK1VxNxUVzRg1BrAvqzk7
         9dgbWgHuoRfTPXXHnVbbanQqP51pufkTkLkHGOYASY8sxHbe8rN1iwZCZ6/Dleg/sXCb
         FbYG7aVUhYHP8aimXur2z5Y+xrsi1QzI/BGMI/x2EnmzLIwh+c3T6l3KK5Nu+RTuZixZ
         Qd1okiJpcWSrHmyf84NPFPW37k7wftysrpqXNGCnyCwaXsOj69CYM9u4J/BWOACeolA3
         fW81hIWAZcPNMHJd3jRis/E4hiXiOOW6VqDbfAgMukWRD984oln61UkNCv160joGJp4W
         tySg==
X-Forwarded-Encrypted: i=1; AHgh+RrxOD3dahVVC4ato1oqzBhXj9GdUNqCwBHmiLhHsFf1BjbMlBubRjYNZzY5eBX0cg9Qhf2EBZFyTCMx@vger.kernel.org
X-Gm-Message-State: AOJu0YwiGl6aqjxXDBCwz6HLTymNOYcQkdI56kEd6fo+zvHrioYCZ5rQ
	Bl5qocqJsisMCWOkuoVd0gZPEN/OdgBf+0QJ6ahZrR4SV88DSoObMnxlpVfZmgXs33w=
X-Gm-Gg: AR+sD13KJlbfUekPpKtr5DJnVN/+26LLuPPZP082LHXSmK4ZdQkGwEPxzj2/Q0r1mTR
	/xVrfn9NSvBEMH/DxucNMg5+BXMzi4REJ9QIAOIxphOACphcAE74LJa+7tIwWi4wSYghWzEG7Ub
	KluStYE5pKOFkiDEQL8EM4/lyVVn5rT0zuDCPy0lDyn1lP8IP1LuYAJUsdz8pPn+fM8AS2tlBPF
	/DhMX/JZ3wa6mVuc7sx/bDBopwh33f7ck0sfS1XrrjLZq/+83tFobcAsDH8Xs7HnOlQZ+O+Kvps
	RxyoXwxHn4pDDGSRWE9GgibhTjcVVfY5gOY+QM7CyFzjFkfgnGXMUDyeA0bSxOoysrX+QvgR9Ft
	PiEm0HN3gddk7omHz3k1v40OAT2VMDMLHqMBf/HN23P/z5xgwrZS9LP2sh1CbQRMGGlIxZpaMEv
	KEBLFk5CPm1hubEdphbqRsMl+5nVkyvHB/C79O/xMOPRSObGoYWBPw/r8wFQYiYOyJKmdA
X-Received: by 2002:a17:90b:4488:b0:38e:250b:122f with SMTP id 98e67ed59e1d1-395810f21dbmr2355384a91.16.1787106799073;
        Tue, 18 Aug 2026 19:33:19 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3957f9aaa12sm786281a91.5.2026.08.18.19.33.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 19:33:18 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: alibuda@linux.alibaba.com,
	dust.li@linux.alibaba.com,
	sidraya@linux.ibm.com,
	wenjia@linux.ibm.com,
	kuba@kernel.org,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com
Cc: leitao@debian.org,
	horms@kernel.org,
	mjambigi@linux.ibm.com,
	tonylu@linux.alibaba.com,
	guwen@linux.alibaba.com,
	guangguan.wang@linux.alibaba.com,
	kees@kernel.org,
	gustavoars@kernel.org,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Subject: [PATCH net v7 0/3] net/smc: fix out-of-bounds and use-after-free in SMC-Rv2 LLC processing
Date: Wed, 19 Aug 2026 11:33:03 +0900
Message-ID: <20260819023306.644849-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Patch 1 fixes a use-after-free of the LLC queue entry in
smc_llc_srv_add_link(), patch 2 bounds the peer's rkey counts, and patch 3
carries the tail of an oversized v2 message in the queue entry so that both
readers are bounded by what arrived. All three are tagged for stable: a
tree that takes 1 and 2 without 3 still deletes rkeys read from whatever an
earlier message left in the shared receive buffer.

Changes since v6:
 - collected Sidraya Jayagond's Reviewed-by on all three patches.
 - removed the extra spaces after sentence-ending punctuation in the
   commit messages, the notes and this letter. No functional change;
   the three trees are identical to v6.

Changes since v5:
 - 1/3: leave through the existing exit label instead of repeating the two
   kfree()s (Breno Leitao). The object code is unchanged.
 - 3/3: add the Fixes: and Cc: stable tags (Simon Horman).
 - 3/3: assert that the two DELETE_RKEY_V2 layouts agree on the offset of
   rkey[], since the parsing code indexes one and the existing assert
   constrains the other.
 - 3/3: limit the copied tail to the largest one either reader can use,
   so the size of the queue entry is not chosen by the peer.
 - 3/3: the comment in smc_wr_init_sge() described the memcpy() this patch
   removes; correct it.

Yehyeong Lee (3):
  net/smc: fix use-after-free of the LLC qentry in
    smc_llc_srv_add_link()
  net/smc: bound the peer rkey counts in SMC-Rv2 LLC messages
  net/smc: carry oversized SMC-Rv2 LLC messages in the queue entry

---
v6: https://lore.kernel.org/netdev/20260811231902.47089-1-yhlee@isslab.korea.ac.kr/
v5: https://lore.kernel.org/netdev/20260801094208.1937951-1-yhlee@isslab.korea.ac.kr/

 net/smc/smc_llc.c | 122 ++++++++++++++++++++++++++++++++++++----------
 net/smc/smc_wr.c  |   6 +--
 2 files changed, 98 insertions(+), 30 deletions(-)

-- 
2.43.0

