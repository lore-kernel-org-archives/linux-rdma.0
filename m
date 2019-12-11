Return-Path: <SRS0=YjSL=2B=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7304EC43603
	for <linux-rdma@archiver.kernel.org>; Wed, 11 Dec 2019 12:57:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 413FB2073D
	for <linux-rdma@archiver.kernel.org>; Wed, 11 Dec 2019 12:57:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="CFlmpkoY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729399AbfLKM5i (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 11 Dec 2019 07:57:38 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:44953 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728128AbfLKM5i (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 11 Dec 2019 07:57:38 -0500
Received: by mail-oi1-f194.google.com with SMTP id d62so13062360oia.11
        for <linux-rdma@vger.kernel.org>; Wed, 11 Dec 2019 04:57:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8UBcjBulCkWTBRf3cy8h5JvHZs8UVRnnpilVX4iJ7eY=;
        b=CFlmpkoYWjz7wzo7GiFm3Xq5OwoDccC8iRT6KSYQzlHg9DoPaCQPuWbQvTJT4F4A1b
         TqvpdPNDi/KSNj9F4xOuT50F/WRc4LLY/wFt1Zcwu2Kntgdgj/K0Gxojcf17+brtta3a
         fYkuI6uKOBA5cbxiiINl1NrLLZYNWyf/xuh6w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8UBcjBulCkWTBRf3cy8h5JvHZs8UVRnnpilVX4iJ7eY=;
        b=G9AKT5xRp1hheRF0ISJj7jI9rPb89QCPZLKf4UFzd9nkDnZ4IhHiWxYf+zPi2B2lvO
         kMqY+YN4LmUah61guQd80DasRfZzE72vM0fSagasv+MZlCSr8pE8sS2SdGslIJ56v312
         f2X+BOCk0EYsb/KO1pAmwaSXi8+Gqw4nEDsRBoUq+/tsoeRMfwbK+wdrOtb8XCFxZN97
         +rCMTqdcjc+zZjKVZn6BRgOwShcthpkWE8S5+MyzEJdhtVLb52mHMODs5/dXMDf0WTjT
         3Yt0ZzInGOOaAga8zKVBd4sz0GjZ3Vzj76HvFbbYBNPtQIfZxkX3CjgeVErOs7uqwsfv
         Q17w==
X-Gm-Message-State: APjAAAWPJ/1j+wStL/pupqwBVPIW5xRPRyumpCRtaBXb8B5j2HFc+FkK
        ftTJ2FMAC7eIY5gqFB61LKNatYufmKnYh6nKCc4xgQ==
X-Google-Smtp-Source: APXvYqzrwmdQXnjg1HC0Ldpj3uEYi0APDRJqwJseXr+kR8lU4L9zbtJG+dcZgJSkoCPKExdD5wCry1NFZj8jxqR21gE=
X-Received: by 2002:aca:f445:: with SMTP id s66mr2486781oih.95.1576069057472;
 Wed, 11 Dec 2019 04:57:37 -0800 (PST)
MIME-Version: 1.0
References: <1574671174-5064-1-git-send-email-selvin.xavier@broadcom.com>
In-Reply-To: <1574671174-5064-1-git-send-email-selvin.xavier@broadcom.com>
From:   Selvin Xavier <selvin.xavier@broadcom.com>
Date:   Wed, 11 Dec 2019 18:27:25 +0530
Message-ID: <CA+sbYW13n4BBGRwohMDg6iAOd-nFQXn6SUp8cDLY0qAgpqbZpg@mail.gmail.com>
Subject: Re: [PATCH for-next 0/6] RDMA/bnxt_re driver update
To:     Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc:     linux-rdma@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Hi Doug/Jason,

Can you please confirm whether you plan to pull this series in 5.5? I
marked it as for-next. I was not sure whether it was late for the
current merge window.  If you don't plan to pull this series, can you
please pull patch 1 and 2 for RC? Both are bug fixes.
Thanks,
Selvin

On Mon, Nov 25, 2019 at 2:09 PM Selvin Xavier
<selvin.xavier@broadcom.com> wrote:
>
> This series includes couple of bug fixes and
> code refactoring in the device init/deinit path.
> Also, modifies the code to use the new driver unregistration APIs.
>
> Please apply to for-next.
>
> Thanks,
> Selvin Xavier
>
> Selvin Xavier (6):
>   RDMA/bnxt_re: Avoid freeing MR resources if dereg fails
>   RDMA/bnxt_re: Fix Send Work Entry state check while polling
>     completions
>   RDMA/bnxt_re: Add more flags in device init and uninit path
>   RDMA/bnxt_re: Refactor device add/remove functionalities
>   RDMA/bnxt_re: Use driver_unregister and unregistration API
>   RDMA/bnxt_re: Report more number of completion vectors
>
>  drivers/infiniband/hw/bnxt_re/bnxt_re.h    |  16 +-
>  drivers/infiniband/hw/bnxt_re/ib_verbs.c   |   4 +-
>  drivers/infiniband/hw/bnxt_re/main.c       | 246 +++++++++++++++--------------
>  drivers/infiniband/hw/bnxt_re/qplib_fp.c   |  12 +-
>  drivers/infiniband/hw/bnxt_re/qplib_rcfw.c |   7 +
>  drivers/infiniband/hw/bnxt_re/qplib_rcfw.h |   1 +
>  6 files changed, 154 insertions(+), 132 deletions(-)
>
> --
> 2.5.5
>
