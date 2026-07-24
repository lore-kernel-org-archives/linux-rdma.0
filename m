Received: from smtpbgau2.qq.com (smtpbgau2.qq.com [54.206.34.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E96D731F991;
	Fri, 24 Jul 2026 02:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.206.34.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784860166; cv=none; b=UXUI46dxuwp9d2LHZVpg1TGpDYWd0tQm6g1Pjm4an+QgY5FxxyFiQ4ITgfJVHhPqdUP59KvvplZful2411OmuMoWPkYUK+BNKYbuYwJojJZhHbzgMX8OKSC+FkEpr62lAKi6NXxvTNtERJ6+7q9RvWz+7+eVeXmEH4M/Tclt0fQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784860166; c=relaxed/simple;
	bh=q1KitDd+5YTKSMZcayu9YP2JDF1w1PFBb+0293Mc3/Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UbIFdoNnEHep7K63Yq+VqKSweL1/gs7kRXPwIdVWuY+x017BPBmjJ5uSDJwXhw8RmDDJFLMtc2mlCyfuqpCH5tBXNxoMnyKm1lo94dJ0PSW61aXUh1KR+wMz/h/Q5t9ummBGVKtXgkb8w7FxurUwuPZKRxDtx2JxyFk5+PPe8LE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=ncs5xM37; arc=none smtp.client-ip=54.206.34.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="ncs5xM37"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1784860153;
	bh=HXOSjewrugfoFYAviBCdTNIHqggVZlJ3YZl/fwlFoCA=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=ncs5xM37vVjd0IjnaCGWOLRekG4+uPEyk4jfTeaoa26iiFpR/v9bXLSofrN2Dj0Yf
	 /Ub2ptb4AR5B4ZSN+Ac5nenqlE612qp/SqTGNwAQUYlx+y2EkzZJGa1LPOh7qEQLHM
	 HpxJ1/Y/SMCIXk+vm5MVtGtCgH4Irzyb9mJDYwNE=
X-QQ-mid: zesmtpip4t1784860146t7ae6cf1f
X-QQ-Originating-IP: wWBgv0NV/7CKCdcjUMM5igbrbPg1ViC8PwqJvYK5y/c=
Received: from localhost.localdomain ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 24 Jul 2026 10:29:03 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 4050712520101716894
EX-QQ-RecipientCnt: 26
From: Gou Hao <gouhao@uniontech.com>
To: maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	chleroy@kernel.org,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de,
	airlied@gmail.com,
	simona@ffwll.ch,
	bharat@chelsio.com,
	jgg@ziepe.ca,
	leon@kernel.org,
	akpm@linux-foundation.org,
	gouhao@uniontech.com,
	namcao@linutronix.de,
	ynorov@nvidia.com,
	sshegde@linux.ibm.com,
	nilay@linux.ibm.com,
	clg@kaod.org
Cc: linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-rdma@vger.kernel.org,
	linux-mm@kvack.org,
	gouhaojake@163.com,
	kernel@uniontech.com
Subject: [PATCH v2 2/6] powerpc/xive: add error return value to xive_smp_probe()
Date: Fri, 24 Jul 2026 10:28:47 +0800
Message-Id: <20260724022851.466017-3-gouhao@uniontech.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260724022851.466017-1-gouhao@uniontech.com>
References: <20260724022851.466017-1-gouhao@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5b-2
X-QQ-XMAILINFO: OAPJltlfxx0LCBmOXUuzp2BiW70r2R33oMIB3v25EpbYXyqbc5Cf2aGi
	gYhaKA6U4i6g3pzle958lWasdpVMihj1zbI4dqhSruhzv+4sY2ibGuSKkQ+7gxzBsbvAqqt
	71PhKDoTLFP7hyP+NSP5haJNwT5Lf/NHq/K4Npy0Vg26osRjnEGKunytmKWJW8PLssaiERr
	d8jY+0M1QIhmKoOE5W3KIiUVkhAoiVrU+IYawbztDpSOFrjmxdniLE3d11plVpC2cGHbAze
	FLvPpYHgRflCA2rH6JoDyJXmE1ns47PVtAndyio5BM5SizNqe2VO5Gk6aE4Ihs87oyYQy4F
	IvOmXSznuAy2H8Dk3G5TxX9vTTN04h2bcJY2G9vZxbmySNLo62QpSBe9tLUsWduGBrv16jD
	yjWPlYtXXPJhyy5Lya4X+naSi5CtYrpKz7Jeq18jBDOe8vaiR4rQKtHOCNsez3m9zyXp8uH
	BxBNKbMca5sN3zFZ3FXVBunMKZUORGKWTO5R9L11MgBlRrTaAk7eEZLYDBB5glgcq7Mfv9d
	bPc5EBEUFe8t9MhHMoNdOFaMleaj0LCzLXj9pM1/VpmIxkMDvr81hn4c9hmXurZq1OaPK2l
	UJxgbj6ybMQO0gbqqaO6IeJZg6VWI1R4+uIpIZUsfD3JNDqz1A+x2HAtuJQhqmWfv+Q6QVi
	hcnnAlMNXjR8ohNuJl+R094d3wGSpfPwNSfVXVCuEk2Pzpy22ITpiRIjVvqWhdQ+Z7bzZPd
	aPdFsrM5O2T/du3+dRKmQiD9VcsOPsH0Redms+EYv1Da1zYuU8ofsUt2OMg3URjG/hgdyt6
	+I/PSuDvRskuRNm6JAWBKGLfTY0EiMI9Yb9U6yDEUSeR0bW2B3hJI3oz6084IxAPdZgrBEv
	4MV1w6y9xVTu3ZS4ktpiZytA+nZGVE+s7po6PTrQc2bxhYYNh3BmAajfIiJvzPxvJS2jxKK
	HJFhNPXrHyzK3KI2WJCJUsHYJQKerbfqTcp36oHEPmQchqHDunB780vZYBs7k8iVUHM2XRv
	oQ0B/ufBFa11UrOc2ge90qBRRlnKXRV5Prwzm9LD43GUf5UKga
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
X-QQ-RECHKSPAM: 0

xive_smp_probe() calls xive_init_ipis() which can fail, but its
return value is currently ignored.  Change xive_smp_probe() to
return int so that errors can be propagated to callers.

This is a preparatory patch for the next one.

No functional change yet; the return value is always 0 at this point.

Signed-off-by: Gou Hao <gouhao@uniontech.com>
Reviewed-by: Wentao Guan <guanwentao@uniontech.com>
Reviewed-by: jiazhenyuan <jiazhenyuan@uniontech.com>
---
 arch/powerpc/include/asm/xive.h   | 4 ++--
 arch/powerpc/sysdev/xive/common.c | 4 +++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/include/asm/xive.h b/arch/powerpc/include/asm/xive.h
index efb0f5effcc69..4e3e3358993c0 100644
--- a/arch/powerpc/include/asm/xive.h
+++ b/arch/powerpc/include/asm/xive.h
@@ -91,7 +91,7 @@ static inline bool xive_enabled(void) { return __xive_enabled; }
 
 bool xive_spapr_init(void);
 bool xive_native_init(void);
-void xive_smp_probe(void);
+int xive_smp_probe(void);
 int  xive_smp_prepare_cpu(unsigned int cpu);
 void xive_smp_setup_cpu(void);
 void xive_smp_disable_cpu(void);
@@ -153,7 +153,7 @@ static inline bool xive_enabled(void) { return false; }
 
 static inline bool xive_spapr_init(void) { return false; }
 static inline bool xive_native_init(void) { return false; }
-static inline void xive_smp_probe(void) { }
+static inline int xive_smp_probe(void) { return -EINVAL; }
 static inline int  xive_smp_prepare_cpu(unsigned int cpu) { return -EINVAL; }
 static inline void xive_smp_setup_cpu(void) { }
 static inline void xive_smp_disable_cpu(void) { }
diff --git a/arch/powerpc/sysdev/xive/common.c b/arch/powerpc/sysdev/xive/common.c
index f2904a5c2b7bf..f9a1229cede73 100644
--- a/arch/powerpc/sysdev/xive/common.c
+++ b/arch/powerpc/sysdev/xive/common.c
@@ -1254,7 +1254,7 @@ noinstr static void xive_cleanup_cpu_ipi(unsigned int cpu, struct xive_cpu *xc)
 	xive_ops->put_ipi(cpu, xc);
 }
 
-void __init xive_smp_probe(void)
+int __init xive_smp_probe(void)
 {
 	smp_ops->cause_ipi = xive_cause_ipi;
 
@@ -1263,6 +1263,8 @@ void __init xive_smp_probe(void)
 
 	/* Allocate and setup IPI for the boot CPU */
 	xive_setup_cpu_ipi(smp_processor_id());
+
+	return 0;
 }
 
 #endif /* CONFIG_SMP */
-- 
2.20.1

