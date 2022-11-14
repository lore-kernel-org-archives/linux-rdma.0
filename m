Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CD70C4332F
	for <linux-rdma@archiver.kernel.org>; Mon, 14 Nov 2022 14:40:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236453AbiKNOki (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 14 Nov 2022 09:40:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236928AbiKNOkG (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 14 Nov 2022 09:40:06 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 615932C125
        for <linux-rdma@vger.kernel.org>; Mon, 14 Nov 2022 06:39:58 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id t10so13484432ljj.0
        for <linux-rdma@vger.kernel.org>; Mon, 14 Nov 2022 06:39:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=eN9wr5TlQFzOv7nS6MeUZ2Xjt5GUPeimWQOuoUBU6F0=;
        b=CxgqR1UGr7xTNT1/GZd1iXV+gyAZaqRy+diJIDZb3cP6SKW4iow0EBL2GC6V3KfS4Q
         STg+Npa5o3LSOW9n0JcWPUUlryy4Z5hg2RzZpThnQ7t4zVurF357Zaenbq83ciolPh99
         DULzJjhcTY5Zt8bPM6LzU2cnKbhwDLgQmFuyhcVKY2pzGoD+jL5Uq+uUVnBDGbbn1xEm
         nn56YhvdTYaQGkhEBNL/BlaGhk5NorQTQDJLp3frX5vMo1gHg4/cNRU9iMkDtWa1LTPy
         C6hTciArUY1ar9qYnUFbvun2q5Kb5konI1ED9pNxsw+uv/D6jNfpkepDZMaMEx0GYDR1
         whUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eN9wr5TlQFzOv7nS6MeUZ2Xjt5GUPeimWQOuoUBU6F0=;
        b=JLPi4mN5f0vuwbHLkZoiqpIBzANV6HY6MAgWb2I3SyckzuQNX25lz9Vg+ACePsRtSg
         yw7tNWnllRQVHTC4SrvsXjN8PwDKWvrT/fOsEjuXdqJPygjEn9dnk8EvRcbRb0/+SjX2
         2TXsjvlWNbSu8QS8Q1wOv2YRyD50jRXMVV3VC9xK7gbwku6VXo71KFnR55I+TR4JL7O1
         aKQ2OTIa6PnlQbI/F3m2r5iyXpDmp2b/kNUvY1sarYyV6R0AFRRNFOIN4hEcIqUAGwbv
         xMytKXESM/ar3N0lFKPcdkjHhhUvkikW0tySXoiqwTsnnF8WCRr0DkReAn3WbkyY5Oam
         fJHQ==
X-Gm-Message-State: ANoB5pkw+Z4Su5/NLP0diU+9IsiP+tuHgHmQcJEYln+S9cqaZQuQqd/X
        WFs4E4DZrXEdwrA3SXJmHhBDimOL7eXb6jv69KEEqQ==
X-Google-Smtp-Source: AA0mqf4o8IBXOf8Aw7U6t98fKKhJnWsDw/5iy5MVOc3MdVsSO9K0lFw5X1KG/Lvg0KkaQH7PHB62B7504fmMCzpXoGY=
X-Received: by 2002:a2e:2c15:0:b0:277:2463:cfdb with SMTP id
 s21-20020a2e2c15000000b002772463cfdbmr4256061ljs.213.1668436796699; Mon, 14
 Nov 2022 06:39:56 -0800 (PST)
MIME-Version: 1.0
References: <20221113010823.6436-1-guoqing.jiang@linux.dev> <20221113010823.6436-3-guoqing.jiang@linux.dev>
In-Reply-To: <20221113010823.6436-3-guoqing.jiang@linux.dev>
From:   Haris Iqbal <haris.iqbal@ionos.com>
Date:   Mon, 14 Nov 2022 15:39:45 +0100
Message-ID: <CAJpMwyiArxegKZMnGVsZ42Ucgv8N=7CJUs1d0W0+rN3y-x0W=w@mail.gmail.com>
Subject: Re: [PATCH RFC 02/12] RDMA/rtrs-srv: Refactor rtrs_srv_rdma_cm_handler
To:     Guoqing Jiang <guoqing.jiang@linux.dev>
Cc:     jinpu.wang@ionos.com, jgg@ziepe.ca, leon@kernel.org,
        linux-rdma@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Sun, Nov 13, 2022 at 2:08 AM Guoqing Jiang <guoqing.jiang@linux.dev> wrote:
>
> The RDMA_CM_EVENT_CONNECT_REQUEST is quite different to other types,
> let's checking it separately at the beginning of routine, then we can
> avoid the identation accordingly.
>
> Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
> ---
>  drivers/infiniband/ulp/rtrs/rtrs-srv.c | 17 ++++++-----------
>  1 file changed, 6 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv.c b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
> index 79504aaef0cc..2cc8b423bcaa 100644
> --- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
> +++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
> @@ -1948,24 +1948,19 @@ static int rtrs_rdma_connect(struct rdma_cm_id *cm_id,
>  static int rtrs_srv_rdma_cm_handler(struct rdma_cm_id *cm_id,
>                                      struct rdma_cm_event *ev)
>  {
> -       struct rtrs_srv_path *srv_path = NULL;
> -       struct rtrs_path *s = NULL;
> -
> -       if (ev->event != RDMA_CM_EVENT_CONNECT_REQUEST) {
> -               struct rtrs_con *c = cm_id->context;
> -
> -               s = c->path;
> -               srv_path = to_srv_path(s);
> -       }
> +       struct rtrs_con *c = cm_id->context;
> +       struct rtrs_path *s = c->path;
> +       struct rtrs_srv_path *srv_path = to_srv_path(s);

This isn't correct for the RDMA_CM_EVENT_CONNECT_REQUEST event. At
that moment, cm_id->context is still holding a pointer to struct
rtrs_srv_ctx. Even though it never gets used for this event here, its
not right IMO to dereference in this incorrect manner.

How about we move the check for the RDMA_CM_EVENT_CONNECT_REQUEST
event outside (just like you did), but let the pointers be NULL, and
only dereference after the if condition for
RDMA_CM_EVENT_CONNECT_REQUEST event?

>
> -       switch (ev->event) {
> -       case RDMA_CM_EVENT_CONNECT_REQUEST:
> +       if (ev->event == RDMA_CM_EVENT_CONNECT_REQUEST)
>                 /*
>                  * In case of error cma.c will destroy cm_id,
>                  * see cma_process_remove()
>                  */
>                 return rtrs_rdma_connect(cm_id, ev->param.conn.private_data,
>                                           ev->param.conn.private_data_len);
> +
> +       switch (ev->event) {
>         case RDMA_CM_EVENT_ESTABLISHED:
>                 /* Nothing here */
>                 break;
> --
> 2.31.1
>
