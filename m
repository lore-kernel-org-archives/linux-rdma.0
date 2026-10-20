Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792526331;
	b=qJbN9geZYcRhY/+nR/1dyAJmub6xzjNC3he4Ma762sdZgXgyxkW0KKe5LmPcxG4QbLRb
	 4B64b7ww1kzfsP+A2Y64ujbs8r/aQAe5+EGUXuAQCRiTpKSzqwZs1ZIonam7JNLKTfYma
	 mBnEYKJuleV6cQCg77G6a1YJO8tZ2RMCpInGm8z8Gb4KiAdghbcigRuf081+k1ylS/vhF
	 qTLag1+bVXwMHF4DL/TSTYm6aWsLEGecnxNKZEMLUfNEm8ZLtbnWgugfFRkUV9dTzzkeT
	 tCkBODCffoZaUaG/EPbIT9PmNrfXE2Q2Cg8gZxSQY0nixQF0EP+GVMiN6/4ekeEsfBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792526331;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=gS/FsaYBKpeu/L8hLJ758OOpwjOjFow/Zq1oHAZ5OVQ=;
	b=RblGuzXo4w2wr0ASOFCjfqVfxKlA1zCc2We8XGtbwT+dZsBRoOb15uhF9QF6MsMZKHKp
	 fObTceQQB2uBuRPOYFNa87bMdgEZ8eXvMNiy4X4lNVqEvriJNTNs2dQWdM7JiQNMSdx+Y
	 WgDMq+/DFc1AlPFEqDY1GeCI0b/idqbuDKBvT79ydXBa12Zu+bXWqQZxsEVGFF81S42kC
	 XpU8ZG5TvTMW/JFqbfAiONN7cYllBDBYgB3q/pT8ghLgmAIY+Lp7luWdXQkOoiNoGe92z
	 ncaK3F+/JM4hN/MZnWMgh2DZYMchOm6pZk/UDfLe4aj9hTlpZuo3SqwRAgeYtBzABGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XJUo1IOn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD44A606A31B;
	Tue, 20 Oct 2026 19:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XJUo1IOn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E647A1F000CA;
	Tue, 20 Oct 2026 19:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792526330;
	bh=gS/FsaYBKpeu/L8hLJ758OOpwjOjFow/Zq1oHAZ5OVQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=XJUo1IOnXoAoAkKeYWvB0oCfNEpJ0qtSGmjkLYyx/oxXLSn+gWuUd1bMhk8kTk/xQ
	 ZAM/mM5Nl+lUsNUemt1O/dtCh42wmGU1xdogMqFjTu2nszAN1dgNaBiuNWTIymb64n
	 z1A3xKufgobUH2NYf1POG+giYjPLJGhgJAq5WFwibZigQS/ByNZV0ccr7FHaTgPI9E
	 ykBDO4nvsKa8nuwbrBrMhAxHDqoTgJM2H7Z6XWZQWFhJJMtPVOqsyWnQtAQwCqSwjg
	 7g3O9CEa+DYJEF4rGD+lV6fy8FXdRBM3BdnxLfJ8qLy8XqE/Rt6CtXr9Xh+E+YZFZS
	 +mPiMUUEauy/g==
Date: Tue, 20 Oct 2026 12:58:49 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: alibuda@linux.alibaba.com, dust.li@linux.alibaba.com,
 sidraya@linux.ibm.com, mjambigi@linux.ibm.com
Cc: Chengfeng Ye <nicoyip.dev@gmail.com>, davem@davemloft.net,
 edumazet@kernel.org, pabeni@redhat.com, tonylu@linux.alibaba.com,
 guwen@linux.alibaba.com, horms@kernel.org, linux-rdma@vger.kernel.org,
 linux-s390@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH net v3 0/3] net/smc: fix link group scheduling,
 registration and work lifetime
Message-ID: <20261020125849.67c40566@kernel.org>
In-Reply-To: <20261013091716.1210420-1-nicoyip.dev@gmail.com>
References: <20261013091716.1210420-1-nicoyip.dev@gmail.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 13 Oct 2026 17:17:13 +0800 Chengfeng Ye wrote:
> This revises the two-patch v2 series and adds a separate fix for the
> running-free_work lifetime issue identified during review.

SMC maintainers, please review.
