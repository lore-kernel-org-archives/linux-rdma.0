Received: from pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.34.181.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C54714EBAFD;
	Wed, 30 Sep 2026 13:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.34.181.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790776561; cv=none; b=RkQHcPU7b7hRxkEEq9PwSpoABP1udGfE3yu6XFcaST4sF93aie1jHLAI8JJKzybqa0eZwscp4n//QQFv/gR1iUiHhsd0PYW/GAQiVDtpcUXWMb0qcTFaZG33KNewMMiWs7EPCLa6yG45OooZBtk9rfbFf8LFwu+56xd6uglY7/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790776561; c=relaxed/simple;
	bh=8jfen76L+5+BCio0zyoKB5ZapSrxCWBC1+MdvPmQNec=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=nh4N0Wd8un/XGYN76w0d4tcrFl12a5oKwdyuG+EU5/4Lw8FtPigd8WStqEgBBByMx6TPN36Vks5dlEAYQIXDKv3HMhkf7xOZhXAwnYhZdR7ewO0pbqp7lfCocXQ7wi5lhKT+V2yNOmhljBx81hNCrU6ePUJ0Eoa0XAeELyFVDD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=YxpBh3FL; arc=none smtp.client-ip=52.34.181.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="YxpBh3FL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1790776555; x=1822312555;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=qDm+S6sd80/3qx2pFJFtn4/wG9Lxy2FLbqMAV5zF8p4=;
  b=YxpBh3FLN5Rrinb1GXxRE/7H3KLKvxstnLDUcgDjw72zh/Pp3bcXZPh+
   MqAIC2WV60GjMqqXihSpsjdJdSXf/doEjQs9JwywWiGRr2uiBTBgQ422T
   JU90VsTwnlyZRySha0NAzZ8kA7xxscErbxC1QUqL+w4ttau5LSaE2TZj1
   idFtHsD18UXJI/zjFBF9se1xupEFZTLJv7FKYLrWKVK78xES16bW7L1wW
   TQ3auewKC/Lp+YiXNzrMHbtZZCZHQ1Aqux/2flhB/BnjL1EF5N3E8Evoe
   d4q9Ldavy3+bAAmZWdW/Q4gBbz739jQlxr4F5Vrbk4c/Y/+2X+t8/TnzU
   A==;
X-CSE-ConnectionGUID: HqAKzGF4TQ6LS6dabDLcQw==
X-CSE-MsgGUID: VGsL49ucQsmx8zd8igT4fg==
X-IronPort-AV: E=Sophos;i="6.27,132,1787011200"; 
   d="scan'208";a="30029825"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 13:55:45 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.53:2975]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.62.119:2525] with esmtp (Farcaster)
 id 11173d28-5b50-48e8-8966-6d09cb52794d; Wed, 30 Sep 2026 13:55:45 +0000 (UTC)
X-Farcaster-Flow-ID: 11173d28-5b50-48e8-8966-6d09cb52794d
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49;
 Wed, 30 Sep 2026 13:55:44 +0000
Received: from dev-dsk-doebel-1a-7b355d76.us-east-1.amazon.com (10.169.119.5)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49;
 Wed, 30 Sep 2026 13:55:43 +0000
From: Bjoern Doebel <doebel@amazon.de>
To: Zhu Yanjun <zyjzyj2000@gmail.com>, Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, Shuah Khan <shuah@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <doebel@amazon.de>, <stable@vger.kernel.org>
Subject: [PATCH] selftests/rdma: Skip rxe_sent_rcvd_bytes when rdma_rxe is missing
Date: Wed, 30 Sep 2026 13:55:30 +0000
Message-ID: <20260930135530.881281-1-doebel@amazon.de>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D033UWA004.ant.amazon.com (10.13.139.85) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

On a kernel built without CONFIG_RDMA_RXE the test exits 1 instead of
skipping:

  # modprobe: FATAL: Module rdma_rxe not found in directory ...
  not ok 467 selftests: rdma: rxe_sent_rcvd_bytes.sh # exit=1

Every other test in this directory probes with modinfo and exits
$KSFT_SKIP. Apply the same guard, identical to the one in the otherwise
near-identical rxe_socket_with_netns.sh.

Fixes: c67bd973695c3 ("selftest/rxe: Add selftests for perf")
Assisted-by: kiro:claude-opus-5
Cc: stable@vger.kernel.org
Signed-off-by: Bjoern Doebel <doebel@amazon.de>
---
 tools/testing/selftests/rdma/rxe_sent_rcvd_bytes.sh | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/rdma/rxe_sent_rcvd_bytes.sh b/tools/testing/selftests/rdma/rxe_sent_rcvd_bytes.sh
index 0e4fbfeebd228..89218ccfba4c1 100755
--- a/tools/testing/selftests/rdma/rxe_sent_rcvd_bytes.sh
+++ b/tools/testing/selftests/rdma/rxe_sent_rcvd_bytes.sh
@@ -4,6 +4,8 @@
 PORT=4791
 MODS=("tun" "rdma_rxe")
 
+source "$(dirname "$0")/../kselftest/ktap_helpers.sh"
+
 exec > /dev/null
 
 # --- Helper: Cleanup Routine ---
@@ -24,6 +26,10 @@ if [[ $EUID -ne 0 ]]; then
 fi
 
 for m in "${MODS[@]}"; do
+    if ! modinfo "$m" >/dev/null 2>&1; then
+        echo "SKIP: Kernel module '$m' not found." >&2
+        exit $KSFT_SKIP
+    fi
     modprobe "$m" || { echo "Error: Failed to load $m"; exit 1; }
 done
 
-- 
2.50.1

