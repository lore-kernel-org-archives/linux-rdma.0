Return-Path: <SRS0=j6t7=6T=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95CBAC3A5A9
	for <linux-rdma@archiver.kernel.org>; Tue,  5 May 2020 01:09:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66846206D7
	for <linux-rdma@archiver.kernel.org>; Tue,  5 May 2020 01:09:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="cLoDl+jv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgEEBJK (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 4 May 2020 21:09:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726551AbgEEBJK (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 4 May 2020 21:09:10 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28AF2C061A0F
        for <linux-rdma@vger.kernel.org>; Mon,  4 May 2020 18:09:10 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id x12so676309qts.9
        for <linux-rdma@vger.kernel.org>; Mon, 04 May 2020 18:09:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=pseDX/vd959GjPUrXE9qfXRdW3luLIxgrjADdnn6dUI=;
        b=cLoDl+jvii5tSoqw/CKmNyctoHoWQ/7tuaP0Pw0jWAq+TYOQWPcpAanaQXrSDQulaw
         tLAvNlO4w7KdYRIhTRIgLaX20qmzOkz5Oz0Dgieuj3VO2wFSfR7g1E4z+01Qr8msBExq
         eJN15z+ZRoGo4QLUws4KTPJfQVbdykMm81xDZE6JMfZHAw/HmnwqXWdCJLISeYj2XL+d
         bTXqK3elb7iZ5Y8xhS3KfV0FqLj1gmAx2led9wIHu0s4227Wf1Ycex480N4Whl5mdnxC
         pHQlvkkrOYQWS2aZT6lelE2rxTYMNJ5pHKFOJ8DCr/XtZ+9JeDfKr6LL5bWceXnmUiFU
         YxbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=pseDX/vd959GjPUrXE9qfXRdW3luLIxgrjADdnn6dUI=;
        b=CpzX+iZ5/4slRjmiEMY9SpLaQbddKydAwWrdWQj+A86vxEh7tFruV2jct8S4pk7Y3/
         SJImk/AWW0fw8Jj2C8y8Au0O2/whpQuoGIOl6A7FVfzbg92Dcoiq2q82PJGSgAHckqW8
         5fpBlkyqsCtmSYuNc+Rm9KSQ9RZK//n562a6A9eISCLZ2MZycblISRqEOL0CG52uMwpZ
         FY7I+oWaKdIpXtyjnGRkNsexmG8ZNSu6osWkhtxjHu4UgScaflI34qKQ9BhycmJxkcVk
         m2w4fKHIkrEKX/qizBahsqorCykuTIOywiVYxLRb6EcZ4GlgLalLN6WE048bmfzm/JSh
         cHtw==
X-Gm-Message-State: AGi0PubP95s5VDDMFLtUNe7i0H4kQ6XVJb698sftXABPlXRXWD9LJwo/
        QY2m7Q3pz+LA1gqjLw1xlyyQ4c4VGUQ=
X-Google-Smtp-Source: APiQypJurw92B25LwVWPwZernkm+7SLjKTeVrFpGY2ua2kDaUIXW7wIEEOj6otOwMDAVE0itpKhbXQ==
X-Received: by 2002:ac8:3a83:: with SMTP id x3mr257649qte.44.1588640948983;
        Mon, 04 May 2020 18:09:08 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id y4sm447479qti.33.2020.05.04.18.09.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 04 May 2020 18:09:07 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jVm54-0004xl-VX; Mon, 04 May 2020 22:09:06 -0300
Date:   Mon, 4 May 2020 22:09:06 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Gal Pressman <galpress@amazon.com>
Cc:     linux-rdma@vger.kernel.org
Subject: Re: Can't build rdma-core's azp image
Message-ID: <20200505010906.GD26002@ziepe.ca>
References: <05382c9f-a58d-ba5a-02cd-c25aa3604e52@amazon.com>
 <20200407180658.GW20941@ziepe.ca>
 <67f9e08a-467c-34ce-e17e-816cb4bf03db@amazon.com>
 <ca41331c-3b53-fbb6-4543-bc960f796062@amazon.com>
 <20200417162150.GH26002@ziepe.ca>
 <519a9c33-fa1b-7439-fa6a-7a54b69bde0b@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <519a9c33-fa1b-7439-fa6a-7a54b69bde0b@amazon.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Sun, Apr 19, 2020 at 09:37:45AM +0300, Gal Pressman wrote:
> Unpacking libc6:arm64 (2.27-3ubuntu1) ...
> dpkg: dependency problems prevent configuration of libc6:i386:
>  libc6:i386 depends on libgcc1; however:
>   Package libgcc-s1:i386 which provides libgcc1 is not configured yet.
> 
> dpkg: error processing package libc6:i386 (--configure):
>  dependency problems - leaving unconfigured
> dpkg: dependency problems prevent configuration of libgcc-s1:ppc64el:
>  libgcc-s1:ppc64el depends on libc6 (>= 2.17); however:
>   Package libc6:ppc64el is not configured yet.
> 
> dpkg: error processing package libgcc-s1:ppc64el (--configure):
>  dependency problems - leaving unconfigured
> Errors were encountered while processing:
>  libc6:i386
>  libgcc-s1:ppc64el
> E: Sub-process /usr/bin/dpkg returned an error code (1)

Wow, that is actually an APT bug... Must be from old age :O

Ah we can hack around that with this:

https://github.com/jgunthorpe/rdma-plumbing/pull/new/azp_fix

Let me know if it works

Now that github has docker hosting I wonder if we should try to host a
copy of the docker image there.. Their docker hosting is a pain last I
looked though..

Jason
