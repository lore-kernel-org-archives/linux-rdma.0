Return-Path: <SRS0=RHPu=CD=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 070C5C433DF
	for <linux-rdma@archiver.kernel.org>; Tue, 25 Aug 2020 05:09:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC3C82071E
	for <linux-rdma@archiver.kernel.org>; Tue, 25 Aug 2020 05:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598332179;
	bh=xghkNZGiHt08vLm/Z1dguQak2SCtktG5m7zGti3yt9U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=DxgruIspCPIZho22G1vgnW0RbCohVB6N9Kw/pMqpGcv3Z7DUhpNPO2qt74h/47cvO
	 MUd41am95+rUy23xf2VAWt7Hcirz8BUWW7dzmabDXf9eb1kDZUphDoxJ/UV6gXtGby
	 wukcH+V3pH6leNYoyQRG0Q6Z5p4aF2b8+YCTVgSc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbgHYFJj (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 25 Aug 2020 01:09:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:54298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725781AbgHYFJi (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 25 Aug 2020 01:09:38 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BE8F2071E;
        Tue, 25 Aug 2020 05:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598332178;
        bh=xghkNZGiHt08vLm/Z1dguQak2SCtktG5m7zGti3yt9U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bHxiCWv62Ae+2mYHIcTW0sNwOYsYyUicNPZjcAcH064eZa/CLZdhRIHMqMrbmjHeX
         7xCFWOAE6d5IkI8M1F02GpIYkgZEsYh5YSuJN8nLWs6zRSscqFdSTrcz+YPrNZFv2k
         CbjDhnji9myYszpOqc7gmySzLo6qex9n/SWMDByo=
Date:   Tue, 25 Aug 2020 08:09:34 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Bob Pearson <rpearsonhpe@gmail.com>
Cc:     zyjzyj2000@gmail.com, linux-rdma@vger.kernel.org,
        Bob Pearson <rpearson@hpe.com>
Subject: Re: [PATCH] Fix tests/test_device.py
Message-ID: <20200825050934.GN571722@unreal>
References: <20200825012344.5696-1-rpearson@hpe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200825012344.5696-1-rpearson@hpe.com>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Mon, Aug 24, 2020 at 08:23:44PM -0500, Bob Pearson wrote:
> Removed a test case which requires vendor_part_id to be non zero.
> Per IBTA A3.3.1 VENDOR INFORMATION it is not required that the
> vendor part ID field be set to a non-zero value:
>
> 	The following components are vendor specific: VendorID, DeviceID, De-
> 	vice Version, Subsystem VendorID, SubsystemID, ID String.
>
> 	The vendor places its IEEE assigned Organization Unique Identifier
> 	(OUI) in the VendorId field and *MAY PLACE ANY VALUE IN THE DEVICEID* and
> 	Device Version fields. The vendor may also provide an ASCII string of its
> 	choice in the ID String field.
>
> 	The Subsystem VendorID and SubsystemID provide additional informa-
> 	tion when a subsystem vendor uses components provided by other ven-
> 	dors. In this case the subsystem vendor provides its OUI in the Subsystem
> 	VendorID field and may specify any value in the SubsystemD field.
> 	A vendor that produces a generic controller (i.e., one that supports a stan-
> 	dard I/O protocol such as SRP), which does not have vendor specific de-
> 	vice drivers, may use the value of 0xFFFFFF in the VendorID field.
> 	However, such a value prevents the vendor from ever providing vendor
> 	specific drivers for the product.
>
> Signed-off-by: Bob Pearson <rpearson@hpe.com>
> ---
>  tests/test_device.py | 1 -
>  1 file changed, 1 deletion(-)


Thanks, I'll pick to rdma-core later this week if no objections come.
