Return-Path: <SRS0=OzSu=AE=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74D40C433E0
	for <linux-rdma@archiver.kernel.org>; Tue, 23 Jun 2020 18:20:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EC45207E8
	for <linux-rdma@archiver.kernel.org>; Tue, 23 Jun 2020 18:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592936456;
	bh=UHSzK1qmu5qkVFlVS+obFaAqtQjbzpf3re6wkOIbD1I=;
	h=Date:From:To:Subject:List-ID:From;
	b=2HldHhFtJ5JW21UkShafTm90qZCKBLrByzUfXfOYcgWzSfHqb2Tgdm1aLC0LZBBz+
	 by1Ri6JFjbXaQ3ri57YWHFPTcboASsssZnNWSq6GGqLW5j3MMeLFi8/266SLb7dfdi
	 syJ3zsTMH0mjFbxLc520ukyDPFyiMfochWnzNnQM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733155AbgFWSUz (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 23 Jun 2020 14:20:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:55252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732913AbgFWSUz (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 23 Jun 2020 14:20:55 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B1F7207E8
        for <linux-rdma@vger.kernel.org>; Tue, 23 Jun 2020 18:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592936455;
        bh=UHSzK1qmu5qkVFlVS+obFaAqtQjbzpf3re6wkOIbD1I=;
        h=Date:From:To:Subject:From;
        b=BaBNCbs5EqF8ecOBl6bUKJ2jZYaxZoP+WyJtTHjmpngf6hhZxGGNAUmx8U3+9/wOm
         Ushl6R1IeVQZ6zFKbN1kbSaj8F493bvc2dK5dvH/EEXO6lcin//TXshZZel3xGGER+
         730bolHNG4h0L24rvTKosHZ8cdvcqKW0InS44MfE=
Date:   Tue, 23 Jun 2020 21:20:51 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: CFP for RDMA minisummit at virtual LPC 2020
Message-ID: <20200623182051.GD184720@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Hi,

I will be short.

Please send me/Jason/Doug/"mailing list" the topics which you would
like to discuss at RDMA minisummit at LPC 2020 which will be virtual
this year.

Thanks
