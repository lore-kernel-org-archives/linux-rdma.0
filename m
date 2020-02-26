Return-Path: <SRS0=T2EA=4O=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 534CFC4BA13
	for <linux-rdma@archiver.kernel.org>; Wed, 26 Feb 2020 14:13:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1CF3224683
	for <linux-rdma@archiver.kernel.org>; Wed, 26 Feb 2020 14:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582726424;
	bh=Z/SU7bAJrTqmM8UQr594lbwv9bhSMpLNabJVIeUlnBw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=INy8du2BP3BAyXKHcRweQHUeWBZmp5GrwSQ6ocJwLlM74hXea2SkXj5kLt9H8Tu7z
	 QV9q9PHPAnUVkBMOVkr5qTfpKs61Dd3z5Y2NYw1KLChLMS3y5+46yTlEUecgsgsUsy
	 q6805/ESq+e7UsIpQhUgLhgJuHq60+BgTwzHVeIY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbgBZONn (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 26 Feb 2020 09:13:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:33462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726579AbgBZONn (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 26 Feb 2020 09:13:43 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34D1E2467B;
        Wed, 26 Feb 2020 14:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582726422;
        bh=Z/SU7bAJrTqmM8UQr594lbwv9bhSMpLNabJVIeUlnBw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=enu3roc3bTzCShfSnnqCGAjhH+gV5NHsL3WcLCERXm38yk5iyMcu54j5lCrycoWxU
         0wg18bB+wYt1iBFcAHXV5hd+Q9OxhiAmqPFdQsSoMRA162xIfGE8b5rx4XHe2xiTWV
         gqQOnn7KiJldhCDkfylDtnvmEzC5DX5opLalhhLI=
Date:   Wed, 26 Feb 2020 16:13:40 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
Cc:     "Dalessandro, Dennis" <dennis.dalessandro@intel.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH for-rc] RDMA/core: Fix additional panic in
 get_pkey_idx_qp_list()
Message-ID: <20200226141340.GF12414@unreal>
References: <20200225133150.122365.97027.stgit@awfm-01.aw.intel.com>
 <20200226130432.GB12414@unreal>
 <a6c9d82e-59ca-eb27-fe53-ca6edd55fb5b@intel.com>
 <20200226134802.GC12414@unreal>
 <MWHPR1101MB22717251968B09F6D695214486EA0@MWHPR1101MB2271.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR1101MB22717251968B09F6D695214486EA0@MWHPR1101MB2271.namprd11.prod.outlook.com>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Wed, Feb 26, 2020 at 02:08:52PM +0000, Marciniszyn, Mike wrote:
> > > You mean this one? https://marc.info/?l=linux-
> > rdma&m=158263596831342&w=2
> >
>
> Ok.  I will test the patch.
>
> > Yes, this is what I wanted to achieve by "if (!(qp_attr_mask &
> > (IB_QP_PKEY_INDEX || IB_QP_PORT)) && qp_pps) {" line.
>
> Was a non-bitwise || what was intended in this statememt?

No, another mistake, see commit
commit 4ca501d6aaf21de31541deac35128bbea8427aa6
Author: Nathan Chancellor <natechancellor@gmail.com>
Date:   Mon Feb 17 13:43:18 2020 -0700

    RDMA/core: Fix use of logical OR in get_new_pps

It is still mystery but we didn't see failures with "broken" code.

Thanks

> >
>
> Mike
