Received: from smtpbgbr1.qq.com (smtpbgbr1.qq.com [54.207.19.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E091B31A053;
	Fri, 24 Jul 2026 02:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.207.19.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784860181; cv=none; b=fIoPClbqDVCuPk4RR/MWuZHLMRfBqyS0ILroQxM0M2CyBykzPdbHElnY9i19w4ye5PfXDIS1w5WohICp9FUgGbApev6C3jdwVU7I/wkkF8Cx16tKGl0RKkbltSF+2uxReBDUtnS/0K84YIzwjlVvDyPts7NAxL/mHZ+HlyqaAW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784860181; c=relaxed/simple;
	bh=bvRp3NThDExwUVLGiRwJgad3CghL7MLUZfwhVd7fpY8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=te3ua1gN0agyvkO6IF9HQlY5nWmUb7mGoHGQRuX7PlYGJQRu4Jb/YNqKuZRCtRhQzjaZ4Mbp3lT/mMov9dbw6Rc+ZE1zTyZNm4iQ4ibtGWP16lihVFWDndmF+IcoRX2M9f5SlEAblJ29gqv1QSI8mJmOVLXWUK0QCfHSAkE8b+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=JfRBL6vG; arc=none smtp.client-ip=54.207.19.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="JfRBL6vG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1784860173;
	bh=Yn0Gyoe5DqjP71R2buJi41mG3iZ0k1ZX3eDGImr8Sq0=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=JfRBL6vGX+km3YMzXlEy7HJjnZqr5bN52rjPOVAQnKRIbluO+xg2UR2JNwgYqwD0z
	 SXyUg4OftBJTjKaq6Dj2Mo8/uGJrhggOebDVx6pkjdosAv8MRFez9vbIMWQeQE8m6Q
	 WIIski7wchHE/k3u849ZwaM0Ku3cvTGxYk+Yhn7A=
X-QQ-mid: zesmtpip4t1784860167t2acc5bb8
X-QQ-Originating-IP: qIXv24m5LF8xLoOUC1kXo/DM9tGPxEiRVtvDS4LSMeI=
Received: from localhost.localdomain ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 24 Jul 2026 10:29:24 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 530311859156334886
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
Subject: [PATCH v2 6/6] RDMA/cxgb4: remove dead NULL checks after GFP_NOFAIL allocations
Date: Fri, 24 Jul 2026 10:28:51 +0800
Message-Id: <20260724022851.466017-7-gouhao@uniontech.com>
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
X-QQ-XMAILINFO: OL8jzxGXDQwe5+Vjow/jerrouFsLXYDeJK1O9Ov7DSshBfHWdMk4cvFo
	qhZgnY5yIrRt0nKFW4MuulZWTEKLA7qGK4rGL6oTYRvRyXfyx5N+de1qAoH+IwYekwkzl83
	nkcBjId3AZu89P0s7xWI0BKZbRMsKzk6gtqBfgoBC3J2ov6HpLzowzIZON3zLqbnvPEPXVr
	Xs2Z0HwdodOWZsPSDCD13kqn5wG/RDo0DYTiLoTlux+WQRQGSRtnioz4AGSXEYAcYekkprr
	uwZh4D2rV9FBUQNpW7NnbyC4cdB16eFUaKmv1zYed+IgAGvsqF1Rw1ibOT8KmuNhhRt2CMl
	sYOmBQvS/V5cPS6Am1X2hFicO1fBvvXeaVha7ZRExw9V/Jsz78PqTxyQrNvjwy9EderILKf
	HiRrhjpaheDbpBhkWaPRLzn9xhsMVYriUkLZhHeP6seMv6uUI3wa+7YIuLKM//u20YkYjrN
	aL9EgHjwi4ATfe/cY0BB3zpl0tuHtTPgoPMbA1Dr71QO+JOIP2Qr4OqmSUmpmN7YB+Y6a1L
	Bc5p5aXkMkDh3mTXuL4E7uLVY4Vfz6BBIXSTUxZe4bz1QbYfRVauns/059HnE/gXUybrc9W
	UJffQ92bNNzb6+XQxiBAmrIUwqG+UgKEUfnfGiimXPD26OIxb9etyu+sY19bSY+ifuz5wQd
	DaBEv1opdSjABeLBH4G620oVXA15cH5O56esS+xxXi2ufPm/bEQV8PgZkfTPauMkjNABUQi
	L4zMmvwUV2IB9DQA4fjjBxBAm1o3hwzfocIhBWzIZS+veewUanOUlDzjggCfDv5TJQ+yKQJ
	HHhsscOe4zGd2w5DtuXRG5LNbufWD+KVATt05WCDuu+4pZ/TQuk9jY3T4kP83DF3NyovMCf
	52AtX0Ug+MfO+YK3AVgKFTvTxsXSPEhSfvfbarw+eAGIjgxeg1rbt/JRY9Z4RLMF5OjoAL2
	9NdntHcVlZKc6LDQfRut1ybN6zjnjws7A2Gvaaz/kFlUQEqbOYUa2KIKcN4EqdkPVyU6RnX
	Vlou6gjJacfcVcGfO/VmpzGLFJBem0xRYjdsdAjNtIrVllOZCEetzorxY8DG+ujtzIEN5LH
	A0v3nKEk98+YnfaFSsjZ8iZkOyJUJgvYVX+Stz8ULjGEYUiVqJYTto=
X-QQ-XMRINFO: MPJ6Tf5t3I/ylTmHUqvI8+Wpn+Gzalws3A==
X-QQ-RECHKSPAM: 0

alloc_skb() with the __GFP_NOFAIL flag will never return NULL,
so the subsequent NULL checks and error handling are unreachable
dead code. Remove them.

Signed-off-by: Gou Hao <gouhao@uniontech.com>
---
 drivers/infiniband/hw/cxgb4/mem.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/hw/cxgb4/mem.c
index cd1b010141984..08631de17c0a3 100644
--- a/drivers/infiniband/hw/cxgb4/mem.c
+++ b/drivers/infiniband/hw/cxgb4/mem.c
@@ -74,11 +74,8 @@ static int _c4iw_write_mem_dma_aligned(struct c4iw_rdev *rdev, u32 addr,
 		c4iw_init_wr_wait(wr_waitp);
 	wr_len = roundup(sizeof(*req) + sizeof(*sgl), 16);
 
-	if (!skb) {
+	if (!skb)
 		skb = alloc_skb(wr_len, GFP_KERNEL | __GFP_NOFAIL);
-		if (!skb)
-			return -ENOMEM;
-	}
 	set_wr_txq(skb, CPL_PRIORITY_CONTROL, 0);
 
 	req = __skb_put_zero(skb, wr_len);
@@ -134,11 +131,8 @@ static int _c4iw_write_mem_inline(struct c4iw_rdev *rdev, u32 addr, u32 len,
 					 roundup(copy_len, T4_ULPTX_MIN_IO),
 				 16);
 
-		if (!skb) {
+		if (!skb)
 			skb = alloc_skb(wr_len, GFP_KERNEL | __GFP_NOFAIL);
-			if (!skb)
-				return -ENOMEM;
-		}
 		set_wr_txq(skb, CPL_PRIORITY_CONTROL, 0);
 
 		req = __skb_put_zero(skb, wr_len);
-- 
2.20.1

