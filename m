Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=111.22.67.139
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795161011;
	b=kjNfm8YEq5446q3sGv/RxU1SPl2dBodnUHT1imQ+90oyYsayzYJoE354xpDTfjAdxr5i
	 dFLguWwvu/01BIIMsuQqhgvKC6ikPBXd4evb+Swkl1Dat0f/tgybaxggpJe2fX8HpE5+l
	 j8eBfCvIWyAkCzM27iKIKiYzqupuWMgVYvgWN21WhBXp75rj/6sz4515QIu7QyQANugHk
	 IK/w4QAGBZluqlUfGau3K7Xi+8EqEMRxyLj5CK3vd1BNuUc1/AYhuSHBhbMdzfTfj46fM
	 EPvyF7HvbTuQ1mz884W4gwNEVqCgSCJbnD6mY26P5y09jqIuzCp3Ezon3JjeogHqoKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795161011;
	h=DMARC-Filter:DKIM-Signature:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:
	 X-RM-TRANSID:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:X-RM-TRANSID:From:
	 To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=NZQHsT/1yyOszeTOdmMaoUGS5yXzbh+whWHyfrpQDOs=;
	b=4Wg7bTtxPz+XAj2Ppj4u0QDO3VCFlbxC1Ir3la4KmmqVrLkU/8INSoM1BM8bO76YPaUz
	 LhY3qXwr0KoP6Ceisy1dvEUW/n64p993hV1t76JIxoPyMmDM2G94m+WBritAeDXrEa6o0
	 fJG7+OkB5dhguYWA+q0zslMEVDFh+unKj1xqyMq6Yrj50ML1lOpmhgbPJ8/5NfjPcjnyS
	 6mNITKD1auoOV2KR7+msfM9pI0PhbGBTVEbybXGQ3lbFpdCMJCZ/zDHsD42MI7S9jSaQ2
	 UQhH2Ta+MepUj19M4VU5m+Q/Xio2MVZNFXp/L8TQXX1rYfJHKlhm8sVChruw/s5Hfqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cmss.chinamobile.com;
	spf=pass smtp.mailfrom=cmss.chinamobile.com;
	dkim=pass header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=JRrTuUd8;
	arc=none smtp.remote-ip=111.22.67.139
Received: from cmccmta6.chinamobile.com (cmccmta6.chinamobile.com [111.22.67.139])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82F63606A320;
	Fri, 20 Nov 2026 07:50:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 82F63606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=JRrTuUd8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=JRrTuUd8GJZH4GdWOMhbevHRHM90IP2mW3Yqdh4ty2qMqLhkzl36kkSMVqBvxE3cLeTm+lq5Ct0Rz
	 nj0yKkRxkWv+Qu0P5hkT8Q1M19hKoxsZT614+gc/S947aSLnzmCnvhrWdlBjkiByY0Z6yYZ+HspwsE
	 ni2oe1KTYZO4JE48=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app05-12005 (RichMail) with SMTP id 2ee56afffbb09ab-235e8;
	Fri, 20 Nov 2026 15:50:09 +0800 (CST)
X-RM-TRANSID:2ee56afffbb09ab-235e8
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from FHD-W7400297 (unknown[10.55.1.70])
	by rmsmtp-syy-appsvr04-12004 (RichMail) with SMTP id 2ee46afffbae7c9-1c5f9;
	Fri, 20 Nov 2026 15:50:09 +0800 (CST)
X-RM-TRANSID:2ee46afffbae7c9-1c5f9
From: Aibing Chen <chenaibing@cmss.chinamobile.com>
To: Saeed Mahameed <saeedm@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net] net/mlx5: fix a stack over-read in the QP debugfs files
Date: Fri, 20 Nov 2026 15:50:05 +0800
Message-ID: <20261120075005.843-1-chenaibing@cmss.chinamobile.com>
X-Mailer: git-send-email 2.50.1.windows.1
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

dbg_read() formats the field into char tbuf[18] and passes the return
value of snprintf() to simple_read_from_buffer() as the number of
available bytes.  snprintf() returns the length the output would have
had, not the number of bytes written, so when the string does not fit
that value is larger than the buffer: the longest QP transport string is
"Invalid transport type" (22 characters), so with the trailing newline
the function returns 23 while only 18 bytes were written.

simple_read_from_buffer() uses that length to bound the copy to
userspace, so reading .../qp/<qpn>/transport copies up to 23 bytes out of
the 18 byte stack array, leaking 5 bytes of stack.

Enlarge the buffer so the longest string fits and use scnprintf(), which
returns the number of bytes actually written.

Signed-off-by: Aibing Chen <chenaibing@cmss.chinamobile.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/debugfs.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c b/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
index 30be2b631..3e75f66f7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
@@ -496,7 +496,7 @@ static ssize_t dbg_read(struct file *filp, char __user *buf, size_t count,
 {
 	struct mlx5_field_desc *desc;
 	struct mlx5_rsc_debug *d;
-	char tbuf[18];
+	char tbuf[24];
 	int is_str = 0;
 	u64 field;
 	int ret;
@@ -522,9 +522,10 @@ static ssize_t dbg_read(struct file *filp, char __user *buf, size_t count,
 	}
 
 	if (is_str)
-		ret = snprintf(tbuf, sizeof(tbuf), "%s\n", (const char *)(unsigned long)field);
+		ret = scnprintf(tbuf, sizeof(tbuf), "%s\n",
+				(const char *)(unsigned long)field);
 	else
-		ret = snprintf(tbuf, sizeof(tbuf), "0x%llx\n", field);
+		ret = scnprintf(tbuf, sizeof(tbuf), "0x%llx\n", field);
 
 	return simple_read_from_buffer(buf, count, pos, tbuf, ret);
 }


