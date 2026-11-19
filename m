Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051632;
	b=XSjkO6KCQ2Puq9uSlBPoinXIJ/53WJ9QicQZXSr1kqqXhxRSpou5CFXCsOSAAKixsTw4
	 j8Dl23qGBH6AjGgBYDnZN6Prc7nITp+U2POe1sDQPPa0rnDNRnnEQ98ez/5HbRHcE1eRZ
	 oSYm6BBIHDJu06Jr4ysxaEckLunAL6xLydPNCqaEJ4kqUXSI+fQ/9HeUfhXFKTHhym5z0
	 Kv3NvB//mDXyoxHZcZY9eWG+ERozPAP27p8pkyHTuk4gxdGUEfwbO7KyhHPlcTV8B7Tgg
	 GIn+GK7WeloLYZTlc5nRXAHtI/6ltPzaqSfI/D+YhsiZ4tIgEdXfefxbkv3hl+XRNag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051632;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=wMPR2OAqKd8NTkv9afi4XE21M7DTJCxQ1aj05lm6jLA=;
	b=tcHlmtoCVOvVi+bXiIXECNATueGhkqpuPw2eJJJ3dc+fRvOyDr4LSW8tkZEkEKnBbbSy
	 I2DuE8/ZxPQIiohl0JjOZKgSt2gibT0PcVAYBRtCHnbX40dWOcKv+HlR6ArKDdWlUVFUz
	 cr5jr7jsje+eoIIYiEjgviS1c+QMv3mruV7UVm5LsK67TFA4IJsD1NdBxqhJNMCsQhDtC
	 laD9S57G53xtwxHO4vHRoIAdDGX31FLXRkwMVycR5DCJuNwHLWZL2kVcccTHgJK+HvZ9z
	 CCaCEPdoQ3LQ338fdSRGXqdALrc0FIPe+LWBe48llgSa5w2O1e1Ye8u8Mec+/oy2cPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dnBigy5L;
	arc=none smtp.remote-ip=209.85.222.172
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BAFE606A31C
	for <linux-rdma@vger.kernel.org>; Thu, 19 Nov 2026 01:27:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4BAFE606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dnBigy5L
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-949680e6d82so223787885a.2
        for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 17:27:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795051631; x=1795656431; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=wMPR2OAqKd8NTkv9afi4XE21M7DTJCxQ1aj05lm6jLA=;
        b=dnBigy5LCe3PKsBq23e+tzlO8XsZwaQCApUPD1wD4F6K6Q5XNb5RCm9PkGUqNAq275
         kDRAPaS8Z1ouYJH9Gi/DA/vAdNWLSBfwtrt+ZcCHcPqbjR4l/m4lvpjbg0MdRqkR3IXY
         3gEPFuzpldVtV54oxUxL7CZ0fg0cay7mfcrBcfxJK57/bOcwe1Y6UNEu4npiVjwc4h31
         uqZLBnbePKmptJZk9mv4MKFVJQLET8BnkaroIthf7S0Uv3tDvqCHPH1pEP7okI7CXY45
         lvJf3xvwTroXbIm5BtDjmNOqsqIJP6JWA1cfQDm4OOL/Qm5Gc05pIlE3dUKtBVISQA3+
         Zuvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795051631; x=1795656431;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wMPR2OAqKd8NTkv9afi4XE21M7DTJCxQ1aj05lm6jLA=;
        b=OJZMuo8sNQz7noulzgrJNcoY5mNshyL098MHDHUVI8oU6LZs1NZPgxHpjLJl2nc3Gx
         uFRNoqn8W+YirhJu4Vr51Dt3XgJ/eCtBmGpMwPIV7omByAlegLSIrIC9FtIlblhmfDh2
         /+Xz5gYjLyYfC9hfMBxbzMCwBVX4U4FkqId5jOaK81xZRtitHQqDzTxehaKgti9/9n2v
         F+DyE57QjMI6qXe1lMmnDXnjMXiP68tHtj79vlabfzg6659rP8Wc8DhDWbrrPxVXgz7p
         Hd21vkpNq/PV4ETrx3lo4fxQcg7CT3aEW/D8mxllb/5m7i31sMvO1gLvCOR1D40Iog9M
         3BvQ==
X-Forwarded-Encrypted: i=1; AL+hErFuz3ih+UNxZbLwEjPpXGN/SzE5b2BqBPJS/W7F3ujJa+DAYAiVsLNKNxAjFj6EaxMYT9nqPNdv3m+E@vger.kernel.org
X-Gm-Message-State: APuU4Z848SRtJXR8aXMx2YadPnUcKwQ9YbHi+T+8wSsCYKtpMcYVl6r1
	gs4Q6lwg1nSqZgKkHbx8ODkWMbT0PbJYl09su8XocVM7AbfdKJjGtFrU
X-Gm-Gg: AYBFou0Xh/PYiJ4m3xY9V8ZglnVygm5mgqvItd7mMZZJjgnQg7ixvjvQBXK/XGTeMnb
	2upTOZ5fOPmuMk2CBV8koglGmLMzSvdTxWK+drlcz5cwrGSSjWxC7D4k9SY5IJfAtcMmUy17Z6l
	cjZBQOW4QVrxDWIf6etLvWxPHraV5TMOvvVMkVrlNEtfb83bfEPhf4ymUCSzv3ES/kwgpBGslr3
	IB7/6ZBJqk/YAjS9P4yw52WIrVc+a8KLCmABzJQn+hkTBHNGIbC2MJdRKjXmcc9CLHLnfju0dV1
	mrhsPLPn8UTOaeCRAlIk0s+bWwVJZ+qq9dBkFUFoNyqk4e5GOPWqplhzPE6IFNRVK5t81N1by9n
	EqqybAVbwnTLmGdxvFAGCLjpJB2bKSeSLQaYW3YlN4RrnyGORkg3EZbS4OT7MnAAE34prfKcGvH
	Hp7ubuJIg+099BvBzJ5JERbmrZK6/WoFnsYCm/gWP63fN/kDbzuPatgiJz7wVQAMhfX3R4tR5FA
	qhGItOuXWsIRf2X/vMSZ1YeP09iDDj39yF2gUUtYKgajrM+dQbK1b4tGAw9TVM2W1ccAcFuTyPf
	OqhwKcBaAcIky9hen/5eyRDb85CTnkn+f8SMGMrWX8EG+5R6lAc40J5sle/7WOpMN3dgCp4Jyac
	=
X-Received: by 2002:a05:620a:2709:b0:93e:920c:c00e with SMTP id af79cd13be357-9499957ea71mr827141385a.21.1795051631052;
        Wed, 18 Nov 2026 17:27:11 -0800 (PST)
Received: from linux.. ([8.34.174.240])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9499b4524c3sm318730885a.1.2026.11.18.17.27.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 17:27:10 -0800 (PST)
From: Changyul Lee <lcy8047@gmail.com>
To: Saeed Mahameed <saeedm@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Gal Pressman <gal@nvidia.com>,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Changyul Lee <lcy8047@gmail.com>
Subject: [PATCH net] net/mlx5e: Skip hairpin entries not ready in debugfs dump
Date: Wed, 18 Nov 2026 20:27:07 -0500
Message-ID: <20261119012707.555494-1-lcy8047@gmail.com>
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

Hairpin entries are added to the table before creation completes.
Reading hairpin_table_dump can therefore dereference a NULL pointer
while creation is in progress, or an error pointer if creation fails.

Skip entries that are still being created or whose creation failed.

Fixes: 0e414518d6d8 ("net/mlx5e: Add hairpin debugfs files")
Signed-off-by: Changyul Lee <lcy8047@gmail.com>
---
Found with a static analysis tool we are developing.

Compile-tested only, with x86_64_defconfig plus MLX5_CORE_EN,
MLX5_ESWITCH, MLX5_CLS_ACT and W=1.

 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 1d35c97aea0b..c6623f13261b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1067,12 +1067,15 @@ static int debugfs_hairpin_table_dump_show(struct seq_file *file, void *priv)
 	u32 bkt;
 
 	mutex_lock(&tc->hairpin_tbl_lock);
-	hash_for_each(tc->hairpin_tbl, bkt, hpe, hairpin_hlist)
+	hash_for_each(tc->hairpin_tbl, bkt, hpe, hairpin_hlist) {
+		if (!completion_done(&hpe->res_ready) || IS_ERR(hpe->hp))
+			continue;
 		seq_printf(file,
 			   "Hairpin peer_vhca_id %u prio %u refcnt %u num_channels %u num_packets %lu\n",
 			   hpe->peer_vhca_id, hpe->prio,
 			   refcount_read(&hpe->refcnt), hpe->hp->num_channels,
 			   BIT(hpe->hp->log_num_packets));
+	}
 	mutex_unlock(&tc->hairpin_tbl_lock);
 
 	return 0;

base-commit: 342e62fd34c2674e82bffc89cb5c7091924986d9
-- 
2.43.0

