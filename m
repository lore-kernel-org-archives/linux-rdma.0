Return-Path: <SRS0=A3Y9=DF=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE78CC4727C
	for <linux-rdma@archiver.kernel.org>; Mon, 28 Sep 2020 23:14:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88B4A23A5A
	for <linux-rdma@archiver.kernel.org>; Mon, 28 Sep 2020 23:14:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="BlX+CwQ4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727227AbgI1XOe (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 28 Sep 2020 19:14:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727068AbgI1XNm (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 28 Sep 2020 19:13:42 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99ECFC0613A8
        for <linux-rdma@vger.kernel.org>; Mon, 28 Sep 2020 15:36:04 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id k25so2107581qtu.4
        for <linux-rdma@vger.kernel.org>; Mon, 28 Sep 2020 15:36:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=E6o1Xg5cHVZMY5hHDlsYGaqfQfQoQMj4uN/vu7I2wU8=;
        b=BlX+CwQ4BiN/7yQa8XmdcImpU9IlDRhnsgC++e4Ije7ZhPK0YvLPbilvyOkMdO3QcX
         /Vc5pVTdxBN8GAMft2GHYoG4nAJClmV7FaMmT0wBxo9uyL7wx0FXyGyuVz1F9L1J2NSG
         6dXv2eJIWvIHyX9yXDStSzj0hWD+k5qlwU4VB/HEtURs93zD9AP3IyZPnL/0OHDzN8tk
         ByudXaNgBpV9LgTNjxTklqGNiieoi4IhhVPcQtDWWjJj4Ajqx7oj4ST3UUP7Ykh8jhFq
         QR8q+QuQjhnVaGQZ4zUeSp5eA7mn02emJtp1ss3NglTwUzToOdU1YjwG3TUOGXxUGBRY
         HV4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=E6o1Xg5cHVZMY5hHDlsYGaqfQfQoQMj4uN/vu7I2wU8=;
        b=e7JBJBC7a8NaWpqO35O7kxnVIeyEbZeHoRZ88tDeKU3sg8SRS6UuNLx045+X2oTrd/
         4yiCKoiEoefBtqFiPydtp1Rt2iFlkLk/BWan/LUz/gB56gZhMAq8qomQsfhjBhwTLiMi
         Cf6Nr0ZokmD3wHZNXJka9la4j3hVcgmj4nv5l8a3sx/TKjuoPU0dExgGwMh0CGkrAZKw
         e1Pwmca8uijky8F56bmUUO6i6CRMK8PWPRCPKXMnb8bp0DC6iE5vzfvkEQbdBbDO4C5U
         mFF3Ys4j4alt30Mhr5BRuXKJmcxOokeW5yaGyPZTTKNDxG/UbSpz1XjBTKYw4kIYDaCS
         x0Ng==
X-Gm-Message-State: AOAM533Opy6Iu9Ik1p9HTYmJ2M5Poybu9lE7XGuzowbV/lo5xq+JD5H9
        oWEIuDwKOwCLyoeDT2Or0nFChQ==
X-Google-Smtp-Source: ABdhPJx6PDs1ve4+MaO8asvzeeubcLXS2JRvSLk/EJaEvwYAO02DGP6ufOLLOrbmCKlGZy6L45I+cA==
X-Received: by 2002:aed:3e3d:: with SMTP id l58mr359140qtf.350.1601332563854;
        Mon, 28 Sep 2020 15:36:03 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id a24sm2387620qko.82.2020.09.28.15.36.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2020 15:36:03 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1kN1kY-002a85-L0; Mon, 28 Sep 2020 19:36:02 -0300
Date:   Mon, 28 Sep 2020 19:36:02 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Kamal Heib <kamalheib1@gmail.com>
Cc:     linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH for-rc] RDMA/ipoib: Set rtnl_link_ops for ipoib interfaces
Message-ID: <20200928223602.GS9916@ziepe.ca>
References: <20200928202631.52020-1-kamalheib1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200928202631.52020-1-kamalheib1@gmail.com>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Mon, Sep 28, 2020 at 11:26:31PM +0300, Kamal Heib wrote:
> Before this patch, the rtnl_link_ops are set only for ipoib network
> devices that are created via the rtnl_link_ops->newlink() callback, this
> patch fixes that by setting the rtnl_link_ops for all ipoib network
> devices. Also, implement the dellink() callback to block users from
> trying to remove the base ipoib network device while allowing it only
> for child interfaces.

Why?

Jason
