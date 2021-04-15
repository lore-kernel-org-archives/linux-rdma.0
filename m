Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A4ADC433ED
	for <linux-rdma@archiver.kernel.org>; Thu, 15 Apr 2021 09:56:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D63B861042
	for <linux-rdma@archiver.kernel.org>; Thu, 15 Apr 2021 09:56:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbhDOJ5U (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 15 Apr 2021 05:57:20 -0400
Received: from vmi485042.contaboserver.net ([161.97.139.209]:36896 "EHLO
        gentwo.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229481AbhDOJ5U (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 15 Apr 2021 05:57:20 -0400
Received: by gentwo.de (Postfix, from userid 1001)
        id 377C9B00679; Thu, 15 Apr 2021 11:47:34 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by gentwo.de (Postfix) with ESMTP id 3652AB00673;
        Thu, 15 Apr 2021 11:47:34 +0200 (CEST)
Date:   Thu, 15 Apr 2021 11:47:34 +0200 (CEST)
From:   Christoph Lameter <cl@gentwo.de>
To:     Wan Jiabing <wanjiabing@vivo.com>
cc:     Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Kamal Heib <kamalheib1@gmail.com>,
        Alaa Hleihel <alaa@mellanox.com>,
        Valentine Fatiev <valentinef@mellanox.com>,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        kael_w@yeah.net
Subject: Re: [PATCH] infiniband: ulp: Remove unnecessary struct declaration
In-Reply-To: <20210415092124.27684-1-wanjiabing@vivo.com>
Message-ID: <alpine.DEB.2.22.394.2104151147070.633142@gentwo.de>
References: <20210415092124.27684-1-wanjiabing@vivo.com>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Thu, 15 Apr 2021, Wan Jiabing wrote:

> struct ipoib_cm_tx is defined at 245th line.
> And the definition is independent on the MACRO.
> The declaration here is unnecessary. Remove it.

Correct.

Reviewed-by: Christoph Lameter <cl@linux.com>

