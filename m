Return-Path: <SRS0=JlAs=7L=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDE37C433DF
	for <linux-rdma@archiver.kernel.org>; Fri, 29 May 2020 23:31:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98301207BC
	for <linux-rdma@archiver.kernel.org>; Fri, 29 May 2020 23:31:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="iYn2DlT/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728499AbgE2XbY (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 29 May 2020 19:31:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728430AbgE2XbX (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 29 May 2020 19:31:23 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43E45C03E969
        for <linux-rdma@vger.kernel.org>; Fri, 29 May 2020 16:31:23 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id fb16so1909292qvb.5
        for <linux-rdma@vger.kernel.org>; Fri, 29 May 2020 16:31:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zXol5ci9en0xQ/0SDw4YH33E8d+wj+Bu3xgBoFDgfGM=;
        b=iYn2DlT/dc4pVXooxlmiU75lFDU+WtXKk7quaJcfiB+kjAJDvQnYEfL6gif+5KO4cy
         7g09nempnpFd7kOOdrpEshIwzNTEAUurAWs2z9X+TST4bsPW8PmZIGAXmQlmokpeukkP
         5dCRHafSc/Op6ZbUKTj4IqVFtwXmshgcDDsQN4RH4l33MVOmlFCKuzGIzfyhXkQlUsd+
         mVsI06k2JkMCgMkxr+YmtWrDPsMkBhsknPMO5VbW8qMXVfbyppszNWhbieDm4/XxuxSe
         t5DTnmKqtCnfoQoqfRj54D2CJXSXY5wnWSgUWWQ29e82gY5nX4qIZpi1Y8swzOxQDmqp
         GSpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=zXol5ci9en0xQ/0SDw4YH33E8d+wj+Bu3xgBoFDgfGM=;
        b=d319kLLCvLkXsFmXyKIuf5w/BQ2MdROSSMpqSQnOFDlTixWgsTiWxV0kZueIWTw/s9
         Dqv05TBnwfz9K1f0jeP2vQ/2nDEPADCpLD+UDKz+6wRrh7/8amC0cFK+NLyD2IAaFoMp
         ZvAXkGQCjl/oQWDAPNWdgqIhkgHi92P1NREeQ9JnnFtDs5FkR34Qkyu5wyMh7ar0CXTq
         9O/cPhzg/nybpc2P4HfHiNoazOSHjvIXWHomAULRuJ9pg+JcXenAn6QO+a4TeWT51SrX
         6GpDN9d35yHLMNOa9TOCnXg2iMmA63ZqhoILdPt2HtWhaK/3/+gg+LzZvjn9F/hRqbw+
         VwvA==
X-Gm-Message-State: AOAM533WlzSRaWjFxmgp1pvzjKb1yjS6nkP5ANR9wb+7OZ+S5tpD3Sqx
        Dq0Fv+9vEcNMRDh7itOs7EAssA==
X-Google-Smtp-Source: ABdhPJzcf19G+8C6aGVGc6evYYV41ivXpA3Kr1wgTmRxF2hoeHsbRgQliCGIxs2om0EEvmYp32xYNg==
X-Received: by 2002:a0c:f286:: with SMTP id k6mr10746966qvl.72.1590795082355;
        Fri, 29 May 2020 16:31:22 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id o188sm1414032qkf.28.2020.05.29.16.31.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 29 May 2020 16:31:21 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jeoTB-0000t5-DQ; Fri, 29 May 2020 20:31:21 -0300
Date:   Fri, 29 May 2020 20:31:21 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Maor Gottlieb <maorg@mellanox.com>, linux-rdma@vger.kernel.org
Subject: Re: [PATCH rdma-next v1 11/11] RDMA/mlx5: Add support to get MR
 resource in RAW format
Message-ID: <20200529233121.GA3296@ziepe.ca>
References: <20200527135408.480878-1-leon@kernel.org>
 <20200527135408.480878-12-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200527135408.480878-12-leon@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Wed, May 27, 2020 at 04:54:08PM +0300, Leon Romanovsky wrote:
> From: Maor Gottlieb <maorg@mellanox.com>
> 
> Add support to get MR (mkey) resource dump in RAW format.
> 
> Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
>  drivers/infiniband/hw/mlx5/restrack.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/hw/mlx5/restrack.c b/drivers/infiniband/hw/mlx5/restrack.c
> index 9e1389b8dd9f..834886536127 100644
> +++ b/drivers/infiniband/hw/mlx5/restrack.c
> @@ -116,7 +116,8 @@ int mlx5_ib_fill_res_mr_entry(struct sk_buff *msg,
>  	struct nlattr *table_attr;
>  
>  	if (raw)
> -		return -EOPNOTSUPP;
> +		return fill_res_raw(msg, mr->dev, MLX5_SGMT_TYPE_PRM_QUERY_MKEY,
> +				    mlx5_mkey_to_idx(mr->mmkey.key));

None of the raw functions actually share any code with the non raw
part, why are the in the same function? In fact all the implemenations
just call some other function for raw.

To me this looks like they should should all be a new op
'fill_raw_res_mr_entry' and drop the 'bool'

Jason
