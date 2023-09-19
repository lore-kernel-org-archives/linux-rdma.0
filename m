Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14C24CE79A9
	for <linux-rdma@archiver.kernel.org>; Tue, 19 Sep 2023 20:08:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbjISUIz (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 19 Sep 2023 16:08:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232066AbjISUIz (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 19 Sep 2023 16:08:55 -0400
Received: from mail-oa1-x29.google.com (mail-oa1-x29.google.com [IPv6:2001:4860:4864:20::29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98DA8BA
        for <linux-rdma@vger.kernel.org>; Tue, 19 Sep 2023 13:08:49 -0700 (PDT)
Received: by mail-oa1-x29.google.com with SMTP id 586e51a60fabf-1c50438636fso3628958fac.1
        for <linux-rdma@vger.kernel.org>; Tue, 19 Sep 2023 13:08:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=enfabrica.net; s=google; t=1695154129; x=1695758929; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ntExC3b/MrCYaxJF3rRU9pcgj2ek/gszRgdWTI4A7uY=;
        b=W8idrwfL7YY06GZrZ2OkrBmyM0j09BVHyXwo3MIdLuEkP8iCQOyzkJEkuQG16Bd93R
         yDUNOi/cOEUYR6Zcrai+r92n9vlB3zpq0hINzGHZxHU/JbJqgim7RWfbgHVi0F6MuYZy
         FFFOWh8fEx+rNVcJatiIfxHOOKSuc+5I6G0yR4DCFbsd0Ra8lsUuvy27QWnIVgvOTxS7
         APRxaxbaWcn4qFJg2HWS685hUg+6PdI56Jg2c051e0sL764AvNRKW3lrfy/v++YSgwS2
         tu0VZQ2hHKFpjd1S0pqbu8WNtH+giTIeMclJ7is59pEQ6bSagKMLZoV95qJ9cyaO29PO
         C3Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695154129; x=1695758929;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ntExC3b/MrCYaxJF3rRU9pcgj2ek/gszRgdWTI4A7uY=;
        b=dOTDxmp65foJOUI6wMg7xvP7L5ZkrOFqqTi4SEzcdhfDddQMV8SmROen+rQtwV/OMs
         zlpV2lXy327Z0JMDdZfUIfkJWu2k0eMJMSkaaGIl1yPMDFBAgEOfB3wmQXJKk8fdsScy
         YvMIVUqhuJroRzXIj3jQ/xnblTiRFan4QZUcG2j+x8UjUWvZquK/yxHD3xhXJ266kHUg
         k6a52lFCXJsG1NkAHD+6MS/os67BOJCMorld8rXMT/6TxLh4Y5ijfC/Tpv/sLtVvZYeD
         k7MqgPgWysqkbhL/CZbmabpAqR0cE1cy0EZV+jbwEpGzfV9aZvXNzQI74D2E6FZQrw5d
         QNkg==
X-Gm-Message-State: AOJu0Yy2jJ34s+WGRL4BrcNnK6BBglqgsOojPCKxxOrGwq3M5F7L40lH
        GG+EmtCRDfef9JyRzH6x5sc/H5MZgAssZu5ierNiDw==
X-Google-Smtp-Source: AGHT+IHbBtCAhcuYf8hPlXXdtGcnAi7RUIhr0S6KOxfcsFteob2+/NEOqx5D8JZhyWzspwCloY6E0JbwD48s4GS7fQw=
X-Received: by 2002:a05:6870:5625:b0:1be:fd4e:e36c with SMTP id
 m37-20020a056870562500b001befd4ee36cmr590820oao.2.1695154128972; Tue, 19 Sep
 2023 13:08:48 -0700 (PDT)
MIME-Version: 1.0
References: <20230918142700.12745-1-vitaly@enfabrica.net> <20230919072136.GB4494@unreal>
 <CAF0Wxh=YhKCLbOLZ+-b+_rmzRoWQtqoBGn6Bo9X3zR308Vm1zA@mail.gmail.com>
In-Reply-To: <CAF0Wxh=YhKCLbOLZ+-b+_rmzRoWQtqoBGn6Bo9X3zR308Vm1zA@mail.gmail.com>
From:   Vitaly Mayatskikh <vitaly@enfabrica.net>
Date:   Tue, 19 Sep 2023 16:08:38 -0400
Message-ID: <CAF0Wxhkxa1Lk76nnkTQbNL6_v_4amczVd=wodPt00iOU2WB6+w@mail.gmail.com>
Subject: Re: [PATCH] RDMA/core: use rdma_cap_iw_cm() in rdma_resolve_route()
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        linux-rdma@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Roland Dreier <roland@enfabrica.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Tue, Sep 19, 2023 at 4:06=E2=80=AFPM Vitaly Mayatskikh <vitaly@enfabrica=
.net> wrote:
>
> On Tue, Sep 19, 2023 at 3:21=E2=80=AFAM Leon Romanovsky <leon@kernel.org>=
 wrote:
>
> > I see that rdma_protocol_iwarp() is used in other places in cma.c too,
> > Don't they need to be updated too?
> >
> > Also I see that we have check for protocol RoCE in else before the
> > changed line, shouldn't all cma.c be changed to rdma_cap_*_cm() calls?
> >
> >   3376         else if (rdma_protocol_roce(id->device, id->port_num)) {
>
> I can't really judge, but looking around in the code it seems that
> some if not all of
> those cma.c functions that are checking for the protocol - they only
> called from the
> drivers that actually use the protocol. For example, iSER.
>
> Our driver does not support iWarp, but implements IW_CM callbacks. The pa=
tch has
> the only fix that was needed to make it work w/o a full blown iWarp.

Ugh, adding everyone back...
