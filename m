Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE2F2556E;
	Tue,  7 Apr 2026 01:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775524799; cv=none; b=MEjtA2QzDd5k32e2TVYHnPqdsavmd+2qEY09ryBvN5lzooNQEX/LUPqq0oGDXOLTOFCzgtAUf4ekd5Jz4eYfAFIBrXQAFXs+jRNiTBCxuv7SgAEZ7KQWyt4hy5qGuxoIrvrIlxuXiPjzabG/Gxm782W+Sk2dCvpEyYb5/rSzzl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775524799; c=relaxed/simple;
	bh=PLcLg4WwUSV/6I/ub2ZtYdVWKpfYp+2/iJXwjJKaZ8M=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NOq2f/hWq/2eESQKWud66D/VhJyX7xDmDvQayi1pdb2Uy3qHNlySbYMceenyxH2KCMi2yUb7IbM+HKCC3Ir9NMUQe8zLQs1IPU1NQKBfldNmBSbQSnQ89oQJlea6r5/vPymHCf+ULDG7BHWGLF/Sa671UnHYpbyKg0gJp+7Iha4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TltX10YM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TltX10YM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57285C4CEF7;
	Tue,  7 Apr 2026 01:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775524798;
	bh=PLcLg4WwUSV/6I/ub2ZtYdVWKpfYp+2/iJXwjJKaZ8M=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=TltX10YM+P3/+/lElWXycvjj3cmY/Og0mpBZSG39/fhyTkQVTnP+Upy4R4A+PaoB/
	 MZon6TXWwgmtY+qVNI92GRHFt5YJSA+D7outKNMQ9AR9Vn7wFqMop2KfAhskfa4nIa
	 yrxaNKAindt/rtls21MOquOEaYawnv5lwVLgiy3UcMW9aJPdsqssQ7ynDStiRpMapr
	 II8HiTMimleeidya3kvWNKpHvmk0UfK0g+cOatyxFI3jJ547RpfIglCprpAxD6O3M1
	 zTvQ1FAgLhFN4zHZWHzu39c6HjX2/WH1gTqvKtz41Ad5TkJ6kwPAta93YO5CQRZ2i7
	 E11hz6LU7te0A==
Date: Mon, 6 Apr 2026 18:19:57 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Allison Henderson <achender@kernel.org>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
 rds-devel@oss.oracle.com, horms@kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net v1 1/2] net/rds: Optimize rds_ib_laddr_check
Message-ID: <20260406181957.4bba8580@kernel.org>
In-Reply-To: <20260405041613.309958-2-achender@kernel.org>
References: <20260405041613.309958-1-achender@kernel.org>
	<20260405041613.309958-2-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat,  4 Apr 2026 21:16:12 -0700 Allison Henderson wrote:
> From: H=C3=A5kon Bugge <haakon.bugge@oracle.com>

> Signed-off-by: Somasundaram Krishnasamy <somasundaram.krishnasamy@oracle.=
com>
> Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
> Signed-off-by: Allison Henderson <achender@kernel.org>

Author's sign-off missing on this patch (I sent out the AI reviews
as well, without looking, take them with a grain of salt).
