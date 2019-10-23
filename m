Return-Path: <SRS0=3BW3=YQ=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF5CDCA9EB6
	for <linux-rdma@archiver.kernel.org>; Wed, 23 Oct 2019 17:42:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A951921929
	for <linux-rdma@archiver.kernel.org>; Wed, 23 Oct 2019 17:42:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="kms7BHYD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731458AbfJWRmY (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 23 Oct 2019 13:42:24 -0400
Received: from mail-qt1-f181.google.com ([209.85.160.181]:34972 "EHLO
        mail-qt1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731112AbfJWRmX (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 23 Oct 2019 13:42:23 -0400
Received: by mail-qt1-f181.google.com with SMTP id m15so33598357qtq.2
        for <linux-rdma@vger.kernel.org>; Wed, 23 Oct 2019 10:42:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3z4OTpqM1IXXicd22iFwut4x2IoYUpJh3hTR5XIsq24=;
        b=kms7BHYDYXnYyfMFKp2dxxZ91TtFt36KU9wBlTRJuBYodiKkfdvIwlO8QbHxIv/8iq
         qvoso4vNUtW1gLFyyYs+eaLgAvPGssEhCvAXm/YR8gimMydCDPqdTEfX//jdgqb11QZF
         yoM89ENB2bjiuNxXicPKyBkphGYnkhoQu6lombn7mu8YZYIf0cqPCBQioWpCH+rtADrx
         7WGciyJpAs5dKFN3y+fyUlJN3mX+u3JiVZ/ZSQ+Ipaem1Gyyihkf97Eb/SxyZrNy6sSf
         Fjt2fJ0h95tEDo5X1aUY41VO4sxV9U9Y0ELB/v6uQYIcLmj/ST5cpl0cynMFy/0LDpol
         XwZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=3z4OTpqM1IXXicd22iFwut4x2IoYUpJh3hTR5XIsq24=;
        b=sd+2xxnPEWJ5Dv6hq6Xy2p/qIZi7GiWqti/jgDWgzNmk1yCDnmAKyMHyVq0BY8NYmj
         B5HXzOhg/NPPkW8s+gSi7+hZM53tYWEFT+XHVcDV11UiJ+d+MWqirkUTOSNg9ehgieL+
         4grlqNHR+L9D4w2QcMwZMS8k4QgPr2W1aI0eeYB2de9lIjl9tmlUQSHjCDoSn+jyNiZa
         9ym+I4AP2Ge0PviIV5YAKAqhLmtagIq7j5PeTrlaS3CH1BEisMdn4RReWF5R0UieLHd/
         DmEmnNp9VhLiLl/8tMhblrWFsGpH2eKe9GbC7swi6CAOop+mmoSh9TyvionxicgehzO6
         81pQ==
X-Gm-Message-State: APjAAAWVHSX2Q4BrC0X1UjEuvunl06Jo/9nGJmg1pdvDLAmSuGFslHX6
        1Qg8HeYq/yymp1Os5n3eqrPNlw==
X-Google-Smtp-Source: APXvYqwskkyupukCI3qDvFcniW4cikeTh0Yf5VitCQ+07tmBFNTLuIOl8hEpizBOBy6u/rz2b9C9RA==
X-Received: by 2002:ac8:2247:: with SMTP id p7mr10836411qtp.180.1571852540747;
        Wed, 23 Oct 2019 10:42:20 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-180.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.180])
        by smtp.gmail.com with ESMTPSA id m20sm10515662qkk.51.2019.10.23.10.42.20
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 23 Oct 2019 10:42:20 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1iNKeJ-0005sJ-O1; Wed, 23 Oct 2019 14:42:19 -0300
Date:   Wed, 23 Oct 2019 14:42:19 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Kamal Heib <kamalheib1@gmail.com>
Cc:     linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH for-next] selftests: rdma: Add rdma tests
Message-ID: <20191023174219.GO23952@ziepe.ca>
References: <20191023173954.29291-1-kamalheib1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191023173954.29291-1-kamalheib1@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Wed, Oct 23, 2019 at 08:39:54PM +0300, Kamal Heib wrote:
> Add a new directory to house the rdma specific tests and add the first
> rdma_dev.sh test that checks the renaming and setting of adaptive
> moderation using the rdma tool for the available RDMA devices in the
> system.

What is this actually testing? rdmatool?

This seems like a very strange kselftest to me.

Jason
