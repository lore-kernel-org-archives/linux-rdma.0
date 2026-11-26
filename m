Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795694668;
	b=4pAXTDPS8+DlrbFRk4lJQq7fEAULA2MbW/5pgMAi+D8yRjvSDCQMxFbNSuRfqpc9bhlS
	 v0TsNGyKrT0lKonP62zlFCSQbklDeJIIiyLjWpuQENzC2LwTrXuiqOfcB+7n1msjnriat
	 UbI6Px4lv8LMzoQirA5qa3KPQqRwkMLKq1l/lDbeLLJqtSFirTypXtmeGMoA1gfBCqfwq
	 0Ig/CBuh1WpDENN1FOQ/0rdM8URjimhCH0n2AUxmAtubeJ2nLC58IvYcqfauvT2Qe9ymt
	 OiqYVr0bs2CrTwHDsM5rhfd/MfpDUtIxIiAK9bNLr2AR9ux1+xudmOxbLVcziMiDC2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795694668;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=kP9909YZOHJ/yyoxYA4yDZI5lpWuHUiSSOlW6VYlpew=;
	b=5dYzmd6ANa+woERSOO/nNVFrBbol8cx291uXwUkpPtuZQd1YR05tVGFHuAI9I4+NEnus
	 2etobPCcVN5pFo1Qh6KlZvPLbw3tpXk9mpsGnCf4TCmwA5atvxVncFxbK0ZGJn9+LJPKM
	 1HoiyRalvegnxr0s6KOVCx5DSutsfJRsOFjDowZQcYUrXYl1THkKYRtTmvdIWHIHTiTsu
	 26529SIXftppff6c2L33cExf5IoJvTzvzf2Xr10ShOPpX8UJ8iB6wkzU2cWQVbCIXNxGu
	 z7pKSj+dzVOyX8cO4tAhVosmkCLuIMIg45glzGl1Q+9dSIt8ZDUO7xMW9XtU6mlWxog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Jm+6UvF6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B74A606A31C
	for <linux-rdma@vger.kernel.org>; Thu, 26 Nov 2026 12:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Jm+6UvF6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21A961F000C0;
	Thu, 26 Nov 2026 12:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795694667;
	bh=kP9909YZOHJ/yyoxYA4yDZI5lpWuHUiSSOlW6VYlpew=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Jm+6UvF6d9Stos68cY/iOukqixGjw7OSKSWUJHqNMklfAxLkFSsEQrQHbPozGuBlL
	 d4noK27otpXuzyNO3UAv2jtLgAHp1Eplv6eh+cDmoMZQK4FJSFkPJjEs76iBOMGqeM
	 5ZVtIVgc8wMRFlzQmjYnGgK0u2hg/rBPU+O1ZGLbQlftsXW9ZToyngSGNBNscwFMbZ
	 YNUUBk+RmBvRzETJkhuLXaKF3KlL+MZaw26x0Ui+oFIT2OJeExTUiFQadVzcyfU1cI
	 eOLgB5OuyNJIIFUSLL4wu2W3hFiJXUaYiibyd1Y9+ypHwUbXdNV19RiaX7dTZgXj4D
	 2r4bIqMYzuayg==
Date: Thu, 26 Nov 2026 14:04:24 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Md Haris Iqbal <haris.iqbal@ionos.com>
Cc: linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Subject: Re: [PATCH 9/9] RDMA/rtrs-clt: Close all paths before freeing any in
 rtrs_clt_close()
Message-ID: <20261126120424.GJ774860@unreal>
References: <20261123143719.938876-1-haris.iqbal@ionos.com>
 <20261123143719.938876-10-haris.iqbal@ionos.com>
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
In-Reply-To: <20261123143719.938876-10-haris.iqbal@ionos.com>

On Mon, Nov 23, 2026 at 03:37:19PM +0100, Md Haris Iqbal wrote:
> rtrs_clt_close() closes and frees the paths one at a time. Meanwhile, the
> paths that are not closed yet can still walk clt->paths_list: a reconnect
> fires link_ev(RECONNECTED), whose handler calls rtrs_clt_query(), and a
> closing path fails its requests over through rtrs_clt_failover_req().
> Either can then touch a path that is already freed:
> 
>   BUG: KASAN: slab-use-after-free in rtrs_clt_query
>   Workqueue: rtrs_client_wq rtrs_clt_reconnect_work
>    rtrs_clt_query
>    rnbd_clt_link_ev
>    init_path
>    rtrs_clt_reconnect_work

Please include the full dmesg stack trace in commit messages for RDMA-related changes.

Thanks

> 
> Move every path to CLOSING first, wait for all close works, and only then
> unlink and free the paths. A close work cancels the reconnect work of its
> path synchronously, so no path is freed while another one still uses the
> list.
> 
> rtrs_clt_open() tears down its paths on error the same way, so move the
> sequence into rtrs_clt_destroy_all_paths() and use it from both, with
> sysfs torn down first.
> 
> Fixes: 6a98d71daea1 ("RDMA/rtrs: client: main functionality")
> Reported-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
> Closes: https://lore.kernel.org/linux-rdma/20261105202939.3104321-1-shuangpeng.kernel@gmail.com/
> Signed-off-by: Md Haris Iqbal <haris.iqbal@ionos.com>
> ---
>  drivers/infiniband/ulp/rtrs/rtrs-clt.c | 49 ++++++++++++++++++--------
>  1 file changed, 34 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
> index 7930039dcd32..760ae71c9230 100644
> --- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
> +++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
> @@ -2862,6 +2862,38 @@ static void free_clt(struct rtrs_clt_sess *clt)
>  	device_unregister(&clt->dev);
>  }
>  
> +/*
> + * Close and free every path of @clt.  The caller has torn down sysfs, so
> + * no paths can be added or removed, and does not use the session any more
> + * (no IO, no rtrs_clt_query()).
> + *
> + * Until its close work has finished, a path can still reconnect (firing
> + * link_ev, whose user may call rtrs_clt_query()) or fail requests over,
> + * and both walk clt->paths_list.  So move every path to CLOSING first,
> + * which keeps further reconnect attempts from starting, wait for all of
> + * them, and only then free.
> + */
> +static void rtrs_clt_destroy_all_paths(struct rtrs_clt_sess *clt)
> +{
> +	struct rtrs_clt_path *clt_path, *tmp;
> +
> +	list_for_each_entry(clt_path, &clt->paths_list, s.entry)
> +		rtrs_clt_close_conns(clt_path, false);
> +	list_for_each_entry(clt_path, &clt->paths_list, s.entry)
> +		flush_work(&clt_path->close_work);
> +
> +	/*
> +	 * The close works have flushed every reconnect and stopped the
> +	 * heartbeat, and the caller issues nothing, so nobody walks the list
> +	 * any more and no grace period is needed.
> +	 */
> +	list_for_each_entry_safe(clt_path, tmp, &clt->paths_list, s.entry) {
> +		list_del(&clt_path->s.entry);
> +		rtrs_clt_destroy_path_files(clt_path, NULL);
> +		kobject_put(&clt_path->kobj);
> +	}
> +}
> +
>  /**
>   * rtrs_clt_open() - Open a path to an RTRS server
>   * @ops: holds the link event callback and the private pointer.
> @@ -2887,7 +2919,6 @@ struct rtrs_clt_sess *rtrs_clt_open(struct rtrs_clt_ops *ops,
>  				 size_t pdu_sz, u8 reconnect_delay_sec,
>  				 s16 max_reconnect_attempts, u32 nr_poll_queues)
>  {
> -	struct rtrs_clt_path *clt_path, *tmp;
>  	struct rtrs_clt_sess *clt;
>  	int err, i;
>  
> @@ -2943,12 +2974,8 @@ struct rtrs_clt_sess *rtrs_clt_open(struct rtrs_clt_ops *ops,
>  	return clt;
>  
>  close_all_path:
> -	list_for_each_entry_safe(clt_path, tmp, &clt->paths_list, s.entry) {
> -		rtrs_clt_destroy_path_files(clt_path, NULL);
> -		rtrs_clt_close_conns(clt_path, true);
> -		kobject_put(&clt_path->kobj);
> -	}
>  	rtrs_clt_destroy_sysfs_root(clt);
> +	rtrs_clt_destroy_all_paths(clt);
>  	free_clt(clt);
>  
>  out:
> @@ -2962,17 +2989,9 @@ EXPORT_SYMBOL(rtrs_clt_open);
>   */
>  void rtrs_clt_close(struct rtrs_clt_sess *clt)
>  {
> -	struct rtrs_clt_path *clt_path, *tmp;
> -
>  	/* Firstly forbid sysfs access */
>  	rtrs_clt_destroy_sysfs_root(clt);
> -
> -	/* Now it is safe to iterate over all paths without locks */
> -	list_for_each_entry_safe(clt_path, tmp, &clt->paths_list, s.entry) {
> -		rtrs_clt_close_conns(clt_path, true);
> -		rtrs_clt_destroy_path_files(clt_path, NULL);
> -		kobject_put(&clt_path->kobj);
> -	}
> +	rtrs_clt_destroy_all_paths(clt);
>  	free_permits(clt);
>  	free_clt(clt);
>  }
> -- 
> 2.43.0
> 
> 
