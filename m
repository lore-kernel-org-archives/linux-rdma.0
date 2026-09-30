Received: from fhigh-b2-smtp.messagingengine.com (fhigh-b2-smtp.messagingengine.com [202.12.124.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DAA43911DC
	for <linux-rdma@vger.kernel.org>; Thu,  1 Oct 2026 04:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790830491; cv=none; b=aKoy4m6WWA16Kr7iu0xg2P17zibtxkFJ1794Jv3tiSp1kmVAnLx9uGYVYSzcanL7yfmEUcp9voPgJ0/HEY8LqiVaYNAk4L+vNEV/83+84KpaMafXnaoCK6jiR/mpELzT5uNznANodnvlZgBo7DZYQTZqmpxkng/vFfkl8Xh7TIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790830491; c=relaxed/simple;
	bh=C2JITBpO0cPMMCnjlXunESd4iolvpXsHTDjDFltASqU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oYsgQBdb15jFPpoELP3KM+DKQrx90uFBv6DmlPO9nbJhZh4HzDl93NsJwSZhe0Q6TstmXPY8/KDItUjqvHxF6YBoZ/NlMtTMOLm9surElcg5fX9FG5xYVCUXQ7CMr9e2JGjrON9IQ93qGzQ8AHECgI7sSvscs1pQo5F5CDHNp+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kroah.com; spf=pass smtp.mailfrom=kroah.com; dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b=MqlQNbgc; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Py/NnpFN; arc=none smtp.client-ip=202.12.124.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kroah.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kroah.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b="MqlQNbgc";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Py/NnpFN"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 6D7BA7A00CC;
	Thu,  1 Oct 2026 00:54:48 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Thu, 01 Oct 2026 00:54:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1790830488; x=1790916888; bh=TkPJZVI9jA
	bEDPulpabyTcoUNAvK0Vsd4K/5zRy3Rks=; b=MqlQNbgc5whkE/FD5weEdGrsJI
	iCxrrfWNOh9mF86Wpe2fl7IFKTlJaO53wf3dFTKt0Kv1J+T50MA+jMT8AR0MGjce
	bdeetZxEGTY58i4W60LRp7/mYddj5eKcX6dpnBkJt0M94R/rHvAXsbyo7pirhHDk
	13l4gGkC6gTIQGyOS7q88BFwjj1YcdqcGyIVUTWoCe/IeK6WDoXzlt7Vk3448Jlj
	GCENpUR6feosMrRngjZVMsHr/jq00mlEoI/8YQpMNmyZlYbbGi9nngwo+dfzNQ8t
	faszj4fwLD9ym4o+v5IbrwIli+lEBpYrQS+OWMTM4fBf5tsNh8NWXA1ScS2g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1790830488; x=1790916888; bh=TkPJZVI9jAbEDPulpabyTcoUNAvK0Vsd4K/
	5zRy3Rks=; b=Py/NnpFNIm/qSOAiELVmU2oF5zH/OUsKJRFvaJ/2u372BLNiFI+
	qlnBUVCf08WqFDyHrN19WMOhrLw6tgRFIrg6vyPueaB8pxj/3GqppKwSdFFUG+2w
	9Q3Ix0OAH6/knChjQ95ZxF6r0H1z4b8L3XADma2eVNlgw+xUDea97WbFBI4z6c/K
	3x/58XGRjNFLKc1ViHb4juZ0vNq6vLEZxxaOT2Vs+Xc/dgRfNbfdCzY/M8vLJt71
	LhcR0mKvT5TIKA39kgrk3vZByCnZsy9t4KfLBBki/fjcijGndpeb0zncdcEcGikD
	rTActQHwahU3ZxR6YWTE9bfpL5zEwQ7KSrA==
X-ME-Sender: <xms:mOe9aoX52iQ0MWVo09LihtKqN1pLGhJC3VtsQir3MSLphd-6BkpWOg>
    <xme:mOe9amnZ7j6rE9Vmnu6Gt_R65RKX56oC654adHeuft6aE5dZLcXGCfOEKmpu8DCgT
    JG19TVOiNukRjTyWoafeP5Lophc4sA7P2NiTV3OTzTA3tOwyHk>
X-ME-Received: <xmr:mOe9ajB2EQbvdeZ139Nm3SOspwp9vc-o1FstLOewXbLKk4Ey6XGnIex63UgJnLKEL7UcSu1jCEs_mdAy9f4F71EhUbFRqG6B-h4cVeP5rts>
X-ME-Proxy-Cause: dmFkZTFTk0DAZisxRbaA4BOumDSEJ+WNQZif40pfJSW1Qx8KFhpYRttt/xHbs5nyPLyO8V
    S11mBoQgYaxyXtwyu6lXuwRbYTTKFdbWgF77ux8MLcwMK4TGEZHris1InMytm5Io/A8b6D
    uo8C0ApPRQ1tf2M2d/mfZgvmSlJMVbweUoIN0xASj6mHw//ESuQNfRbVOtmuyUIFTMvkKd
    OdpCE3Q7IyZonYNkm3/VZHe2VqFYlm5sdYzvqngRKFIACNd0Q0VEnESI5yJMavSxLAhYMA
    626XKvzimazYywTVwQnsS+iyajUi0G/xov8LiObS1I40Wnf8Ti2hlUeRXOco9OIJQTutdl
    qBVsTJvRWJxeJutzny2uvSFsNsyKoNNNAXPztcmrgYFLU7umc/KaxpQHOIdfFYGqp124qA
    Tzeqok0wUn2fHi/ogAfiCB2Ax7gVapGdrMgzdSuSbeE54Gjd5JfmVN1H/aCJGp3UMLJp9a
    dRb3mzzAtL9wgDgl4LloAJpvvdEA/vY1U+1Vzvfj6WuvLiazdDpzadY9R0tdYrpw2aZt6L
    aPC69WgXB3XMCF2fEMloIivA2+ym7ya97AW3vjCuS3speeYjEwuemz7f6AVhhdcYPkVq9U
    oYaDIalnBltp6hJ8+OssIpU8Yw92RsYnjHdSh6tS6xKmKqZOSr6ISQV6w/eQ
X-ME-Proxy: <xmx:mOe9alhwlrqGsAUmksLgef135xwqhNFFgDsrafUt0i0m3m5fbXAz8Q>
    <xmx:mOe9agw24P4k-FM9sQi5bXxwZU1s0BoJcXU36SbIH_s5z8y_89d2sQ>
    <xmx:mOe9am2ryWNvhMjseiye_zdH-lVIC7BFDDvxoADu8JlFYiLN-ie-Pw>
    <xmx:mOe9al_Ae8I9G81K7ZAPZe2C3EMn42BU40MAyyst9uem_UM2--gTAg>
    <xmx:mOe9ai0l_r2NNLGLT1oBpu9WV1WTDKztks1RcqNPK0x9ksVy5LoDigFM>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 1 Oct 2026 00:54:47 -0400 (EDT)
Date: Wed, 30 Sep 2026 17:35:29 +0200
From: Greg KH <greg@kroah.com>
To: AYS <ays511.kr@gmail.com>
Cc: zyjzyj2000@gmail.com, linux-rdma@vger.kernel.org, security@kernel.org
Subject: Re: [PATCH] RDMA/rxe: bound the WQE opcode before indexing
 rxe_wr_opcode_info[]
Message-ID: <2026093009-from-autograph-5601@gregkh>
References: <CAPAqSgY_3HQwokvRpErRfZvT32CJODXSsd0=TE985exOkZ2WHA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPAqSgY_3HQwokvRpErRfZvT32CJODXSsd0=TE985exOkZ2WHA@mail.gmail.com>

On Wed, Sep 30, 2026 at 11:31:08PM +0900, AYS wrote:
> wr_opcode_mask() indexes the global rxe_wr_opcode_info[] array with a
> caller-supplied opcode and no bounds check. For a user QP the WQE comes from
> an mmap'd SQ ring, so wqe->wr.opcode is an attacker-controlled __u32 read back
> by the requester (req_next_wqe() -> rxe_requester()); rxe_post_send() takes
> the qp->is_user branch and never runs validate_send_wr(), whose only opcode
> check is itself !wr_opcode_mask() (it indexes before it checks).
> rxe_wr_opcode_info[] has entries only up to IB_WR_REG_MR, so an out-of-range
> opcode reads out of bounds and the result is used as a mask and dereferenced;
> observed as a KASAN global-out-of-bounds "Read of size 4" and a wild-pointer
> oops.
> 
> Return a zero mask for an out-of-range opcode, matching how validate_send_wr()
> already treats a zero mask (an invalid WR), so no path indexes the array out
> of bounds.
> 
> Fixes: 8700e3e7c485 ("Soft RoCE driver")
> Signed-off-by: Youngsung Ahn <ays511.kr@gmail.com>
> ---
> Notes (not part of the commit):
> Reproduced on a KASAN x86-64 build of 7.3-rc4 as uid 1000. Present unchanged
> in mainline 551c722f4080 (2026-09-29) and rdma for-next. Compile-tested
> (KASAN+RDMA_RXE), not runtime-tested. Found through manual review; per
> security-bugs.rst this is public and a reproducer can be shared on request.
> IB_WR_REG_MR is the highest index the array initializes; an
> ARRAY_SIZE(rxe_wr_opcode_info) bound would be equivalent but the array is
> extern to this header.
> 
>  drivers/infiniband/sw/rxe/rxe_loc.h | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/infiniband/sw/rxe/rxe_loc.h
> b/drivers/infiniband/sw/rxe/rxe_loc.h
> index 64d636bf80fd..dcc0788db90a 100644
> --- a/drivers/infiniband/sw/rxe/rxe_loc.h
> +++ b/drivers/infiniband/sw/rxe/rxe_loc.h
> @@ -184,6 +184,9 @@ void rxe_comp_queue_pkt(struct rxe_qp *qp, struct
> sk_buff *skb);
> 
>  static inline unsigned int wr_opcode_mask(int opcode, struct rxe_qp *qp)
>  {
> + if (unlikely(opcode < 0 || opcode > IB_WR_REG_MR))
> + return 0;
> +
>   return rxe_wr_opcode_info[opcode].mask[qp->ibqp.qp_type];
>  }
> 
> --
> 2.43.0
> 

Patch is corrupted and can not be applied :(
