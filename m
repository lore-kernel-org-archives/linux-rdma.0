Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 971D4472F62;
	Tue, 21 Jul 2026 20:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664836; cv=none; b=upETclJl+miQ2U5azGlhkjj22r/tChqtgiIIGH4n6Z+86HMWgBOxrg7HkmXQNh5X2DZZAq0nHF6BSRvWp6Ed0VygcmUsHcYn3efVCUAiepKwRKlE34eAJDMFrrZFeMbXu4P6Bc10DJFBlryMcmmcKXusMjuAVNb4brAipQK/W98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664836; c=relaxed/simple;
	bh=2L+3BCG06iLdaK/CKLWLIdAY2y1wfXTErETicujdPcE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WJ6ipFpst9V2WCFdbRaZAZutAuXNA7TxRUIQH6cXAD03o4TNV/acdABID+iFsnD2me8IAue7Ufgkr2kaBjmnEqlvnMVvF/5ismEFLWKeYGJW3ZICFrAicAJyAk6Z7THhBLf739eqMbsUTU52su3XcL60ZxwlS80x8hVkcRCx6CY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=e3FXLeEZ; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="e3FXLeEZ"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4h4T9Y6CPdzlfvqP;
	Tue, 21 Jul 2026 20:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1784664830; x=1787256831; bh=rYMr1tKPbxY1Cr3dBgHWqvye
	NRic/bw7ZBLUXgtqIVU=; b=e3FXLeEZ9UW5A1tAy+h3u1uoRa6ZIydmodlCF8xR
	wMyBupGJyXh4G0p9AJWZUG07xbNChvOPZUKy8uZe+/a0FqgIIZqHjaiK1XYSOjB2
	dsGx2Uq48tuokiBK5is0Ng+4zMMCRrq/TLHUrvCPovUHvPyQKCvUHwRK4aVgWrtK
	7TydzHMIzVSR+qgcsOZ/e1vQtFt9CyQw+zkbpVtaC0x5/goDzafJ8SGWssdBW4F0
	3mmagxUHncgxlT7PmTvpqZ9RJU6NoLlNVSB8b45tWvMQX4G0G16+UHJ+oqSGWS1F
	f2kuylErLT1ZR4cVo1IwJXJtlXUWI0i/i7XqtqUVqzSGRQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id kqskXLTN55ZW; Tue, 21 Jul 2026 20:13:50 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4h4T9T1ZlFzlfvqD;
	Tue, 21 Jul 2026 20:13:48 +0000 (UTC)
Message-ID: <54cd4e16-f3c2-4e80-b8ab-98de3d2bd6c8@acm.org>
Date: Tue, 21 Jul 2026 13:13:48 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rdma-next] RDMA/srpt: Pass the mapped task attribute to
 target_init_cmd()
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 Nicholas Bellinger <nab@linux-iscsi.org>
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260721-b4-scsi-ordering-violation-due-to-hardc-v1-1-07205aab71bb@nvidia.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260721-b4-scsi-ordering-violation-due-to-hardc-v1-1-07205aab71bb@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/21/26 2:10 AM, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> srpt_handle_cmd() maps the initiator-supplied srp_cmd->task_attr into
> cmd->sam_task_attr, but then hands a hardcoded TCM_SIMPLE_TAG to
> target_init_cmd().
> 
> Pass the already mapped cmd->sam_task_attr instead, so target core sees the
> attribute the initiator requested.
> 
> Fixes: 9474b043132f ("ib_srpt: Convert I/O path to target_submit_cmd + drop legacy ioctx->kref")
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
> Bart,
> 
> I found this during code review, but I'm not sure what the
> original intention was.
> 
> The Fixes line references the addition of MSG_SIMPLE_TAG as a
> hardcoded value. MSG_SIMPLE_TAG was later renamed to TCM_SIMPLE_TAG.
> 
> Thanks
> ---
>   drivers/infiniband/ulp/srpt/ib_srpt.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
> index a22ee4fc1e4c..7197d95f2216 100644
> --- a/drivers/infiniband/ulp/srpt/ib_srpt.c
> +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
> @@ -1602,7 +1602,7 @@ static void srpt_handle_cmd(struct srpt_rdma_ch *ch,
>   
>   	rc = target_init_cmd(cmd, ch->sess, &send_ioctx->sense_data[0],
>   			     scsilun_to_int(&srp_cmd->lun), data_len,
> -			     TCM_SIMPLE_TAG, dir, TARGET_SCF_ACK_KREF);
> +			     cmd->sam_task_attr, dir, TARGET_SCF_ACK_KREF);
>   	if (rc != 0) {
>   		pr_debug("target_submit_cmd() returned %d for tag %#llx\n", rc,
>   			 srp_cmd->tag);

Although the Linux kernel SRP initiator always uses the SIMPLE tag, the
above change looks good to me. Hence:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
