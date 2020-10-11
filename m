Return-Path: <SRS0=I5My=DS=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C41DEC433DF
	for <linux-rdma@archiver.kernel.org>; Sun, 11 Oct 2020 19:44:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82A292145D
	for <linux-rdma@archiver.kernel.org>; Sun, 11 Oct 2020 19:44:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S7Yhz7FN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbgJKTo3 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 11 Oct 2020 15:44:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726363AbgJKTo3 (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Sun, 11 Oct 2020 15:44:29 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9799EC0613CE;
        Sun, 11 Oct 2020 12:44:28 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id e22so20353496ejr.4;
        Sun, 11 Oct 2020 12:44:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=11y0pgG7aEVp4MN5bK5igJeBve2DHauuUJfvXQcU/cQ=;
        b=S7Yhz7FN4RrMaWZm062rjZtizkHtS2nV//ChDYOYkWaZc2/x3cEdl0rYtGoalmayEv
         l6AXRWI4xAJDVQC++R7i4AUWeE9nt3IDlOsLJfhNz/n0nROqitAsJb1eMMW0Yhfeyapq
         qMxH65BqWerBKZ4RgZ9KNhyYwXdUKGtBcQJnmk0ChQ/rARn80X/hhBRogAcNMNwiCk1R
         WCL9mXtmyKYZletsrxv5wKAuFEwNw0sfn4YhHnyFiqudQ0WPzB9n0wZfD0dXd67mpvtu
         OQJX97FsIVmi7NonufBQle/Iu1kSzfxG+Pr4jFLedyLWzd079oE6JpWXdDobDiqzrc4Z
         L9qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=11y0pgG7aEVp4MN5bK5igJeBve2DHauuUJfvXQcU/cQ=;
        b=muCG6Eff6aIR1lJBy1wKXOJsBf7Z0xG6xXzwjCCy29q4pZqU/1nmvDl8v+z6p8Xpoy
         wiReaQJlHxJ0RJ8ca7UbldOuuP3MOS6cjDWimterrk3q/tVWwJPH9HRY5XLS6GRsXwj8
         xF9AkrhYaq0CYAULN2NQ8Y994Gy9pC/t0Jxlh+O9UFHELR2wcPjTs6+Kouio33ldESYg
         fVF2GpAW5xEPZekOW8KWP9If4gArlFT7OJ/H1bTL7EjfNd5S86PN/5W4PDXuyTyK8Nl6
         bt5D9QIslGthAB5Qhrs1MMkrFSa4KChsZpEAQedH+OlBwFUyWhb6h5faLRGpX16xKTzk
         Bnag==
X-Gm-Message-State: AOAM532wS7Rrh6lqRpCJuntmJQaWqaUr9yq3rUKcC7mFDMfMJ1SbrCDq
        aP5p086vOsT9Ohwq10Pfp6Y=
X-Google-Smtp-Source: ABdhPJwVvpcAwXtIRgiHnHwS6RDkPJ1F5KHG+smtvSF9qxcZiwxZuqYBL0otDnZ7nDsvJi4e8+FCrw==
X-Received: by 2002:a17:906:6887:: with SMTP id n7mr24494904ejr.288.1602445467117;
        Sun, 11 Oct 2020 12:44:27 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f00:6a00:51b7:bf4f:604:7d3d? (p200300ea8f006a0051b7bf4f06047d3d.dip0.t-ipconnect.de. [2003:ea:8f00:6a00:51b7:bf4f:604:7d3d])
        by smtp.googlemail.com with ESMTPSA id y25sm9655319edr.7.2020.10.11.12.44.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Oct 2020 12:44:26 -0700 (PDT)
Subject: [PATCH net-next 01/12] net: core: add function dev_fetch_sw_netstats
 for fetching pcpu_sw_netstats
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?Q?Bj=c3=b8rn_Mork?= <bjorn@mork.no>,
        Oliver Neukum <oneukum@suse.com>,
        Igor Mitsyanko <imitsyanko@quantenna.com>,
        Sergey Matyukevich <geomatsi@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Pravin B Shelar <pshelar@ovn.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-rdma@vger.kernel.org,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        bridge@lists.linux-foundation.org
References: <a46f539e-a54d-7e92-0372-cd96bb280729@gmail.com>
Message-ID: <5bb71143-0dac-c413-7e97-50eed8a57862@gmail.com>
Date:   Sun, 11 Oct 2020 21:36:43 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <a46f539e-a54d-7e92-0372-cd96bb280729@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

In several places the same code is used to populate rtnl_link_stats64
fields with data from pcpu_sw_netstats. Therefore factor out this code
to a new function dev_fetch_sw_netstats().

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 include/linux/netdevice.h |  2 ++
 net/core/dev.c            | 36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index a0df43b13..ca4736349 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4495,6 +4495,8 @@ struct rtnl_link_stats64 *dev_get_stats(struct net_device *dev,
 					struct rtnl_link_stats64 *storage);
 void netdev_stats_to_stats64(struct rtnl_link_stats64 *stats64,
 			     const struct net_device_stats *netdev_stats);
+void dev_fetch_sw_netstats(struct rtnl_link_stats64 *s,
+			   struct pcpu_sw_netstats __percpu *netstats);
 
 extern int		netdev_max_backlog;
 extern int		netdev_tstamp_prequeue;
diff --git a/net/core/dev.c b/net/core/dev.c
index 7d18560b2..ba91bf16b 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10323,6 +10323,42 @@ struct rtnl_link_stats64 *dev_get_stats(struct net_device *dev,
 }
 EXPORT_SYMBOL(dev_get_stats);
 
+/**
+ *	dev_fetch_sw_netstats - get per-cpu network device statistics
+ *	@s: place to store stats
+ *	@netstats: per-cpu network stats to read from
+ *
+ *	Read per-cpu network statistics and populate the related fields in s.
+ */
+void dev_fetch_sw_netstats(struct rtnl_link_stats64 *s,
+			   struct pcpu_sw_netstats __percpu *netstats)
+{
+	int cpu;
+
+	if (IS_ERR_OR_NULL(netstats))
+		return;
+
+	for_each_possible_cpu(cpu) {
+		struct pcpu_sw_netstats *stats, tmp;
+		unsigned int start;
+
+		stats = per_cpu_ptr(netstats, cpu);
+		do {
+			start = u64_stats_fetch_begin_irq(&stats->syncp);
+			tmp.rx_packets = stats->rx_packets;
+			tmp.rx_bytes   = stats->rx_bytes;
+			tmp.tx_packets = stats->tx_packets;
+			tmp.tx_bytes   = stats->tx_bytes;
+		} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
+
+		s->rx_packets += tmp.rx_packets;
+		s->rx_bytes   += tmp.rx_bytes;
+		s->tx_packets += tmp.tx_packets;
+		s->tx_bytes   += tmp.tx_bytes;
+	}
+}
+EXPORT_SYMBOL(dev_fetch_sw_netstats);
+
 struct netdev_queue *dev_ingress_queue_create(struct net_device *dev)
 {
 	struct netdev_queue *queue = dev_ingress_queue(dev);
-- 
2.28.0


