Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E70914AD20;
	Mon, 27 Jul 2026 11:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785152771; cv=none; b=RN4xK0el66ZGEgLg+RvkF1IitnS47NmKMkJGsA2Jr5jGha5vaiy7K4FWtzER822+atk5LMpPE/y8SwiVb9HZl0SAwxRY7vDnU//sVo64tD5/9phDGOK1RhFVg0iM4pzPxPk51i1KVseo9VixrCRBFiudcs6Ro69ZEjp6asOybGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785152771; c=relaxed/simple;
	bh=zqm3O6m+QpEtrQ7UTdL+wPxmVKRnUbQbCwh77QEcsuM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=ZVlgB6NTly8eAXW4yBuNo1NaeDua1/gigWJy7Fr2RZ0zNrNk75u9qA9MfGgh/fRHyNO5dVmt2fVCqKpqzwaenKlINVhagsvZ/OEVvtleF01vf0qLMGIpwd3wjGlxVyJ5+9UdyNl/F+2IqOPBi9/FyZm6j7M32JaI2xxsL6Qa5q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KRsaDRGD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KRsaDRGD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FD4C1F000E9;
	Mon, 27 Jul 2026 11:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785152769;
	bh=0vSFFv78idt46W6ea0vfhA/gtTDHZyy1iWsNdScm0sI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=KRsaDRGDe0DsZoOcTizI7dE1eGz1hX3Thttna0Vt1fD4tVkz/+0wHCFEH8+itDkjO
	 cUQnMZaV9v72vNecpdBW+r5uB3ukQ9SriOEhJq6EhttJxvl/r1c6VUAWexZUDRC7wF
	 0qcB9ixlrJm514q32PFtWyHnA8oG4leRjVoFqn0e1a7yds/Y6sdcgdxi7TFKPjGwEN
	 rHma42U7HN3Bq1Uu6cSGDWR2JvzY1T+tr3WW5RFb4gMaODZAn8FFQ/pi6XIdK7HFyk
	 zjAxQoFmPiOnABeslqiQyd7BsfD6YZ6zgqN4cFLOCQdU2Hi49DOoQvmnKhe3QNljg2
	 CBK3r3dEm91mw==
From: Leon Romanovsky <leon@kernel.org>
To: zyjzyj2000@gmail.com, jgg@ziepe.ca, 
 Peiyang He <peiyang_he@smail.nju.edu.cn>
Cc: linux-kernel@vger.kernel.org, matsuda-daisuke@fujitsu.com, 
 stable@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <70CB6DBCB19624C7+20260727050659.1543627-1-peiyang_he@smail.nju.edu.cn>
References: <70CB6DBCB19624C7+20260727050659.1543627-1-peiyang_he@smail.nju.edu.cn>
Subject: Re: [PATCH] RDMA/rxe: Fix UAF in ODP init error-handling path
Message-Id: <178515276686.693952.13496892884500099278.b4-ty@kernel.org>
Date: Mon, 27 Jul 2026 07:46:06 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Mon, 27 Jul 2026 13:06:59 +0800, Peiyang He wrote:
> rxe_odp_mr_init_user() stores &umem_odp->umem in mr->umem before
> calling rxe_odp_init_pages(). If rxe_odp_init_pages() fails,
> rxe_odp_mr_init_user() releases umem_odp and returns an error.
> 
> rxe_reg_user_mr() then unwinds the error through rxe_cleanup(),
> rxe_mr_cleanup(), ib_umem_release(mr->umem). There is an
> IS_ERR_OR_NULL(umem) check at the start of ib_umem_release().
> But since mr->umem is NOT reset to NULL in the error handling
> path of rxe_odp_mr_init_user(), the check passes and it reads
> already-freed fields like umem->is_dmabuf, causing UAF.
> 
> [...]

Applied, thanks!

[1/1] RDMA/rxe: Fix UAF in ODP init error-handling path
      https://git.kernel.org/rdma/rdma/c/d7c244a453561b

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

