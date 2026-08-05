Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC8AA38889B;
	Wed,  5 Aug 2026 15:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785942234; cv=none; b=qskjHo2t/pW6t/B9qR9O2wQtPqad73H08teCVAnJN1QqChZPWFbbRFzHGTuAdO+3m6OsAno6i8E5XeG+gS/Kg3fBBlU1qp71HtmmEMNH7RAfCgCTVm32P++j388THKPd8xie0jL4+67S5HpxOwZ5ZwAUr0xvZ1ZZnMrQz/hbuhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785942234; c=relaxed/simple;
	bh=fH9I3qb5tcXDQbvOEAPTHw1/cxgbgGPGUsl9Ul/kJ1w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U3o/700Ud8RXwZg45MNvbHoCJFljZdSgR9XxQXLL0SZ/CX1ZlV4/ykubunT5RDNEpLrdzVLZpZXzx1JbHNe5kfTczle+r2k59pFNKXjLBZspb0hWqb5mDqpZPVdSZiOkymSPSf64gJE/xLr3X7Z5zGXIMreAw4s5NA0ud5M/KQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B15o3Orv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B15o3Orv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53AF41F000E9;
	Wed,  5 Aug 2026 15:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785942230;
	bh=+39LRpNND11Y+pUIyCG3EWc9TB7URvX/vkuLIGRNNxk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=B15o3Orv2YKUM53fYl6CcAdk+q4o2siYB8HgDd61vbeddQhXIffCRfDHC/Cf2HZZt
	 15cjQ5sVz/8fN7wNX3tAMRb/WNGqlLhc1V5iLPGcJCbukOj7se45ZRkJEOlwgftXKu
	 d1gOfSNCuFYkDe9L9YACCEHU+jEsGHYLzcqTVHM7StBs1ZTDZPYhwxCtfr38QXhRPH
	 nEUYbFYP9jzD23opoh8s09IOvwc9qtFBt/uopeI1TG5tYKrMDThjpgP+j8rI/P2GI2
	 olCnFxjX4It07vdOqrT3k/cMUBMg8p+TL4LCXt54TU7ERIqvwHWgQGBG+dtQ8j2Y8C
	 Zm1NhbbT9nrdA==
Date: Wed, 5 Aug 2026 18:03:44 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Cc: sagi@grimberg.me, jgg@ziepe.ca, michael.christie@oracle.com,
	martin.petersen@oracle.com, linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v3 2/2] IB/isert: reject full-feature PDUs that arrive
 before registration
Message-ID: <20260805150344.GD23431@unreal>
References: <20260730135110.1647384-1-yhlee@isslab.korea.ac.kr>
 <20260730135110.1647384-2-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730135110.1647384-2-yhlee@isslab.korea.ac.kr>

On Thu, Jul 30, 2026 at 10:51:10PM +0900, Yehyeong Lee wrote:
> The full-feature receive buffers are posted from isert_put_login_tx(),
> which runs before __transport_register_session().  An initiator that does
> not wait for the final Login Response can therefore still have a SCSI
> command executed against an se_session whose se_tpg is NULL, with the same
> oops as the previous patch.
> 
> Move the ISER_CONN_FULL_FEATURE transition into isert_get_rx_pdu(), where
> it happens after the session has been registered, and reinstate the
> connection on any PDU that arrives before it, the same call this function
> already makes when a work completion fails.  The state is read without
> isert_conn->mutex because isert_recv_done() runs on ib-comp-wq; the acquire
> load pairs with the release store so that the session registration
> preceding it is visible.
> 
> Measured over rxe with an initiator that fires SCSI commands into that
> window without waiting for the Login Response, 400 login cycles per run:
> the oops appeared in 7 of 10 runs with only the previous patch applied and
> in 0 of 10 runs with this one on top.  The check fired 22 times across
> those 10 runs, 16 in ISER_CONN_BOUND and 6 in ISER_CONN_TERMINATING, where
> the reinstatement is a no-op because teardown has already latched.
> Well-formed traffic is unaffected: 20 runs of a spec-conforming initiator,
> 400 login cycles each, pass with the check never firing.
> 
> Fixes: b8d26b3be8b3 ("iser-target: Add iSCSI Extensions for RDMA (iSER) target driver")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
> ---
> v3: unmap login_tx_desc in isert_connect_release() (1/2); make the
>     FULL_FEATURE store a release and the state check an acquire load, and
>     log the value actually tested (2/2).  Both from Sashiko's review of v2.
>     v2: https://lore.kernel.org/all/20260730063124.1554460-1-yhlee@isslab.korea.ac.kr/

Sashiko is still not satisfied with this patch.

Thanks
