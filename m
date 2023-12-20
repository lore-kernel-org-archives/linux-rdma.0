Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4837B1D520;
	Wed, 20 Dec 2023 08:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UhIxQgP9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE5C6C433C7;
	Wed, 20 Dec 2023 08:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703060883;
	bh=PvZzODyCN3h0tm/M44eh6gfUfU6RJmkkjXP2te2QE/g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UhIxQgP9RMa2hIa55tyezx81Qnuht1Ck39onGZDWdO1OKrdIDIZa/yTUWeGjDXYmi
	 vGHlltknD4YXjk8bWEopjl9PLyZY8+TNdMPh5Bm352qhzYjBAa/xFLxBlWYdCvdkVD
	 yl6jBW63RR0x5n425wRaAJDCpiDgBpZf3LN6Alx5aFBwsR+wq6l5iYTWTltNYXyNC8
	 Nlf1whr/O9Wd8+xMHBNJdkRW65vpyxzwxc/FcGhJwK//3zcznOwD1k+k2YSLbwyyvG
	 HisJXHShyMC8MYvOyNbCsQC8jVJ+4Ri1WTMjy7ZNjSQ+Tz/sT04ZERHw4Y98hGDWwv
	 wGwTRte9cdv8Q==
Date: Wed, 20 Dec 2023 10:27:58 +0200
From: Leon Romanovsky <leon@kernel.org>
To: longli@linuxonhyperv.com
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Ajay Sharma <sharmaajay@microsoft.com>,
	Dexuan Cui <decui@microsoft.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Long Li <longli@microsoft.com>
Subject: Re: [Patch v4 0/3] Register with RDMA SOC interface and support for
 CQ
Message-ID: <20231220082758.GC136797@unreal>
References: <1702692255-23640-1-git-send-email-longli@linuxonhyperv.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1702692255-23640-1-git-send-email-longli@linuxonhyperv.com>

On Fri, Dec 15, 2023 at 06:04:12PM -0800, longli@linuxonhyperv.com wrote:
> From: Long Li <longli@microsoft.com>
> 
> This patchset add support for registering a RDMA device with SoC for
> support of querying device capabilities, upcoming RC queue pairs and
> CQ interrupts.
> 
> This patchset is partially based on Ajay Sharma's work:
> https://lore.kernel.org/netdev/1697494322-26814-1-git-send-email-sharmaajay@linuxonhyperv.com
> 
> Changes in v2:
> Dropped the patches to create EQs for RC QP. They will be implemented with
> RC patches.
> 
> 
> Long Li (3):
>   RDMA/mana_ib: register RDMA device with GDMA
>   RDMA/mana_ib: query device capabilities
>   RDMA/mana_ib: Add CQ interrupt support for RAW QP
> 
>  drivers/infiniband/hw/mana/cq.c               | 34 ++++++-
>  drivers/infiniband/hw/mana/device.c           | 31 +++++--
>  drivers/infiniband/hw/mana/main.c             | 69 ++++++++++----
>  drivers/infiniband/hw/mana/mana_ib.h          | 53 +++++++++++
>  drivers/infiniband/hw/mana/qp.c               | 90 ++++++++++++++++---
>  .../net/ethernet/microsoft/mana/gdma_main.c   |  5 ++
>  include/net/mana/gdma.h                       |  5 ++
>  7 files changed, 252 insertions(+), 35 deletions(-)

Applied with the following change in third patch.

diff --git a/drivers/infiniband/hw/mana/qp.c b/drivers/infiniband/hw/mana/qp.c
index 19998082a376..21ac9fcadf3f 100644
--- a/drivers/infiniband/hw/mana/qp.c
+++ b/drivers/infiniband/hw/mana/qp.c
@@ -443,17 +443,16 @@ static int mana_ib_create_qp_raw(struct ib_qp *ibqp, struct ib_pd *ibpd,
                ibdev_dbg(&mdev->ib_dev,
                          "Failed copy udata for create qp-raw, %d\n",
                          err);
-               goto err_destroy_wq_obj;
+               goto err_release_gdma_cq;
        }

        return 0;

-err_destroy_wq_obj:
-       if (gdma_cq) {
-               kfree(gdma_cq);
-               gd->gdma_context->cq_table[send_cq->id] = NULL;
-       }
+err_release_gdma_cq:
+       kfree(gdma_cq);
+       gd->gdma_context->cq_table[send_cq->id] = NULL;

+err_destroy_wq_obj:
        mana_destroy_wq_obj(mpc, GDMA_SQ, qp->tx_object);

 err_destroy_dma_region:


> 
> -- 
> 2.25.1
> 
