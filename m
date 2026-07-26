Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F47D248880;
	Sun, 26 Jul 2026 07:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785052519; cv=none; b=YNQCmcssAMAEU7RB39zzmHR2yT2THdLYMY/dkDR27m53deXYCKvxQ4KsOlExed1R8r0hUqhg7scJ25UedGwGHggp0R1ePYW67VDK1tNhqD6Jp3hS81BuQgUzgVk5BVGBwIe83LKng8lJteabi3w1lMsWNs1k5Hr7UIx9Enu9kCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785052519; c=relaxed/simple;
	bh=OiMO73u0D3944SIy9J9lszv48ZZZNV/OSLk9y08+QfY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lQF64Zghp2qwhxY1sBvRplJ4gXjJgxMVgxEmRBPrRTybnGJt+qq+sVswpe/WikZf28fezpHyZkWkMSPe16A5qslSxefrA+uQ/0DgYosPg3zeX+2h90AVdJrLuBApyhJ5h2sm3ZHRrXaJv2g47OKx4/kYyatGsOk3yG6LtTi4ILo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UOTmlmpy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UOTmlmpy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B27721F000E9;
	Sun, 26 Jul 2026 07:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785052518;
	bh=XbT4FegLK82Go8FSNtRzFE1Gp4ouo3+bOMQCMDpJg1I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UOTmlmpy27cOHLtAv7sdYYwPRq5pDAb7krqx7S8TnX3gYiP+6/CC59FoJyJKCku9S
	 pgP8oONKpeenaYuHz9UHtkAG6CzJnG1y5JMPnzXghcoOq4kWqZuEhEykRjqdOuKnG4
	 6gUBb9Gsw2R6CaXE3VL3IXsFwbIsOIvlK7JVTqHOJRTgqCWUuen78irmHMzI+s4puo
	 E4YXi1QlISsSqAtq6bpW7Lg5wx1iomtUDXz/VOD5eCEZzBJPq0C+kdozSPCFuytQ+y
	 x3NgoXjbK5gi48+TCEpyafsukFh/+dIC6iTRBO8nE8tP/ZbIIasfrFSrQX+Y/s0kbQ
	 bT8/ghqxWTO1w==
Date: Sun, 26 Jul 2026 10:55:11 +0300
From: Leon Romanovsky <leon@kernel.org>
To: kensanya <kensanya@163.com>
Cc: bvanassche@acm.org, jgg@ziepe.ca, linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
	TanZheng <tanzheng@kylinos.cn>
Subject: Re: Re: [PATCH v2] RDMA/srpt: fix NULL deref when sending BUSY
 before target_init_cmd()
Message-ID: <20260726075511.GC12003@unreal>
References: <20260723024456.52851-1-kensanya@163.com>
 <20260723095120.GF110966@unreal>
 <56479481.2552.19f920118cd.Coremail.kensanya@163.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <56479481.2552.19f920118cd.Coremail.kensanya@163.com>

On Fri, Jul 24, 2026 at 10:42:53AM +0800, kensanya wrote:
> At 2026-07-23 17:51:20, "Leon Romanovsky" <leon@kernel.org> wrote:
> >On Thu, Jul 23, 2026 at 10:44:56AM +0800, kensanya@163.com wrote:
> >> From: TanZheng <tanzheng@kylinos.cn>
> >> 
> >> If srpt_get_desc_tbl() fails, srpt_handle_cmd() jumps to
> >> target_send_busy() before target_init_cmd() has set cmd->se_tfo.
> >> target_send_busy() then dereferences a NULL se_tfo.
> >> 
> >> Call target_init_cmd() first with placeholder data_length and
> >> data_direction, parse the descriptor table next, then fill in the
> >> real data_length. That way target_send_busy() is safe if parsing
> >> fails.
> >> 
> >> target_send_busy() is only valid after a successful target_init_cmd().
> >> If target_init_cmd() itself fails, free the send ioctx tag locally
> >> with target_free_tag() instead of calling target_send_busy().
> >> 
> >> Fixes: 8b8807b9e982 ("scsi: RDMA/srpt: Fix handling of command / TMF submission failure")
> >> Link: https://lore.kernel.org/all/20260717025402.64054-1-kensanya@163.com/
> >> Suggested-by: Bart Van Assche <bvanassche@acm.org>
> >> Signed-off-by: TanZheng <tanzheng@kylinos.cn>
> >> ---
> >> v2:
> >> - On target_init_cmd() failure, use target_free_tag() instead of
> >>   target_send_busy()
> >> 
> >>  drivers/infiniband/ulp/srpt/ib_srpt.c | 36 +++++++++++++++++++--------
> >>  1 file changed, 26 insertions(+), 10 deletions(-)
> >> 
> >> diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
> >> index f66cfd70c263..71af1fb0d380 100644
> >> --- a/drivers/infiniband/ulp/srpt/ib_srpt.c
> >> +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
> >> @@ -1558,8 +1558,8 @@ static void srpt_handle_cmd(struct srpt_rdma_ch *ch,
> >>  	struct srp_cmd *srp_cmd;
> >>  	struct scatterlist *sg = NULL;
> >>  	unsigned sg_cnt = 0;
> >> -	u64 data_len;
> >> -	enum dma_data_direction dir;
> >> +	u64 data_len = 0;
> >> +	enum dma_data_direction dir = DMA_NONE;
> >>  	int rc;
> >>  
> >>  	BUG_ON(!send_ioctx);
> >> @@ -1584,6 +1584,25 @@ static void srpt_handle_cmd(struct srpt_rdma_ch *ch,
> >>  		break;
> >>  	}
> >>  
> >> +	/*
> >> +	 * Call target_init_cmd() before srpt_get_desc_tbl() so that
> >> +	 * cmd->se_tfo is set if descriptor parsing fails and
> >> +	 * target_send_busy() is used. data_length is filled in after a
> >> +	 * successful srpt_get_desc_tbl().
> >> +	 *
> >> +	 * target_send_busy() is only valid after a successful
> >> +	 * target_init_cmd(). On init failure free the tag locally.
> >> +	 */
> >> +	rc = target_init_cmd(cmd, ch->sess, &send_ioctx->sense_data[0],
> >> +			     scsilun_to_int(&srp_cmd->lun), 0 /* data_len */,
> >> +			     TCM_SIMPLE_TAG, DMA_NONE, TARGET_SCF_ACK_KREF);
> >
> >1. TCM_SIMPLE_TAG -> you need to rebase to latest rdma-next.
> 
>       I will modify and resend the patch.
> 
> >2. You are hardcoding dir, while it can be overwritten in srpt_get_desc_tbl().
> 
>       In the srpt_handle_cmd() function:
>       &send_ioctx->cmd;
>       srpt_get_desc_tbl(..., send_ioctx, ...) 
>            ioctx->cmd.data_direction = *dir;
> 
>      Therefore, after successfully calling srpt_get_desc_tbl(), even if target_init_cmd() is
>      passed DMA_NONE, cmd->data_direction should already have stored the actual direction.
> 
>      Do you mean  that after calling srpt_get_desc_tbl(), displaying the overwritten content
>      would be better？I want to make sure I address the intent of your comment correctly.

You need to do this correctly: target_init_cmd() must receive the
correct directory, as calculated by srpt_get_desc_tbl().

Thanks

> >
> >Thanks
> 
> Thanks,
> TanZheng
