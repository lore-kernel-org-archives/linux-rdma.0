Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3376D361670;
	Thu, 16 Jul 2026 08:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784190603; cv=none; b=lPLLu8OozR60H4/2YofqI9PZMnqwquQ/Gbh7Z6mhRkKZ/lUMsWxd+aNVp/HLsDpxfr9mfO80brzxyXug/kfhwy7il0AkuH0DRAE34IkOwkBToSR/09CcjCUYxrFPZjnwRz4skBRTKKLgeXkAw8IE3J2ZsdZzMHrc1O84JuQCQ+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784190603; c=relaxed/simple;
	bh=1yDo93vSdvaPJ1ePWHSyVvLMFDIzHXUcL1TcPT/gObA=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=aCvCjKgAclS0B3O3CSnjXiMqGIslQ+hEBq7aVdnpS0jhqbT/BYJtgTh58dd4w0nhkP7C0OagZzLxXdg0Elyk4+h0Qt7mvA0vmNjcUdTkJgTtm5vEOwOsP5OAUMbtuF5XZzaQWvCIAKaUZw0YdxRzEPq0PLaL+EaVSp6sFoENUbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iO4VGqq+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iO4VGqq+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 225AF1F000E9;
	Thu, 16 Jul 2026 08:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784190600;
	bh=MfSdS9mjQz5XDxRBfstSNO5ePCzNau+ka3Qc5CrXL84=;
	h=From:To:In-Reply-To:References:Subject:Date;
	b=iO4VGqq+ESyG5QcTeYKuUODIQXjE5XWQBg5uCmL5RIo/PUS8oNu/1YH0Pq2dzs5L1
	 S3rGT2CE62tDDjattNR2z5uYnRN9m2Xs5XLbJBMgA54kl+zRxt2nLp+5w3TVyuozS7
	 eOKsbKKBRBa0tYp0FegEsrCcKdIvEo9sjofDwuKRqD2Ht/4nYRnACerj06FMeVNmKR
	 bgyGxC6zRbcDFArYgvbeqQAWI8u7jUOvA3+Px27MEX0ZXlm9aA/YP2SZMLg90+KiUC
	 TTjbDAl0m3URN+lDn2G5E1f0doE8Wxw83k6Q7z/agiWS0s7Yv4Ah3AQ2wR83W9/B1Z
	 HLp273oqRckVg==
From: Leon Romanovsky <leon@kernel.org>
To: yishaih@nvidia.com, jgg@ziepe.ca, linux-rdma@vger.kernel.org, 
 linux-kernel@vger.kernel.org, 
 Praveen Kumar Kannoju <praveen.kannoju@oracle.com>
In-Reply-To: <20260715080738.1357072-1-praveen.kannoju@oracle.com>
References: <20260715080738.1357072-1-praveen.kannoju@oracle.com>
Subject: Re: [PATCH v4] IB/mlx4: Fix stale CM id_map entries when RTU is
 never received
Message-Id: <178419059769.297515.12559710952711271768.b4-ty@kernel.org>
Date: Thu, 16 Jul 2026 04:29:57 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Wed, 15 Jul 2026 08:07:38 +0000, Praveen Kumar Kannoju wrote:
> mlx4_ib_multiplex_cm_handler() allocates an id_map_entry for CM
> transactions, but the entry is normally released only on DREQ or REJ
> flows.
> 
> In the duplicate REP handling scenario, cm_dup_rep_handler() may be
> invoked when the remote side receives a REP for which no matching
> cm_id_priv exists. In such cases the CM handshake never reaches RTU, and
> the sender side may never receive either DREQ or REJ cleanup events.
> 
> [...]

Applied, thanks!

[1/1] IB/mlx4: Fix stale CM id_map entries when RTU is never received
      https://git.kernel.org/rdma/rdma/c/548897f0f78837

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

