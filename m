Return-Path: <SRS0=H3r4=B3=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7BAFC433DF
	for <linux-rdma@archiver.kernel.org>; Mon, 17 Aug 2020 19:27:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 993BD204EC
	for <linux-rdma@archiver.kernel.org>; Mon, 17 Aug 2020 19:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597692432;
	bh=oRpPTF8CLVl2GdwVLqbcgNxfGrfqo2YvIIghubdcD3U=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=GXH/caYMHgMT9znIskxu/8XK4OoMYXzEa8mm3FU7K39XtAc8R3t8ADE6yJLreemQf
	 SOHV4uZQzkI9tpYZjrCTldfebphNwJj9uw3OLnJkbPIN93zykbESvlwxSROMUF6t1V
	 hEbm2DwSUmzYO+GRnBnbNPb936Jg4BeEXFAnmO20=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731951AbgHQT1F (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 17 Aug 2020 15:27:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:36020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730386AbgHQPdd (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 17 Aug 2020 11:33:33 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 273CA22CAE;
        Mon, 17 Aug 2020 15:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678413;
        bh=oRpPTF8CLVl2GdwVLqbcgNxfGrfqo2YvIIghubdcD3U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cuCOTw7vdPagZu/YDOJ36n2k21iuhjC6Q+xcZCv5VwkvMnHehBKNuY7qWH1YfhLfQ
         uxs01fevGl2GXxKi+lBy8SDRp/QtPGUzthJFloMf+LShCgY+WQoz9xkezYTUR31ppl
         J47G6NfE97P+DK4Vs9w04H/cBfS//QF3y2IB04fA=
Date:   Mon, 17 Aug 2020 08:33:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Allen Pais <allen.lkml@gmail.com>
Cc:     jes@trained-monkey.org, davem@davemloft.net, kda@linux-powerpc.org,
        dougmill@linux.ibm.com, cooldavid@cooldavid.org,
        mlindner@marvell.com, borisp@mellanox.com, keescook@chromium.org,
        linux-acenic@sunsite.dk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-rdma@vger.kernel.org,
        oss-drivers@netronome.com, Romain Perier <romain.perier@gmail.com>
Subject: Re: [PATCH 08/20] ethernet: hinic: convert tasklets to use new
 tasklet_setup() API
Message-ID: <20200817083330.78e365eb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200817082434.21176-10-allen.lkml@gmail.com>
References: <20200817082434.21176-1-allen.lkml@gmail.com>
        <20200817082434.21176-10-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Mon, 17 Aug 2020 13:54:22 +0530 Allen Pais wrote:
> In preparation for unconditionally passing the
> struct tasklet_struct pointer to all tasklet
> callbacks, switch to using the new tasklet_setup()
> and from_tasklet() to pass the tasklet pointer explicitly.
> 
> Signed-off-by: Romain Perier <romain.perier@gmail.com>
> Signed-off-by: Allen Pais <allen.lkml@gmail.com>

drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c:374: warning: Function parameter or member 't' not described in 'ceq_tasklet'
drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c:374: warning: Excess function parameter 'ceq_data' description in 'ceq_tasklet'
