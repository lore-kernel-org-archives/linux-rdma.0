Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794830157;
	b=UzWIlVPrfDYLpMBGkwls3WQuzq1Bj2OU8Xv3N2/31pqLMEuaS4jtFs8TJV41r6kQkmrd
	 IaJLFXCpKIFUmLibJPZ6DSmjVzBWSO6Wj7kMv4J324w6yt2gf1Exd8rx3Ad3HcickIa7E
	 9SppOu8yEHBUVQ5N9X/47fKo/GFpmIpYEn4rQeD/IW14EWZkxuDdbMQW8XtzVlRr6do8x
	 RHlviNjqcTKNj7HuNh7QKKOO1vFDQ+gJ8vK1bQUK31dL2biaKstr5q3JmhDfksSsU0jMJ
	 IKVTwVbX3H4ai32g6TDFdPpAMhZHtMD20lC34kQVawF5c0grt+hRiZ3yEcsl2pLgWeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794830157;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=64fdSmC+itpUqVCIpnFMnNpeeM+0Kk4P4QNxg3UZAZg=;
	b=XY4NontOYvajkW0+ETNv+orax5MqeEJNpSS6YM+UArWKDdztCY0JLvNIjvQWH/hUql5D
	 d+RQVsPKmSQgHVxL+oAQ0XUvqKaP+FhMzLBFZuEQgWR6Sg32IZlu0Tw0ROxywv4Onx2c9
	 +OTnquryLBNm5pM8YQVDqVahxi9dIDEwAobLnpyBjQ6MUK/fTrfOvrCqZYIxD8HGAdXjc
	 DF/BpPHmTxIOaIUOuxzkM6p6mEfy9vea5ETKM6jQbScgEQV0k/sYMaJ39AYFchpCWnQHh
	 RyZ05oJ9FSpQbgXU3ba4XjXLjAFFKGETmc1T5vkSnfLpgXSV0sx3u/hnifXU0Mkx8Ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=csJRLdRu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59AE4606A323;
	Mon, 16 Nov 2026 11:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=csJRLdRu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87AA51F000C4;
	Mon, 16 Nov 2026 11:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794830157;
	bh=64fdSmC+itpUqVCIpnFMnNpeeM+0Kk4P4QNxg3UZAZg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=csJRLdRubG+yNTVHO8RrwXPIEcRujHZEquxnXrq5jdGltmCsesAIlg26Pm1kV2pAS
	 X5GuwhtZjl5ts9CkqufuN4BO9f7c/l6vOZmHHCkPYqMbVRBzUIyVS3n+WXJg1Fsfep
	 qafsRuxHFqovN998tELNWIdVOKYyRuw//h6KApmmfz5EJl1qfgKmN7cJBEwrmd96Zj
	 ZR9UPCo1YtT8tq+th9psrCc39gbR69YX1MZSc5LbTOKM69bzEDsdYd44SvrukWugjY
	 nuWPSavX1rmnVE58Z8AqUvXqpTsL2PA/xKzlpURHXS0jK6gMcqxkS3Fy2U6bf4O2m3
	 w58XB92QGg4mA==
Date: Mon, 16 Nov 2026 13:55:53 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>
Cc: Selvin Xavier <selvin.xavier@broadcom.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RDMA/ocrdma: Fix potential EQ table leak
Message-ID: <20261116115553.GJ11319@unreal>
References: <20261112-88a3a7ff32-rdma-ocrdma@mail.sdu.edu.cn>
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
In-Reply-To: <20261112-88a3a7ff32-rdma-ocrdma@mail.sdu.edu.cn>

On Thu, Nov 12, 2026 at 09:59:12PM +0800, Guangshuo Li wrote:
> EQ teardown destroys the individual queues but leaves their dynamically
> allocated table behind. Free the table after all EQs have been destroyed
> and reset its pointer and count.
> 
> This issue was found by our static analysis tool under development.
> 
> Fixes: fe2caefcdf58 ("RDMA/ocrdma: Add driver for Emulex OneConnect IBoE RDMA adapter")
> Signed-off-by: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>
> ---
>  drivers/infiniband/hw/ocrdma/ocrdma_hw.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
> index 006ef2e6b5f3..4a977281a85b 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
> @@ -518,6 +518,9 @@ static void ocrdma_destroy_eqs(struct ocrdma_dev *dev)
>  
>  	for (i = 0; i < dev->eq_cnt; i++)
>  		ocrdma_destroy_eq(dev, &dev->eq_tbl[i]);
> +	kfree(dev->eq_tbl);
> +	dev->eq_tbl = NULL;
> +	dev->eq_cnt = 0;

These two lines are unnecessary because dev->eq_tbl is not reused.

Thanks

>  }
>  
>  static int ocrdma_mbx_mq_cq_create(struct ocrdma_dev *dev,
> 
> base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
