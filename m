Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CADF8C2B9F2
	for <linux-rdma@archiver.kernel.org>; Sat, 22 May 2021 09:42:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D850610A2
	for <linux-rdma@archiver.kernel.org>; Sat, 22 May 2021 09:42:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbhEVJoX (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sat, 22 May 2021 05:44:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbhEVJoW (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Sat, 22 May 2021 05:44:22 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 006FCC061574
        for <linux-rdma@vger.kernel.org>; Sat, 22 May 2021 02:42:57 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id i23-20020a9d68d70000b02902dc19ed4c15so20407883oto.0
        for <linux-rdma@vger.kernel.org>; Sat, 22 May 2021 02:42:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vJAfSks11D4uX40iR41CF326FzIHmKVihij0PDqUMLs=;
        b=IMdYndFc81qlwSLDcnpdZZSbnprZegvyQvdt0U5hRMz2XmTistfMQdRe7oM9N3fhz7
         Grhgg7250HiAHe0+BWgKVNXrBAbJHlbPhLvc4epLAEardKsin5IP7Fr3GWFNG1O+fzJF
         Dt/fzPgg6FN35KphM3Z9DUw1GmUJbVw/hAFmkTicZtC8h6rqeW/UPH7/vM1amIMsHhad
         i/SxIHwMSi/kdf4d5rZfYquUtkPGh3yJQHEyhjuJfrS71r3fRskRphrUsnUdIHeDWcL3
         TbBBzIM0PcWL5lH5TCEru8//iLQe2j2WPDHqB4bakeFFAmFO4DuHFBvPzgAeaN9VECq+
         fnYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vJAfSks11D4uX40iR41CF326FzIHmKVihij0PDqUMLs=;
        b=e8nhflLpZk+zzfHheq5sGnGHmJA6sH6vZiE+eCr70SGMybl9hiFQ3Sgefm9Yj84vO8
         BG8LKLTbyb1LwBvCElJJdeZ0NA899TWTWWU3v1plXBCAvVHXTH9X1nB/eN/Jk2a2ow+I
         Eiph6JpLbyxCioCg6tdGTrbxs8DGgg6UREnCNBhf4NqeQvkHFs3EgSHe15ZggQ+QsUyz
         IfDWBDnb38d+e+AhCw+0rplyEGSHSzyuXTRaL6me4p8z7eWiO2kKY1n0OFkTPRZC2hrf
         p1tolKXN/DC7jb277Cl+kIyXk1RJyf12w/2kolsg2WKSXllURPy9MK/tmRDKYNn3j3y8
         AJ7Q==
X-Gm-Message-State: AOAM533Je7IVmkYKhEp1ZYVrxyVYqxVzUdO1AfVHaVFQBsNxTwf6qdDm
        CflhDrSkT34lIVccoODmW1jsxhtXPehoj4I+bdc=
X-Google-Smtp-Source: ABdhPJyf6U6NHksvqx7HMo0N+AVgxlrteIYjhLG6733BA9xO/zgBoqKtZ+EIc8lkPLwvWP/lAdGKJunXPLrti4GJHDI=
X-Received: by 2002:a9d:614b:: with SMTP id c11mr11844686otk.59.1621676577423;
 Sat, 22 May 2021 02:42:57 -0700 (PDT)
MIME-Version: 1.0
References: <1621590825-60693-1-git-send-email-liweihang@huawei.com> <1621590825-60693-15-git-send-email-liweihang@huawei.com>
In-Reply-To: <1621590825-60693-15-git-send-email-liweihang@huawei.com>
From:   Zhu Yanjun <zyjzyj2000@gmail.com>
Date:   Sat, 22 May 2021 17:42:46 +0800
Message-ID: <CAD=hENccB1npfk88Dswz7pShfFYQyF91Wc8vS=5O5TieKD=_Gw@mail.gmail.com>
Subject: Re: [PATCH v2 for-next 14/17] RDMA/i40iw: Use refcount_t instead of
 atomic_t on refcount of i40iw_puda_buf
To:     Weihang Li <liweihang@huawei.com>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        linuxarm@huawei.com, Faisal Latif <faisal.latif@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Fri, May 21, 2021 at 7:35 PM Weihang Li <liweihang@huawei.com> wrote:
>
> The refcount_t API will WARN on underflow and overflow of a reference
> counter, and avoid use-after-free risks.
>
> Cc: Faisal Latif <faisal.latif@intel.com>
> Cc: Shiraz Saleem <shiraz.saleem@intel.com>
> Signed-off-by: Weihang Li <liweihang@huawei.com>
> ---
>  drivers/infiniband/hw/i40iw/i40iw_cm.c   | 8 ++++----
>  drivers/infiniband/hw/i40iw/i40iw_puda.h | 2 +-

https://patchwork.kernel.org/project/linux-rdma/patch/20210520143809.819-22-shiraz.saleem@intel.com/
In this commit, i40iw will be removed. And this commit will be merged
into upstream linux.

Zhu Yanjun

>  2 files changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.c b/drivers/infiniband/hw/i40iw/i40iw_cm.c
> index c1becb9..9bb86a4 100644
> --- a/drivers/infiniband/hw/i40iw/i40iw_cm.c
> +++ b/drivers/infiniband/hw/i40iw/i40iw_cm.c
> @@ -77,7 +77,7 @@ void i40iw_free_sqbuf(struct i40iw_sc_vsi *vsi, void *bufp)
>         struct i40iw_puda_buf *buf = (struct i40iw_puda_buf *)bufp;
>         struct i40iw_puda_rsrc *ilq = vsi->ilq;
>
> -       if (!atomic_dec_return(&buf->refcount))
> +       if (refcount_dec_and_test(&buf->refcount))
>                 i40iw_puda_ret_bufpool(ilq, buf);
>  }
>
> @@ -531,7 +531,7 @@ static struct i40iw_puda_buf *i40iw_form_cm_frame(struct i40iw_cm_node *cm_node,
>         if (pdata && pdata->addr)
>                 memcpy(buf, pdata->addr, pdata->size);
>
> -       atomic_set(&sqbuf->refcount, 1);
> +       refcount_set(&sqbuf->refcount, 1);
>
>         return sqbuf;
>  }
> @@ -1096,7 +1096,7 @@ int i40iw_schedule_cm_timer(struct i40iw_cm_node *cm_node,
>                 spin_unlock_irqrestore(&cm_node->retrans_list_lock, flags);
>                 new_send->timetosend = jiffies + I40IW_RETRY_TIMEOUT;
>
> -               atomic_inc(&sqbuf->refcount);
> +               refcount_inc(&sqbuf->refcount);
>                 i40iw_puda_send_buf(vsi->ilq, sqbuf);
>                 if (!send_retrans) {
>                         i40iw_cleanup_retrans_entry(cm_node);
> @@ -1286,7 +1286,7 @@ static void i40iw_cm_timer_tick(struct timer_list *t)
>                 vsi = &cm_node->iwdev->vsi;
>
>                 if (!cm_node->ack_rcvd) {
> -                       atomic_inc(&send_entry->sqbuf->refcount);
> +                       refcount_inc(&send_entry->sqbuf->refcount);
>                         i40iw_puda_send_buf(vsi->ilq, send_entry->sqbuf);
>                         cm_node->cm_core->stats_pkt_retrans++;
>                 }
> diff --git a/drivers/infiniband/hw/i40iw/i40iw_puda.h b/drivers/infiniband/hw/i40iw/i40iw_puda.h
> index 53a7d58..5996626 100644
> --- a/drivers/infiniband/hw/i40iw/i40iw_puda.h
> +++ b/drivers/infiniband/hw/i40iw/i40iw_puda.h
> @@ -90,7 +90,7 @@ struct i40iw_puda_buf {
>         u8 tcphlen;             /* tcp length in bytes */
>         u8 maclen;              /* mac length in bytes */
>         u32 totallen;           /* machlen+iphlen+tcphlen+datalen */
> -       atomic_t refcount;
> +       refcount_t refcount;
>         u8 hdrlen;
>         bool ipv4;
>         u32 seqnum;
> --
> 2.7.4
>
