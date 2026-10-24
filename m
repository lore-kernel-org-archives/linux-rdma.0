Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792859349;
	b=AvFNEUCCmO/xE7gU9DkiRlufhuS6xrVvf/drWCQso+yPNU4nzLl2u0dpol06oWnf+2ea
	 baMb4u7C/+3zyXyWcdVATgvyLPCWmRvivQA2hQdiWZAbxL2mzu2MFua1Zp8rc0feQKyk0
	 vAgM7lPo03rlMxjhl83+d3TLUq/8Y8TBCfVube8bZdkAURO7RsxSEZv+3NGd66aQMfsCP
	 NOSjYpkkRtaluVas0RZG4G6uIHhvTSXrt3GMEoE3ZOe6n+qM3//1qaqGnypvCkbhtwKPe
	 TvKXxqnrM7fDCCWq12/6rA8JoK+w9RSxcA/SV5nF0NS3E2yjoLU6Hmu23vF39qP0iWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792859349;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=llsgWckxU6HrF1Oq7gERdngWWd2BM5NRfeUcsEwDim4=;
	b=gmlEMm8Vn18+Y+ng18qc7duPfHy62QxDx05j8ZFZ8rG/47qSo5OFw6N+hxCpB9OaqGAn
	 CU9VjucNCatgxDKdUNmFeObG7u+mUUCNdybdp9UVbHThJPDHAGaB6oh8DWLnnTBb4VXzv
	 uyQWTYSx1w67WBavu5hICn1VGo0Vr9nJONj5boZ7ZfaD2s56po8CMfuTfMOgE05QPsCgD
	 I+/mMw/CXuDCkxJ12mERXyuihJDTlO8CSdRFqNfM928reyFUuzqvvboYjdiBt3GhxyCHt
	 N0oxGBdJ1h2I5u3+fHcqXRYGdeetsvUSkAaOFpLc9lmWtSB+GXj6QiWd//YMONW5kTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=Nmqafhes;
	arc=none smtp.remote-ip=74.125.82.53
Received: from mail-dl1-f53.google.com (mail-dl1-f53.google.com [74.125.82.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DBD8606A31A
	for <linux-rdma@vger.kernel.org>; Sat, 24 Oct 2026 16:29:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6DBD8606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=Nmqafhes
Received: by mail-dl1-f53.google.com with SMTP id a92af1059eb24-15943c9c005so2432384c88.1
        for <linux-rdma@vger.kernel.org>; Sat, 24 Oct 2026 09:29:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792859347; x=1793464147; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=llsgWckxU6HrF1Oq7gERdngWWd2BM5NRfeUcsEwDim4=;
        b=NmqafheshdwPak0EWBNwAofN8AZNgmQptxYh3iGuiskd4q9UV02Q5UGh/oeX7f6FAP
         hsww53lS37P3JAtMBHk1Ke30ZUyjQ970syUPgtgen7abOm3OdBvvHzNhQeSS8thBBjN2
         SC3HNizvps20P1by+xoZcccTn9VK6mlBWX86kM9SgLixrnZqkm2a15VPLsC1r5akYpOd
         GbFtf6SAKcIIaCFJLHlyrXE7eppDpukU3KNhEmWL7AFobu0iXnIDJT2TSN8h/2LThiu3
         chbxN23xEius6S8t10nOzv38wj/umbcr/Gbh4ewd8+Qxc1HolXYT5oZhHgwwouOLAZCq
         SWFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792859347; x=1793464147;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=llsgWckxU6HrF1Oq7gERdngWWd2BM5NRfeUcsEwDim4=;
        b=Qxgvkll5r7/7mbraDasvXj76zwQm4Jn08rtJHysd7jL+iq39n0sJT1C7fAVFiPXilW
         qBafEM4TX242s4epgPJmkTVDW3eE+yYYhGmr/twxCbE7TiITxiet44LyhMR53dzFPOSi
         wAvOP8u/ApUCSI1ce+9mtbdHwxxP2vgkOr4kRg3Dxzpl3qcHXLHMReRnpwfkA0nryFi/
         iIbXhBiZR3K1OYg9RwaCQxr2H1F/2lbYfQ0MZKBd13OHwEqFsEhaT2VddukLC66BBNRU
         00seAG4JVOODJdRfGf2QL39h2zQG8ujEOMyUyvWjl5OvSF4Z/MqH8l77V6gjfJOD9QBo
         aQgA==
X-Forwarded-Encrypted: i=1; AKwUvByD1TOnpO9QTrAVp4qNVMb9ucNoU+lNX4W3GjNB8EyrNEIgpWrWmPHCSEclldwiJnwk03YbuNHwZmA7@vger.kernel.org
X-Gm-Message-State: AFq9FYKalbHvKEpb4AIplRl34NRRon8o6PupfeCiRuedRjYtFw7pcFpr
	Bq+no8sLpQwgxvK2CU+3cIQIPmE5sMXKv+Glb0c9q9o2/pCR6EHt+lHPZelTb6vvp10=
X-Gm-Gg: AYBFou0gDA/Oa948APXFz+dFYsPM9bk3g1Q0GG2GjfWzkjEedFhc1R4LfjviRLfFvdm
	nfKijpk3xK9i4WG9c3GtJFbOoyiGpkL3jXmlwrfcThbT2ceqieWftTpwKPX8hWECI8DfrddQ9Ua
	mbQ1nntw/K9Sa1lvB3nK1S9rgFAo5nVuQHEOZOtaEnxgLaeTxlob7F5W0PkFMQFA4k6tSRbHTAZ
	9Y6MH8Lq7wIqnpHei/KY6Dl5Ukac6ChENemSTlm+et6glYdXhrIBIDGz89vPVR6IywYhSiSUPYI
	qUUcvhbVvnbUqIUH9GKLcKC4dP/2AaCFmxdPCssOJx8JdNShRz99oZ8gzc169BFZpldIKX5OiR6
	tLaGva29Te9qt8J42Sy66JpvVRwM364WDAM66GfkeOt/ZJLu+1gp4kGFXZ6sUxLvlNSPJu5cmJr
	Eb1eAhCKP+CSPS9JlUhoiWEvjvYgmDd68krugPscXEDxjpjHNGqa1eKb8Z688qLxyVd2e5gBnEA
	hxv56hXi8Mh9qHzD186z//0b4RXgTSaIXY/wi8c0LSPZCt0dWD1R3wQH8qTBVEMKvrVEY4Qp6oc
	XBvklMS5kZKXo6igsbQOBw06bFmtP9oYToyK9vBHrpWl5BhKSicet1cld+phJTZ8
X-Received: by 2002:a05:7022:220f:b0:14c:aaa0:941c with SMTP id a92af1059eb24-1993fba154cmr5334530c88.35.1792859347154;
        Sat, 24 Oct 2026 09:29:07 -0700 (PDT)
Received: from localhost.localdomain ([2406:5900:1044:110c:dba3:be57:a674:a67f])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-19a3736d16fsm7192350c88.12.2026.10.24.09.29.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2026 09:29:06 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v4 0/2] RDMA/srpt: fix the indirect descriptor table bound and the context counters
Date: Sun, 25 Oct 2026 01:28:50 +0900
Message-ID: <20261024162852.3528224-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
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

Both changes are needed, and they fix different things.

A 510 entry table fits in the default 8276 byte IU when the additional CDB
is empty, so the bound accepts it and the counters then have to hold it.
With only the bound, a conforming command carrying 256 or more descriptors
still wraps n_rw_ctx and leaks every context it allocated. With only the
wider counters, a command that sets ADDITIONAL CDB LENGTH to its maximum
still walks a descriptor table that runs past the receive buffer.

The two defects also come from different commits, which is why they are
split here.

Changes since v3, both from the review of 1/2.

desc_off is a uintptr_t subtraction now, as Bart asked.

The room check is gone. It divided the bytes left after the header by the
descriptor size, and the division truncates toward zero, so a byte_len one
to fifteen bytes short of the header gave room zero rather than negative.
A table_desc.len below one descriptor gives nbufs zero at the same time, so
nbufs > room was false and a truncated request was accepted. That is
Sashiko's [Medium], and the v3 commit message claimed the opposite. v4
compares the span the table occupies against byte_len directly, which needs
no division and no sign, and the wrong paragraph is gone.

2/2 is unchanged. Bart asked why int rather than an unsigned type. The
values are counts and never negative, so unsigned fits, but
rdma_rw_ctx_init() returns int and the WARN_ON(ioctx->n_rdma <= 0) in
srpt_rdma_read_done() is a signed test, so int leaves the surrounding code
alone. I am happy to make both unsigned int and turn that test into == 0
instead.

Link: https://lore.kernel.org/linux-rdma/20261022143901.2991062-1-yhlee@isslab.korea.ac.kr

Yehyeong Lee (2):
  RDMA/srpt: bound the indirect descriptor table to the IU
  RDMA/srpt: widen the indirect RDMA context counters

 drivers/infiniband/ulp/srpt/ib_srpt.c | 11 ++++++++++-
 drivers/infiniband/ulp/srpt/ib_srpt.h |  4 ++--
 2 files changed, 12 insertions(+), 3 deletions(-)


base-commit: 5b0764a53235d3c77e1ed674e836e1b3fe1a4b1f
-- 
2.43.0

