Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795818732;
	b=tykIP2VWeUG1hfUy+TD24d4R9jahWp/OE6KlfeQYOEVjDgLBnMQpEIzuWVTK4JKoO1o1
	 OdAKhrCJhjEXUuY6CvIN2UQGFN1De3k0+B8S7a1V1yfLp3j2dZ+dwu/SlIcM/xZXE1xRL
	 /P46hi1dsjlKvDECFaCk3+Qu7YVuFbPDnaYH5UiY1yIxFCI7c7+9mtYlibnPrT50RBS6C
	 3EEQwzoVr4Kr4cWdCXMxNXWymmq8firfvvVmjOS16c2fWpAe/cSoNY9Q1BoyLTK1tuj/t
	 P7lMP1X5iP56dBTmoFTZIlN8S7lC6NFos4n7mvz5bUeSy/cWtIb0nd57N/5HYiCb04w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795818732;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=hf3iXViVGecIP9wPS3m2X07wBDLsna5TAyKFMYMJcRw=;
	b=SvVBoYE3+cGrJz6sMQDvtasTC8zscGY4E4ciXi7TKQVm4g1CVSBjba2x/umNhNHcbT3E
	 SUYE9jc3A9FDPjmp4yjNWjkqG+kh/8h5gQmbS8bxkhm0Z8O4tI60eg212HBU6z8c0YSvH
	 geUHcUTaNh3c6HfZjPegVyRHAzy/ugy+Sr0avC3o/JfeWV5rBDz1ghiLjjcWBJ3hTGxC7
	 7O+RcqgniYMfXtK9M7gM0jXHoGxTNE2gxaOiI9nxwy5TCTP7rUiYvJtVul9Q+Hp/5LSae
	 fmKMmKtGQLOcwT9aGLN5zLCF+eTY3cMCAOAV8wEQYOKL3psDxAOi4+jM7BANpeQ/sTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=md0yhpBp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA56B606A331;
	Fri, 27 Nov 2026 22:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=md0yhpBp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28E211F00898;
	Fri, 27 Nov 2026 22:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795818732;
	bh=hf3iXViVGecIP9wPS3m2X07wBDLsna5TAyKFMYMJcRw=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=md0yhpBpykQrEMbjjtHbuksb0uXZpGZYeJnAmw8yZJAME4GXUYGU9kHomWn1pgJIu
	 Ptz2t9vCbTHiNG9qBpQrCA+Io/waa1HOoumFma6Y70wq5FDJ9IH7biacanewpDeRuM
	 A7DyAHapauSGG+aQVcojZVhtQRt8KUtWRC+nS2S9+FZd0z5vtohBq/n1VCIH+aD8Tr
	 0TvNzwBEyBdJZKsSAOlKQvQmLGEbsDopQQftU8xtKqG/gIWYEScVmSWMd4L6O3B1m1
	 D+zCkg1NUtRj599gy6Luu+VOZWFzQWRMsfqdGD6LF/OqkqUhMCleHaLlpoq7RoDY/9
	 84wstPwbX3uLw==
Subject: Re: [PATCH net 04/10] net/mlx5e: Drain pending hardware event work
 before freeing IPsec SA
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 willemb@google.com, parri.andrea@gmail.com, borisp@nvidia.com,
 cratiu@nvidia.com, eedmunds@nvidia.com, gal@nvidia.com, jmassar@nvidia.com,
 jianbol@nvidia.com, kuniyu@google.com, leon@kernel.org,
 linux-rdma@vger.kernel.org, mbloch@nvidia.com, phaddad@nvidia.com,
 raeds@nvidia.com, saeedm@nvidia.com, horms@kernel.org,
 sridhar.samudrala@intel.com, steffen.klassert@secunet.com
Date: Fri, 27 Nov 2026 22:32:10 +0000
Message-ID: <179581873075.3135.16762994208019735596@kernel.org>
In-Reply-To: <20261126215614.792598-5-tariqt@nvidia.com>
References: <20261126215614.792598-5-tariqt@nvidia.com>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] The commit message leaves out a second change to IPsec init and
  teardown ordering.

--

net/mlx5e: Drain pending hardware event work before freeing IPsec SA

The IPsec hardware event work item now lives in struct
mlx5e_ipsec_sa_entry instead of being allocated for each event. This lets
mlx5e_xfrm_free_state() call mlx5_eq_synchronize_async_irq() and then
cancel_work_sync() on it before the SA is freed. The patch also moves the
mlx5 notifier registration out of the ASO helpers and into
mlx5e_ipsec_init() and mlx5e_ipsec_cleanup().

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> index a549851c83827..ea7a1ae2056fa 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c

[ ... ]

> @@ -1022,18 +1031,22 @@ void mlx5e_ipsec_init(struct mlx5e_priv *priv)
>  	if (!ipsec->wq)
>  		goto err_wq;
>  
> -	if (mlx5_ipsec_device_caps(priv->mdev) &
> -	    MLX5_IPSEC_CAP_PACKET_OFFLOAD) {
> +	if (pkt_offload) {
>  		ret = mlx5e_ipsec_aso_init(ipsec);
>  		if (ret)
>  			goto err_aso;
> +
> +		ipsec->nb.notifier_call = mlx5e_ipsec_event;
> +		ret = mlx5_notifier_register(priv->mdev, &ipsec->nb);
> +		if (ret)
> +			goto clear_aso;
>  	}

[ ... ]

> @@ -1073,8 +1089,10 @@ void mlx5e_ipsec_cleanup(struct mlx5e_priv *priv)
>  		ipsec->netevent_nb.notifier_call = NULL;
>  	}
>  	if (ipsec->aso)
> -		mlx5e_ipsec_aso_cleanup(ipsec);
> +		mlx5_notifier_unregister(ipsec->mdev, &ipsec->nb);
>  	destroy_workqueue(ipsec->wq);
> +	if (ipsec->aso)
> +		mlx5e_ipsec_aso_cleanup(ipsec);
>  	kfree(ipsec);
>  	priv->ipsec = NULL;
>  }

[Severity: Low]
Could the commit message also describe this init and teardown change?
Right now it only covers embedding event_work in sa_entry and cancelling
it in mlx5e_xfrm_free_state().

The patch also makes these changes:

  - mlx5_notifier_register() and mlx5_notifier_unregister() for ipsec->nb
    move out of mlx5e_ipsec_aso_init() and mlx5e_ipsec_aso_cleanup() in
    ipsec_offload.c. They now live in mlx5e_ipsec_init() and
    mlx5e_ipsec_cleanup().

  - mlx5e_ipsec_init() now checks the return value of
    mlx5_notifier_register(), which was ignored before. It also gains a
    new err_notifier unwind label.

  - mlx5e_ipsec_cleanup() now calls destroy_workqueue() before
    mlx5e_ipsec_aso_cleanup(), where it used to call it after.

The reorder looks like a fix for a separate lifetime problem. Before this
patch, event work still pending on ipsec->wq could run this path after the
ASO had been freed and ipsec->aso set to NULL:

  mlx5e_ipsec_handle_event()->mlx5e_ipsec_aso_query()

The new ordering looks correct. Without a note in the changelog, though,
someone backporting this may not see that the ordering change is needed.

Would it make sense to add a sentence explaining why the workqueue has to
be drained before the ASO is torn down?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261126215614.792598-1-tariqt%40nvidia.com
