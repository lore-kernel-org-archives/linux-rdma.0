Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 374A72E7F3A
	for <linux-rdma@vger.kernel.org>; Fri, 31 Jul 2026 07:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785481528; cv=none; b=AY72JFjknTZZyxRUmWuMAkxalVO5hf/acx+2XwHGoCXMb31OiUNLQZ4K7SgON8ZqybiOxBJAP09d8fSvEyaqFlpj2bOEUhqB79orJwgxR3b1yn9v96jsu7cf4QOjeNr+GfAsQykIxKOrLo426ebtUeeenbUJr+14ngkuwuagOQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785481528; c=relaxed/simple;
	bh=NqOoRdyRQwEnHaciOW1Lo15WOzVkPW8i+CqT++jomdk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KGdwvtkpqJP81jF4bJCeX7mNx+yzIsXcR1CXsJtHwPO92832I/1SAj2BNSlM41UTuCNHPynNCH9wBKKbnqDBboH3s0ddOuPZUH4RRJKVJiTxFcBISMUQiLwdxKElO2bdc06e9Bie2p4EiSJpoUaNtZCy+BDEC6z2uK38Vl4pevk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=c0GuwMPd; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="c0GuwMPd"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-848743155bcso341606b3a.0
        for <linux-rdma@vger.kernel.org>; Fri, 31 Jul 2026 00:05:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1785481524; x=1786086324; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=MXV9qH7UyhntE49tPsJBkiOVAaJG6JngpHeIAflWXR4=;
        b=c0GuwMPdOzqJUAGYdqnoaooYfpNFhiXhzAtOfICyJYNDQ0N9GjM/XAyjhTCF9HuiCe
         RYDC1I5LShs4tKGl9fMRjq0JQxROozcHjbT0gQKIi4GeHo1k7IT4N1Wif8CrzqmoaSgw
         lzf0KoAO3KpFlhOyK3gmptoTwOMyR7v2DOXyLS+tDG6KrUZLC86Kh4gry1FEq6gt4HKi
         qZi2cWJcgDtZVKDcueW91EWq8PYtjDkBoRYi8l+M4D0Sd0gODHh9UkGsGAhNBn9jtFpP
         Hgi8sgqDJpVT0Ms45t+OTAcI/RqVnZXZm30rfjIc+LeBPwUZrG/+nu2K5PMZOW5B7i2i
         TRwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785481524; x=1786086324;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MXV9qH7UyhntE49tPsJBkiOVAaJG6JngpHeIAflWXR4=;
        b=k5xjXC3Tsn/yQOEya9VhNjxsHuClqc1rDNGQ89XSR/2/4I3hAr/4ucX1C7c1XnTg0I
         Bo0WhtAEI+wPNOb80hulKvUNEyuPcWCq9J0Q/Dd4hN8rOci8AGlgrMNOcch41VIKJk1i
         9XizA/30g+oRP12P60PpWggWCkSL7VA1fOoMJ49ri4g1Fc0blyKeVZHh4w4P06gLm2jk
         I6lytS5WysF5zhA1GVvxEdGUZx9Q77nCucXA7p2JMD+Ofhx2YbVhcAWmBbZ0D6bJ37z3
         C+3lFNg1y8S+JniWXrCmDUaWPMQTcOJwKaqXGGHYtCMNdYtr3WVunjcQKEGef7+mzS6a
         1ZQw==
X-Forwarded-Encrypted: i=1; AHgh+Rp5xmDQ9e3W7s9aOQ/kaqoUrCFL9CScT6iA20YdGzMsQUi1YfxPIPIcJx4omH0XdY5CI/DTbexvjBZe@vger.kernel.org
X-Gm-Message-State: AOJu0YzbS7luAX4bt2ejCh7pxmuaE0tFXrhSKnL//KEETnEw+rsYGGyu
	yr/u+xvieb8YbJclJ9r5GuuMAh/66J8FShpH3a+BaB+2OqW+V0PD+pWOB2XbFFnfr5w=
X-Gm-Gg: AR+sD12XzaWnf1zb21rkUUH1mZRTnX3l/V7rQe2HcR7QvIJe6AdRvpP/bl+lpjUpCEf
	XWt5slfDV+FCixJ6uj1bI19FLbYITubBeHIT6KUKRE/iau4/tcalA95ioXI4E5j4wM4nPViar6P
	tjYqWNEJubTqxooHlaxLB2+Oo68XMyAhYsGN0PCJZQpIKXz+UmTi1Wq4WIp+Ir3RTLEXCCGAGMb
	UnHLmdEq1rPQom11wdSaS9Uj6Dt53D2lzMYAFjNxkYsGxz+Pd9rpB7MnUJOYWHjZ0PUCxnfzfwa
	RQj1j+Wxmq3AstDTSb/EHaDAqF2hGkfoy9GXbzUEn60FwIEkaGSVp9fXNKOtmJgP5QB/d9Y39ZF
	w5lxJ4HrDLSKFOSXdkXsIr0oTRrHuXxBESpuUo/2xrSrXUGsgACme88+ym3oWU3xYgCpfHjMIqD
	I7tfhF0m1XC6omhga+TJd7Ovo/SSwwntU2blSJRJi2JMN13XJC5oooD1+lAnhipSee2jJH
X-Received: by 2002:a05:6a00:3e1e:b0:848:5935:2e11 with SMTP id d2e1a72fcca58-84ed7266716mr671512b3a.48.1785481524374;
        Fri, 31 Jul 2026 00:05:24 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84edc2d4473sm39233b3a.40.2026.07.31.00.05.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 00:05:24 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: alibuda@linux.alibaba.com,
	dust.li@linux.alibaba.com,
	sidraya@linux.ibm.com,
	wenjia@linux.ibm.com,
	kuba@kernel.org,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com
Cc: horms@kernel.org,
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
Subject: [PATCH net v4 0/3] net/smc: fix out-of-bounds and use-after-free in SMC-Rv2 LLC processing
Date: Fri, 31 Jul 2026 16:05:06 +0900
Message-ID: <20260731070509.1818665-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Split of the single v3 patch, in the order Jakub asked for:

  1/3 frees the LLC queue entry in smc_llc_srv_add_link() only after the
      last use of the pointer into it.
  2/3 bounds the peer-declared rkey counts in smc_llc_save_add_link_rkeys()
      and smc_llc_rmt_delete_rkey() by the buffer they read from.
  3/3 copies an oversized SMC-Rv2 LLC message into the queue entry and
      declares the rkeys that fit inline, so both consumers stop
      reconstructing the layout themselves.

1/3 and 2/3 are tagged for stable.  3/3 is not: it does not fix a crash on
its own, and it changes a structure layout and a static function signature.


---
v3: https://lore.kernel.org/all/20260727095833.1079618-1-yhlee@isslab.korea.ac.kr/

Yehyeong Lee (3):
  net/smc: fix use-after-free of the LLC qentry in
    smc_llc_srv_add_link()
  net/smc: bound the peer rkey counts in SMC-Rv2 LLC messages
  net/smc: carry oversized SMC-Rv2 LLC messages in the queue entry

 net/smc/smc_llc.c | 101 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 76 insertions(+), 25 deletions(-)

-- 
2.43.0

