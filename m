Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94A44353A7C;
	Mon,  7 Sep 2026 08:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788769654; cv=none; b=T4BkT1h+ehQDOaTZR5uL0A3BpyheDjpzf8mvKVZE8QKPF8XaSO5SlqVBiX24c1/rj86bxQG9pz8IOXndH6S5odscfFA5+025pcRQdHnbBzCvdKn3r2FLMSSYLQahrXo3CyxDWapmSTJ9g5uvOUQusNrcUW9NuMCSoP/lcMl489E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788769654; c=relaxed/simple;
	bh=R6CZvmqKQVrt9c+UdoY1gnKS5oX2WdvZ1djg3wuIFzk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hexgmzPV2oyFRzOap60NpiFP8yD6Cuz31lz48tzIba9WvG9rUyQ+z9qJlu4EyF4xRtM3tVQgMcXAXMcXVy7gBj3l6VUreXPWCeyJKVr0JlYKf+ZY5CO2hcTHlAMKHuBbSeQUeLKNLOtJVL+WL+rS3xoANmwMsxzAK99H+aI5QqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=csxo6N+5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="csxo6N+5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C292C1F00A3A;
	Mon,  7 Sep 2026 08:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788769653;
	bh=mz5x7t6DyK5kGMyq3bHZyg45fCnl34nlc4jlgFKy2/U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=csxo6N+5a5FxQ1PEEOIIT8xXTpK8gh/EEQFAAwj34aiiP3XZC3jYRud7oGuNjdjto
	 8cCDAw5JZ5vn+/E9De7KqhW51ax613rbgiN6EFtgX1or0biY86U0hhlp9GRiZDELOu
	 F07twXeUupuJ1kNY8jkdPugDn3PqWbFEph9or2ArHS3/hXops3fj34t7qcEMhtJmod
	 AFMlttyxtKsYTR5Z0k+i1RxlzUDnZIlPiCPY9FrDP6OCHNqaSA3ly0BObTCrorG1MU
	 qvAJX9Cguw6MgQBSzJcjiYYtxCbQpum8pyLJQVSHsgy3nSiN0zDmtJ2fQEao4hI/5N
	 nksZCsBJ84G+w==
Date: Mon, 7 Sep 2026 11:27:28 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Hemanth Selam <hemanth.selam@gmail.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Potnuri Bharat Teja <bharat@chelsio.com>,
	Cheng Xu <chengyou@linux.alibaba.com>,
	Kai Shen <kaishen@linux.alibaba.com>,
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Michal Kalderon <mkalderon@marvell.com>,
	Nelson Escobar <neescoba@cisco.com>,
	Satish Kharat <satishkh@cisco.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Max Gurtovoy <mgurtovoy@nvidia.com>,
	Bart Van Assche <bvanassche@acm.org>, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org, target-devel@vger.kernel.org
Subject: Re: [PATCH 1/2] RDMA: fix typos in comments
Message-ID: <20260907082728.GH13683@unreal>
References: <20260907065047.26773-1-hemanth.selam@gmail.com>
 <20260907065047.26773-2-hemanth.selam@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907065047.26773-2-hemanth.selam@gmail.com>

On Mon, Sep 07, 2026 at 12:20:46PM +0530, Hemanth Selam wrote:
> Fix typos in comments, reported by scripts/checkpatch.pl using the
> misspelling list in scripts/spelling.txt.  Only touches comments, no code
> changes.
> 
> Assisted-by: Cursor:claude-opus-5
> Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
> ---
>  drivers/infiniband/core/device.c              | 2 +-
>  drivers/infiniband/core/uverbs_uapi.c         | 2 +-
>  drivers/infiniband/core/verbs.c               | 2 +-
>  drivers/infiniband/hw/bnxt_re/ib_verbs.c      | 2 +-
>  drivers/infiniband/hw/cxgb4/cq.c              | 2 +-
>  drivers/infiniband/hw/erdma/erdma_main.c      | 2 +-
>  drivers/infiniband/hw/hfi1/affinity.c         | 2 +-
>  drivers/infiniband/hw/hfi1/firmware.c         | 2 +-
>  drivers/infiniband/hw/mlx4/mcg.c              | 4 ++--
>  drivers/infiniband/hw/mlx5/odp.c              | 2 +-
>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.c   | 6 +++---
>  drivers/infiniband/hw/qedr/verbs.c            | 2 +-
>  drivers/infiniband/hw/usnic/usnic_abi.h       | 2 +-
>  drivers/infiniband/hw/usnic/usnic_ib_verbs.c  | 2 +-
>  drivers/infiniband/hw/usnic/usnic_transport.h | 2 +-
>  drivers/infiniband/sw/rdmavt/qp.c             | 2 +-
>  drivers/infiniband/sw/rdmavt/srq.c            | 2 +-
>  drivers/infiniband/ulp/ipoib/ipoib_vlan.c     | 2 +-
>  drivers/infiniband/ulp/iser/iscsi_iser.c      | 6 +++---
>  drivers/infiniband/ulp/iser/iser_verbs.c      | 2 +-
>  include/rdma/ib_verbs.h                       | 4 ++--
>  include/rdma/uverbs_ioctl.h                   | 2 +-
>  22 files changed, 28 insertions(+), 28 deletions(-)

<...>

>  			 *
>  			 * release_cleanup is the exception because
>  			 * uverbs_uobject_fd_release() needs it. In this case
> -			 * the module reference held by the fops will guarentee
> +			 * the module reference held by the fops will guarantee
>  			 * the type_class remains valid too.
>  			 */

And what has changed here?

Thanks
