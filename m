Return-Path: <SRS0=N7RC=7W=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5598C433E0
	for <linux-rdma@archiver.kernel.org>; Tue,  9 Jun 2020 07:03:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6EB622078D
	for <linux-rdma@archiver.kernel.org>; Tue,  9 Jun 2020 07:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591686237;
	bh=gJCmDFSpevMtUkXKqxfCO9nCWu/9s+zEF9OmqSc5Pi8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=FrX9uvosgDYyMW8FZVWL1ebuCZ5oTwyRScdSdAsW1LrejlfKukonb2xJPLxCybKoj
	 K6xc+xpozqfoG58NtHo6ZT9b696INGFKL46h6tJqQVrAf48vTHmIJwgu/l1TVTvOwV
	 NWvBm4/g5OSUIkAD607g4hHm3di1GE/3UGy/xqbg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbgFIHD4 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 9 Jun 2020 03:03:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:33596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725770AbgFIHD4 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 9 Jun 2020 03:03:56 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 741802074B;
        Tue,  9 Jun 2020 07:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591686236;
        bh=gJCmDFSpevMtUkXKqxfCO9nCWu/9s+zEF9OmqSc5Pi8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mZpsvISs9bUqkt1QiKYqPG5iiE8eMKgnR7Qn0A8C+E3Mr9DaVdB+XhKUmTfBajYdJ
         Qu5MYvXg7MgmcJh1FCZrbyStF05wde0aHQyi9S2qS71AuMzEmw8mnMkdjUCHt7CAHg
         ZKJWuxqmEjzdX0Kaf1x41CKZUffKmmpKYj5iHnJY=
Date:   Tue, 9 Jun 2020 10:03:52 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Divya Indi <divya.indi@oracle.com>
Cc:     linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Kaike Wan <kaike.wan@intel.com>,
        Gerd Rausch <gerd.rausch@oracle.com>,
        =?iso-8859-1?Q?H=E5kon?= Bugge <haakon.bugge@oracle.com>,
        Srinivas Eeda <srinivas.eeda@oracle.com>,
        Rama Nichanamatlu <rama.nichanamatlu@oracle.com>,
        Doug Ledford <dledford@redhat.com>
Subject: Re: Review Request
Message-ID: <20200609070352.GK164174@unreal>
References: <1591627576-920-1-git-send-email-divya.indi@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1591627576-920-1-git-send-email-divya.indi@oracle.com>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Mon, Jun 08, 2020 at 07:46:15AM -0700, Divya Indi wrote:
> [PATCH v3] IB/sa: Resolving use-after-free in ib_nl_send_msg
>
> Hi,
>
> Please review the patch that follows.

Please read Documentation/process/submitting-patches.rst
14) The canonical patch format

You don't need an extra email "Review request" and Changelog should be
put inside the patch itself under "---" marker.

Thanks
