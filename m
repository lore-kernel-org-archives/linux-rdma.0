Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1580C257AD4;
	Mon,  7 Apr 2025 18:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744049896; cv=none; b=H+pJidC+2C2Ob1cSwqE5+HrE2HXVynFgh4uPTvamDj/BSDWJ6S1i5D/i/C7I3PG8XTr3dusEjavyHBf64QbTiYH4a2JJSPJHzqBJc1N8qmBmQANc5jYyHI4ISqEVGKdHTuwS8iiTD6UxkjsZajb/os+PkY9yMoUUkFQKcN2fGjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744049896; c=relaxed/simple;
	bh=T9Zx3vwiTM2+Y33sAeLf5h/TrHKcCQaaj6zPvVbWKLI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=cRNsBNVqhlAGr5EyCQwFkYYMVZpmh4zucOlcuGbwEUGH0mk5MmZNyi6TUVk4se2mco96fZBybH2H3nvvYJ6qz0BXtcetYRkcTDeRZDqeB0QGQMHLei+NyMOZhBH06/3VxZlDlX/i3+G2CTytXpkw+H6vscaSDpvBomZK6N5/cHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t7He2l6M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t7He2l6M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B46C8C4CEDD;
	Mon,  7 Apr 2025 18:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744049895;
	bh=T9Zx3vwiTM2+Y33sAeLf5h/TrHKcCQaaj6zPvVbWKLI=;
	h=From:To:Cc:Subject:Date:From;
	b=t7He2l6MZVBRw5MiL588DkJv9zu5fLFO2w2NO8eLa2e55/ZrkpdSK7nsDn7g2VUMP
	 QAlRU3mOgK/nuMOBajaXSPpvi+zZFVFHAOaG0e27vWrbI3WxGStLqs7RlL0+xC1KXl
	 a+1vuWsMf4juLu0hujrwhKMZ/kpHqkig/mf46w0/5I6W6MUtRfOSesGhK7/bZ268b9
	 KrK8heEpNmUU20nf8i5MhNbTDlPvzDH3abo1HF5zDqHieWurVz9qDQgfpGAAhektXD
	 c4nZcfXlwQ0pJnedp31C16sSoQWOk+PpLlDzt/8snZzW6XNurX9Hyt5+zUdg4/rAfv
	 82cXtdsPQ1xVA==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>,
	dennis.dalessandro@cornelisnetworks.com,
	linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 1/2] qibfs: fix _another_ leak
Date: Mon,  7 Apr 2025 14:18:09 -0400
Message-Id: <20250407181810.3184654-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.10.235
Content-Transfer-Encoding: 8bit

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit bdb43af4fdb39f844ede401bdb1258f67a580a27 ]

failure to allocate inode => leaked dentry...

this one had been there since the initial merge; to be fair,
if we are that far OOM, the odds of failing at that particular
allocation are low...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/qib/qib_fs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/qib/qib_fs.c b/drivers/infiniband/hw/qib/qib_fs.c
index e336d778e076e..5ec67e3c2d03c 100644
--- a/drivers/infiniband/hw/qib/qib_fs.c
+++ b/drivers/infiniband/hw/qib/qib_fs.c
@@ -56,6 +56,7 @@ static int qibfs_mknod(struct inode *dir, struct dentry *dentry,
 	struct inode *inode = new_inode(dir->i_sb);
 
 	if (!inode) {
+		dput(dentry);
 		error = -EPERM;
 		goto bail;
 	}
-- 
2.39.5

