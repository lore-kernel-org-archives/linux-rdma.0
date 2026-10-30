Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=82.195.75.108
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793377916;
	b=Oci34ZhrCDE5ey+U0Aw791x0t7XRW2rSt+GBOWFlnyEqvqnZgNSEzEctmDhH3EUxvF5i
	 cTJwbKqNsg3W4M9rZVfU9vt1j71NLOQsdKhM7jUwXCEDKbI5cgvp0DQEaDkH/N6iE/hPv
	 MUjd3pOfb2dmkaN7LQ0Cd54v5njARiUifuOM+D5cPP5O7ukGvBDVOpbX6peSb6q9bk0mI
	 D1gw6gA3XMCYUuyCJGk508Ho1/qaJDeGpUHgDBXKQt2gaVcZdXbXzSp8FQNH3cb7Cb4fV
	 c/3d5yNeVMQf6Wx+izSmpa8GCMCzYCrQ4aSM2O1W0JA/nKqeBQNLvEob6c0AyQuL+fQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793377916;
	h=DMARC-Filter:DKIM-Signature:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Debian-User;
	bh=18iLjx7wEgVFJMWjkIMOjrBL+KFsjnRPIBJEFlbdmjc=;
	b=UEm8gDdnCsBtgvDFrI1sMxqQ1PFocfqx3Wg+NlugchMTYzaJ6uUl196PaMM16GM7ds9l
	 foq6HQW15xXqG1JEqq8hEFNbu7cawwOfEGq80DkIm1LksxHrQmmWb4iDXYnwEGpuhHl8c
	 rLFBGfCOEPbjJEOMIubvpTaGvMnGzlmBVGyrxMXsQSjl9wBwsN3UPNUsPBGDVaDjgxCKw
	 NVFzSF+0gBChalOSPVpBuQsCUUlsdjv6nUvw/RrX8ZSm61n19xgTgHaF0weurY/SKyUEO
	 kBiVJJKIKZ5Hr9OiWK1BvDFGTV0UiwQSBTamq5vA1R1fsVCUqbc321Dr2Qe05v3YszQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=debian.org;
	spf=pass smtp.mailfrom=debian.org;
	dkim=pass header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=fBbgBfwZ;
	arc=none smtp.remote-ip=82.195.75.108
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1101F606A31C;
	Fri, 30 Oct 2026 16:31:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1101F606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=fBbgBfwZ
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-Id:Date:Subject:From:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=18iLjx7wEgVFJMWjkIMOjrBL+KFsjnRPIBJEFlbdmjc=; b=fBbgBfwZBI7t5A1Qja0Z6xR5Zh
	80mbJmMoLiW0Xjg039OjFMOlVm7jYeJiVq2j3K7R8jI32Jio4ZwGzDUQxTy3dUGZmSVIPk3BYMN0X
	ZVw21m9mju3B+LD8sowr9rz57eHN2vEHLAa4Qz+qcZFfTfZ++yc7guHY5leYJytiSRir+aU8Hk4Xt
	v02EHKcjnQLug47DN+OMkCHkuHCAHP9J8H13mrNePOmOAeorCJOeFCQWsR+V7YHSGEKbvQ/yWtCdL
	LBPnDbkRL7yClDCmlHRACP4jajhwhokW4W/3m3DQp6gZFUuATKfS9XOqUWY/lBWDtmkFBJqvH72dW
	yAfMBapA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xMpWA-003x1s-02;
	Fri, 30 Oct 2026 16:31:50 +0000
From: Breno Leitao <leitao@debian.org>
Subject: [PATCH RFC 0/2] net/mlx5: Cut workqueue traffic of firmware
 commands and stats
Date: Fri, 30 Oct 2026 09:31:42 -0700
Message-Id: <20261030-mlx5-cmd-wq-v1-0-1458b2aed637@debian.org>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAG7G5GoC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzNDA2MD3dycClPd5NwU3fJC3URDUzMLY6C4SWKaElBHQVFqWmYF2LRopSA
 3Z6VYiGBxaVJWanIJyByl2loAkhji9XQAAAA=
X-Change-ID: 20261030-mlx5-cmd-wq-a156836104af
To: Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>, 
 Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, 
 Andrew Lunn <andrew+netdev@lunn.ch>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Breno Leitao <leitao@debian.org>, 
 kernel-team@meta.com
X-Mailer: b4 0.15-dev-47773
X-Developer-Signature: v=1; a=openpgp-sha256; l=1993; i=leitao@debian.org;
 h=from:subject:message-id; bh=fSYl3YbyV2t6dd8c0/OYqNO+5zzMvz+WgutkCutaf7k=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBq5MZysrKXg7y6xjuVzIDGwQqgOhGpKI51hAczy
 /Q71TivthGJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCauTGcgAKCRA1o5Of/Hh3
 bXf+D/9VTpEbaUSWrfBo4XO7zEo8VTP2E9GDAdqPBNa+x1+tiITaryl4wU+YQtmUG5MUeHF/Jwi
 9JB331eUDcyRABbMwJTw/vyQLpMUVnmvf8hi/3Rnj0krVA9DjP6U1qN84aQL7VqCQi4pAqhJPJf
 yExm4uxyuaVr8/Kf+SJUPVy6TC69Mzm/NgIIxPp+p2s/4dOI7TUAKTGmibpojYQkRUzB6peEixO
 RYpDCN7Gsw9KpUn/IHdnhX410hgDN0JH2aoCzUHn/9k35CfF7mg1EisGQ/eBJ+Lt1cE47UGFPul
 yelSieAmggekIEXtV0bTvImklLpNFoX5XC6TDQfUKoqJ1cPLU7Snr9HJus8A6k8U/5WYrCfrX33
 swAqnxozXRzK3itnj1NxItHXydyh5WKhmtzbZuu01gV/apVoQBIwt9L1TSkDATdjIrcJs6CKMDH
 NyvLDVLc08Bk3f6UqiZa4MC0BgdW4+fGkFDG+xcVAXgAb6659xureWag356JLVLH/BM0noobc3/
 BXpEPSBWsN32s3/SLbPqBPiz7USkdAspJPIcdEUPneSrJ417q+CaKSU2cfzlrNLz5pRc8T9AiTA
 w+VHY2JMveBY+xtF9vVMcBi5VCb+B3OiBwtD4/vSKodOmc3rQC8bi6xeB5LCa8AA0hdQibX+q0t
 QvpOVfQpP4S2AYw==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

While looking for Meta's arm64 fleet wide lockstat, I found that mlx5 is
one of the major culprit for the locks in the fleet, and this is the
motivation for this patchset.

On an arm64 host with a dozen mlx5 functions in switchdev mode, lock
contention profiling showed the pool->lock of the unbound worker pool
that all ordered workqueues share as the hottest workqueue lock.
Monitoring daemons read /proc/net/dev, so every mlx5e netdev keeps
queueing update_stats_work. Each refresh sends one to three firmware
commands, and each command is one more work item, on the ordered
cmd->wq of its function.

Patch 1 submits blocking firmware commands from the caller's context,
as page-queue commands already do, and keeps the workqueue for
callback commands.

Patch 2 brings back the 200 msecs stats refresh interval that the
driver used until 2018, as the minimum time between two on-demand
refreshes.

Tested on a ConnectX-4 Lx host (x86, firmware 14.32) against the base
commit, in legacy mode and in switchdev mode with 8 VFs. With one
/proc/net/dev reader in switchdev mode, the firmware commands of a
13 second run drop from 13.4k to 1.8k, and the mlx5_cmd work items of
32 parallel ethtool -S loops drop from 46.7k to none. Channel
reconfiguration, switchdev enable/disable and the load above ran with
no failed firmware commands and no warnings.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
Breno Leitao (2):
      net/mlx5: Submit blocking commands from the caller's context
      net/mlx5e: Rate limit the HW stats refresh from ndo_get_stats64

 drivers/net/ethernet/mellanox/mlx5/core/cmd.c     | 3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en.h      | 2 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 9 +++++++++
 3 files changed, 13 insertions(+), 1 deletion(-)
---
base-commit: 4dd16e31135ea8437a720222df34e8745f385d6d
change-id: 20261030-mlx5-cmd-wq-a156836104af

Best regards,
--  
Breno Leitao <leitao@debian.org>

