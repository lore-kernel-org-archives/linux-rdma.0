Return-Path: <SRS0=DhTo=A7=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6004BC433E1
	for <linux-rdma@archiver.kernel.org>; Mon, 20 Jul 2020 14:00:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39AD422BF3
	for <linux-rdma@archiver.kernel.org>; Mon, 20 Jul 2020 14:00:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="gX2Am33h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725934AbgGTOAP (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 20 Jul 2020 10:00:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbgGTOAP (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 20 Jul 2020 10:00:15 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C303C061794
        for <linux-rdma@vger.kernel.org>; Mon, 20 Jul 2020 07:00:15 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id k18so12977786qtm.10
        for <linux-rdma@vger.kernel.org>; Mon, 20 Jul 2020 07:00:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+fLsfSk7o0WDQiKalP+FCf5uIC5pOQLCUktmbUXjwbA=;
        b=gX2Am33h+RfXkdCVCdw9Qwi1dihm80dUqOuaR1AjUqPZgKlTV0m/fKXPhfOOGkfbeh
         2kPnPBC2VvRBRrMtWhjMWTyl+YNmYQ8o4tNz2uJbJ67sOMm6xG11pyXmUnqEd8c6m0E4
         ZtN8+WfxiO7Hza7frfBAom2c1Jf8DAFY9I8tWR+6ZZGRdFjstp/395/BbaITxPmnoPH3
         cYORXd13UvTJH9FldRXbqFVl5T3IskvW7Seo3OMN8DgZ0KhuyAeTtdX3qJq9B6ULxsgd
         BJ7HjntddNZf2OlKGU1cFkwUlG02eTZjU66QrFE+lrW3PEHJQJXToDZpAXwvcNzV1NWW
         Napw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+fLsfSk7o0WDQiKalP+FCf5uIC5pOQLCUktmbUXjwbA=;
        b=iDMTD80O/643ajdIrYLAUgJ561lnmxdJ4/WBPHozt5iASL4d2oL5GYjT3Pna/6uhA4
         EL6SA//hIpIIyCr/PvL6xqUNyaQGx4+WOnHc4Kkoz9j0KBrHW8vdP/y3Ig4u3ZfQ+yWs
         Y23pTrR4tYcQ3u4TbpUwkYASZH3TtGst8cJRkzdyGp/AYkBvagQ7mtDdQuJmYnELrs58
         VjSEoRBbUIaIrnID4krsykG/Onk7QGXGC2Ap9RVHvxMYXh8TxKtzDkT8rJUZKLAfiX+B
         IBQ9jyRoE+n+xw8kgZUJw09504p6jRDGNAyGqmqIeG+1T6atGhFlKgqtd8VLR6ynSiKC
         zLGw==
X-Gm-Message-State: AOAM533BDYFghS7HqxqTpoDEnyYnO2TESObQHLU/lBZKZj+SLlJUrId0
        euKoDvCDKkMua9vlmQJW5YDGDClMN3E12g==
X-Google-Smtp-Source: ABdhPJxEJGRpRm+T1t2kUAbOUuBhRV4F6vAO7U6+TdxN5N0zzDtZcXOdi0LZZ3WlJEweng6b6FwldQ==
X-Received: by 2002:ac8:2fcd:: with SMTP id m13mr24758691qta.237.1595253614362;
        Mon, 20 Jul 2020 07:00:14 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id a203sm5089830qkg.30.2020.07.20.07.00.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 07:00:13 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1jxWKz-00CaCP-4y; Mon, 20 Jul 2020 11:00:13 -0300
Date:   Mon, 20 Jul 2020 11:00:13 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Chuck Lever <chuck.lever@oracle.com>
Cc:     linux-rdma@vger.kernel.org, aron.silverton@oracle.com
Subject: Re: [PATCH RFC 0/3] IB CM tracepoints
Message-ID: <20200720140013.GG25301@ziepe.ca>
References: <20200710135812.14749.4630.stgit@klimt.1015granger.net>
 <20200710151737.GZ25301@ziepe.ca>
 <1CE2FD8B-8A27-4623-ABA0-D7E830E83D7D@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1CE2FD8B-8A27-4623-ABA0-D7E830E83D7D@oracle.com>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Fri, Jul 10, 2020 at 12:32:28PM -0400, Chuck Lever wrote:
> 
> 
> > On Jul 10, 2020, at 11:17 AM, Jason Gunthorpe <jgg@ziepe.ca> wrote:
> > 
> > On Fri, Jul 10, 2020 at 10:06:01AM -0400, Chuck Lever wrote:
> >> Hi-
> >> 
> >> This is a Request For Comments.
> >> 
> >> Oracle has an interest in a common observability infrastructure in
> >> the RDMA core and ULPs. One alternative for this infrastructure is
> >> to introduce static tracepoints that can also be used as hooks for
> >> eBPF scripts, replacing infrastructure that is based on printk.
> > 
> > Don't we already have tracepoints in CM, why is adding more RFC?
> 
> One of these patches _replaces_ printk calls with tracepoints.
> Is that OK?

Seems OK? I'd rather have the trace points be self consistent than a mix
of things spilling into pr_debug.

If someone wants to debug the CM it is clearly better to use the
complete set of tracepoints, right?

Jason

