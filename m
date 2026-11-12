Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794519231;
	b=qOcHcNVfCcDgr58J8bd0A37pKMtkMKnFtZcaKD60nkAlihIav4vrdww7LThUykKSPQXN
	 75pRqLeUrgB/btbc38Mv1G3IDBbbExggKmrbvfdm2rSCGZVMrvuWG34/JpqIBU7smZT1A
	 Sx1gzsWo4jYOJ3y64maUE5oBUYhnUqcLJcu8ezgiP8/coRkwUqSIIarScajhpfxQMiI2H
	 JgQLb/slCabfRA5XeSpQLVrsDHEtyvyJFOAy8sUOZbnYj0kXfOjzWabEgf6+nzHMy1PJX
	 Ngjh3XnPkEMF/hOohztyJBxanicNr7G+e/UGMq3YyEWU5QTK6MMEeSDicTtGZuK6HHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794519231;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=B1nHuEfs2ZwDEq4F5sl2TrpESM/akN0rejt8We1Bf8g=;
	b=rF5VDFLT7MEDEGIW2dMCneV6bq7d2nnRy5BoUW3A9Erv8bCeMuDj5GrO/ZEZI3twKMr/
	 JmOes4acRN7ZLP3heTWMc44kpapqpkBeST9hTdOlvJQB50wvx4t3EnHHAvBcSEQp5dijC
	 UqE6E9S+aR7SHwNaW0MQa6x5/HxGNorPNoqlmKG9OzNZWn8ueae+eww+MzSeV3NqFh7R4
	 fpukucPuz6gJAz6x/UsRMrEO+BzeIcuBmP6UQjXjteTTap/6M9UK0JhXdbKrvqpRtFbDw
	 Uac4YiA3AilFhbNItPurqqehW8yqkhb6QZvijQkcOLVOlt0QOFWFYCoTpOA3x8kUMBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=Bhw6envU;
	arc=none smtp.remote-ip=199.89.1.16
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D57B606A31C;
	Thu, 12 Nov 2026 21:33:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2D57B606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=Bhw6envU
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4jQYY413stzlqkZW;
	Thu, 12 Nov 2026 21:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1794519221; x=1797111222; bh=B1nHuEfs2ZwDEq4F5sl2TrpE
	SM/akN0rejt8We1Bf8g=; b=Bhw6envUHArq5lyI50d2Acpiyod8FqX+3dRtI076
	ScyuXWP90v0QNIDrvfG8afLaFkhi/OGg37E3T4aDVX2T67OGoshOAeBbHyoqPsPZ
	PyITlON0S8LHTcFarX2HZu1+xprQf6M5dbWDSilGUB8eaqTOxGt7P7eT7NUJLFVU
	1iBoInBois3cSgYa6afG2EtYfbgtz7QSH5GWnetS3LdED3gmNEmI1cqtQ5bb9IXV
	1vtWEEbeNCGoOcy6iRyEKEvUQ5l9iQFb6u7hKjawTK7KH3HSwEUwflX8X1fhHRKJ
	HeoE4fVbJpvPXz2lGWGZzMmRGkZi2Ho9KCqjN+oPvEeeiQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id STmJZHg_h9mo; Thu, 12 Nov 2026 21:33:41 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4jQYY14KsFzllCWh;
	Thu, 12 Nov 2026 21:33:41 +0000 (UTC)
Message-ID: <92a82300-a454-4ee5-a191-0ce5a2ee58c7@acm.org>
Date: Thu, 12 Nov 2026 13:33:40 -0800
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] RDMA/srpt: Prevent uninitialized read buffer
 disclosure
To: liuyong <pkfxxxing@gmail.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 linux-rdma@vger.kernel.org, target-devel@vger.kernel.org,
 linux-kernel@vger.kernel.org, security@kernel.org
References: <20261110030809.913063-1-pkfxxxing@gmail.com>
 <20261110030809.913063-2-pkfxxxing@gmail.com>
 <20261110052827.963143-1-pkfxxxing@gmail.com>
 <20261111065342.1282709-1-pkfxxxing@gmail.com>
 <20261112094138.1390409-1-pkfxxxing@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261112094138.1390409-1-pkfxxxing@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/12/26 1:41 AM, liuyong wrote:
 > +		target_init_cmd(cmd, ch->sess, &send_ioctx->sense_data[0],
 > +				scsilun_to_int(&srp_cmd->lun), 0,
 > +				cmd->sam_task_attr, dir, 0);
 >  		goto busy;

srpt_get_send_ioctx() zeroes ioctx->cmd, hence the current code
triggers a NULL pointer dereference in target_send_busy()
(cmd->se_tfo == NULL) if srpt_get_desc_tbl() fails. That is a separate
bug that can be triggered remotely. Please move this change into a
separate patch, mention the NULL pointer dereference in its description
and explain in a comment why the target_init_cmd() return value is
ignored.

 > +			/* Make CPU writes and zeroed data visible to the RDMA device. */
 > +			if (!ib_uses_virt_dma(sdev->device))
 > +				dma_sync_sg_for_device(sdev->device->dma_device,
 > +						       ctx->sg, ctx->nents,
 > +						       DMA_TO_DEVICE);

This is unrelated to the information leak. If a DMA sync is missing
between filling the buffer and posting the RDMA WRITE, then that issue
applies to all data written by the backend and also affects other
users of the RDMA R/W API, e.g. nvmet-rdma. Additionally, this code
relies on how rdma_rw_ctx_init() maps the S/G list. If a sync is
needed, it should be added to the RDMA R/W API. Please leave this out
of this patch.

 > +	/* Control CDB handlers may leave part of the response untouched. */
 > +	if (cmd->data_direction == DMA_FROM_DEVICE &&
 > +	    !(cmd->se_cmd_flags & SCF_SCSI_DATA_CDB))
 > +		sg_zero_buffer(sg, sg_cnt, send_ioctx->buf_len, 0);

__target_submit() only zeroes the first S/G element for control CDBs.
I think it's better to fix this in the target core by zeroing the
entire buffer there since that benefits all fabric drivers that provide
their own S/G lists. With that change, srpt only has to zero the part
of the buffer beyond cmd->data_length, for all READ commands.

 > +static void srpt_zero_read_tail(struct srpt_send_ioctx *ioctx)

The S/G lists of the RDMA contexts are chained and are passed to the
target core as cmd->t_data_sg / cmd->t_data_nents. Hence, this function
can be replaced with a single call:

	sg_zero_buffer(cmd->t_data_sg, cmd->t_data_nents,
		       ioctx->buf_len - cmd->data_length, cmd->data_length);

 > +		for (i = 0; i < nbufs; i++)
 > +			total_len += be32_to_cpu(idb->desc_list[i].len);
 > +		if (total_len != be32_to_cpu(idb->len))
 > +			return -EINVAL;

Please log the mismatch with pr_err(), similar to the check above it.
That makes it easier to debug interoperability issues with initiators.

Please also mention which tests have been run against the new version.

Do the SRP tests from https://github.com/linux-blktests/blktests still
pass?

Thanks,

Bart.
