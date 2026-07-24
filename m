Received: from smtpbgbr2.qq.com (smtpbgbr2.qq.com [54.207.22.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 248E92DFA2F;
	Fri, 24 Jul 2026 02:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.207.22.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784860167; cv=none; b=lkvpPa5o6yE9Ju91WRcmqOhCA6r/3hBhjsvvJ5eSdrumFqV6WChEzr4vQH5bPYLTQADwhm379Ze9CPQv6/S2ryD/7750w28ElSSLbkf1+iV8Znas51ofzV+Z70Fqn5rr+7sxaerOcQJgv7djB8RkHlRr3LHQVcMRnAc8lBI/7s8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784860167; c=relaxed/simple;
	bh=qBcgriTpGXSdcveMAzU624WbFDixVzDy04LllnPaDrM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FutYmupQJ3YWFuauc0X0Jz0fgpWk39AHg1fPlZMaITL8P1hBC8TcpefSJHTxGWNZDKBdz7oztihBfHNSI24ou9R6B1lwH9FJklZWh9W3RDPYOp2Vj978iAvFyoFJSV+bmPvnRP/nzm/AQxs3OtV0iBz3misltwC0CR+Y7vdT//s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=LGfdFVjE; arc=none smtp.client-ip=54.207.22.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="LGfdFVjE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1784860158;
	bh=nFjFFaXMkLzxoExHNfOEPPaBXmUVyvwpIJWfb32uFmU=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=LGfdFVjEYvjxVglWZxiq7eRgH6iAbJCqSGnStOyur1w26FW1jBqPB7R5Vqou5CR4Y
	 FMd5CNpZNFjhTPK2ACHL6w4uGM93PnwP44MG4hx0+QkjlnXi1dZJwKdpwjcAOv+ny8
	 qv2LUvh8UWBYWu8YbbUEuozZRsLChfXnyot4kYlE=
X-QQ-mid: zesmtpip4t1784860151te3c12dad
X-QQ-Originating-IP: Q0VsYdJjns2x4KkOcgSLM6b/xTyYuD8mV2X7QLUMAvc=
Received: from localhost.localdomain ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 24 Jul 2026 10:29:08 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 9743323694755543151
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
Subject: [PATCH v2 3/6] powerpc/xive: fix use-after-free of xive_ipis
Date: Fri, 24 Jul 2026 10:28:48 +0800
Message-Id: <20260724022851.466017-4-gouhao@uniontech.com>
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
X-QQ-XMAILINFO: N4WhQbLQyIqSPgzBttvoGSM0rHIoDOFdOVlvtNsNl44gq9z78OzWrIQn
	6gTUsLCO36PpNFC0aA0PRmQnKvNci4ZQCuiVBpPbpXXISn8zdTFbgp3vKkE6ZTbobi1ogUE
	jATLyFsKHyR0ky86uD5CPeWt4gVZ3ayOK4w0Nv73iUfhXxwuohHPDR2QOkSXwKafi+gdb0h
	1X4BV8pTOicrYDaJjzUgKGlx9or5UZcU1K8SNsa37VetUCDaiU/d0CaIbuy97xGqFr6CB6E
	AzCoAY4qG7oHl+WKxvsj95cwOvTv9qDVxkL1IkZQlh4KXHmp7spDG/qS6tfu3WZLbS24DEG
	tBZ0fLHQFzaigA4CKBN/BkwdiKDNV98VH7swM35UHPCb05m6mI/yyjP4yw9ISxU5M5aMw1i
	LRcTYcQ0Kb+ZQoqRhYWH+ANL/sT0mwXjNj4ct1K1VFbmWCTYtJKNQWU5mKh9BSdaMUXlzm1
	gjUQ2XdDE7+xTon2+AW+culXQWK+nKPYFKsZS2gAnwEz3hhqW0eHlpqFezzWzc/n9T+BW1F
	USfm8IEoAt9mMb3IGT6KEBGnnH/BbAS4m+tUQwNFxKwNwcOSW5cLXvGeVL+V2FszAciqtqv
	a+67zkvAWR2kxz2PyFSIDwZ0kdKlk+5jxO3QPySjDh3+fGncTY5QZC+UiYStS1SQ4dpxPxS
	VyCPuwluLgsOqTnob3KzueH755NsrSdey9aMQ9lvEtiv9JKZQp5/lXQhcmlWoA7lVxGNEgL
	ozyPBRAVhe+T3Sh/Fu5CP5xqCW9BhWPbBZ5qOxwwHpyLTiScNYfgEXrYLFSBbrJDGuJuXpR
	p1dRHRV+4fDuKy1kQCxQjKypoZA5aVe+ujIKuDbZENUKLEelQ3eCqBx6RxgMulVxp5Q2QhM
	G2hZkRtPGSrsZoLO0m85p1NxOqKy85Elc0TYzaN71kA87lyWHSzO4PhGwn2psCCPI4lLFTi
	rtNDeat6HTyZApeULdkEsXOeFnRiftQ7ErQ61jheOn7erktHgbKaShSSlZSvNp3fZgmvkmC
	bCJ7UCKhsIkqyX9n66pXkL+khsHQYr8jD+XbN2EiDOf9A1pSEOnRcnwcItIRM=
X-QQ-XMRINFO: Mp0Kj//9VHAxzExpfF+O8yhSrljjwrznVg==
X-QQ-RECHKSPAM: 0

When irq_domain_alloc_irqs() fails in xive_init_ipis(), the error
path frees the global xive_ipis array via kfree().  However,
xive_smp_probe() ignores the error return and proceeds to call
xive_setup_cpu_ipi(), which dereferences the already-freed xive_ipis
pointer, resulting in a use-after-free.

Propagate the error from xive_init_ipis() through xive_smp_probe()
and check it in both pnv_smp_probe() and pSeries_smp_probe() so that
IPI setup is aborted cleanly on failure.

Fixes: 7dcc37b3eff9 ("powerpc/xive: Map one IPI interrupt per node")
Signed-off-by: Gou Hao <gouhao@uniontech.com>
Reviewed-by: Wentao Guan <guanwentao@uniontech.com>
Reviewed-by: jiazhenyuan <jiazhenyuan@uniontech.com>
---
 arch/powerpc/platforms/powernv/smp.c | 8 +++++---
 arch/powerpc/platforms/pseries/smp.c | 8 +++++---
 arch/powerpc/sysdev/xive/common.c    | 6 +++++-
 3 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/platforms/powernv/smp.c b/arch/powerpc/platforms/powernv/smp.c
index 8f41ef364fc6f..b1201dbafcaf6 100644
--- a/arch/powerpc/platforms/powernv/smp.c
+++ b/arch/powerpc/platforms/powernv/smp.c
@@ -332,10 +332,12 @@ static void pnv_cause_ipi(int cpu)
 
 static void __init pnv_smp_probe(void)
 {
-	if (xive_enabled())
-		xive_smp_probe();
-	else
+	if (xive_enabled()) {
+		if (xive_smp_probe() < 0)
+			return;
+	} else {
 		xics_smp_probe();
+	}
 
 	if (cpu_has_feature(CPU_FTR_DBELL)) {
 		ic_cause_ipi = smp_ops->cause_ipi;
diff --git a/arch/powerpc/platforms/pseries/smp.c b/arch/powerpc/platforms/pseries/smp.c
index db99725e752bd..14cd0634eeca8 100644
--- a/arch/powerpc/platforms/pseries/smp.c
+++ b/arch/powerpc/platforms/pseries/smp.c
@@ -194,10 +194,12 @@ static int pseries_cause_nmi_ipi(int cpu)
 
 static __init void pSeries_smp_probe(void)
 {
-	if (xive_enabled())
-		xive_smp_probe();
-	else
+	if (xive_enabled()) {
+		if (xive_smp_probe() < 0)
+			return;
+	} else {
 		xics_smp_probe();
+	}
 
 	/* No doorbell facility, must use the interrupt controller for IPIs */
 	if (!cpu_has_feature(CPU_FTR_DBELL))
diff --git a/arch/powerpc/sysdev/xive/common.c b/arch/powerpc/sysdev/xive/common.c
index f9a1229cede73..bb6ce07c1699e 100644
--- a/arch/powerpc/sysdev/xive/common.c
+++ b/arch/powerpc/sysdev/xive/common.c
@@ -1256,10 +1256,14 @@ noinstr static void xive_cleanup_cpu_ipi(unsigned int cpu, struct xive_cpu *xc)
 
 int __init xive_smp_probe(void)
 {
+	int ret;
+
 	smp_ops->cause_ipi = xive_cause_ipi;
 
 	/* Register the IPI */
-	xive_init_ipis();
+	ret = xive_init_ipis();
+	if (ret < 0)
+		return ret;
 
 	/* Allocate and setup IPI for the boot CPU */
 	xive_setup_cpu_ipi(smp_processor_id());
-- 
2.20.1

