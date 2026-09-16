Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A69CE45563F;
	Wed, 16 Sep 2026 23:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789602157; cv=none; b=k6BrH9QS51yUCdVU2ZKsD6G8Hu0eY/Y5RbBA2KMNBQH36OEsyjvhPBLzssPdEz/vcrD0ZlKQlPp5pTNsgMKmlvPO4oNlnls7jISYCKS2XHW1clG6ZmXxoignVhWcvUvK1ydtH9kfxVk5g3pZZmjFauHtKvPtFoa4g9VlHerku5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789602157; c=relaxed/simple;
	bh=PzKkMxsSFVXbH2ST9awkV6tBuLR/rPvVcw6VpTfg62s=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=G3gE99ihe3Xl949mxFAFPZoErt9sl/q4M7/ckmxiHD+PZ69c+8H5xFDlMS2ti8CEJT7FCXv9VJZYRFW4rGFnjf1iAblBKfqxmBOgrwYKcPOBNdARWxc6Ncohg75+tdslefJTuaUO7knvpcByW586Z78PV8tVkcCyusBmif+yaKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fQlOau3O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fQlOau3O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9568C1F000FF;
	Wed, 16 Sep 2026 23:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789602156;
	bh=0hvf0/Djh6pFUqL1HPlpZe8vWgHonCbMs9ZGbsXVmg0=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=fQlOau3OcmZFg/oK3o9Gslayi0e0l1Bd7KCfZNnpnRF9NXV32bZAwvhkiUaoaSnT9
	 l2YNUCtk+DGJURXeX6IKUwp4XoEpDWd3g2gAauqFK9+GL1KDAx+9r9h76mAbuwSgEK
	 D5kfkD1J1CZtzW0z+paZ/Fus124xYIMOqvdLuVVy542fxY+KfgzbE1F4nYQJNSnTGI
	 MSZX+IbSp6KysT1/ceiNw3MtnnMYJ53wwhuDBIl2h4wRTR8h5qtK+jFEYrwa9DLY8R
	 HI8GUEfxe/aG3+oVgcq3kNMPcwQLkIIsmHiELWFTsD9IhMH0PJo2tFAzrLsGvMkXYF
	 wki8SMCAmqAfQ==
Subject: Re: [PATCH net-next 2/6] net/mlx5: HWS, Fix error message in
 mlx5hws_cmd_generate_wqe
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com, erezsh@nvidia.com,
 gal@nvidia.com, leon@kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, mbloch@nvidia.com, saeedm@nvidia.com,
 kliteyn@nvidia.com
Date: Wed, 16 Sep 2026 23:42:35 +0000
Message-ID: <178960215515.22033.15231787947837063127@kernel.org>
In-Reply-To: <20260915111912.3926585-3-tariqt@nvidia.com>
References: <20260915111912.3926585-3-tariqt@nvidia.com>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider:

Critical: 0 · High: 0 · Medium: 0 · Low: 1

- [Low] Commit subject/message misidentifies the location of the fix.

--

net/mlx5: HWS, Fix error message in mlx5hws_cmd_generate_wqe

This adds the missing trailing newline to the error message printed when
the generate WQE command fails in the HWS send path.

> net/mlx5: HWS, Fix error message in mlx5hws_cmd_generate_wqe

[Severity: Low]
This isn't a code bug, but does the subject point at the right function?
The only change is in hws_send_wqe_fw() in
drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c, which is the
caller of mlx5hws_cmd_generate_wqe():

send_wqe:
	ret = mlx5hws_cmd_generate_wqe(mdev, &attr, &cqe);
	if (ret) {
		mlx5_core_err(mdev, "Failed to write WQE using command\n");
		return ret;
	}

mlx5hws_cmd_generate_wqe() itself lives in hws/cmd.c and both of its error
prints already end with '\n':

	ret = mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
	if (ret) {
		mlx5_core_err(mdev, "Failed to write GTA WQE using FW\n");
		return ret;
	}

	status = MLX5_GET(generate_wqe_out, out, status);
	if (status) {
		mlx5_core_err(mdev, "Invalid FW CQE status %d\n", status);
		return -EINVAL;
	}

Would something like "net/mlx5: HWS, Add missing newline to error message in
hws_send_wqe_fw" be more accurate, so that someone grepping cmd.c for the
quoted string is not sent to the wrong place?

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c
> index ae3ff232c63bc..80cfd0ddba08b 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c
> @@ -1287,7 +1287,7 @@ hws_send_wqe_fw(struct mlx5_core_dev *mdev,
>  send_wqe:
>  	ret = mlx5hws_cmd_generate_wqe(mdev, &attr, &cqe);
>  	if (ret) {
> -		mlx5_core_err(mdev, "Failed to write WQE using command");
> +		mlx5_core_err(mdev, "Failed to write WQE using command\n");
>  		return ret;
>  	}
>

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260915111912.3926585-1-tariqt%40nvidia.com
