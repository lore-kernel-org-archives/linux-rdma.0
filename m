Return-Path: <SRS0=vUM0=3W=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 379BAC35249
	for <linux-rdma@archiver.kernel.org>; Sun,  2 Feb 2020 00:44:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 01B9420679
	for <linux-rdma@archiver.kernel.org>; Sun,  2 Feb 2020 00:44:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=imatrex-com.20150623.gappssmtp.com header.i=@imatrex-com.20150623.gappssmtp.com header.b="ALXBVEHm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbgBBAox (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sat, 1 Feb 2020 19:44:53 -0500
Received: from mail-ed1-f49.google.com ([209.85.208.49]:41763 "EHLO
        mail-ed1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726708AbgBBAox (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Sat, 1 Feb 2020 19:44:53 -0500
Received: by mail-ed1-f49.google.com with SMTP id c26so12089533eds.8
        for <linux-rdma@vger.kernel.org>; Sat, 01 Feb 2020 16:44:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=imatrex-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=GYB1Q48ZeJRqCw7a99OlSqKip6XDlBV914kqi3XBdlY=;
        b=ALXBVEHmAfko71Jo8s1v03zgJWiXYM3DzZleZrGq0oBZPXUC+NKKxh6CP+PEpXmPAW
         gR1whErKs8g4n2+tUvmdl5ydvwzHk3rU0KSm1jemZWwJwbDLujNCRhsvS6MaWpcJSXku
         w394vCBiFcIORamN6AcztE02eL5JO1WX91WCzTNadYqNlRp//JIdfN/zHlUb/WOOigde
         VZnWWy3zpSbYBTyRohJFMo81PJKofHKBr3qb/k310lkrj/PzIDuLrk5HKAFV82YN0aSh
         BkyZ5XP9Eb5YEafhp3WtfraqMh4Yv3aTkAlV4egomzPk9TRk7dRfEXQ0k7+p7vRfSi0r
         4B0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=GYB1Q48ZeJRqCw7a99OlSqKip6XDlBV914kqi3XBdlY=;
        b=KXXmmA7QkWu2HpQLuSaf8W8mSx0sqY3SxJEdzxNnodIt5uufO1eL7juPTOQHuqyQpi
         rzLni5Z71l4PxAPdGij3V6wme9Ai6GfWGBr/GL/qQOpXHFMWSP9CNXodYl3a3SlMJT1m
         MiWejH3l7DpaAs8QsYGcG19sH/byhGQ9NOt9K1WAYzRtea/cMjVLUjuElssz4p14tZ8b
         wcxA/k/0vc3XvkPBWQfuGgRYbMXBumb2LEo95EXjgOhCPns2RzswY/5PpNRWK0Y59RGR
         MQM8boOjfx98ad/3d1D4Jlnlm6yeXi/3/xjV4gZH+wwRIkpuurhiAFym1nFZCPDQWcSy
         9jQQ==
X-Gm-Message-State: APjAAAUJGtA0FNif8kWIkOgNHyQjmLuQ7/QJFHT3ijffPJR5GsDjmO0O
        WMcgwtfQvjStoqBhGTb4ydsXM94iAw9WukYt+tNMbqTv9/c=
X-Google-Smtp-Source: APXvYqydqaqCcxvSp86Xs0l/WqIKjAmgWWjxDLrrftoJJEy+t48m1ryEJOwiBs0OqE56bTSjyLbUyq6CuAltmWoXOiM=
X-Received: by 2002:aa7:cf81:: with SMTP id z1mr6378267edx.157.1580604290867;
 Sat, 01 Feb 2020 16:44:50 -0800 (PST)
MIME-Version: 1.0
References: <CAOc41xEmgiw_xekLuhi6uYZ+rKdMrv=5wOJWKisbpYPpBJsdkA@mail.gmail.com>
 <20200201083845.GF414821@unreal>
In-Reply-To: <20200201083845.GF414821@unreal>
From:   Dimitris Dimitropoulos <d.dimitropoulos@imatrex.com>
Date:   Sat, 1 Feb 2020 16:44:37 -0800
Message-ID: <CAOc41xEvwbr5RUMgD2HqEyiX4N6jB0-6mA8btiDbf-moh60oKw@mail.gmail.com>
Subject: Re: RDMA without rdma_create_event_channel()
To:     linux-rdma@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

It seems RDMA RC is completely optional, only the default/standardized
way of exchanging parameters and any custom way will do.

Most helpful, thank you.

Dimitris

On Sat, Feb 1, 2020 at 12:39 AM Leon Romanovsky <leon@kernel.org> wrote:
>
> On Fri, Jan 31, 2020 at 09:00:24PM -0800, Dimitrios Dimitropoulos wrote:
> > Hi,
> >
> > I'm looking to connect an RDMA hardware accelerator to a Centos 8.0
> > server with RoCE_V2 capability.
> >
> > Is there a way to implement RDMA RC functionality without invoking the
> > Connection Manager (skipping the rdma_create_event_channel()) ?
> > Perhaps with a simple exchange of the necessary information through an
> > external protocol, say UDP packets ? And then initialize the QPs with
> > the received parameters.
>
>
> You can do it without RDMA-CM, see libibverbs//examples/rc_pingpong.c
> for exactly that.
>
> Thanks
