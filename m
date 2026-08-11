Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601982EEE61;
	Tue, 11 Aug 2026 15:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786461946; cv=none; b=icflsRtJpoZFPuGdNJyCLssIwZ268br7kfvsrEECLJNlD42aip7Mit7ck8Wft5/wNGHKDWMa3C1Pz15egwC4jOJAqWlWXSFjhW2zML1p4KsatxTkL/9FeZ/h2uEMe5s7vljLglB+DgLYqlRgX+BLOn7Zlv9HMv2fjKhndZ3yLUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786461946; c=relaxed/simple;
	bh=8SN/B39AjzcoxaC2HfAubg8B9fm3/7wx7xHjDq0HHAE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KtbcAboyJImEaoIVDJndLWRfuwE+S79Dz/vMbMP9wizhbKIix3zmHnCAnYMbfrfRCdZoowWPXjoIRlPTg0ICOtg3ngz1emEsClrZMEGno2f8uNPxWe+qS0gZmV/Nqr5gapp07HIKwT+qhRBR1qYNbYnBMgfkclDg+0QYA9SCMSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CpAoIJfX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CpAoIJfX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F0EB1F00A3A;
	Tue, 11 Aug 2026 15:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786461944;
	bh=CO5x6xA5FuapUJuQKyHB7ALTaJ7AIo3HlXmtKeh3a5c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CpAoIJfX9udfqHY5mc86zUkEbAvGh8fVM3Ncq0LuvkZnqz1/e9k4whObvjnSVNUvS
	 ofpTOequaPbbE8CZwl7RLafN0/ctSH1vZsfRAsHDBBeYqRoFYibuvwlPY6c1jlj6pV
	 OfKpaJBJVMFhoNMA37+C7LmEmncPhy6fSp5wyXlLBaVWYCxI/OotdWZR3sMFhyTjpp
	 FAXUlALvn8UfXQkwIDnxtk2Vy/cvIUTHvf1gefGeqSYGUPaP4VlpL3coThmrSnS0fP
	 zzH7Bukk920jXUrI9KcAIfhTbmbWiMGFnz/SrMxYFMBsMH5/2g0sZ/dQLse2KP+zYC
	 4SXa5G30WbMGw==
Date: Tue, 11 Aug 2026 16:25:38 +0100
From: Simon Horman <horms@kernel.org>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	Akiva Goldberger <agoldberger@nvidia.com>,
	Alexei Lazar <alazar@nvidia.com>, Alex Vesker <valex@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Erez Shitrit <erezsh@nvidia.com>, Feng Liu <feliu@nvidia.com>,
	Gal Pressman <gal@nvidia.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Kees Cook <kees@kernel.org>, Leon Romanovsky <leon@kernel.org>,
	linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
	Mark Bloch <mbloch@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>,
	Parav Pandit <parav@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
	Shay Drory <shayd@nvidia.com>, Vlad Dogaru <vdogaru@nvidia.com>,
	Yevgeny Kliteynik <kliteyn@nvidia.com>
Subject: Re: [PATCH net-next V2 1/5] net/mlx5: HWS, Print more details for
 bad completion
Message-ID: <20260811152538.GG51943@horms.kernel.org>
References: <20260810092630.3137666-1-tariqt@nvidia.com>
 <20260810092630.3137666-2-tariqt@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260810092630.3137666-2-tariqt@nvidia.com>

On Mon, Aug 10, 2026 at 12:26:26PM +0300, Tariq Toukan wrote:
> From: Yevgeny Kliteynik <kliteyn@nvidia.com>
> 
> When polling for completion returned completion with error,
> parse some more details: QP number and WQE count.
> Also, extract all the long value-to-string if conditions
> to a short value-to-string functions: do it for rule
> resize state, rule status, and syndrome.
> 
> Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
> Reviewed-by: Erez Shitrit <erezsh@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Overall this series looks good to me.
But the AI-generated review of this patch, pasted below, does seem relevant.

...

> @@ -423,6 +445,15 @@ static void hws_send_engine_dump_error_cqe(struct mlx5hws_send_engine *queue,
>  			    "    rule 0x%08llx:  |--- syndrome = 0x%x\n",
>  			    HWS_PTR_TO_ID(rule),
>  			    err_cqe->syndrome);
> +		mlx5hws_err(ctx,
> +			    "    rule 0x%08llx:  |--- QPN = 0x%x\n",
> +			    HWS_PTR_TO_ID(rule),
> +			    be32_to_cpu(err_cqe->s_wqe_opcode_qpn) &
> +					0xffffff);

AI-generated review text:

  Is this new QPN line printing something that the same function already
  dumps a few lines later?

  At the tail of hws_send_engine_dump_error_cqe() there is already:

	mlx5hws_err(ctx,
		    "    rule 0x%08llx:  |------------ qpn = 0x%06x\n",
		    HWS_PTR_TO_ID(rule),
		    be32_to_cpu(cqe->sop_drop_qpn) & 0xffffff);

  err_cqe is just a cast of the same cqe pointer, and both fields land on
  the same four bytes of the 64 byte CQE (include/linux/mlx5/device.h):

	struct mlx5_err_cqe {
		u8	rsvd0[32];	/* 0..31  */
		__be32	srqn;		/* 32..35 */
		u8	rsvd1[18];	/* 36..53 */
		u8	vendor_err_synd;/* 54     */
		u8	syndrome;	/* 55     */
		__be32	s_wqe_opcode_qpn;/* 56..59 */
		...
	};
	struct mlx5_cqe64 {
		...
		__be32	byte_cnt;	/* 44..47 */
		__be32	timestamp_h;	/* 48..51 */
		__be32	timestamp_l;	/* 52..55 */
		__be32	sop_drop_qpn;	/* 56..59 */
		...
	};

  Same offset, same 0xffffff mask, so a single dump now reports the QP
  number twice, once as "QPN = 0x%x" and once as "qpn = 0x%06x", with
  different labels and widths.

  Would it make sense to drop the new QPN line, or at least align its label
  and width with the existing one, given the one-shot
  queue->error_cqe_printed guard is there to keep this dump compact?

Source: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260810092630.3137666-1-tariqt%40nvidia.com

> +		mlx5hws_err(ctx,
> +			    "    rule 0x%08llx:  |--- WQE_CNT = 0x%04x\n",
> +			    HWS_PTR_TO_ID(rule),
> +			    (u32)be16_to_cpu(err_cqe->wqe_counter));
>  	}
>  
>  	mlx5hws_err(ctx,

...
