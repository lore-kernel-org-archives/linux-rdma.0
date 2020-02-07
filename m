Return-Path: <SRS0=kLfo=33=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48858C2D0B1
	for <linux-rdma@archiver.kernel.org>; Fri,  7 Feb 2020 05:18:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0ECDC22314
	for <linux-rdma@archiver.kernel.org>; Fri,  7 Feb 2020 05:18:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=imatrex-com.20150623.gappssmtp.com header.i=@imatrex-com.20150623.gappssmtp.com header.b="z2O0Y+v1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726019AbgBGFSO (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 7 Feb 2020 00:18:14 -0500
Received: from mail-ed1-f50.google.com ([209.85.208.50]:38760 "EHLO
        mail-ed1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbgBGFSO (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 7 Feb 2020 00:18:14 -0500
Received: by mail-ed1-f50.google.com with SMTP id p23so1052680edr.5
        for <linux-rdma@vger.kernel.org>; Thu, 06 Feb 2020 21:18:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=imatrex-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to;
        bh=kiaH+EUM9IdqSdQdusqIug3qrqmSz4xmRRIeEn/wo7c=;
        b=z2O0Y+v1XqUga/xk/U5K9qnkHCKCggnp0uaXP1RiTX6DS6fNK2xHCR3Y04966tpYgm
         OvjHwZy6rzdoGYgjGb/basL3PRw+zkBnCr6SQnamYmDuFaEyIs+G0QhrLo1HhnSxEj+l
         OO/G91i3zcSsP4adlHM8xhJReBCgn08bSIMvwtnJf5RqpuDf7nOXe66ai1vDaMmre3WK
         RK1ugPUx3XaQyDUo51zShWeb5N1K2n0brw5LWkI6AsW85YXwtp35WXfHTWs/TJOyFbRs
         S+XY8WOQpCZUqxwHBeL/ETUkpqgi2/fp+1o7QcJIz3MO1eJ5sN67jisuK9rVfxTMaHrr
         SNLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=kiaH+EUM9IdqSdQdusqIug3qrqmSz4xmRRIeEn/wo7c=;
        b=nr8gfgN+dNmuSV1QcrEVqHMjcgAmTxTDpSxiV67K5uKDpD4JAMTgqrSI40164F5H68
         uxCPBddXTU8ZcJ0l9szHn9Oqod/nV2nRY1uUAF3i4/C6LwSdK3+bd4Oj6uM817b/LGrZ
         yfH3RVvsfOMbhcM3Jy/Jq+umkxh+mSucDsFGdqmTeFQpypyCVDxH1OtHGda3BpZ9zFxF
         6l2rVtZE4uNheVYnpDSHgn78B6idgvB1W4p7ExiwQwiGYBdwTnTO+HVql/bWHuaj4235
         kiiFTqz1n6WkUL4oXT5fxgOGRpdknKaoerWKT2CVGNGtQzPQrIA5FM6d9FJCayxFAKpx
         +cVw==
X-Gm-Message-State: APjAAAVlB4RN+BtTcxyxqNyIpCDIspauib785Xofv8wyk3MB8Xxw6RpS
        Z2Gtpr9hceWrCsdNR8SD86tzlBMR+Ru1Y771o7IpArLg2xg=
X-Google-Smtp-Source: APXvYqzkVPX9M6GR+sbSLQI7gFvG6u24wP9OcKiQz3QVDuvxN1ML7o2i7iVFRejZbF24qOcCFtJYdl9TnXjzwdErluE=
X-Received: by 2002:a17:906:eda9:: with SMTP id sa9mr6686960ejb.297.1581052690783;
 Thu, 06 Feb 2020 21:18:10 -0800 (PST)
MIME-Version: 1.0
From:   Dimitris Dimitropoulos <d.dimitropoulos@imatrex.com>
Date:   Thu, 6 Feb 2020 21:18:00 -0800
Message-ID: <CAOc41xHpF5VXK_-L_BeaU9v842BuRd2QTXkZunDKDgiEhixFtg@mail.gmail.com>
Subject: maximum QP size
To:     linux-rdma@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Hi,

I'm running the ibv_rc_pingpong example and I notice as as rx-depth
increases the QP create fails, eg at 50k. My understanding is this
variable controls the number of RECV WR that will be posted in advance
before SEND WRs are posted.

Is there a limitation on the queue size (the size is unit32_t) and if
so why ? Also is there a way around it ?

Regards
Dimitris
