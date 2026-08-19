Received: from mail-pj2-f10.google.com (mail-pj2-f10.google.com [74.125.227.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 763CE480DD6
	for <linux-rdma@vger.kernel.org>; Wed, 19 Aug 2026 16:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787155541; cv=none; b=Nw0wycZFiuZIjwEZgSUT2hDoAguhgKpfHU8C45bJ1PSmN6bvCAsQpuIb3r0IK0vVCUZ6Qi/FuUaFeUUoGgPona1PKPMT9L6czUuI/UaZqPZLtOwAsEyeFQfX1kkT7A22SA0rw8h2B3R7qnVZtu0n3vF7SlWw2xox8ulJyAXC/nE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787155541; c=relaxed/simple;
	bh=2PLCByWGgAwhdeSGwInJPW8yjXmeKf4VnccaWVFyDiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fuvoRd6BlZKNLeV6YixDAfRouq0569wOOLHmXR/ZPI2dVWX4Dt2PzAqga4tTA3uR6JPMijcd1iWckEdVEfS/LkFjSKMDx5OUSHfjmmaIHOgMyIL0/6Z/loLFx7c57UaUL8UzsAeKaoYdqMOKzYBBEjPtWBOzU8+6BOzS5cNr154=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I4r++4To; arc=none smtp.client-ip=74.125.227.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I4r++4To"
Received: by mail-pj2-f10.google.com with SMTP id 98e67ed59e1d1-38dc4f9462cso392017a91.0
        for <linux-rdma@vger.kernel.org>; Wed, 19 Aug 2026 09:05:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787155539; x=1787760339; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=e7rQxNaXNWqb2c9lwuccfrB1MuTuQX8j+1HrCiB3XiE=;
        b=I4r++4Toa7TpOYhfu0AAjKAiDOoEBpYuAXB4f09fwwzc0G76OxMtJ5TpEtZXVwgKIX
         OP3S/lAoHgO+3tMp+eaxZaJw5XiZ3v6PkOIomnIvHVITNlkG7hGr5svI8kW+R+IrJSn3
         PuJ2MG8TSg4slbA5Z+03+VDdIawGvw7xe0HW2XT0VMXcqLcKdYKEBfedl23qVFu7qg8B
         5nz8rq5pR2F7Rs5OOAyEOY+XkbwgU/6n7IcOcXQLepn3OkcCUzpTqHmtuGwOUBljg7Dk
         AF4Nnnu9kib8gBzBk0UZXBeJ/g3BoX10BVSvun9kmhHANvx2o3oKPu85BPnyqGPz06MY
         +moQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787155539; x=1787760339;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=e7rQxNaXNWqb2c9lwuccfrB1MuTuQX8j+1HrCiB3XiE=;
        b=k4fPCWXmgSUHLThutHjQjGZD7UhozeYRQyOQ9kpq4Dhfx5aVkQuxN944dFC29A7oGK
         HnnSgrhZlGQPqGc4KX0d5uIQ87SVkVd9XnB0GB5BT5Ue2WjW25l5kX1TZ6cItBbChomn
         Bokvpl0HUzjWCWSmKNv9yIQ/yV4ND4epgok6TEFgOEs9+zuAGy4Lc6qlmTzjYX1+iT+t
         /JIU/szrUgC2kWJ9JyzL5Ay1gaZTOGKWbsQ9ouPdw5ff91akEOjWb7gwcDwMNhRXmivB
         E72rxRWWqtZpVlpeFGklQbLqxgD6ofN+QLZEN9dnf7hiPJC2lLbgDRj6yCsrSz9IX7Ld
         LQTw==
X-Forwarded-Encrypted: i=1; AHgh+RrR3CwluE75KDsBOgXfqPIj0d665nWNgx8/GcEajYrfco/jo7x8/YLGLlj5lmxtxfFNvIHIvmaID0S0@vger.kernel.org
X-Gm-Message-State: AFuF++m3eaIWbeaP02R5ZdbBsF4bAlKA1lsGMNN2NS3GuHNS8hRMV71+
	qT6C5VUsJtLXLCdQw8wze+9Q/T6MRgDEAKmzA2U+WZ2sYrY/U5oat3BY
X-Gm-Gg: AR+sD11/vjDtU3fEgkSvepR/6QvR7lxGLW/ypPLJJxRDFpg8uNVgBQ79XXgh/ZucLWy
	SMILQ0y+FFF9Tk30Go9PnDbR0ucaFzQnoPcArDUuY/1BptX/cjvLSB5gbqFV3NcyU95ddh90Ttk
	ZjrgLxjgf/7iohQ2R3xQrqAGPSalWBU/3uB+bQdg0DjOXh+M7GMtG3nzQ6HiGIRLDnnO3sSg5O/
	r+DkqGQ/vrRy3kifq748sFQmAiMJtYXZ1n3BiLcCl6enTjp/WPV1F0ULOsbfK4vz+pav/8UeBFA
	EuWg9B/vbcwan8PRC0+XOXOV10dsZaKx6BSllK9KZFc4ULQIlsNvFcpr19o8WocIknwailTeE9G
	KYmH454/Z1mRBztYRXd5XOAXFHmDk9+d6iXt5cz0gGoq4IVZkOb5JCBBelNI/EjS0joMN2ruAyA
	Ftw/vZJQJ2X8mG15J0MOyJpLynZI9mv7r4/4lsFm9amYp2mSPfVTM8ZA==
X-Received: by 2002:a17:90b:4d0b:b0:38c:a59b:5189 with SMTP id 98e67ed59e1d1-3958127d8bdmr9857765a91.15.1787155538709;
        Wed, 19 Aug 2026 09:05:38 -0700 (PDT)
Received: from localhost ([2a03:2880:2ff:54::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3957faf6849sm3011405a91.10.2026.08.19.09.05.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2026 09:05:38 -0700 (PDT)
From: Stanislav Fomichev <sdf.kernel@gmail.com>
X-Google-Original-From: Stanislav Fomichev <sdf@fomichev.me>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	anthony.l.nguyen@intel.com,
	przemyslaw.kitszel@intel.com,
	andrew+netdev@lunn.ch,
	saeedm@nvidia.com,
	tariqt@nvidia.com,
	mbloch@nvidia.com,
	maxime.chevallier@bootlin.com,
	mcoquelin.stm32@gmail.com,
	alexandre.torgue@foss.st.com,
	aleksander.lobakin@intel.com,
	horms@kernel.org,
	magnus.karlsson@intel.com,
	maciej.fijalkowski@intel.com,
	sdf@fomichev.me,
	ast@kernel.org,
	daniel@iogearbox.net,
	hawk@kernel.org,
	john.fastabend@gmail.com,
	guoren@kernel.org,
	dtatulea@nvidia.com,
	witu@nvidia.com,
	martin.lau@kernel.org,
	yoong.siang.song@intel.com,
	intel-wired-lan@lists.osuosl.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	bpf@vger.kernel.org,
	linux-csky@vger.kernel.org,
	leon@kernel.org
Subject: [PATCH net v3 1/3] xsk: align TX metadata layout across ABIs
Date: Wed, 19 Aug 2026 09:05:33 -0700
Message-ID: <20260819160535.1472459-2-sdf@fomichev.me>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260819160535.1472459-1-sdf@fomichev.me>
References: <20260819160535.1472459-1-sdf@fomichev.me>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add explicit padding before launch_time so xsk_tx_metadata has the same
layout on 32-bit and 64-bit systems.

On several architectures (csky, i386, nios2, m65k, openrisc, sh), the old
native 32-bit layout put launch_time at offset 12 and had a natural size of
20 bytes. Using sizeof(struct xsk_tx_metadata) as tx_metadata_len was already
rejected because the length must be a multiple of eight, so the
straightforward use of the interface was broken on those ABIs. Userspace
could still register a padded length of 24 bytes, though; mixing the old and
new layouts then silently reads launch_time from the wrong offset and
misprograms packet launch times. This intentionally replaces that
incompatible layout because the affected architectures are unlikely to
have any notable users. (x86_64 and arm64 have the most users and are _not_
affected)

Fixes: ca4419f15abd ("xsk: Add launch time hardware offload support to XDP Tx metadata")
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
---
 include/uapi/linux/if_xdp.h       | 1 +
 tools/include/uapi/linux/if_xdp.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/include/uapi/linux/if_xdp.h b/include/uapi/linux/if_xdp.h
index 23a062781468..50d67df78911 100644
--- a/include/uapi/linux/if_xdp.h
+++ b/include/uapi/linux/if_xdp.h
@@ -149,6 +149,7 @@ struct xsk_tx_metadata {
 			__u16 csum_start;
 			/* Offset from csum_start where checksum should be stored. */
 			__u16 csum_offset;
+			__u32 reserved;
 
 			/* XDP_TXMD_FLAGS_LAUNCH_TIME */
 			/* Launch time in nanosecond against the PTP HW Clock */
diff --git a/tools/include/uapi/linux/if_xdp.h b/tools/include/uapi/linux/if_xdp.h
index 23a062781468..50d67df78911 100644
--- a/tools/include/uapi/linux/if_xdp.h
+++ b/tools/include/uapi/linux/if_xdp.h
@@ -149,6 +149,7 @@ struct xsk_tx_metadata {
 			__u16 csum_start;
 			/* Offset from csum_start where checksum should be stored. */
 			__u16 csum_offset;
+			__u32 reserved;
 
 			/* XDP_TXMD_FLAGS_LAUNCH_TIME */
 			/* Launch time in nanosecond against the PTP HW Clock */
-- 
2.53.0-Meta

