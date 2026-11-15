Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794749469;
	b=zMUOM5ZHixCiFVuY3ArLzUCb4w+kUZ116tVztIE9/BkvtvGjaEORq2/kzgj44Ebd/F31
	 J6BWJoghSlq/P26ndlpIXHdUXEhUyMSkp3DmjQT5P78UwyhaqnMv1O+xaU+DY1YSf9EjI
	 CKCrqsz0HpmJviE+Zj0VNTCG56TVtQn+Lqb1QUG0RG2e+yyklAlls7m2TOjgH3z85QZO2
	 ++qxEDCSNrIFOOFb+2l9cEvVGlPGGUREHBKnc7smjF8fPsou5ktINGQ/vJ6kbimrSWA2G
	 aITiSIF6I9YLuJq1S/nm30kLE/RsYxlXV/4TnQLvAUEtBZop90SmSYQjm9zXtFSL2pA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794749469;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=IVISIJ4I1N8jzFvQ/DTygsWJR5ytQa6L5vZOgCpSOkA=;
	b=23WVFXnebnhUsdFFnV0HNnGH19OjUNwJK7s++ZzxsaMZ/c3tmFcvanh11PgrcVP0iBDX
	 /s8ZEQPonFrs5k6IL48eqWi803PLOAUQXQa7uUxJhKzTQY8PNnTkoOeqUagKk9SefKOOR
	 zdtllvT+l5tomZKg++FlNR9kH//FjU/0BKKTE9sIVh96KeirTObZHdO/A1oeZCEGIitfi
	 SVbGiQneJjOz9NDxHbxVhXTAROFMkW7Kqx7aMoKY5y2bHEkeQ45E9NIbTmOAtxGNbbZDg
	 ftS+gPigfIpiccLw4EXVIpN/UkacJXFjgxLTjqHCAGZQ12m6GTxvaF1zWySOWg2HNAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="lqlj+o/4";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58EC9606A31E
	for <linux-rdma@vger.kernel.org>; Sun, 15 Nov 2026 13:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lqlj+o/4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CE6D1F000C4;
	Sun, 15 Nov 2026 13:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794749469;
	bh=IVISIJ4I1N8jzFvQ/DTygsWJR5ytQa6L5vZOgCpSOkA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lqlj+o/4WtmNetxkvNXV0utbObHgklrCEhlFC5TVWAPEQc/6aBhKY5vquKS1F8tZ1
	 56MTIm4clLUfjBWtFV60kaYLu1NtlRZw/53/OCFJP0ISbu94vPAyOId3A30MrRypzT
	 pIJxonaSTUnCBc2zSL6lI0+FsfALZewDhfSaWXa1pQXgPBCLDdzwidmccy2FxpVQSt
	 V/9/yEHo/JUqGBzZE9wx71R0WwkhfxbRQ5TdVfBSrx7z5NfctAIny7ZrDxbvsUKLSZ
	 po7ZCSDXnBmU/z3dgBY2h5hrEy8T3rT3Ru1a0WvkCMnABulbx8e5JFWdAcvap/kF6G
	 qzSDvViI11Y8A==
Date: Sun, 15 Nov 2026 15:31:04 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Junxian Huang <huangjunxian6@hisilicon.com>
Cc: jgg@ziepe.ca, linux-rdma@vger.kernel.org, tangchengchang@huawei.com,
	linuxarm@huawei.com
Subject: Re: [PATCH for-next] RDMA/hns: Add reset fence before freeing DMA
 memory when destroy mbox fails
Message-ID: <20261115133104.GB42525@unreal>
References: <20261110115609.1981900-1-huangjunxian6@hisilicon.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110115609.1981900-1-huangjunxian6@hisilicon.com>

On Tue, Nov 10, 2026 at 07:56:09PM +0800, Junxian Huang wrote:
> When a destroy mailbox (QPC/CQC/MPT/SRQC/EQC) fails or is skipped
> in a reset, HW may still access the context while the driver frees
> its DMA memory, causing a HW UAF.
> 
> According to the suggestion in [1], add a reset fence before freeing
> DMA memory when the destroy mailbox fails. Once ops->ae_dev_reset_cnt()
> increases, the HW reset is guaranteed to have completed, so HW will
> no longer access the DMA memory and it is safe for the driver
> to free it.
> 
> [1] https://lore.kernel.org/linux-rdma/20250401133956.GC186258@ziepe.ca/
> 
> Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
> Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
> ---
>  drivers/infiniband/hw/hns/hns_roce_cmd.c    |  7 +++-
>  drivers/infiniband/hw/hns/hns_roce_device.h |  1 +
>  drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 40 +++++++++++++++++++++
>  3 files changed, 47 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/hw/hns/hns_roce_cmd.c b/drivers/infiniband/hw/hns/hns_roce_cmd.c
> index 1943031b0dbe..885900e68779 100644
> --- a/drivers/infiniband/hw/hns/hns_roce_cmd.c
> +++ b/drivers/infiniband/hw/hns/hns_roce_cmd.c
> @@ -287,5 +287,10 @@ int hns_roce_create_hw_ctx(struct hns_roce_dev *dev,
>  
>  int hns_roce_destroy_hw_ctx(struct hns_roce_dev *dev, u8 cmd, unsigned long idx)
>  {
> -	return hns_roce_cmd_mbox(dev, 0, 0, cmd, idx);
> +	int ret;
> +
> +	ret = hns_roce_cmd_mbox(dev, 0, 0, cmd, idx);
> +	dev->hw->mbox_rst_fence(dev, ret);

There is no need to pass ret to .mbox_rst_fence(), call it conditionally
instead:
if (ret)
	dev->hw->mbox_rst_fence(dev);

> +
> +	return ret;

Is the returned error still relevant after calling `mbox_rst_fence()`?

>  }
> diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
> index 5890ee69247c..021a52bc49ab 100644
> --- a/drivers/infiniband/hw/hns/hns_roce_device.h
> +++ b/drivers/infiniband/hw/hns/hns_roce_device.h
> @@ -976,6 +976,7 @@ struct hns_roce_hw {
>  				enum hns_roce_scc_algo algo);
>  	int (*query_scc_param)(struct hns_roce_dev *hr_dev,
>  			       enum hns_roce_scc_algo alog);
> +	void (*mbox_rst_fence)(struct hns_roce_dev *hr_dev, int mbox_ret);
>  };
>  
>  #define HNS_ROCE_SCC_PARAM_SIZE 4
> diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
> index a8f319a57f25..e17569a532e4 100644
> --- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
> +++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
> @@ -1317,6 +1317,43 @@ static bool check_device_is_in_reset(struct hns_roce_dev *hr_dev)
>  	return false;
>  }
>  
> +static void hns_roce_v2_mbox_rst_fence(struct hns_roce_dev *hr_dev,
> +				       int mbox_ret)
> +{
> +#define FENCE_POLL_INTERVAL_US 1000
> +#define FENCE_TIMEOUT_US (60 * 1000 * 1000)

Please put these defines above hns_roce_v2_mbox_rst_fence().

> +	struct hns_roce_v2_priv *priv = hr_dev->priv;
> +	struct hnae3_handle *handle = priv->handle;
> +	const struct hnae3_ae_ops *ops = handle->ae_algo->ops;
> +	unsigned long cnt;
> +	unsigned long val;
> +	int ret;
> +
> +	might_sleep();
> +
> +	if (!mbox_ret && !check_device_is_in_reset(hr_dev))
> +		return;
> +
> +	cnt = ops->ae_dev_reset_cnt(handle);
> +	if (cnt != hr_dev->reset_cnt)

This is exactly what your check_device_is_in_reset() checks.

> +		return;
> +
> +	if (!check_device_is_in_reset(hr_dev)) {
> +		struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hr_dev->pci_dev);
> +		enum hnae3_reset_type rst_type = hr_dev->is_vf ?
> +			HNAE3_VF_FUNC_RESET : HNAE3_FUNC_RESET;
> +
> +		ops->set_default_reset_request(ae_dev, rst_type);
> +		ops->reset_event(hr_dev->pci_dev, handle);
> +	}
> +
> +	ret = read_poll_timeout(ops->ae_dev_reset_cnt, val, val > cnt,
> +				FENCE_POLL_INTERVAL_US, FENCE_TIMEOUT_US,
> +				false, handle);
> +	if (ret)
> +		dev_err(hr_dev->dev, "reset fence timeout.\n");
> +}
> +
>  static bool v2_chk_mbox_is_avail(struct hns_roce_dev *hr_dev, bool *busy)
>  {
>  	struct hns_roce_v2_priv *priv = hr_dev->priv;
> @@ -5943,6 +5980,8 @@ static int hns_roce_v2_destroy_qp_common(struct hns_roce_dev *hr_dev,
>  			ibdev_err_ratelimited(ibdev,
>  					      "failed to modify QP to RST, ret = %d.\n",
>  					      ret);
> +
> +		hr_dev->hw->mbox_rst_fence(hr_dev, ret);
>  	}
>  
>  	send_cq = hr_qp->ibqp.send_cq ? to_hr_cq(hr_qp->ibqp.send_cq) : NULL;
> @@ -7327,6 +7366,7 @@ static const struct hns_roce_hw hns_roce_hw_v2 = {
>  	.hns_roce_dev_srq_ops = &hns_roce_v2_dev_srq_ops,
>  	.config_scc_param = hns_roce_v2_config_scc_param,
>  	.query_scc_param = hns_roce_v2_query_scc_param,
> +	.mbox_rst_fence = hns_roce_v2_mbox_rst_fence,

I don't see much justification for implementing this as a callback when only one
v2 HNS device is supported.

Thanks

>  };
>  
>  static const struct pci_device_id hns_roce_hw_v2_pci_tbl[] = {
> -- 
> 2.33.0
> 
> 
