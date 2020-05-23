Return-Path: <SRS0=Njt3=7F=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2434DC433E0
	for <linux-rdma@archiver.kernel.org>; Sat, 23 May 2020 06:23:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E37FC2071C
	for <linux-rdma@archiver.kernel.org>; Sat, 23 May 2020 06:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1590215035;
	bh=+uJtASeDq4IEldmSgr/kHVVdZVTMLf6DB7JtL5P/OLM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=F3HkLymcX9sIM1P8Z++7PVNazbxqSLwuSD2xEzuLax4bLjc3ZmKuySHbC2IrsPiUU
	 kSC8GFEkkLg/BJBAOIwoycLT+A8JxNVvqt3kooNrjkY0YQP+rbIkKQJ5ZMeI8oQCZl
	 luiq8De7JxNj/4m/HO3Z2Vl7G35PQ+So4JZHvsqc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387457AbgEWGXz (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sat, 23 May 2020 02:23:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:42994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387443AbgEWGXz (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sat, 23 May 2020 02:23:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 236B72067B;
        Sat, 23 May 2020 06:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590215034;
        bh=+uJtASeDq4IEldmSgr/kHVVdZVTMLf6DB7JtL5P/OLM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CYCuIbQ18/2QMXV8/spW+LRarDB68gvA7+5jzKQGd/vLb7rW3tpo8pSkDNvklp8EX
         x3ymn+VenMTWgEjBHDPWcTnp633mftkGcWLKEkbasEPOwdmuvP2GDmUFIr3/XmvEH7
         86TNeTFdmHQXXsn1L0Rdu1Ld3THlnyghEIj5XVWQ=
Date:   Sat, 23 May 2020 08:23:51 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, Fred Oh <fred.oh@linux.intel.com>
Subject: Re: [net-next v4 10/12] ASoC: SOF: Introduce descriptors for SOF
 client
Message-ID: <20200523062351.GD3156699@kroah.com>
References: <20200520070227.3392100-1-jeffrey.t.kirsher@intel.com>
 <20200520070227.3392100-11-jeffrey.t.kirsher@intel.com>
 <20200520125437.GH31189@ziepe.ca>
 <08fa562783e8a47f857d7f96859ab3617c47e81c.camel@linux.intel.com>
 <20200521233437.GF17583@ziepe.ca>
 <7abfbda8-2b4b-5301-6a86-1696d4898525@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7abfbda8-2b4b-5301-6a86-1696d4898525@linux.intel.com>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Fri, May 22, 2020 at 09:29:57AM -0500, Pierre-Louis Bossart wrote:
> This is not an hypothetical case, we've had this recurring problem when a
> PCI device creates an audio card represented as a platform device. When the
> card registration fails, typically due to configuration issues, the PCI
> probe still completes.

Then fix that problem there.  The audio card should not be being created
as a platform device, as that is not what it is.  And even if it was,
the probe should not complete, it should clean up after itself and error
out.

That's not a driver core issue, sounds like a subsystem error handling
issue that needs to be resolved.

thanks,

greg k-h
