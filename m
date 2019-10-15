Return-Path: <SRS0=iMHv=YI=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BC21C10F14
	for <linux-rdma@archiver.kernel.org>; Tue, 15 Oct 2019 17:06:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3117920872
	for <linux-rdma@archiver.kernel.org>; Tue, 15 Oct 2019 17:06:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="emeryovO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbfJORGR (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 15 Oct 2019 13:06:17 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34753 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbfJORGR (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 15 Oct 2019 13:06:17 -0400
Received: by mail-pg1-f193.google.com with SMTP id k20so5162388pgi.1
        for <linux-rdma@vger.kernel.org>; Tue, 15 Oct 2019 10:06:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ujgF9JEJhRgGi/p4jB+P1JVV1nhqg9X7Sqglf8nL3vU=;
        b=emeryovOquVrACLjncaCsSaZAc/laMOYt74EproQnqjivFEcjnhpbjNUoRzBrrVoGT
         6/2QxrXfEE7Trhj19ajsXZvj6jrEf/3JyGTyE+rVEJB+e2AhH1UE0MvkFyhS3+HGGtKZ
         EgkcuDfIGam+07xKG+pk97OgtUNPwXVvjGAcGxlnet/2JCyKQKWDVoCfXhVfZrzU/oMQ
         BdweI4lzBF1iCfxXe/HcsjQMjhnyruT1zLVpiPXbXnYZ8FApsvpumoaBPr8H2XpRFF7d
         MVyLEX7d+PgsbDXZSArQoDN7ph4DWFvQJ74YeslJAgWtevGAP84erK5zln0JgOJIpnO0
         uIKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ujgF9JEJhRgGi/p4jB+P1JVV1nhqg9X7Sqglf8nL3vU=;
        b=JZJhX2q6z4Cl+N+4xZhcpLhhfvSMbwJnQUz+2EtMXfGakViggai+78CGYXJw5v86mY
         a1soH5ZdVpcRdgUzX25xj7AMawgKYkHd0HHTjqlhEj+7tRHNnDYEmDuvxTkJZNVux0bB
         p8tmCnbO15/rAZ4xKfknbcPW44TcJCSR7xug9K50YE23ATv4sboJs5s1vYMN7wCFnLea
         odySqv3sczBFdS0CRzW7quoQQlgTvW6aiHPYak4q/Btal63q/1wNEdFUzFfn19Y9xXU+
         1wbl/Y7Tc8cFPoHCHCXiKs/Q2muZrqTHUSJv0VwRUZOjiei3DcWojgjlTVW63vxHLgMd
         rnYw==
X-Gm-Message-State: APjAAAXe1RkD7oqD86IfRpUTtIAbcPVPwisseR6eu4BW4aCA/+Leam6a
        YdUOZlhx/vkiRugfM2RlnIW+8g==
X-Google-Smtp-Source: APXvYqxiQb1oa6KMT7fZzXKtbFJUjxrmpYkuIuled6rcvZMkkkob1r2LWrhM/6hh8PXt2j1Z9O2dnA==
X-Received: by 2002:a62:870c:: with SMTP id i12mr39794755pfe.247.1571159175696;
        Tue, 15 Oct 2019 10:06:15 -0700 (PDT)
Received: from ziepe.ca ([72.143.229.181])
        by smtp.gmail.com with ESMTPSA id e14sm19114613pgk.70.2019.10.15.10.06.14
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 15 Oct 2019 10:06:15 -0700 (PDT)
Received: from jgg by jggl.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1iKQGz-0001Ti-Be; Tue, 15 Oct 2019 14:06:13 -0300
Date:   Tue, 15 Oct 2019 14:06:13 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Adit Ranadive <aditr@vmware.com>
Cc:     "dledford@redhat.com" <dledford@redhat.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Bryan Tan <bryantan@vmware.com>,
        Pv-drivers <Pv-drivers@vmware.com>
Subject: Re: [PATCH for-next v1] RDMA/vmw_pvrdma: Use resource ids from
 physical device if available
Message-ID: <20191015170613.GC5444@ziepe.ca>
References: <1568924678-16356-1-git-send-email-aditr@vmware.com>
 <20191008181544.GA2880@ziepe.ca>
 <8F02F753-B71A-4F73-83D8-D6224D6C4F6B@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8F02F753-B71A-4F73-83D8-D6224D6C4F6B@vmware.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Sat, Oct 12, 2019 at 07:03:55AM +0000, Adit Ranadive wrote:
> On 10/8/19, 11:15 AM, "Jason Gunthorpe" <jgg@ziepe.ca> wrote:
> > 
> > On Thu, Sep 19, 2019 at 08:24:56PM +0000, Adit Ranadive wrote:
> > 
> > >  
> > > +	if (!qp->is_kernel) {
> > > +		if (ucmd.flags == PVRDMA_USER_QP_CREATE_USE_RESP) {
> > 
> > Why does this flag exist? Don't old userspaces pass in a 0 length?
> > Just use the length to signal new userspace?
> 
> I did have that in an earlier version but we decided it to make it more
> explicit. It would be easier to add another flag later on if required
> than to check the length (which might be same).

You should add a flag if either the length or detecting value == 0 is
not sufficient to detect the new support. No reason to add things
until this situation comes up

Jason
