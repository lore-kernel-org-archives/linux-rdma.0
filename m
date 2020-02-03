Return-Path: <SRS0=727Q=3X=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFE99C35247
	for <linux-rdma@archiver.kernel.org>; Mon,  3 Feb 2020 16:50:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C244620721
	for <linux-rdma@archiver.kernel.org>; Mon,  3 Feb 2020 16:50:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="UFbVpuAl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728364AbgBCQuh (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 3 Feb 2020 11:50:37 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:37362 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727319AbgBCQug (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 3 Feb 2020 11:50:36 -0500
Received: by mail-qk1-f195.google.com with SMTP id 21so14881505qky.4
        for <linux-rdma@vger.kernel.org>; Mon, 03 Feb 2020 08:50:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=kWk364qHF61tUnLsG2t+B73CxvmHcccvhK8KixuUXvo=;
        b=UFbVpuAlrZjMKouT6VErGvHeRx7g5ngycY7UhsdEE5Sbievr0TZKtZ5PaFFCQGoy67
         yHvqj8FEQ+IvgYllBcaPeF8QW26hnS140A+D1YwVFXRJfVIK0V79j42JTxDAvdfVvrtN
         7p732R8xs17CJ4Ti6U+aXBpd1AkopwRjqTqrFPiP6Tav++aj+/GSUm1Q6UTlVAKg9ZCT
         M9lZdx8+6Q8/VqGSXZS7kSZFbk6AFLNE+fySUzcoRF/Eij7Oqk09c5H6AMpR19nwWvTO
         wYagtwGPkMbB0KjqR6+k0VC8ExFzyYWxvdCSmeWHwMYN8cu/hjwRWk1td74josb3y9s4
         ANcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=kWk364qHF61tUnLsG2t+B73CxvmHcccvhK8KixuUXvo=;
        b=mbLcifhY6pNG1Z+tMol8VLQk3WUaw0g+aV2HUj6GXd30C4g6haeaaEvWB+30g53Wwt
         ELtgVfPFRdPOdiHL+OmXdKagYXivifDr/KX8Np524kV9Wqyvp1pDyZZ13Cdk2srfPd5u
         bz+yW6a8yxnlbIeodo1HpYUZB73eaCyX4QoSTSP6LTsl1CXYce17ngs4T5eNBVdH5Rx4
         eVzSdGRJjFlnz98ck9aGBSSXVuFaIFnut6yMaELY28nFKLazLpODzyR1XGEGkDmiS75C
         adudCJ1+EN7ewWai7nWmqvUo7AGUAm32zurDMLwkLFUrtB3qJD42c0P5RlwUYbkTpeEz
         VxIw==
X-Gm-Message-State: APjAAAVqE5Zn+ELx7KFjGrxL/HD+EAXxzZinucNLejkSsO+hWl+DknAv
        OTTbvnC0IsU3mdaA8AfbgI6M30ZUgkM=
X-Google-Smtp-Source: APXvYqyKU9A1jdECmWhySaamnHOPadSN1IDUO16KkFlCxIzrH5xd1lx3G5WhgI+qwpqTwdqkC/2q6w==
X-Received: by 2002:ae9:f70c:: with SMTP id s12mr24127643qkg.487.1580748634426;
        Mon, 03 Feb 2020 08:50:34 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id a145sm9591330qkg.128.2020.02.03.08.50.33
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 03 Feb 2020 08:50:33 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1iyevh-0007Yt-7y; Mon, 03 Feb 2020 12:50:33 -0400
Date:   Mon, 3 Feb 2020 12:50:33 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Devesh Sharma <devesh.sharma@broadcom.com>
Cc:     linux-rdma <linux-rdma@vger.kernel.org>,
        Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v4] libibverbs: display gid type in ibv_devinfo
Message-ID: <20200203165033.GB14732@ziepe.ca>
References: <1580745415-19744-1-git-send-email-devesh.sharma@broadcom.com>
 <20200203160849.GA14732@ziepe.ca>
 <CANjDDBiA53__MuzqXiAh70YAa_JvWQcm6Sdo0dFsoAs1EgVbjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANjDDBiA53__MuzqXiAh70YAa_JvWQcm6Sdo0dFsoAs1EgVbjQ@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Mon, Feb 03, 2020 at 09:57:39PM +0530, Devesh Sharma wrote:
> On Mon, Feb 3, 2020 at 9:38 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> >
> > On Mon, Feb 03, 2020 at 10:56:55AM -0500, Devesh Sharma wrote:
> > > It becomes difficult to make out from the output of ibv_devinfo
> > > if a particular gid index is RoCE v2 or not.
> > >
> > > Adding a string to the output of ibv_devinfo -v to display the
> > > gid type at the end of gid.
> > >
> > > The output would look something like below:
> > > $ ibv_devinfo -v -d bnxt_re2
> > > hca_id: bnxt_re2
> > >  transport:             InfiniBand (0)
> > >  fw_ver:                216.0.220.0
> > >  node_guid:             b226:28ff:fed3:b0f0
> > >  sys_image_guid:        b226:28ff:fed3:b0f0
> > >   .
> > >   .
> > >   .
> > >   .
> > >        phys_state:      LINK_UP (5)
> > >        GID[  0]:        fe80:0000:0000:0000:b226:28ff:fed3:b0f0, IB/RoCE v1
> > >        GID[  1]:        fe80:0000:0000:0000:b226:28ff:fed3:b0f0, RoCE v2
> > >        GID[  2]:        0000:0000:0000:0000:0000:ffff:c0aa:0165, IB/RoCE v1
> > >        GID[  3]:        0000:0000:0000:0000:0000:ffff:c0aa:0165, RoCE v2
> >
> > I think you should display the RoCEv2 GID in IPv6 notation, since it
> > isn't really a GID anyhmore. The IPv6 notation should automatically
> > show the IPv4 dotted quad
> 
> There are many format specifiers, which one are you indicating? are
> those supported in printf()?

inet_ntop(AF_INET6)

Jason
