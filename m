Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=111.22.67.151
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795359120;
	b=wZ7Lj+1DcE/gq0JWo9eR7Uzxxp5Szo9nDFgVvMrSBKz8VrQ2OhaXc5i0A+i3jERlIDqr
	 ZN5/Q1SrXKi+1DwB22ZcAMq8LWGT69PT5v7mNE848kV9zY4Ic0Tmstm5pKx9VN/V+QcRZ
	 TEtdmFsK5zv/RNREan1MmitpgFUKun48U2wT3sRwowpUbYIOJDBj3TcANHil8iRZQACzE
	 NaQJsdueJAtRqAqRi0IwNKYXLBdgcOy0wr3SvHJgpGAd7qHqod01/ySAK1cTQ2aY9tF6y
	 rF/kcQVjIw+ssDGRfndE9EPgAWbekWjFT+6ltoDE9+fCHvRFzh+pggL1hbHdoHGnrKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795359120;
	h=DMARC-Filter:DKIM-Signature:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:
	 X-RM-TRANSID:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:X-RM-TRANSID:From:
	 To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=N+g6yFnu5goWeGzRkjeNV5+MD0chsaKXrf18q6pxcOo=;
	b=wv7ZwHxsOCV9vloC+FJXRrsr+szcZOVnJUR0yElOeCo8QAd7vsNf/QaGW5n0LJIKXRN/
	 +NtxMS4uwo/yz9xn6K9xHPT9oY4mIp0rm9TCLoBjnatve/0ZCOSldhA89JmClptHqfbJH
	 0FDau3P696TPOykYZircZrvZ9mfMn/6lhX4DAMOMDhjO0N6W9dEJV3xZ/gFyGSUBI7ejD
	 aVxeHvNplJnF2vJ75IE50h6qo4dbwU4vmO66i3O4Cu8ql9NR3quXJimemi74bNPAQV6wM
	 JhyiTUavPTiHTUePPhpF1sOC/e1WqY6/grNupHEw4HbwH3cXExs1O8/DaqPdoagNiHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cmss.chinamobile.com;
	spf=pass smtp.mailfrom=cmss.chinamobile.com;
	dkim=pass header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=AkmXN8eP;
	arc=none smtp.remote-ip=111.22.67.151
Received: from cmccmta8.chinamobile.com (cmccmta8.chinamobile.com [111.22.67.151])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A1D8606A32A;
	Sun, 22 Nov 2026 14:51:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9A1D8606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=AkmXN8eP
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=AkmXN8ePhCC3zrt5wKubezneAcarFP2gnKoWuHUoOevXheQ+zPfb5syHH4Rpy2RmhSfTAmvtGYOFL
	 AqUQEUG1305oBCJBZfAXTOwuMDiFx+h6KJL1+rHtDqOTjIunO9ig/BEuToSqCM1QKvGP+2zSmsb/rD
	 9ldw+CG7V7a3VV28=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app06-12006 (RichMail) with SMTP id 2ee66b03018953e-0092d;
	Sun, 22 Nov 2026 22:51:54 +0800 (CST)
X-RM-TRANSID:2ee66b03018953e-0092d
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from FHD-W7400297 (unknown[10.55.1.70])
	by rmsmtp-syy-appsvr04-12004 (RichMail) with SMTP id 2ee46b0301877a1-71c7e;
	Sun, 22 Nov 2026 22:51:54 +0800 (CST)
X-RM-TRANSID:2ee46b0301877a1-71c7e
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
Subject: [PATCH net v2] net/mlx5: fix a stack over-read in the QP debugfs
Date: Sun, 22 Nov 2026 22:51:52 +0800
Message-ID: <20261122145152.1473-1-chenaibing@cmss.chinamobile.com>
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

Fixes: db81a5c374b5 ("mlx5_core: Improve debugfs readability")
Signed-off-by: Aibing Chen <chenaibing@cmss.chinamobile.com>
---
v2:
- add the Fixes tag for the commit that introduced the tbuf/is_str
  formatting, as suggested in the review.

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


