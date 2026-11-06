Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=159.226.251.81
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793957676;
	b=ahYGO8t4Iz27hGTV7KGApcmZfmVb5WwdwSL/FVjVwZA2iKaDjFmPewUPoxmx8KV+9tL2
	 nxzcfDIGa/AxGjYQk53GOolkeJiVNPmTUlJhFGhXpwP3ahKItC2O0CgpGY0M7qLI/Qgph
	 8yzXRoS5TSLuMwQ3Z6zPU8cxKiHS+Bq9uzlvSsVcPQtWAhNMsEgc+ay3waCV05wGS9beF
	 HLUWHltuMHeWsZ4qOPwDUcBulW4205/KfmaPVedDbiyiQp9Ttk7AtLYXwJrRGXG/IHPxs
	 TgLZpK48fjREspYleZALFYnQ8brRlan3U9ojXA7IC6yG0iuzOMzEMH2Y2RepBtflXeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793957676;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
	 X-CM-TRANSID:X-Coremail-Antispam:X-Originating-IP:X-CM-SenderInfo;
	bh=5DpkpCFdql2S/x8Err04oU2KI9wV3J7R3Kv596mw4Ww=;
	b=m0rWA12CqwJypwWXeWoyRvejqLkiNUtQMgfbzzgUvUI6ofEOZzEWjMdXSDBn358EyARU
	 ZKW/kk1cRlD/fNUOBkDAGqfmVmtCk9J7obmmm9O49QMNtMa+1lw71TybHj1IjWWibij4g
	 VB0rd6QSlMqqdX6Z/28zz9ag4GSKpwOpqG2u+5SrkECWkTvVHzrarHD1NP7pCViLm85JJ
	 gAB7tdzLOHAa0W71l1uHtvQ02UQhRE7Po3vfaHEH+2afkxkxKvBKeqzRx2su6/gQfaQp9
	 Olo1Qm/hB7Xgv+M4m+l0WOjWJqh8kwbDIDgIxamLLDTTSO71FJVBfybwOqKkwOgm2MA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=iscas.ac.cn;
	spf=pass smtp.mailfrom=iscas.ac.cn;
	arc=none smtp.remote-ip=159.226.251.81
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E81606A32D;
	Fri,  6 Nov 2026 09:34:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E0E81606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from fc87d0ffb700.home.arpa (unknown [36.110.52.2])
	by APP-03 (Coremail) with SMTP id rQCowAC3v5Akn+1qE3ZrAA--.5072S2;
	Fri, 06 Nov 2026 17:34:29 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: leon@kernel.org
Cc: jgg@ziepe.ca,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	rolandd@cisco.com,
	vulab@iscas.ac.cn,
	stable@vger.kernel.org
Subject: Re: [PATCH] RDMA/core: Fix member use-after-free in process_group_error()
Date: Fri,  6 Nov 2026 17:34:38 +0800
Message-Id: <20261106093438.366229-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260923084752.GN563127@unreal>
References: <20260916184555.2093238-1-vulab@iscas.ac.cn> <20260923084752.GN563127@unreal>
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
X-CM-TRANSID:rQCowAC3v5Akn+1qE3ZrAA--.5072S2
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYq7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUtVWrXwAv7VC2z280aVAFwI0_Cr1j6rxdMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1l42xK82IYc2Ij64vI
	r41l42xK82IY6x8ErcxFaVAv8VW8GFyrJr1UJwCF54CYxVCY1x0262kKe7AKxVWUAVWUtw
	CFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE
	14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2
	IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxK
	x2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI
	0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuYvjfU75l1DUUUU
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiCRIDA2rtky8q+gABsx

Hi Leon,

You are right, I looked at it again and can't prove it. Please drop the patch.

Sorry for the noise.

Thanks,
Wentao

