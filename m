Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC3341DE02
	for <linux-rdma@vger.kernel.org>; Tue,  1 Sep 2026 13:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788269088; cv=none; b=aDdujMSol2+SDBMn1zR+SO0dem45ye2hUpVBD6JKvg/UOLe2gX9IxXhEwBOJDYVA8o9h/ScP81ZAg73iKToPe3kCf2OtPxrT3GffTfurKvNCfT/Y2dFQMqknataSKlnLppNTBlPkuCfX6H2xEwZnNpzEpAciiGN5Cyf+RTrC8PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788269088; c=relaxed/simple;
	bh=h/RTCTmp9cloQD0As6xIJxTyyBxEMl+rhfZEJ25jy5E=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=uIyLTKAtdkrYRoQkrj2ov8atXf0vxMeSGkgQ/2pOwK9zmm2cjo3Y6/w8gzkMV06OuAkvBFqaMvTS1VeulGXb2YYTbkpYEbR/15/jDn8DrHafXhQ59o86R19ng19/JZk7z+VIGGBX+etUaPGplmFO/S5DOxLanQbZF9nzjFgPVMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AULkS1dm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AULkS1dm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68FCB1F00A3D;
	Tue,  1 Sep 2026 13:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788269087;
	bh=QE8thre2CDXTJwBk00VwBJ4ZQSEhrK5Faj2vy7C5kBA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=AULkS1dm/72/s2sHZOQJz38aZQZCymohqcO1luTv1mudkSqKKhHxhef+IOtfh+bE5
	 ezkUJa9Rf5Xemvs7IWG8XoJTjutprL1NYQG43Cn2UdIZGTaq7/rIrSnU1n9Ctfd4Y5
	 Xg0S5iqPNjDQDF7+li3fBMgRTJokFVZ6Bn1k99girZHgpQA4m1CaGLKFR8Bwtn/tAe
	 NGpcbaJkIcyJs+KEuV/PQsDKM9KmUTrEhby+bFpJ54ZGJuR90OnwQXFUfKiabwUbgA
	 zveeM8rJ+uGaFC+tDiARZHEvjuwQh2guTdbWnV+Bmm8xWVbpxRM4HJo3M3Z2iwg5IZ
	 +NLqx6vUnJI6g==
From: Leon Romanovsky <leon@kernel.org>
To: linux-rdma@vger.kernel.org, Weimin Xiong <xiongwm2026@163.com>
Cc: yanjun.zhu@linux.dev, xiongweimin <xiongweimin@kylinos.cn>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
In-Reply-To: <20260716055255.157674-1-xiongwm2026@163.com>
References: <20260716055255.157674-1-xiongwm2026@163.com>
Subject: Re: [PATCH v3] RDMA/rxe: Hold netdev reference for transmit skbs
Message-Id: <178826908418.1330026.3320395867822374068.b4-ty@kernel.org>
Date: Tue, 01 Sep 2026 09:24:44 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Thu, 16 Jul 2026 13:52:55 +0800, Weimin Xiong wrote:
> rxe_init_packet() assigns skb->dev from an RCU-protected GID attribute
> without holding a netdev reference. If the netdev is unregistered before
> the skb is freed, subsequent accesses to skb->dev are unsafe.
> 
> Hold a reference with dev_hold() when the skb is initialized and release
> it from the transmit destructor or via rxe_put_skb() on error paths that
> run before the destructor is installed.
> 
> [...]

Applied, thanks!

[1/1] RDMA/rxe: Hold netdev reference for transmit skbs
      https://git.kernel.org/rdma/rdma/c/19881618ffa454

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

