Return-Path: <SRS0=zI+0=5Q=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B8E7C43331
	for <linux-rdma@archiver.kernel.org>; Tue, 31 Mar 2020 13:02:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C820121473
	for <linux-rdma@archiver.kernel.org>; Tue, 31 Mar 2020 13:02:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="iqckFFsD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730686AbgCaNCo (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 31 Mar 2020 09:02:44 -0400
Received: from mail-qt1-f172.google.com ([209.85.160.172]:33664 "EHLO
        mail-qt1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730473AbgCaNCo (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 31 Mar 2020 09:02:44 -0400
Received: by mail-qt1-f172.google.com with SMTP id c14so18216581qtp.0
        for <linux-rdma@vger.kernel.org>; Tue, 31 Mar 2020 06:02:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WvciGNT4Swu8x7tqkBLqGitjDN1PC4vLzFpPCNletYE=;
        b=iqckFFsDpFlxtbJS5sb+1XmDhhTelXn/8FdvMk9NclL+RchNfUcwPb2C9q5Gml936E
         YBxU7//mELwQEPn8zAA1wXm8Xxaw3F83uE7zwBlOCB8/wR9RNW9TM0zSm01epQ1UEblR
         s1tDCnPtonZ+2j/GIkmxgFkzbDwjuMlBunPx6+pecE79fYDyLd1iBnWHwWkwMpR7m/OG
         EC+aK6hGeVx+sbJtW9x+mMEUrjERBzHGIK5kN/j0G+9+7Blh1tQFlzknBv1mhDeUPvNv
         dV1dirqhzPEn6K8HI7X+H+a28u5ecW9jzko6Ha2VovgvBkkbbLtaLcALyYyn+5GiPD6y
         vMPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=WvciGNT4Swu8x7tqkBLqGitjDN1PC4vLzFpPCNletYE=;
        b=m0aXnPdDKqaD7quTSOs5VsENkCUnXgDgsYWgqUMb4l/1Jwq9o1MOoCy6+hQADSeocP
         l4nFPpbI/X+RzW6gUd/PV2t3pbYpmsQTBgtEKaw2tqyhTy4rHv+MHvcOfyEbARYxW1ar
         Lq6x+nfqxeLYOFstdHQKDpuDar/piDZPzOyI0RQ3OdkhJg3aAt3khkudiCEvyRmcjmu1
         hZdgrP/KMRGuVZJqHt61prvnbvZGawWSxH/i4Cf64up/9S4v8FQK7oXlVENNSVzR0z0B
         jHlizKxaLO+bZllPd4OPPnTqGuzTg1RbQmfa8A3ndYDDGTYmXN6zN+/xSdpnf5bHrLJ3
         YD8g==
X-Gm-Message-State: AGi0PubUuEeCB+mGsn7fMvvbrL2LmgkZl1iKiED9HacIpc1XED3VV3Ta
        YY2o6CYRPusHSR/7BX9nTuEBBkOF1AZm3w==
X-Google-Smtp-Source: APiQypKwfdmHSjAKC+yYPrx3gnmnEzljrLLmNIX5AzT8PpupJ5lr+VDbNMaAlRn2pCkrQR5ILE7seA==
X-Received: by 2002:ac8:2a68:: with SMTP id l37mr430751qtl.77.1585659761795;
        Tue, 31 Mar 2020 06:02:41 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id a18sm10174670qkc.117.2020.03.31.06.02.40
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 31 Mar 2020 06:02:40 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jJGXP-0002hS-R6; Tue, 31 Mar 2020 10:02:39 -0300
Date:   Tue, 31 Mar 2020 10:02:39 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Jacques Marais <jacques.marais@vastech.co.za>
Cc:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: ibv_send_wr untagged union
Message-ID: <20200331130239.GL20941@ziepe.ca>
References: <CC88D066-59C0-42D3-9C19-41D1D9FDF3EC@vastech.co.za>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CC88D066-59C0-42D3-9C19-41D1D9FDF3EC@vastech.co.za>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Tue, Mar 31, 2020 at 12:42:06PM +0000, Jacques Marais wrote:
> Hi
> 
> I have a question regarding a untagged union field added in commit:
> https://github.com/linux-rdma/rdma-core/commit/f67fa98d3c0cb78c95f84301572eb93989d4b0f9
> 
> Specifically the union in the 'ibv_send_wr' structure:
> https://github.com/linux-rdma/rdma-core/blob/master/libibverbs/verbs.h#L1097-L1100
> 
> We have a golang wrapper library in order to make use of infiniband
> in our system. However golang can only interface with tagged unions.
> 
> Is it possible to tag that union?

No, it is 'api' that it remain untagged

Jason
