Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F20644A72C;
	Mon, 14 Sep 2026 11:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789387186; cv=none; b=XyEs1R8jRRDhuriUn6yxZ5KDGajmyEUnFOjOWwpCJHN7faGZPLhrnXY6grDRRbVMzpJBLAgWDLxJJDsPpT1MjENse1A/7vyyItithjGgVfW5VMUGKitk0r5se5o8i28xDrlmWPnV88SHTGGeLGRT6rtCriVMKNLeYQpiFsdk6Pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789387186; c=relaxed/simple;
	bh=GLF39awVILJGkHZ6UOyQqoWvwO3LUyGdhLhWPJbuBoQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HfXPXFZWGt9xfngkmBR0ooWGfp+M2VHnNEJfiSqW3aQ5ZorNajOTYIurTKYqNLQp5856HouMoa9CXvzHjiOxY4GTln1ZQRYeBQgNMs0rjQf8/hZwdTf8HoNXuyM5tahm4NO/BgsvTWDbUti7go9gaWYW9ufMjMEPiRg0KY8GkHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g5mVfeUi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g5mVfeUi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 351511F0089B;
	Mon, 14 Sep 2026 11:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789387168;
	bh=SHyLSrR28tVrch564QTckP01wh8w505+im4e5HFEDqo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=g5mVfeUiRmEtO7eoNPx4fe5UXzgvGSLrciS/yj18DFrbzrKppT2vyxfizIlsSONKL
	 3K1T6qSitkG3WFtwFlUHjyjbwAZLX+yv79E7fqDBCmXnDPDi+sKO2d5wMHKkd594R4
	 Rau9W90fRQ4rlp36zyDjg0uBemF9Tpvf5FYM5lj5gKOJcWEmubtw/ENNvQAgsCDBak
	 R6OtbAKSU3SnNK0rF45lzFfvUAfubWRD2G+66/CzhhHIgm17XOr4awSyHXhTzwXqwc
	 xLhHgXA2Ng11iTaPVer4Z718hzPiWCrCLX1OxmolVG1QSYHqtr8JVx9Ip/b+r6/khG
	 TJpf72pCFeqyw==
Date: Mon, 14 Sep 2026 14:59:25 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Abhijit Gangurde <abhijit.gangurde@amd.com>
Cc: jgg@ziepe.ca, brett.creeley@amd.com, andrew+netdev@lunn.ch,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, allen.hubbe@amd.com, nikhil.agarwal@amd.com,
	linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [for-next v1 0/5] RDMA/ionic: add SRQ support and firmware
 assigned CQ and SRQ IDs
Message-ID: <20260914115925.GZ13683@unreal>
References: <20260908090802.152142-1-abhijit.gangurde@amd.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260908090802.152142-1-abhijit.gangurde@amd.com>

On Tue, Sep 08, 2026 at 02:37:56PM +0530, Abhijit Gangurde wrote:
> This series adds ionic Shared Receive Queue support and lets firmware assign
> CQ/SRQ IDs when the LIF advertises qid-allocation capability.
> 
> Patch 1: extends the RDMA LIF identity with SRQ qtype and alloc_qid_cap.
> Patch 2: uses that for firmware-assigned CQ IDs and splits CQ create/destroy
> so cq_tbl is updated only after the ID is known, and removed before the ID
> is returned to firmware.
> Patches 3: Refactor RQ state into ionic_rq so QP RQ and SRQ share init/destroy.
> Patches 4-5: add SRQ verbs and EQ events. Userspace ABI field srqid is new
> with this series;
> 
> rdma-core PR: https://github.com/linux-rdma/rdma-core/pull/1799
> Net changes pull request:
>   The following changes since commit df2908090cda368b01ff43709f51890076c56157:
> 
>     Linux 7.3-rc2 (2026-09-06 15:07:20 -0700)
> 
>   are available in the Git repository at:
> 
>     https://github.com/abhijitG-xlnx/linux.git ionic-shared
> 
>   for you to fetch changes up to 4d77450be558f140997fe23b362e4049c0ff0d74:
> 
>     net: ionic: Fetch qid allocation and SRQ capability from firmware
> 
> Abhijit Gangurde (2):
>   net: ionic: Fetch qid allocation and SRQ capability from firmware
>   RDMA/ionic: support firmware-assigned CQ IDs
> 
> Amit Kumar (3):
>   RDMA/ionic: segregate rq related fields from ionic_qp into a new
>     ionic_rq struct
>   RDMA/ionic: add Shared receive queue (SRQ) support
>   RDMA/ionic: implement SRQ event handling support

You received valid Sashiko comments. Please address them.

Thanks
