Return-Path: <SRS0=E0T5=XV=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02DDDC4360C
	for <linux-rdma@archiver.kernel.org>; Thu, 26 Sep 2019 19:55:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8EE222459
	for <linux-rdma@archiver.kernel.org>; Thu, 26 Sep 2019 19:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1569527720;
	bh=GgScC/ZmDM7WuaJvv15NzyOfI7XBx7GudRVPMk0llJM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=eOiMKPtnvWLY1JhmcUnG0zVIHezn44E2oJxEmXtITPff4qq1A/qMyJIyyWP1GKZg9
	 +dmNmhzha0InNGv4LCQEW/Cwu+xKvrUsR8dkCr7QAn0dj6UwBo1v04BoMBPPTkliEa
	 OfTUDpyEtg9UofO+47yZbbLAm9Ov1ecD+S7mW/FA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727821AbfIZTzU (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 26 Sep 2019 15:55:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:47278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727794AbfIZTzU (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 26 Sep 2019 15:55:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E1B6222C3;
        Thu, 26 Sep 2019 19:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569527719;
        bh=GgScC/ZmDM7WuaJvv15NzyOfI7XBx7GudRVPMk0llJM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ayX+tWAyH2kDKFuPjD91cpUZUuMebtjW4MLMIPxUnErcNHOtpLnIwJvEYAspAeVXS
         CDyWI8v7crxOB8bha8kLCujuwc75qXk/PLC1QGELD4HNN/Ps1OcEvGA6aY4ZUqNP7c
         WGKPeGIUIccCEb0tt3yu5OGsJ5TJf85om1ctXDwI=
Date:   Thu, 26 Sep 2019 21:55:17 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     "Saleem, Shiraz" <shiraz.saleem@intel.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "jgg@mellanox.com" <jgg@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [RFC 20/20] RDMA/i40iw: Mark i40iw as deprecated
Message-ID: <20190926195517.GA1743170@kroah.com>
References: <20190926164519.10471-1-jeffrey.t.kirsher@intel.com>
 <20190926164519.10471-21-jeffrey.t.kirsher@intel.com>
 <20190926174009.GD14368@unreal>
 <9DD61F30A802C4429A01CA4200E302A7AC702BDA@fmsmsx123.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9DD61F30A802C4429A01CA4200E302A7AC702BDA@fmsmsx123.amr.corp.intel.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Thu, Sep 26, 2019 at 07:49:44PM +0000, Saleem, Shiraz wrote:
> > Subject: Re: [RFC 20/20] RDMA/i40iw: Mark i40iw as deprecated
> > 
> > On Thu, Sep 26, 2019 at 09:45:19AM -0700, Jeff Kirsher wrote:
> > > From: Shiraz Saleem <shiraz.saleem@intel.com>
> > >
> > > Mark i40iw as deprecated/obsolete.
> > >
> > > irdma is the replacement driver that supports X722.
> > 
> > Can you simply delete old one and add MODULE_ALIAS() in new driver?
> > 
> 
> Yes, but we thought typically driver has to be deprecated for a few cycles before removing it.

If you completely replace it with something that works the same, why
keep the old one around at all?

Unless you don't trust your new code?  :)

thanks,

greg k-h
