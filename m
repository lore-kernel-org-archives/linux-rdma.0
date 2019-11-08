Return-Path: <SRS0=fYhk=ZA=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41C74FC6196
	for <linux-rdma@archiver.kernel.org>; Fri,  8 Nov 2019 21:51:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1697B215EA
	for <linux-rdma@archiver.kernel.org>; Fri,  8 Nov 2019 21:51:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=netronome-com.20150623.gappssmtp.com header.i=@netronome-com.20150623.gappssmtp.com header.b="v6yGJOyW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727672AbfKHVvV (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 8 Nov 2019 16:51:21 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:42281 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbfKHVvU (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 8 Nov 2019 16:51:20 -0500
Received: by mail-lf1-f67.google.com with SMTP id z12so5549012lfj.9
        for <linux-rdma@vger.kernel.org>; Fri, 08 Nov 2019 13:51:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=pjTRr0Ec/7D/SD2DSIp1WRI4YQ8Q1c/X0d5DLs4SpQQ=;
        b=v6yGJOyWPww9FgRnAS7dK1eYVTIpQwh1HxWR9ZpjHlvvzMESt3N7xDyV0DPkVDnhkS
         bpMEwIpCDyTZufBBpD6LwvZGh7qzhBcc+GTQ8z79Fv2lFXXms2fdeNNpRk8SJUdpZJIs
         4ehf9AOXtrVtx+UjUmcEWUBTpw4jd7MnaSHyFun6dy17XY0gPBeLbi3x2LcFlc8tuWjl
         0gfBCk7jVnmj5iHWukHJz2gYp1Z7TWj+aMZMI4vO/UNms2/qdbI0FFMsf5drA3NUOqMi
         IPXMjJIz9R80zI6gI1Dwn2THe5oo/MIVXZ+WNcQirrhYVrg+VQ9ZIXxwVQWHyhQ4bt1A
         wEVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=pjTRr0Ec/7D/SD2DSIp1WRI4YQ8Q1c/X0d5DLs4SpQQ=;
        b=E4RaZKLjVdX7dImNjUbp2UT8guQkGjXWut3CIemwRENyVYA9zfe1Si3ZeRdRo7g+j2
         fWSw/772pcGdAQYK0heauDtBoPdC3HGHTp2Re+qF7xxk5OSkxUVm6nWr701AKebtqitu
         BPpyymGIOCH/7vzaXe0uAjA51lqNTVQ5adt2ERyMa6lfwb1jVrdwqAtEDlXL5pOWLKBR
         jW2nHOlx+MlJGrPSNq5S8wZTu7C0SZJbNy6tVOkJFfEE7wPBjeZ9b+8EmdDnwSCPMoh5
         nJS1BcIb2mg8aoesKqvvS/e7ySjpQe8i9JCjliBP6ADzqUIMjej6uB56XZ9Fmd7UespX
         m+Fw==
X-Gm-Message-State: APjAAAXHf/k7LUPIcyffJcGE9oml5q031iZ0sZdrYAnZoiFJHvizIOv4
        djA1pFMNQ3iqzFRwERxXHHbmVg==
X-Google-Smtp-Source: APXvYqzBVlVp10LBUGfJPwXg0YAxcN7fNdNGF+Hc6mgKysDtZiRWF0SB3Lc7WXQXsBSzLrEHy3XXqw==
X-Received: by 2002:a19:1ce:: with SMTP id 197mr8207726lfb.16.1573249877377;
        Fri, 08 Nov 2019 13:51:17 -0800 (PST)
Received: from cakuba ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id h16sm3791325ljb.10.2019.11.08.13.51.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 13:51:17 -0800 (PST)
Date:   Fri, 8 Nov 2019 13:51:09 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Parav Pandit <parav@mellanox.com>, alex.williamson@redhat.com,
        davem@davemloft.net, kvm@vger.kernel.org, netdev@vger.kernel.org,
        saeedm@mellanox.com, kwankhede@nvidia.com, leon@kernel.org,
        cohuck@redhat.com, jiri@mellanox.com, linux-rdma@vger.kernel.org,
        Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [PATCH net-next 00/19] Mellanox, mlx5 sub function support
Message-ID: <20191108135109.0c833847@cakuba>
In-Reply-To: <20191108213952.GZ6990@nanopsycho>
References: <20191107160448.20962-1-parav@mellanox.com>
        <20191107153234.0d735c1f@cakuba.netronome.com>
        <20191108121233.GJ6990@nanopsycho>
        <20191108110640.225b2724@cakuba>
        <20191108194118.GY6990@nanopsycho>
        <20191108132120.510d8b87@cakuba>
        <20191108213952.GZ6990@nanopsycho>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Fri, 8 Nov 2019 22:39:52 +0100, Jiri Pirko wrote:
> >> Please let me understand how your device is different.
> >> Originally Parav didn't want to have mlx5 subfunctions as mdev. He
> >> wanted to have them tight to the same pci device as the pf. No
> >> difference from what you describe you want. However while we thought
> >> about how to fit things in, how to handle na phys_port_name, how to see
> >> things in sysfs we came up with an idea of a dedicated bus.  
> >
> >The difference is that there is naturally a main device and subslices
> >with this new mlx5 code. In mlx4 or nfp all ports are equal and
> >statically allocated when FW initializes based on port breakout.  
> 
> Ah, I see. I was missing the static part in nfp. Now I understand. It is
> just an another "pf", but not real pf in the pci terminology, right?

Ack, due to (real and perceived) HW limitations what should have been
separate PFs got squished into a single big one.

Biggest NFP chip has an insane (for a NIC) number Ethernet ports.
