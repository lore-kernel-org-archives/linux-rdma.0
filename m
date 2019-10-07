Return-Path: <SRS0=zqf9=YA=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B177AC47404
	for <linux-rdma@archiver.kernel.org>; Mon,  7 Oct 2019 21:55:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F46E206C0
	for <linux-rdma@archiver.kernel.org>; Mon,  7 Oct 2019 21:55:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m0SNwn2+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729133AbfJGVzd (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 7 Oct 2019 17:55:33 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:45433 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728422AbfJGVzc (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 7 Oct 2019 17:55:32 -0400
Received: by mail-pl1-f193.google.com with SMTP id u12so7493484pls.12;
        Mon, 07 Oct 2019 14:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Fh/v3zhxR6R1H2Q5qz0fPvsPGD6CN/4zH5A3jA+1l4c=;
        b=m0SNwn2+uijDrABFwPtcNOCJZFF82maNiMnRi1k4jPTbNVSutdw3lTjto48XWlEorM
         rQivFqnYewMEWPOPMEsW0Xzk5ICkR5iPgzTzXHnbb07VkmAAYGAq3b7AlYZT8yTareM6
         1jHIrUNeOEV8McHBQb3iNRfiGIMtXAR4HFeGPof3LO+G/loGKuf/56xxQPPQWKYFIUBs
         Dh747sPspTqRe8URDtgHAGw+nucnHqdXt3YrbhVeSuCQsL2UJJY0TrPM7ttv+AAeehv0
         rGjUH3Rz0BHqt0fCpgrUrd1L3jepkfBuXI8H5NNgeRwxTvD6Wh2KQmUqU4jXC+EKU+Fi
         vbig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Fh/v3zhxR6R1H2Q5qz0fPvsPGD6CN/4zH5A3jA+1l4c=;
        b=PYokGBorXuYRkelHm0F2bA4hijnHW0VlbWlNiaFuVuTU/QWt1o2Xh1PJ4/mVbhuyZQ
         9FXPyoj3p22AHRcjt95FZSIZreJovcPi6sYFkaRKYFJ6zSX+nAzjycqezivdURNC9IdO
         q8OIQ1jOcUAoFTftb5DPXfh0jpIfzXRg09ncBjBa1bZFA5XrenSpNBsTMTvlPRwWMYO2
         /11oQ71enflo7w2/GDF0Pv2LNLy9v7SQP2YlCCkmPm9SUhrL/CIWZ+PG2YhzZK0c3Wvh
         GkhVBCMrJpyzZvC5gusbxs1WRIbhLaP+L5oFFhUqZA0hUzbEci3CFPFbr9udv7mok6h8
         z6uw==
X-Gm-Message-State: APjAAAVVZDTn3kmZalGb1XMgXsQVU/UvcZ/dhupM19FjRLtF1lGGlcjQ
        MfEL8AGxJ4tRSOyI1ZIKq9s=
X-Google-Smtp-Source: APXvYqyKl22DtP+1oaZxqYjtzDL6/AjPliKNsivsnCtEB3R6/ySLo7a/4+fa0Wu7zR+DUKss/LOtvw==
X-Received: by 2002:a17:902:bb91:: with SMTP id m17mr32142567pls.79.1570485332004;
        Mon, 07 Oct 2019 14:55:32 -0700 (PDT)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:dc58:1abd:13a8:f485])
        by smtp.googlemail.com with ESMTPSA id g12sm17709018pfb.97.2019.10.07.14.55.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Oct 2019 14:55:31 -0700 (PDT)
Subject: Re: [PATCH iproute2-next] rdma: Relax requirement to have PID for HW
 objects
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
References: <20191002134934.19226-1-leon@kernel.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <598c983f-d28a-3b77-9d9c-3a8686836630@gmail.com>
Date:   Mon, 7 Oct 2019 15:55:29 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191002134934.19226-1-leon@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On 10/2/19 7:49 AM, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> RDMA has weak connection between PIDs and HW objects, because
> the latter tied to file descriptors for their lifetime management.
> 
> The outcome of such connection is that for the following scenario,
> the returned PID will be 0 (not-valid):
>  1. Create FD and context
>  2. Share it with ephemeral child
>  3. Create any object and exit that child
> 
> This flow was revealed in testing environment and of course real users
> are not running such scenario, because it makes no sense at all in RDMA
> world.
> 
> Let's do two changes in the code to support such workflow anyway:
>  1. Remove need to provide PID/kernel name. Code already supports it,
>     just need to remove extra validation.
>  2. Ball-out in case PID is 0.
> 
> Link: https://lore.kernel.org/linux-rdma/20191002123245.18153-2-leon@kernel.org
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
>  rdma/res-cmid.c | 5 +----
>  rdma/res-cq.c   | 5 +----
>  rdma/res-mr.c   | 5 +----
>  rdma/res-pd.c   | 5 +----
>  rdma/res-qp.c   | 5 +----
>  rdma/res.c      | 3 +++
>  6 files changed, 8 insertions(+), 20 deletions(-)
> 

applied to iproute2-next
