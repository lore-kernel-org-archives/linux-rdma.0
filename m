Return-Path: <SRS0=nNSQ=AY=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 436F5C433E1
	for <linux-rdma@archiver.kernel.org>; Mon, 13 Jul 2020 17:09:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DC74206F0
	for <linux-rdma@archiver.kernel.org>; Mon, 13 Jul 2020 17:09:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="P6ue5J2Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730267AbgGMRJn (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 13 Jul 2020 13:09:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729933AbgGMRJn (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 13 Jul 2020 13:09:43 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02B41C061794
        for <linux-rdma@vger.kernel.org>; Mon, 13 Jul 2020 10:09:42 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id q198so12938252qka.2
        for <linux-rdma@vger.kernel.org>; Mon, 13 Jul 2020 10:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AjfD32HKP9GelxZOkg41v9V6Gzjw1JRj8RlOK03pams=;
        b=P6ue5J2QVyGR013c2UC25Q9bEjmGLQLJlmEuA1j5UoaACPlwGsRU5oPQydR4VgHRAQ
         L1LLo1DsbWsmVVz1JJH+XrYRnbQxNVDp0Tbzha5dqUAB1U3rVrK0ZuloeI02R3+Ohmck
         nIhcHDRdSQZbeXNk1VGmdTIpJpVNzm4aXapDBvkADLvm+N6wGsC0Vuj5SRCjoLtTpbM6
         3YNMYd60otly0jlZeIyCvHepWSBprUXUrUnc1mbSIi5+zMPYtY/xp7pglqsia5XJhfiB
         F8DgDcnW27IcL2XuD2u0H8FjQS8bqlDG91XFUgIbJjfpl7taOGEyt92W8DFNPIX8mT3F
         fvkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AjfD32HKP9GelxZOkg41v9V6Gzjw1JRj8RlOK03pams=;
        b=r/1f1XrfXzZ6eX+XsLCnK0hi2fBPzlX/xEkvxxV93cqFulnwOUO/bToU9wYDe0v+/C
         rb2KpO4fz2Yoa+W35ENO3BFgf0yuVWLxCkZ0qidXC7/LIUS0sIZtkUQYCfipJM/GqXfY
         LUBTZqqLkgChkIgCl7mAmKHaO9ELCurD2TNS7hyauFJ2MlFVGq8Nu7YsuXo92cnUFVO3
         dMIZUNsmXHF19YCkumhxFX9+PR//UCxEnkcBBYXYFOpSQMHcl2J7t4hgKvHYdSl0NQe2
         oVlgJ8ZKJiIpYm8YS9HylFgdrwjeh/lOG/wh4ZKjR8Gj+018FR9/8+iaNgNxT7rYHyIz
         ANdQ==
X-Gm-Message-State: AOAM5337KQBYhIgObvhd1HFCx+S6x+UcKK0Doj+3dwMa3TDM3E++Nh1Y
        JMbtHeLQrfQaxYeMMTcaGQz2wA==
X-Google-Smtp-Source: ABdhPJzvbBBh0WGnYFjQ6KDKcJ34oSp591S6VrK9/KQzdFPP1pwlEgvCtv/HHrr6bK2VB24/hylh7Q==
X-Received: by 2002:a37:5bc4:: with SMTP id p187mr661575qkb.166.1594660182115;
        Mon, 13 Jul 2020 10:09:42 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id i35sm19119142qtd.96.2020.07.13.10.09.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 10:09:41 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.93)
        (envelope-from <jgg@ziepe.ca>)
        id 1jv1xV-009lWJ-4g; Mon, 13 Jul 2020 14:09:41 -0300
Date:   Mon, 13 Jul 2020 14:09:41 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     "Saheed O. Bolarinwa" <refactormyself@gmail.com>
Cc:     skhan@linuxfoundation.org, linux-rdma@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/14 v3] IB/hfi1: Check the return value of
 pcie_capability_read_*()
Message-ID: <20200713170941.GB25301@ziepe.ca>
References: <20200713175529.29715-1-refactormyself@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200713175529.29715-1-refactormyself@gmail.com>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Mon, Jul 13, 2020 at 07:55:25PM +0200, Saheed O. Bolarinwa wrote:
> From: Bolarinwa Olayemi Saheed <refactormyself@gmail.com>
> 
> On failure pcie_capability_read_dword() sets it's last parameter,
> val to 0. In this case dn and up will be 0, so aspm_hw_l1_supported()
> will return false.
> However, with Patch 14/14, it is possible that val is set to ~0 on
> failure. This would introduce a bug because (x & x) == (~0 & x). So with
> dn and up being 0x02, a true value is return when the read has actually
> failed.
> 
> This bug can be avoided if the return value of pcie_capability_read_dword
> is checked to confirm success. The behaviour of the function remains
> intact.
> 
> Check the return value of pcie_capability_read_dword() to ensure success.
> 
> Suggested-by: Bjorn Helgaas <bjorn@helgaas.com>
> Signed-off-by: Bolarinwa Olayemi Saheed <refactormyself@gmail.com>
>  drivers/infiniband/hw/hfi1/aspm.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/hfi1/aspm.c b/drivers/infiniband/hw/hfi1/aspm.c
> index a3c53be4072c..80d0b3edd983 100644
> +++ b/drivers/infiniband/hw/hfi1/aspm.c
> @@ -24,6 +24,7 @@ static bool aspm_hw_l1_supported(struct hfi1_devdata *dd)
>  {
>  	struct pci_dev *parent = dd->pcidev->bus->self;
>  	u32 up, dn;
> +	int ret_up, ret_dn;
>  
>  	/*
>  	 * If the driver does not have access to the upstream component,
> @@ -32,14 +33,14 @@ static bool aspm_hw_l1_supported(struct hfi1_devdata *dd)
>  	if (!parent)
>  		return false;
>  
> -	pcie_capability_read_dword(dd->pcidev, PCI_EXP_LNKCAP, &dn);
> +	ret_dn = pcie_capability_read_dword(dd->pcidev, PCI_EXP_LNKCAP, &dn);
>  	dn = ASPM_L1_SUPPORTED(dn);
>  
> -	pcie_capability_read_dword(parent, PCI_EXP_LNKCAP, &up);
> +	ret_up = pcie_capability_read_dword(parent, PCI_EXP_LNKCAP, &up);
>  	up = ASPM_L1_SUPPORTED(up);
>  
>  	/* ASPM works on A-step but is reported as not supported */
> -	return (!!dn || is_ax(dd)) && !!up;
> +	return !!ret_dn && !!ret_up && (!!dn || is_ax(dd)) && !!up;
>  }

what is all the !! for? boolean contexts already coerce to boolean

Jason
