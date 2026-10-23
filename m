Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792783924;
	b=EHxu8K9l6VSKKBgzo8Kbr+IBNjTGYae7N4qEOALrG8I8/Mx+mZDwAltSLHuy6cKKhTMf
	 uxsdi6wZdR6clOlEB8jfsdlnl/kCFkiH5GKIlcXcpId22sfjV/hNeAEfqv2d7BqbIMei+
	 2yzHS7gGgqd0Yz1A2MSEKa6YJqHXp2oosx0RYj23wP6lX7uM8mpYN5UuzxZz+UNmr7Crb
	 E5wXcDlg6qeAMQE50vHIUx7RYbDzWxDSnrOp1oMT4UjbTYW9vgojYc1T3XA6/wm7aGtJc
	 nYBeyEQmHGCxOMw2ImkZthQKZsgY5ncFdg0xWIXvF00TFHJ5p34cpAiNnTNZhLi9slw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792783924;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=/PA6dS6FVTk8uCRYEXqlR4w3GUUhUJAhjYTB+eMKIrs=;
	b=dkXg80mEuljIylQNMxnwEMtwLf4Pi8X8a+ZiO3nAMi3cNKqhWQY2RQ6FSJrm4DSm50MV
	 3RxWlplWb0kvV4YP4DEciYuR/LxvTL1HKdr+VOvkCGGmmbjyzlwb9wOKFCrq1x5b4Erzv
	 SaPSZcw/etN+iSwnvN8HckzD7s71iyEgnlKTHN3HG84hV8O29dq+iGjq9gxqP3b3mNpzE
	 ACCzM8BpOOwLmZUcDo+HPpNGkL4EvDc8iKl+eYBoBxBye5t2Z4YGPjQwzymczNV0nae6r
	 D6uuffA5FvcDqdpKkRiYtIeLpQijUV0iFRVc8YqcGRnfKWtcvZ8PqBNoxepT0lppe8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ULylYsue;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D2F606A31A;
	Fri, 23 Oct 2026 19:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ULylYsue
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B580B1F01825;
	Fri, 23 Oct 2026 19:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792783923;
	bh=/PA6dS6FVTk8uCRYEXqlR4w3GUUhUJAhjYTB+eMKIrs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ULylYsuegCnl0tuyU/spZZcgQAR2N2uMk3K6Ij0bnBbEY3bVizZxPg8qZvfmSqYZK
	 nPTXp+aLyMPOa6yMK0EEWJUnrAps/YRxBoXtdmTPEoGJ2Jdudj/QTMelSmu8980HoX
	 VtZq3j5s5/gYIgSvE2KtX5KwdeEivXik5ka9BezZUUPoz5jH0FvHQ/BeUTRkzq7NY1
	 ei907VFZd2A7JCWZFO5U0kqEeL1dDnVqkOytJUmQXlTkWJZWeSW2PWgG0V68Ui3Vja
	 JMDDkYmb7ebZrSizvw7klJ2NmEZ1cx+jBnoESVOiuWt1q7yrLf/z6T37x1o7VIYMLI
	 no8103LT2f6YA==
Message-ID: <sashiko-outbox-183120@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net V2 1/4] {RDMA,net}/mlx5: cache and use TX-enabled
 aggregate speed for vports
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261022193053.3815866-2-tariqt@nvidia.com>
References: <20261022193053.3815866-1-tariqt@nvidia.com>
 <20261022193053.3815866-2-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 23 Oct 2026 19:32:03 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] net/mlx5: lag: missing agg_speed_mbps reset on MPESW and mode-ch=
ange teardown
--

commit ce16ef57f040ab430add649db26c3f383cbab840
Author: Or Har-Toov <ohartoov@nvidia.com>

{RDMA,net}/mlx5: cache and use TX-enabled aggregate speed for vports

This commit caches the calculated operational TX-enabled aggregate speed in
struct mlx5_lag and exposes mlx5_lag_query_aggregated_speed() to query it
instead of the bond speed. It also resets the cached speed to SPEED_UNKNOWN
via mlx5_lag_reset_agg_speed() when resetting vports speed.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/=
net/ethernet/mellanox/mlx5/core/lag/lag.c
> index 4e173b08cb37a..57755ceab8a75 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c

[ ... ]

> @@ -1594,6 +1625,7 @@ void mlx5_lag_reset_vports_speed(struct mlx5_lag *l=
dev)
>  	int pf_idx;
>  	int ret;
> =20
> +	mlx5_lag_reset_agg_speed(ldev);
>  	mlx5_ldev_for_each(pf_idx, 0, ldev) {
>  		pf =3D mlx5_lag_pf(ldev, pf_idx);
>  		if (!pf)

[Severity: Medium]
Does calling mlx5_lag_reset_agg_speed() only from
mlx5_lag_reset_vports_speed() miss resetting ldev->agg_speed_mbps (and vport
speeds) when LAG is torn down via MPESW disable or mode changes?

Currently, mlx5_lag_reset_vports_speed() is only called from mlx5_do_bond()
when mlx5_lag_should_disable_lag() returns true:

drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c:mlx5_do_bond() {
	...
	} else if (mlx5_lag_should_disable_lag(ldev, do_bond)) {
		mlx5_lag_reset_vports_speed(ldev);
		mlx5_disable_lag(ldev);
	}
}

where mlx5_lag_should_disable_lag() checks:

	return !do_bond && __mlx5_lag_is_active(ldev) &&
	       ldev->mode !=3D MLX5_LAG_MODE_MPESW;

When MPESW LAG is enabled via mlx5_lag_enable_mpesw() ->
mlx5_lag_shared_fdb_create(), mlx5_lag_set_vports_agg_speed() populates
ldev->agg_speed_mbps (and mlx5_mpesw_speed_update_work() updates it).
However, when MPESW is torn down via mlx5_lag_disable_mpesw():

drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c:mlx5_lag_disable_mpesw(=
) {
	if (ldev->mode !=3D MLX5_LAG_MODE_MPESW)
		return;

	mlx5_mpesw_metadata_cleanup(ldev);
	mlx5_lag_shared_fdb_destroy(ldev, MLX5_LAG_FILTER_ALL);
	if (mlx5_lag_has_sd_group(ldev))
		mlx5_mpesw_restore_sd_fdb(ldev);
}

neither mlx5_lag_reset_vports_speed() nor mlx5_lag_reset_agg_speed() is
called, and mlx5_lag_should_disable_lag() explicitly excludes
MLX5_LAG_MODE_MPESW.

Similarly, during eswitch mode or SR-IOV changes, mlx5_lag_disable_change()
disables an active LAG directly without calling
mlx5_lag_reset_vports_speed() or mlx5_lag_reset_agg_speed():

drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c:mlx5_lag_disable_change()=
 {
	...
	ldev->mode_changes_in_progress++;
	if (__mlx5_lag_is_active(ldev)) {
		if (ldev->mode =3D=3D MLX5_LAG_MODE_MPESW)
			mlx5_lag_disable_mpesw(ldev);
		else
			mlx5_disable_lag(ldev);
	}
}

Because mlx5_disable_lag() -> mlx5_deactivate_lag() clears ldev->mode to
MLX5_LAG_MODE_NONE, when mlx5_lag_enable_change() later runs mlx5_do_bond(),
__mlx5_lag_is_active(ldev) is already false. If do_bond is false (for
example, if mlx5_lag_check_prereq(ldev) is now false after a mode change or
if the bond was removed during the transition), mlx5_lag_should_disable_lag=
()
evaluates to false and the reset never runs.

Wouldn't this leave a stale speed in ldev->agg_speed_mbps (and stale vport
rate limits) after teardown, causing mlx5_lag_query_aggregated_speed() to
return the old speed instead of -ENODATA, and in the subsequent patch
("{RDMA,net}/mlx5: notify IB uplink on LAG aggregate speed change") causing
mlx5_lag_update_agg_speed() to compare against the stale old_speed and
suppress IB_EVENT_DEVICE_SPEED_CHANGE if LAG is re-activated at the same
aggregate speed?

[ ... ]

>
>
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261022193053.3815=
866-1-tariqt@nvidia.com?part=3D1
