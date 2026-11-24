Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795486417;
	b=fo+yHI9y1BGumT+Y+NiKN0Y6iDjJ6ImrLXmiabLaVaLR7igfI7GSbIAJP+tZjif6tpI+
	 jbRVwJZQFH1pAT50eze5So0rrDn9chyPGX0FTnFHvrsrUJD/Dj3Btgq+pv+c8jOzBqhVi
	 Q9AhicAC9VxWxL/jdDIid/meLE/pGPzpul2lMvbMvWw9c5x1G5ic0q4HLwQkw9rIJOsqc
	 0Cr/8hUqa+Qk0MbIQU1P1HcK4TOafVm9JJslqlHNTYGxDw+4jUuNQ6OMAs/sMhKNmyaL/
	 dqNFRTrH90B+Y5ODRnEoXt8fnNQILabzT+OyOgxR2ThjgrlEEqd6i91JYMaXpzvPJXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795486417;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=RpoOz1PymNRrUVM5m7m0Sy4ud7KVyLtzCj3ueWXw1Cc=;
	b=fq4rkBpnbNGjKo/xjqMRHYQF+EpUEVWKHtsNHKBx79FqROkcbBlsFl+p4y8fFK4TvoQW
	 17pQ5CusMj+phXXOBknVqvO+6FaI3iMh6hvcDdLjT2Tbcop4F73OcyWbWza7zePLyQNOZ
	 uBzlESFC6wZqxqVzVjbuYe/8RCOdYtXxAsoFVVSU2iaQhBl6Wx+QmdZRf8+yRGxTskx0A
	 368QKL7Jg5MmZ8WfCYDVO7f7h4sce17RxnhbM34B7NAnQ8k6uvh0JSeg4xJ3DlTUCcdm3
	 mzh2Apc/Pn7WS0qc83c71dj98kas9prmZa0mfTMCWRpzFs1APiGdbpXtuchgb/WnCAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SVcEzlid;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1A43606A31E
	for <linux-rdma@vger.kernel.org>; Tue, 24 Nov 2026 02:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SVcEzlid
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 429A51F000D2;
	Tue, 24 Nov 2026 02:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795486417;
	bh=RpoOz1PymNRrUVM5m7m0Sy4ud7KVyLtzCj3ueWXw1Cc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SVcEzlidJZFliIpDuYc3oxkCwkyYxJjvmZuvzP7btPZQ0fRPxz60Vmlsb3RSgtgYk
	 nhf0CmXtSE/idMRdjaPp0c+0PdJpUhyruGllSr3exdGHhX8hs/r/mxdgZi9BpqWM1w
	 KCqi2CZKP0kroffg7cFUa4HpxeE6OfFwzPVqFaYuLaCKsgNQHmL1mSsOZZnibY/F7s
	 2U0XSFc8klURQ1K23A7yDYZHBAdbYbkiH+68SLM/xDz65FQ2d59y7La7zE+Eu9/+Om
	 i8bidWfbUPpiRuPd/BUYhwKPVVawwy8o2QqoxC5nriFgnCwVtV+K+I7kDe9NmFm+yw
	 /eKvjTyh2mUSQ==
Message-ID: <sashiko-outbox-230388@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 0/3] rpcrdma: Fix device removal races and endpoint
 cleanup
Reply-To: sashiko-reviews@lists.linux.dev
To: "Li Xiasong" <lixiasong1@huawei.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261124021842.130141-1-lixiasong1@huawei.com>
References: <20261124021842.130141-1-lixiasong1@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 24 Nov 2026 02:13:36 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Sashiko has reviewed this 3-patch series and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124021842.1301=
41-1-lixiasong1@huawei.com
