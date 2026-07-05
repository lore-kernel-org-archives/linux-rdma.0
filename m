Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 724327081F
	for <linux-rdma@vger.kernel.org>; Sun,  5 Jul 2026 12:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783253701; cv=none; b=f5SPByJBg9tQngazJWu4KBbFkX/db5j93Tugmc+aonVwKaBo3/Kkm5wscye9GMD51CXGJz6Lo7ARnsaOPuv35IWSn1m5NHEAV2ikhk/xTBqc531dCpQ0B1nZWINKMd00Qa52QsVIjN529WlKISxxBRMUh2OD2VJe5BT8tuxQ5tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783253701; c=relaxed/simple;
	bh=eiGr/AcWWsU/A+qVKXXvT0Tlt8E7uI5/CCZD04NlAUU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o29ZF4iCzxzD1wPIoLxGqf1JC2IqwdHywryyRhzyr04SA34oRIfcwsbfEaf1kWQenvwXpog6BwVOgVozBwH04awyRZSJ41SBbI6/odXCBsu466WcPE/xeYlX3H/eihb8S/wZTts22unuontwB1f33Fhs+1ChD74ffpAATH0KYZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vos4l4Ix; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vos4l4Ix"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C8371F000E9;
	Sun,  5 Jul 2026 12:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783253700;
	bh=daDkV+w1kUVhn8pZgny8ODdXR+j5mMfcB9XrjXtRXFk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Vos4l4Ix0iiO2ikR/sDEU2XjMii56bkdXRKSkjz0IKCBjV0hga4Ut1f3BJDcn0fK/
	 TfUtAdVslPiqEMoIk9KUExzRRz2Dfge6wds8WMsxdvn9odfrAYPWAFrx6BBN1QPpM9
	 k+gcf+AcnB4F0inKDt4irhUNCqPCt+aeJsLtQOe2rESoewz1HUj8hp7u3yJA/vOGkE
	 /LL+vTu8G6tfMvk3EIgNeF+gDDkWxoKdyKfW4TqmPLVlJ53yFPJMZrUi58Rp4Stb1C
	 UNH20FCSIjb30ujUZa4sziGc3qyFFqb60USD+IJikfqgNPk2zK+sigtwgMc3q7JYze
	 eD1AmEtEpcbQQ==
Date: Sun, 5 Jul 2026 15:14:54 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Jacob Moroni <jmoroni@google.com>, jgg@ziepe.ca
Cc: tatyana.e.nikolova@intel.com, linux-rdma@vger.kernel.org
Subject: Re: [PATCH rdma-next 3/5] RDMA/irdma: Use ib_respond_empty_udata
 where applicable
Message-ID: <20260705121454.GC15188@unreal>
References: <20260627025642.4064973-1-jmoroni@google.com>
 <20260627025642.4064973-4-jmoroni@google.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260627025642.4064973-4-jmoroni@google.com>

On Sat, Jun 27, 2026 at 02:56:40AM +0000, Jacob Moroni wrote:
> Methods that do not provide any user response should use
> the ib_respond_empty_udata() helper to ensure that user
> response buffers are cleared.
> 
> Signed-off-by: Jacob Moroni <jmoroni@google.com>
> ---
>  drivers/infiniband/hw/irdma/verbs.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
> index 19dcc475c355..d06df520d9be 100644
> --- a/drivers/infiniband/hw/irdma/verbs.c
> +++ b/drivers/infiniband/hw/irdma/verbs.c
> @@ -457,7 +457,7 @@ static int irdma_dealloc_pd(struct ib_pd *ibpd, struct ib_udata *udata)
>  
>  	irdma_free_rsrc(iwdev->rf, iwdev->rf->allocated_pds, iwpd->sc_pd.pd_id);
>  
> -	return 0;
> +	return ib_respond_empty_udata(udata);

I wonder how this is supposed to work. What should the user do
after hitting this error? Retry the operation? The object has
already been deallocated.

Thanks.
