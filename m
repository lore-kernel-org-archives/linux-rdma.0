Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20EE6481DD;
	Fri, 18 Sep 2026 12:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789735832; cv=none; b=XYokt+txLlYrOYHq0zR6gqAfXPa+2uY7KrI0YW+ur3DG3yQ9OfOJcttuk0C1zIGiWTueYRtM9Sm1fvZwWy9ylRxZXimKV/gEfPxw6JEbY/tNwQgxHz/z3Mm+ig+GxivjTlXmVyY3Bso+sR1XjAsw9lZfogW8RH+DABUxAkbC68s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789735832; c=relaxed/simple;
	bh=d4wbW/sNLpm6GDuPVHGXrH+UuCL7KDo9SWcCK8ULgjQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V8aXEA5H25wOx4eVcXo7y4eRR8UPITPDKPbOBJnbPJGU+u00+pmJfbgjjU2ft2gkDDT8OarUndKEteArOsddaQ4gQrtZ3f5v5JLFA/Ql3qmvr0YPJ4q7IFyAOeVXYiYGwsiq+9FJGbGShTrFxHFHhUadn6yp/dRBhudVQYGtYXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mCtjIEhk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mCtjIEhk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA4321F000FF;
	Fri, 18 Sep 2026 12:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789735830;
	bh=4ZFIgBf3dFbr9mkY07ho6ySuIxAVZa2yD5JuJV/yFSM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mCtjIEhkI3tc42+aMwhuVcT66zISUnOher23d94JiYfpAKPgP8czeOK1N0/0XU27Y
	 MgjtdMGUut2YXNIs/YcEbWvbGXmn/a2E7T5wue33lVdxvjzcaySn0rLOxCmkuiF5EK
	 aA3UpkgZ5Wcic9hD1lTS5L1Rq7bm6EffI9RYmfX8l+5MIGmx3cKrOML6Dw2S+ZZHKu
	 HQXMFEC0Q/msKaNaAFxCWKEkhCHUQZmN/WAcaXGjeVh1g8TfsA8wB8KDy+Tu82gK0H
	 sa7CzXFirv+6gDFX6L9tjqOvXrYnk0mRYp658539NG98hf+wTv7qoeGzR1P10DQ1yr
	 rEt07xlBSXLog==
Date: Fri, 18 Sep 2026 15:50:25 +0300
From: Leon Romanovsky <leon@kernel.org>
To: norbert@doyensec.com
Cc: Zhu Yanjun <zyjzyj2000@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Bob Pearson <rpearsonhpe@gmail.com>,
	Daisuke Matsuda <dskmtsd@gmail.com>, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org, Zhu Yanjun <yanjun.zhu@linux.dev>,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 0/2] RDMA/rxe: fix ADVISE_MR prefetch on non-ODP MRs
Message-ID: <20260918125025.GY13683@unreal>
References: <20260913-rxe-advise-mr-v2-v2-0-b806c789871c@doyensec.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260913-rxe-advise-mr-v2-v2-0-b806c789871c@doyensec.com>

On Sun, Sep 13, 2026 at 01:45:14PM +0200, Norbert Szetei via B4 Relay wrote:
> ADVISE_MR prefetch on a plain MR runs to_ib_umem_odp() on a struct
> ib_umem, giving a KASAN slab-out-of-bounds read in
> ib_umem_odp_map_dma_and_lock() (splat in patch 2).
> 
> v1 checked is_odp_mr() after lookup_mr(). Leon asked for lookup_mr() to
> do the check itself, off mr->access. That only holds once mr->access
> cannot disagree with the umem, so patch 1 stops the two paths that
> assign mr->access after registration from touching IB_ACCESS_ON_DEMAND,
> and patch 2 passes the flag to lookup_mr() in both prefetch arms.
> 
> Patch 1 adds another failure return to rxe_rereg_user_mr(), so it
> depends on ae36a5b609ae ("RDMA/rxe: validate access flags before
> swapping the MR's PD"), which moved the validation above the
> mr->ibmr.pd swap. The series is based on for-rc.

Please rebase it on top of for-next.

Thanks
