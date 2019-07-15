Return-Path: <SRS0=EqZ5=VM=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94B94C7618F
	for <linux-rdma@archiver.kernel.org>; Mon, 15 Jul 2019 20:52:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 682D72086C
	for <linux-rdma@archiver.kernel.org>; Mon, 15 Jul 2019 20:52:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=networkplumber-org.20150623.gappssmtp.com header.i=@networkplumber-org.20150623.gappssmtp.com header.b="zKqUoGlQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732656AbfGOUwk (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 15 Jul 2019 16:52:40 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:36441 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732649AbfGOUwk (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 15 Jul 2019 16:52:40 -0400
Received: by mail-pf1-f194.google.com with SMTP id r7so7986223pfl.3
        for <linux-rdma@vger.kernel.org>; Mon, 15 Jul 2019 13:52:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YHjXdcD/zzcFwWqFYitISKpmcb8VGL5mrJU3cHFDJio=;
        b=zKqUoGlQHRRTmJU4lX083UapmWZKISeAWpaaXBOwgaOnBI2fqeiLJI/RPeQgnDLXrp
         vNkfAVqgotu/0H7SPvqsaQSC94pwyVxxBvqOxZSpetKTOqApGEjPeoDVQFg2pbbte8jA
         uyPM7yGPDy9Ue3/03HGJofKWehor+WbjJecQf20NqpTOBOYDfOvarRCtlmY6+EOI9sJP
         YCJkyMo6y3HusoAKjmMaptV8t8/QUiauwlbdRcZJY2tV03x5JtB626D7bkNgmUIwjrjU
         IMMMXlJlypYRgjXwnYfMnzOSuDFaRHb9IAt67oQ0Tu1PccGU0O8Mk3xtQVnqeFd5ukUr
         0IDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YHjXdcD/zzcFwWqFYitISKpmcb8VGL5mrJU3cHFDJio=;
        b=hoFLebyhh7gj/1LBi5EXUmHS5n5JF3GS0UxrtdVepHRzhMHsVF+rqKuSu5jemuRqx5
         xKlBHqfcBPwcREhn6oJPY7DkfV9I53tdoc36zsTL9AaNiCc1HAlac2s4ezgTGb4Fvq5i
         6SLDLbUGusj8+XM9gNm1BujzlDLHx++1QT7Is2ay9dIrC0+zyEAJzwVg5kNO1bFF7qvk
         jHE47CqO/QYDkhW5K3cNapKl8Y2VQDt2H59paUDwmlkhKh4eiCQ+zO3cC/KX9XJ+h5XO
         6FqGbh0iZY4dimESlRgSXq9ywLlLu5Fx9EeEPjLQ8YgpGjgytuJ5u7Fb0J+dxgFcTB7K
         rwZA==
X-Gm-Message-State: APjAAAUd/8BO4+hB3Sfxs64vl+ZuMYC25sQfry1H2INuvPLVJbACDM4V
        xbQj/+DuUqhz4O/ZHS/rd4I=
X-Google-Smtp-Source: APXvYqzWCtvHG9HrNyZ51rAnJN+54njXYYZP5AG9ATb0761bX7xTGl+jgHXxFOtmcxy43yGMvdxKFQ==
X-Received: by 2002:a17:90a:7d09:: with SMTP id g9mr30771290pjl.38.1563223959813;
        Mon, 15 Jul 2019 13:52:39 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id f7sm17896141pfd.43.2019.07.15.13.52.39
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 15 Jul 2019 13:52:39 -0700 (PDT)
Date:   Mon, 15 Jul 2019 13:52:38 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        netdev <netdev@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Mark Zhang <markz@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH iproute2-rc 1/8] rdma: Update uapi headers to add
 statistic counter support
Message-ID: <20190715135238.7c0c7242@hermes.lan>
In-Reply-To: <20190710072455.9125-2-leon@kernel.org>
References: <20190710072455.9125-1-leon@kernel.org>
        <20190710072455.9125-2-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Wed, 10 Jul 2019 10:24:48 +0300
Leon Romanovsky <leon@kernel.org> wrote:

> From: Mark Zhang <markz@mellanox.com>
> 
> Update rdma_netlink.h to kernel commit 6e7be47a5345 ("RDMA/nldev:
> Allow get default counter statistics through RDMA netlink").
> 
> Signed-off-by: Mark Zhang <markz@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>

I am waiting on this until it gets to Linus's tree.
