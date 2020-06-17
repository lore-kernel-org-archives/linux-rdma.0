Return-Path: <SRS0=Ytdr=76=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B901AC433DF
	for <linux-rdma@archiver.kernel.org>; Wed, 17 Jun 2020 11:20:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 938CD20739
	for <linux-rdma@archiver.kernel.org>; Wed, 17 Jun 2020 11:20:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="LQHa4HPr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbgFQLUM (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 17 Jun 2020 07:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725894AbgFQLUM (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 17 Jun 2020 07:20:12 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DD87C061573
        for <linux-rdma@vger.kernel.org>; Wed, 17 Jun 2020 04:20:12 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id d7so1036567lfi.12
        for <linux-rdma@vger.kernel.org>; Wed, 17 Jun 2020 04:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qpWcaSj0KP2kiGtVu2ablP/Gn0hxrZxzkrs2BV3CPok=;
        b=LQHa4HPrk0asmAotG0YqMJ1e1v96FOJgdRQzKgOhO8XNzzhwRw2Nrwc+3N0/Imtl6w
         TNsPVTLCMYB4A2uijslsb/KaGo8x6O0Vowm1LabNKOGzWkFpco7LzrfjlbCq8MqUl8LW
         2hoPUqM0iGBjqtg4fdhfLhkmjydqcJ7vv+sVgFjzctyLLEs1DMdILiwRRh0DLGelmtKU
         yLMJfpxoxyGloEsMCzSsXqZPRj4BR/suLkrJfP+NwATK9fYGn/mTrW5f4TQWo6r1+JdL
         AfxpHu81o0/nhtVBCvN8H3Dmqd/XyHxLtzQ3qteF+0f0TqeEAE3qBCEVLGESUCGiT7eg
         jeBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qpWcaSj0KP2kiGtVu2ablP/Gn0hxrZxzkrs2BV3CPok=;
        b=PcHHWRei1fnnHeckACxE6YkqOGi6I2LKJnsyXBs2Lxtyc2BzvEIfgeti8ivTTjF1bG
         oep9aDB+2IU3s5Y8h32ff4PjGDejT8fWOgCfDK7GZG9CVmM0PiKrbG5dTxwBa2VZaasX
         Lk8ewLWayEl1Q4nAtiMo/DWnl6MtQxwLPzMIxpTJdY6QyxDdZY3CIVH1lUFjaae14FQ3
         cgLJi/8f6072Z/fGYFJ2UnXOu5ftTsp+wonC1eA0Mqym4ihiR0QQx2fS5fR8B3FQ81e1
         mDbZLK8l5hBAiKjdOniqxPabaMCipGMQjkYDLXJQvurNtPscDSX5/DTiWqDKQs1y1BxR
         SKpw==
X-Gm-Message-State: AOAM530L2KaoG4hEqh/946gpa3fzBuhMbatVfKeA2zVnTKZpWYQKSWuT
        MCDNlH5dKQuU7MNAFtNKgt13IDZl/QOUqzAI5BCnh2BJ8gU=
X-Google-Smtp-Source: ABdhPJw9fGUOGK79oobbD6MA49IjZ0uE95is+rsBP9saZf5EUjUEQ5Bhsrv7qw/vmIjr6Tf451zgkF5RPAHn4mPVJI8=
X-Received: by 2002:a19:4945:: with SMTP id l5mr4335208lfj.12.1592392810683;
 Wed, 17 Jun 2020 04:20:10 -0700 (PDT)
MIME-Version: 1.0
References: <CAL94vcd2bHKHZaw7wsRMMyk1FCq+nRFR-XD2W0ueG_dgOyVFew@mail.gmail.com>
 <20200617111710.GK2383158@unreal>
In-Reply-To: <20200617111710.GK2383158@unreal>
From:   Vladimir Chukov <vladimir.chukov@cloud.ionos.com>
Date:   Wed, 17 Jun 2020 13:19:59 +0200
Message-ID: <CAL94vcdNjdCOBWVKq_r3TK0Ok=uqs4kWU+gKWk4-RTvVyXMWww@mail.gmail.com>
Subject: Re: [BUG report] rdma-ndd: wrong NodeDescription for second device
To:     Leon Romanovsky <leon@kernel.org>
Cc:     linux-rdma@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

I'm seeing the default description:

sudo saquery 134 -C mlx5_1
NodeRecord dump:
lid.....................134
reserved................0x0
base_version............0x1
class_version...........0x1
node_type...............Channel Adapter
num_ports...............1
sys_guid................0x98039b03006c7912
node_guid...............0x98039b03006c7913
port_guid...............0x98039b03006c7913
partition_cap...........0x80
device_id...............0x1017
revision................0x0
port_num................1
vendor_id...............0x2C9
NodeDescription.........MT4119 ConnectX5   Mellanox Technologies

Thanks,

On Wed, Jun 17, 2020 at 1:17 PM Leon Romanovsky <leon@kernel.org> wrote:
>
> On Wed, Jun 17, 2020 at 01:04:15PM +0200, Vladimir Chukov wrote:
> > Description: rdma-ndd sets correct NodeDescription for device which
> > was initialised first; for the second device description in sysfs is
> > set correctly, but saquery  to that node  will return default
> > "NodeDescription.........MT4119 ConnectX5   Mellanox Technologies"
>
> What do you see for the second device in NodeDescription?
>
> Thanks
