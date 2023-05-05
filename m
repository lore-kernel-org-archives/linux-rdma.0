Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07104C77B75
	for <linux-rdma@archiver.kernel.org>; Fri,  5 May 2023 15:42:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232943AbjEEPmF (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 5 May 2023 11:42:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232460AbjEEPmE (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 5 May 2023 11:42:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 843FB11DA6
        for <linux-rdma@vger.kernel.org>; Fri,  5 May 2023 08:42:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2154063EFC
        for <linux-rdma@vger.kernel.org>; Fri,  5 May 2023 15:42:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F0BBC433EF;
        Fri,  5 May 2023 15:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683301322;
        bh=NB80E6sDOFiSRHYILHBdaX6WhxtoaeKVAuWkNhd3wwY=;
        h=Subject:From:To:Cc:Date:From;
        b=SrtVLCEhwHM/elDANECgFAdlbN0N3IWeoQ/5k0VXflXofpnHeosjPV320rVdktYOH
         YFfB1qfxCIRbFX7dkULQf5HcEAl+LAsNbDlraeeDHv0ysW1Nu5Bw3Bhe2lNaeU/KH3
         slTeJbX1FGzkPQV8Am1F4o0wtB8Wd7hartj9cX9kIE4Xi0vguS/ve1Pi4NQRgwFpJ/
         UAQw8wBfXRwL462/ik+k/VG1g2EkmLDv/DXSyGYg6CcjM1DkDgM/hLWZ/uDeqdoqwc
         cziv3sD9+u5CdyIZkE+gHyCyMzTSwDqx0jGXa9o43ZjKH3Ongy0irCUhR9C8fseL0r
         j6ZlmnROupgEw==
Subject: [PATCH RFC 0/3] siw on tunnel devices
From:   Chuck Lever <cel@kernel.org>
To:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Cc:     BMT@zurich.ibm.com, tom@talpey.com
Date:   Fri, 05 May 2023 11:41:50 -0400
Message-ID: <168330051600.5953.11366152375575299483.stgit@oracle-102.nfsv4bat.org>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Chalk this one up to yet another crazy idea.

At NFS testing events, we'd like to test NFS/RDMA over the event's
private network. We can do that with iWARP using siw from guests.

If the guest itself is on the VPN, that means siw's slave device
is a tun device. Such devices have no MAC address. That breaks the
RDMA core's ability to find the correct egress device for siw when
given a source IP address.

We've worked around this in the past with various software hacks,
but we'd rather see full support for this capability in stock
kernels.

A direct and perhaps naïve way to do that is to give loopback and
tun devices their own artificial MAC addresses for this purpose.

---

Chuck Lever (3):
      net/tun: Ensure tun devices have a MAC address
      net/lo: Ensure lo devices have a MAC address
      RDMA/siw: Require non-zero 6-byte MACs for soft iWARP


 drivers/infiniband/sw/siw/siw_main.c | 22 +++++++---------------
 drivers/net/loopback.c               |  2 ++
 drivers/net/tun.c                    |  6 +++---
 3 files changed, 12 insertions(+), 18 deletions(-)

--
Chuck Lever

