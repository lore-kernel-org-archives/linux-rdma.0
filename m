Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA32EC77B60
	for <linux-rdma@archiver.kernel.org>; Fri, 28 Apr 2023 13:39:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbjD1Njx (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 28 Apr 2023 09:39:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346343AbjD1Njv (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 28 Apr 2023 09:39:51 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2238435BD
        for <linux-rdma@vger.kernel.org>; Fri, 28 Apr 2023 06:39:50 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id af79cd13be357-75131c2997bso615611285a.1
        for <linux-rdma@vger.kernel.org>; Fri, 28 Apr 2023 06:39:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1682689189; x=1685281189;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ksPuMd/nWB2WaYDgyVZZ1GQJEYq4kNKPng4+0nhoQHo=;
        b=ARo04kJqXnGihMAgnU4MvdX+xSPvjPoukj2cxkUEVvZkVz+vtDFtYJP9rDM9gMqijl
         UuqNCAaTnhQGsisFViPypaLjFCMukgSJIQPj/gVBZRxXzsc/hVAY1kEsn/lHMD9DX0eF
         +JG53QcNt90dlKsprzggZBg8mW3eTFUL57PgWWWguTAJ1QE0+BGfu0J2Cy3g0kmkVeY7
         VeFEm1R9NDscmFqug5G5hP67QtYl0uKI5BIUQq+YnoiH0Ag2/RqLJFnUo+iuw5Tb9KJs
         qvUtK9xsvbe+/oaVJERuphRFbVbGaHiFAvdXUWhD0mRJmfJLHgnJ8eB2ohMuPO4PKV5V
         9OWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682689189; x=1685281189;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ksPuMd/nWB2WaYDgyVZZ1GQJEYq4kNKPng4+0nhoQHo=;
        b=GaFabw68yhnNJgwQbaNehxPW3YD26Y6nXDt5ewCM2Gno4ZmPQTdQRgpjoHSMourAvc
         uPbmLYNgPRrrDF78kLcCi5eU1xQrJGcyb/0TmeAAVLtK+tlM/Yghg283Es5If60hjI1I
         8KtkerbfI82mX5BTZYUMNla/iEFPYdLYt48CaBSs2v1nq4fZH8qgPFNkuYul+Ugt7B9f
         Fsp7dYBrHni2Dg+dfIhz6eJZAB/YVSLUexH9P+byv3COsQqxTLYYbIszeENh/945/Zjc
         hbu/ii6zP8QyF9rxsdIsRbQf4lwSuyl6hPfDmraY3KrLEqVxBOqIZts3AzA7bQQl+aDW
         LTCw==
X-Gm-Message-State: AC+VfDyDYHsvy8y2nI89gviG5Ebc4IOihdbdYZVrmkuX7tuhX4EqaAz+
        /PIixPdJRr9kYWucWfmDjhJY3yQLjEPZq8a/vD0=
X-Google-Smtp-Source: ACHHUZ6eLxhmU3noiqnW+gzNksajCNvjQhvISupgtPuJ+2Um8l2kLcGLakZYkt9FEj9LAf4eqerq6w==
X-Received: by 2002:a05:622a:1350:b0:3ef:34e1:d37d with SMTP id w16-20020a05622a135000b003ef34e1d37dmr8041765qtk.25.1682689189215;
        Fri, 28 Apr 2023 06:39:49 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-25-194.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.25.194])
        by smtp.gmail.com with ESMTPSA id f1-20020ac80681000000b003ef3eae106csm6957420qth.60.2023.04.28.06.39.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Apr 2023 06:39:48 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1psOKB-003CDC-U8;
        Fri, 28 Apr 2023 10:39:47 -0300
Date:   Fri, 28 Apr 2023 10:39:47 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Chuck Lever <cel@kernel.org>
Cc:     BMT@zurich.ibm.com, linux-rdma@vger.kernel.org,
        linux-nfs@vger.kernel.org
Subject: Re: [PATCH RFC] RDMA/core: Store zero GIDs in some cases
Message-ID: <ZEvMo4qkj9NSLXTA@ziepe.ca>
References: <168261567323.5727.12145565111706096503.stgit@oracle-102.nfsv4bat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168261567323.5727.12145565111706096503.stgit@oracle-102.nfsv4bat.org>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Thu, Apr 27, 2023 at 01:14:43PM -0400, Chuck Lever wrote:
> From: Bernard Metzler <bmt@zurich.ibm.com>
> 
> Tunnel devices have zero GIDs, so skip the zero GID check when
> setting up soft iWARP over a tunnel device.

Huh? Why? How does that make any sense?

Jason
