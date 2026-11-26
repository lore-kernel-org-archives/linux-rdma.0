Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795695542;
	b=DnM70GV+WGnPicVUvLfUsIBtBDgBe0z1dO+znTYf+kEHAN8V2wp3tuzfCeFNuyh49L3G
	 TvnZzB6nblz8jgg9hApd9w0i3NOED4de+JlOkyt4WxQAl9W0DGBaoqjTsvqft/TPjeZCL
	 fFWRvBFdHh7ec5JYXBB9SGC4EiBqOB8S1y1HAuY3RpOwojiNPauoJ2CbWqgwLXkKYJZ9Q
	 fZyV8VLrVlMYHppKkrE05nUtoE+lSeZ6uL7JkEs5HqX1shhq3Q7EjKoVtHsl7E7Vk1aBi
	 ghiL1G0HO7rsTCXZiXWQWBGtq7BGfr3F3LM15QkTWDxZnvh1RwqVNhUxw3F+P5d8KSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795695542;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=2TVWFja+Cth+NdMQkyy4msOvx7MobbwbldDKZj2x2+M=;
	b=RBlaVmBZh91aGJEk/ou9uz5JtB727Ogs/KvdCKoaBigLqTuMWFffaF53O0uZYQnIaJ5n
	 SkJM90/xJwRwkG8x5OG5tIyCkr5xsisPtXGoBa4H0coA3roKXc45xM1xUGkfZsnq2aUXN
	 ehe1UE+affkjqPdWgZqIgTowDRgpP4FCIrBa3kuOHss1vc2+ZvYtlfr2+NPt3vLXlvN6L
	 LtVyGJe6YAsC4uqqgqDiNzt1nEqR4t8zlxbCA0Tt2+hBH0v7rUm12wJzhN3nbxH0AEWjL
	 JOe0oS0z9P7XGRUpJl97VR/pMNhRL/l1KcSYZz05pXh0FwaypFPOZcGWl2hhw1V96iQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=orXGA7BV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 528B5606A31C;
	Thu, 26 Nov 2026 12:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=orXGA7BV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D4F81F000C0;
	Thu, 26 Nov 2026 12:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795695542;
	bh=2TVWFja+Cth+NdMQkyy4msOvx7MobbwbldDKZj2x2+M=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=orXGA7BVheuI9J6jXHqYnDnO1N9D9xDQWsqA4Cm5A2fp9Bmpbt5i0AMuR+cDKmrN1
	 8QPE732WTNocxJOPOmv+cO8eSqaieyLlVCai4N1v+1Gz3/8cZwFVABtCSyZWg7S32s
	 6ewPfWxWWzSnaPJuNpFA3pFf6hF8EwcRcyUUZImdxLg/+XX0TOYXir+Zy8+45H2sDN
	 VjoDKcbJqMZZ3DUCB27QOS43BtqdkMAnSebeYlTy4eK3UgxUe6C6xRi5lhK5lhTmUY
	 +VVdblDFe/IwISS66JrKYj9dVjogVabxQnT+g319cV2qGYqUy8/Z5A7Mr9n/hnIU5m
	 GEEMfVknjauGQ==
From: Leon Romanovsky <leon@kernel.org>
To: Zhu Yanjun <zyjzyj2000@gmail.com>, 
 Andrew Stellman <astellman@stellman-greene.com>
Cc: Zhu Yanjun <yanjun.zhu@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261123140620.64393-1-astellman@stellman-greene.com>
References: <20261123140620.64393-1-astellman@stellman-greene.com>
Subject: Re: [PATCH rdma-rc] RDMA/rxe: Zero struct rxe_mmap_info on
 allocation
Message-Id: <179569553925.1262876.4833992620993528543.b4-ty@kernel.org>
Date: Thu, 26 Nov 2026 07:18:59 -0500
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
X-Mailer: b4 0.15-dev-18f8f


On Mon, 23 Nov 2026 09:06:20 -0500, Andrew Stellman wrote:
> rxe_create_mmap_info() allocates the structure with kmalloc_obj() and
> does not set info.pad. do_mmap_info() copies ip->info to userspace with
> copy_to_user(), so the 4 pad bytes of struct mminfo come from
> uninitialized kernel heap memory.
> 
> On x86_64 v7.4-rc3 under QEMU with init_on_alloc=0, an unprivileged
> user (CapEff 0) issued 300 CQ_CREATE ioctls on rxe0 and read the driver
> response. After the guest had run ls -lR on /proc and /sys and read
> /proc/*/status and /proc/*/stat, 101 of the 300 pads were nonzero. In a
> separate boot with slub_debug=P, all 300 pads were 0x6b6b6b6b. With
> this patch, all 300 pads were zero in both configurations.
> 
> [...]

Applied, thanks!

[1/1] RDMA/rxe: Zero struct rxe_mmap_info on allocation
      https://git.kernel.org/rdma/rdma/c/5d298f34048ba4

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

