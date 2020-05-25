Return-Path: <SRS0=ECiD=7H=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74041C433E0
	for <linux-rdma@archiver.kernel.org>; Mon, 25 May 2020 17:22:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 533EE2070A
	for <linux-rdma@archiver.kernel.org>; Mon, 25 May 2020 17:22:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="A3/X19Gz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391291AbgEYRW1 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 25 May 2020 13:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388230AbgEYRW1 (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 25 May 2020 13:22:27 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2089EC061A0E
        for <linux-rdma@vger.kernel.org>; Mon, 25 May 2020 10:22:27 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id f83so17961529qke.13
        for <linux-rdma@vger.kernel.org>; Mon, 25 May 2020 10:22:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ot+IcM8qPkKqAOCfj/m77ORc6vsqR0+D6xrRuetngZU=;
        b=A3/X19Gz8RQI+F4DhJ5DIhogl9QufHNqYFw3fHHAE3QoLjfAjqCkZSFBpFFZgjDEc2
         sTTRJd0MpXzPPTKat5qMRmXDpb0m79jNzErOdu6iM1s7TBvSw+pgKLKGugv+lTkjcHT1
         ZEolZak1wQ7CCERVBTAjJo4xTiNtFlFn4bakh0P6XPmBxPGZ10atGOcnVw03GTbQbtDO
         I7zeOLw4N7XtcX2zBaHs9AeJfaSd7wzxIU1sTDEVmRg4ucesNhnhkOJm5XLVqjCZaCRL
         lJU4LPLtrogDn+XpWl6EbVlq123MOLmX0KFhNgOcJLnWLsFTJLwH/EKRDsasfqQjQJoH
         wXOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ot+IcM8qPkKqAOCfj/m77ORc6vsqR0+D6xrRuetngZU=;
        b=ERimG/SJ+ZdPst4OZ24c3sUwrl68SfeAzwip/DsYNgOBhON1TqMRqOJ3f4Ljj4CgAK
         cFGg/kzMoxK7XfMgVDOQ1kd29rWp/sVyKENBbIAXVonJW6YlNwPwGOldF2pomiE3k/hZ
         l01i47bmWeLH67GFosfCJajlokNCsWVGA94TdEgg0sNUsFEp66gbbwIUPj5PpQ9D+y2t
         N+NGbKu1ZU667c2kxV5y4w+ltkl86TwpT7lEI8S68BF/oYCnlS8PYzg+Pb0haQaIr7Hz
         7o442uUJdUGuNKn/FhqW2mgkHlshlRNQe1rJNgWdRdWf6vt5y3UoWFpX1ShRQKM9Dv72
         985w==
X-Gm-Message-State: AOAM530oruWXtuYCW4w88FEVnOw9jmwU2FgoAxpuG0rt2Awb41Pv/V9t
        rJcVn3wEvxr7PJ7OXhqJr3kz9+5GDO4=
X-Google-Smtp-Source: ABdhPJx93FD6gE2VVWIQ/eIY6ZRFq03BiO1cXl3eXyunEk79p16Ky7ijvQ1fjUvF9cDJ+pqQj1p+nQ==
X-Received: by 2002:a37:4351:: with SMTP id q78mr24385471qka.242.1590427346418;
        Mon, 25 May 2020 10:22:26 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id s4sm13430084qkh.120.2020.05.25.10.22.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 25 May 2020 10:22:26 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jdGnx-0007a0-LA; Mon, 25 May 2020 14:22:25 -0300
Date:   Mon, 25 May 2020 14:22:25 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Weihang Li <liweihang@huawei.com>
Cc:     dledford@redhat.com, leon@kernel.org, linux-rdma@vger.kernel.org,
        linuxarm@huawei.com
Subject: Re: [PATCH for-next 0/4] RDMA/hns: Misc cleanups
Message-ID: <20200525172225.GA29081@ziepe.ca>
References: <1590152579-32364-1-git-send-email-liweihang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1590152579-32364-1-git-send-email-liweihang@huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Fri, May 22, 2020 at 09:02:55PM +0800, Weihang Li wrote:
> This is another series of cleanups for kernel 5.8 if it's not too late.
> 
> Lang Cheng (1):
>   RDMA/hns: Simplify process related to poll cq
> 
> Weihang Li (1):
>   RDMA/hns: Remove redundant type cast for general pointers
> 
> Wenpeng Liang (1):
>   RDMA/hns: Remove redundant parameters from free_srq/qp_wrid()
> 
> Yixian Liu (1):
>   RDMA/hns: Make the end of sge process more clear

Applied to for-next, thanks

Jason
