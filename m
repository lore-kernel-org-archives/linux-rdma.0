Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E353C433EF
	for <linux-rdma@archiver.kernel.org>; Mon, 23 May 2022 11:23:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234800AbiEWLXZ (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 23 May 2022 07:23:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234804AbiEWLXY (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 23 May 2022 07:23:24 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F7401581D
        for <linux-rdma@vger.kernel.org>; Mon, 23 May 2022 04:23:23 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id v9so7538092lja.12
        for <linux-rdma@vger.kernel.org>; Mon, 23 May 2022 04:23:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TNH/bw90NLISy2Zj1KaL4+tswMa8Q5RpHUYZL3xzHyE=;
        b=Fn63LR+PqRixgVtlU2Yq9FsWmYD11FjdJvqM+EqtpsFfkG6suxpwKNpINjJpdS+e21
         uYrHsB3Yc1lR+keP43asjnZX+QgufFAc0Y6EfTHBO3gmMNA3ZMqspmAQC/WWy4RLEa89
         Wzizs40hoPKcmJOPouHvJSB2+1ZeA3Ev8yFTQ8aoymxsL5tCPVFH/JwSzgg6+eckIrsu
         dVAl7CDJCoI4hQtVD/xDM64FOL6Fafj/NLs4DhGD5DOPVVbZ2loyJDdhJ8kqVVA3Q+oS
         h69BfMCEUR194BGQ61UNUsi1MOfUyek5MxOe10B0s42r2u3qfxeQzCGgYyZKVFBPWmiG
         H4/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TNH/bw90NLISy2Zj1KaL4+tswMa8Q5RpHUYZL3xzHyE=;
        b=RDyu+y+6B7T7qe3Y4kOy4k8Q21XjYlPpQxhzMFovJ5H80FFdQr+XpOL5eH+b4Trze+
         33+gM4lw9n6dD4Rf6IFUoW53OGmE+kr/q4XO9HHxtgislSQL0ok0xfZQgVqeq7TptfBz
         ZsAeNQh1aWmZDOT/Pr05ohuye+jQELYfkuMFuVclkdT2VF2O9xpu93kslgRV6f7sYZcp
         i48526wpfU0jHZa0QkCXT8+tu3D3zN/hRoybIUHBCrmW9b2zwF5OeWEVfnLaMkYH8Mse
         XK659UtqVVkqTfm/ylxgRXGN1y9hYbW3hTf2BTe/7VachJfRmSjw60+QrLGYaacJdU0A
         zCmA==
X-Gm-Message-State: AOAM530dAuPL01sREUBYQ0gP68AVcMsbcGmAdbUyKfW5485eWiOz06N8
        eF1woCO6OjpUN11+7jZELtoRlz0ciRoui1tijJVjCw==
X-Google-Smtp-Source: ABdhPJw9wltKUS+g+G0pXWPXkkX/fkAjpc85so2B6FgYhzWN/2PjpLQ+IBuXTY4N+U4yKRWBvbExH8OydNCmUHJZbOE=
X-Received: by 2002:a2e:9ccb:0:b0:253:df97:ebd with SMTP id
 g11-20020a2e9ccb000000b00253df970ebdmr8038290ljj.280.1653305001525; Mon, 23
 May 2022 04:23:21 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.DEB.2.22.394.2205131542300.2577@gentwo.de>
In-Reply-To: <alpine.DEB.2.22.394.2205131542300.2577@gentwo.de>
From:   Haris Iqbal <haris.iqbal@ionos.com>
Date:   Mon, 23 May 2022 13:23:10 +0200
Message-ID: <CAJpMwyikfRDBcQxj1M_-3tUypa4g4LDEiUL4ZjhFqz7L9FRrVQ@mail.gmail.com>
Subject: Re: Redhat 9 removes RXE (SoftROCE) support
To:     Christoph Lameter <cl@gentwo.de>
Cc:     Bob Pearson <rpearsonhpe@gmail.com>, linux-rdma@vger.kernel.org,
        zyjzyj2000@gmail.com, jgg@nvidia.com,
        Aleksei Marov <aleksei.marov@ionos.com>,
        Jinpu Wang <jinpu.wang@ionos.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Fri, May 13, 2022 at 3:50 PM Christoph Lameter <cl@gentwo.de> wrote:
>
> I was surprised to find that RHEL 9 removes ROCE support after it was a
> "tech preview" in Redhat 8. Its a good feature with many use cases here
> and there for development, testing and production issues.
>
> Any idea why Redhat would not support RXE? Could we get a campaign going
> to convince Redhat to include RXE?

Yes. We use RXE for testing/development in VMs.

>
>
> From:
> https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9-beta/pdf/considerations_in_adopting_rhel_9/red_hat_enterprise_linux-9-beta-considerations_in_adopting_rhel_9-en-us.pdf
>
>
> 11.2. REMOVED HARDWARE SUPPORT
>
> This section lists devices (drivers, adapters) that have been removed from RHEL 9.
> PCI device IDs are in the format of vendor:device:subvendor:subdevice. If no device ID is listed, all
> devices associated with the corresponding driver are unmaintained. To  check the PCI IDs of the
> hardware on your system, run the lspci -nn command.
>
> Device ID Driver Device name
> Soft-RoCE (rdma_rxe)
> HNS-RoCE HNS GE/10GE/25GE/50GE/100GE RDMA Network
> Contro
