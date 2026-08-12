Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774B7432E9F;
	Wed, 12 Aug 2026 11:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786535676; cv=none; b=UWJMhZ/Td9/p+BlHt9Q2ktJpY9E/zJkRbzrUz5s84IvCyEBfW4BWdznnb4pGD7chLn+dOVMYcd5iwTVUX9tk5WN+ti+BRW30EYawytHYJCoM9Bm+7vWnZoy43ZP7dCA2mFcAfKjwXrCMXKt8qM3nbgnxcaGUWQ7FFAUb64QZoBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786535676; c=relaxed/simple;
	bh=zbAyEYnXEacD2k8rlKIUdpEYeaLA6YWXj6MtSjpSzY0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=pTStmr+YwxJoeZwsGW9q3okDsJOYLLXTOE1wHi8RkXFbZNjcnVfcmH+BD5Nj9wz0qdkZpIeJ2Gwj+bzPT9bKG38hRltnowqpEnUIYZNNmYnAL7ExCDw6OpZBMA/SssxoxRTys01kNFIK0r9lNVV4+6lGYxt0GylL++jXFFd8C5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=osvdAEd3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="osvdAEd3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C6311F00A3A;
	Wed, 12 Aug 2026 11:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786535675;
	bh=M1erg840tTDR6JvlUdtF8ntH3URa484HDCNu3ufne9U=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=osvdAEd3Gvii9ZBXXtOEAUa1DSyP6/R/gVI6Xa7XkLnZveqb659IwNiW4/iJ39fd+
	 m826mVcsRAFKmyvq0sLGV7BlCk2s2Lk8eYkWEDbf65psGLJy3ItKQ+BLLQzzI8BruV
	 h531R38y4ixBc2kIFh7ensTzXUt5u6Ug5+gKkSLy2zuLlQGKKgiEDzX4f4U0XCBdjH
	 8f2BTuejWXOzoxp+NkQRySdxqBUdFE7gRRY0NCE9dn5r7yAdUWwIY/dX6ukYzU0k3i
	 cREsLufIX+kYifYM0FQkTOiJNtWu6enNJG9+hzaewLfhWcnJl1+S5xa5DuY0N7xo68
	 sRXdyAmRlmnRw==
From: Leon Romanovsky <leon@kernel.org>
To: yanjun.zhu@linux.dev, jgg@ziepe.ca, linux-rdma@vger.kernel.org, 
 Peiyang He <peiyang_he@smail.nju.edu.cn>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
 pandit.parav@gmail.com, dledford@redhat.com
In-Reply-To: <A8FFB80EB4DA06C9+20260730022827.2906506-1-peiyang_he@smail.nju.edu.cn>
References: <A8FFB80EB4DA06C9+20260730022827.2906506-1-peiyang_he@smail.nju.edu.cn>
Subject: Re: [PATCH v2] RDMA/rxe: Fix OOB in free_rd_atomic_resources()
Message-Id: <178653567224.16595.8974973380065494257.b4-ty@kernel.org>
Date: Wed, 12 Aug 2026 07:54:32 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Thu, 30 Jul 2026 10:28:27 +0800, Peiyang He wrote:
> free_rd_atomic_resources() iterates using qp->attr.max_dest_rd_atomic.
> Updating max_dest_rd_atomic before freeing the old array can make the
> free path walk past the old allocation and trigger a slab out-of-bounds
> write catched by KASAN:
> ==================================================================
> BUG: KASAN: slab-out-of-bounds in free_rd_atomic_resource drivers/infiniband/sw/rxe/rxe_qp.c:180 [inline]
> BUG: KASAN: slab-out-of-bounds in free_rd_atomic_resources drivers/infiniband/sw/rxe/rxe_qp.c:171 [inline]
> BUG: KASAN: slab-out-of-bounds in free_rd_atomic_resources drivers/infiniband/sw/rxe/rxe_qp.c:163 [inline]
> BUG: KASAN: slab-out-of-bounds in rxe_qp_from_attr+0x1e88/0x2150 drivers/infiniband/sw/rxe/rxe_qp.c:712
> Write of size 4 at addr ffff88802b8dddb8 by task syz.3.451/11063
> 
> [...]

Applied, thanks!

[1/1] RDMA/rxe: Fix OOB in free_rd_atomic_resources()
      https://git.kernel.org/rdma/rdma/c/2f96d52eabe576

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

