Return-Path: <SRS0=XFIj=5F=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8234CC4332D
	for <linux-rdma@archiver.kernel.org>; Fri, 20 Mar 2020 07:14:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57A8520786
	for <linux-rdma@archiver.kernel.org>; Fri, 20 Mar 2020 07:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1584688497;
	bh=V6V8reebmlB1IRxUpqvAffGWx1ELLX6cAVcdtHJsGPo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=Gb5iU+46+BIVWky0ohEDUDOYXqtxjw0+lTaaXFwtZodvxMFpNF76BFPF9CbGSAPXy
	 gwkHlAPN46vdtUBY9jidp3BiP2yT58hC9ubdFtZLlaOwx1X9aetdLIlms6v1BrHbDS
	 HmMtNCOb5qXT9CgXi4qHcZrjiHC+ax56kydWEuEE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbgCTHO4 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 20 Mar 2020 03:14:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:35976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726834AbgCTHO4 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 20 Mar 2020 03:14:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A727920781;
        Fri, 20 Mar 2020 07:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584688496;
        bh=V6V8reebmlB1IRxUpqvAffGWx1ELLX6cAVcdtHJsGPo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HHQCeW1dQzgNrNBj/2gfu84NQippFqD2X7zpgITBdsfb/eUw5k7UVmTI7w6vLj712
         j6CR+jZQ8D8k7Hr4XkQaP6W7aI/mq2+90I3JPWRqpWJyVYQtzYlhWzDljd/v/EcklG
         CIxkiKcgXe3vHp89I9P0t5tVfBy76nmDzLzwkAXI=
Date:   Fri, 20 Mar 2020 08:14:53 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Elliott Hughes <enh@google.com>
Cc:     tglx@linutronix.de, linux-spdx@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH] uapi/rdma/: add SPDX for remaining OpenIB headers.
Message-ID: <20200320071453.GA309332@kroah.com>
References: <20200320004836.49844-1-enh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200320004836.49844-1-enh@google.com>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Thu, Mar 19, 2020 at 05:48:36PM -0700, Elliott Hughes wrote:
> These header files have the same copyright as others in this directory
> that have this SPDX line.
> ---

No signed-off-by: line?  :(

Fix that up and I'll be glad to take these, if the rdma developers don't
want to.

thanks,

greg k-h
