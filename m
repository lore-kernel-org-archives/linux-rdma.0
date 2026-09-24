Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69CDE5383FA;
	Thu, 24 Sep 2026 17:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790271964; cv=none; b=uXm2TqutZyCGa1F1s2sk4kSfH3ercuxjD0b3xl/LxRYUNQnIFAZTdfdBgtYw/2CmpLNqgV+b5b0RaFTgw1mdaq+12GuxftR3fpwyEnNfDriYKg3VjBeqnQ7q3QogR2hi7O3USraZ+yhSDOVgOGJfhjxL/763fgak6EACMMsFxsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790271964; c=relaxed/simple;
	bh=SqztfXoUY5wiM0VwxN/TqP3Wy0DqjN7ecMqn8ckkuSw=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KTHqvDhv86CZ8URtfp98r7Ry3YEQtzWfeCC58zED/RAow2qigMAQ2zXiQrCtsADv5H4AOIJizAJL3poQR9G/cYTDCeAY+e5HkIJ87XSwjbjOxMkiTiE2XOP5iiv9533XgEteUKFS0EOaaAz4TTe1e6Bee6z5FBPYskxBRSFQfB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ti+Boxxh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ti+Boxxh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CCD81F00898;
	Thu, 24 Sep 2026 17:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790271963;
	bh=28PVC8IBZWO2paoTc3sOAA/Wwj6hZMyqXSwzcQQrxDE=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Ti+Boxxh9uQrQakBEUwTMThuYz6AKChg4IowfBHD36gKoiT6kidiHvHbfzvIFBCh5
	 4jwHDAFPZS27a5pYUlHUoYAh7ndBAU0hI81Z+hwDPhwI6+uJPWYkx5tzeuGFUKQdlg
	 G6Gj+VOC8mGKlpnqrsx121v8wuffzmgJXnP+5Wibflj8KCCeoPTLarfcvDsnpy7MZz
	 /rURpn30x6VQ1j7+mZFOS0VkzhqUzy27bIK5Cy5/UHtZo5dYPi1nKlhTy4n0z/qAZ0
	 Nk+NHwB/0/+t+BgkbOdaQ9DCfjawemaKtauKLHzT3G62z27V3kFHzGJBudvpjVNfiw
	 1gxZBUwY94aTg==
Subject: Re: [PATCH net-next 09/13] net/mlx5: E-switch, derive manager vport
 from device capability
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 agoldberger@nvidia.com, cratiu@nvidia.com, gal@nvidia.com, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, mbloch@nvidia.com,
 moshe@nvidia.com, ohartoov@nvidia.com, saeedm@nvidia.com, shayd@nvidia.com
Date: Thu, 24 Sep 2026 17:46:02 +0000
Message-ID: <179027196200.2160803.11089100690642035873@kernel.org>
In-Reply-To: <20260923103830.1183-10-tariqt@nvidia.com>
References: <20260923103830.1183-10-tariqt@nvidia.com>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] mlx5_eswitch_manager_vport() (include/linux/mlx5/eswitch.h)
  now returns MLX5_CAP_ESW(dev, esw_manager_vport_number) when…

--

net/mlx5: E-switch, derive manager vport from device capability

The commit changes mlx5_eswitch_manager_vport() to return
esw_manager_vport_number from the e-switch capability when
esw_manager_vport_number_valid is set, so the manager vport can be a VF.
The old ECPF/host PF mapping stays as the fallback. mlx5_esw_vports_init()
now allocates the manager vport if it is not already in esw->vports.

> diff --git a/include/linux/mlx5/eswitch.h b/include/linux/mlx5/eswitch.h
> index a0dd162baa787..03d3620141c83 100644
> --- a/include/linux/mlx5/eswitch.h
> +++ b/include/linux/mlx5/eswitch.h
> @@ -222,6 +222,9 @@ static inline bool is_mdev_switchdev_mode(struct mlx5_core_dev *dev)
>  /* The returned number is valid only when the dev is eswitch manager. */
>  static inline u16 mlx5_eswitch_manager_vport(struct mlx5_core_dev *dev)
>  {
> +	if (MLX5_CAP_ESW(dev, esw_manager_vport_number_valid))
> +		return MLX5_CAP_ESW(dev, esw_manager_vport_number);
> +

[Severity: Medium]
Do the SW and HW steering backends agree with this new manager vport
number?

esw->manager_vport can now be a vport N that is neither ECPF nor 0. Both
steering backends still hardcode the old rule to decide which vport is
the manager.

In steering/hws/vport.c:

static bool hws_vport_is_esw_mgr_vport(struct mlx5hws_context *ctx, u16 vport)
{
	return ctx->caps->is_ecpf ? vport == MLX5_VPORT_ECPF :
				    vport == MLX5_VPORT_HOST_PF;
}

In steering/sws/dr_domain.c, dr_domain_is_esw_mgr_vport():

	return (caps->is_ecpf && vport == MLX5_VPORT_ECPF) ||
	       (!caps->is_ecpf && vport == 0);

The e-switch core passes esw->manager_vport to these backends as a
destination or source port, with no vhca_id. Some examples:

eswitch_offloads.c (slow-path miss):
	dest.vport.num = esw->manager_vport;

rdma.c:
	mlx5_esw_set_spec_source_port(esw, esw->manager_vport, spec);

The peer and slave miss rules in eswitch_offloads.c and en/tc/sample.c
also use it.

If firmware reports a manager vport N other than ECPF/0, it looks like
mlx5dr_domain_get_vport_cap() and mlx5hws_vport_get_gvmi() would treat N
as a foreign vport. They would not return the cached esw_manager_caps or
esw_manager_gvmi. Instead they would go through dr_domain_add_vport_cap()
or hws_vport_add_gvmi(), which query N with other_vport or other_function
set to true. Vport 0 would also keep mapping to the local manager's
caps/gvmi.

Could this lead to failed rule creation, or to rules that resolve to the
wrong vport context, when SMFS or HMFS steering is used on such a device?

HWS already reads the capability in mlx5hws_cmd_query_caps() into
caps->eswitch_manager_vport_number, and hws/table.c and hws/action.c use
it. hws/vport.c does not. Should hws_vport_is_esw_mgr_vport() and
dr_domain_is_esw_mgr_vport() be updated to use the capability-reported
number as well?

The later patches in this series don't appear to touch the steering
backends. Current firmware probably reports numbers that match the
hardcoded mapping, so this would only show up with firmware that reports
a VF as the e-switch manager.

>  	return mlx5_core_is_ecpf_esw_manager(dev) ?
>  		MLX5_VPORT_ECPF : MLX5_VPORT_HOST_PF;
>  }

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260923103830.1183-1-tariqt%40nvidia.com
