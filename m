Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6658C430CE5;
	Wed,  2 Sep 2026 10:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788343476; cv=none; b=ViYxwoCCY8+xweLheaPulu1s0DRrshbZPjkozrZXv4V0E3j5kZVk6t1rq9zsRwUX6SiXrHFT9eOxmhW7gB8zD50zp0/gvJ2W9OYh6CPOlKeaqquw2rA2omcsQDMBzsjzgfGog8vCdEZmEAb2l8TgTzdk9Fazr+/KQubc/s/2Cak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788343476; c=relaxed/simple;
	bh=DLTMfrvu1QIrUS9tXdB1N/8MVQ/EH10N2IWKdI8yb/M=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=tfCbJ74KzGKfSZJSSWUC8Erhd7ZDDNFSGrVWOrOD4RFIQVTDUFsR40FvTwB847pFWv+BYhJG44uD/FTd17/I92VeYGqlaz5Cym1QRZ24C/JpHplAI39fwyR4uzsr6L5BeTKnQxNxde9f+ydMOm3p0hUyR+h4RGCU736dYgSQS34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cUBQpUR5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cUBQpUR5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 468D11F000E9;
	Wed,  2 Sep 2026 10:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788343474;
	bh=rpzlV4/Yf+sy4O+eIti8OmLdYKW/h4FTsNh4s5VxM+w=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=cUBQpUR5uS/k2lmcb6qAReYonBlp59HhNIVgjIBsoYubSpPfz0SlpaFet0iozS5iF
	 UBHJWdvhWYyu3fSzYjkNHk6b48JBnuqGvEUyySQm3MxeNQF3H3QBmhFN3rFY2VSZW5
	 94qoqj3mLCmHjttXpUHly4Q+dWFR4WoASSM+wTZKppT71JoGCedJgaMI1aHzK1e0M0
	 221rZp2plQsPiTM2q9bs9HbBOV69NOBXXLwxi5YiliPBqspbziB6Pu77YxuNjDSdFO
	 Jw+zE11Z3/uLObCB8z95aOMTBreFf16BJ0/HKgRPHpEXGd8gQKXpHRDx42unLOJWoq
	 Xyrhm21K59qqQ==
From: Leon Romanovsky <leon@kernel.org>
To: "Md . Haris Iqbal" <haris.iqbal@ionos.com>, 
 Jack Wang <jinpu.wang@ionos.com>, Liu Zhenlong <dragonliu2018@gmail.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Jack Wang <jinpu.wang@cloud.ionos.com>
In-Reply-To: <20260818163513.53875-1-dragonliu2018@gmail.com>
References: <20260818163513.53875-1-dragonliu2018@gmail.com>
Subject: Re: [PATCH v2] RDMA/rtrs-clt: use find_next_zero_bit() for permit
 allocation
Message-Id: <178834347208.2349857.17862714329821137793.b4-ty@kernel.org>
Date: Wed, 02 Sep 2026 06:04:32 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Wed, 19 Aug 2026 00:35:13 +0800, Liu Zhenlong wrote:
> __rtrs_get_permit() scans permits_map with find_first_zero_bit() and
> claims the bit with test_and_set_bit_lock(), restarting from bit 0 on a
> lost race.  Use find_next_zero_bit() to resume from the last position so
> a lost race does not rescan the already-set low bits; on reaching the
> end, wrap to the beginning to exhaust the map.
> 
> 
> [...]

Applied, thanks!

[1/1] RDMA/rtrs-clt: use find_next_zero_bit() for permit allocation
      https://git.kernel.org/rdma/rdma/c/e1ab109df034ee

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

