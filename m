Return-Path: <SRS0=yC1B=ZO=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61918C432C0
	for <linux-rdma@archiver.kernel.org>; Fri, 22 Nov 2019 07:19:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 358CA2068F
	for <linux-rdma@archiver.kernel.org>; Fri, 22 Nov 2019 07:19:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbfKVHTt (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 22 Nov 2019 02:19:49 -0500
Received: from zg8tmtu5ljg5lje1ms4xmtka.icoremail.net ([159.89.151.119]:36356
        "HELO zg8tmtu5ljg5lje1ms4xmtka.icoremail.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with SMTP id S1726529AbfKVHTt (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 22 Nov 2019 02:19:49 -0500
Received: from [192.168.43.114] (unknown [223.104.213.121])
        by mail-app4 (Coremail) with SMTP id cS_KCgBnLogOjNdd_3AHAg--.33844S3;
        Fri, 22 Nov 2019 15:19:44 +0800 (CST)
To:     Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org
From:   wangqi <3100102071@zju.edu.cn>
Subject: [question]can hard roce and soft roce communicate with each other?
Message-ID: <53ed2e18-c58e-1e9c-55f8-60b14dfa2052@zju.edu.cn>
Date:   Fri, 22 Nov 2019 15:19:42 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CM-TRANSID: cS_KCgBnLogOjNdd_3AHAg--.33844S3
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
        VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUY-7k0a2IF6FyUM7kC6x804xWl14x267AK
        xVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGw
        A2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26w1j
        6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4UJVW0owA2z4x0Y4vEx4A2jsIE14v26r
        xl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAac4AC62xK8xCEY4vEwIxC4wAS
        0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
        IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
        Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4I
        kC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWU
        WwC2zVAF1VAY17CE14v26r1Y6r17MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr
        0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWr
        Jr0_WFyUJwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r
        4UYxBIdaVFxhVjvjDU0xZFpf9x07jrdbbUUUUU=
X-CM-SenderInfo: qtrqiiyqsqlio62m3hxhgxhubq/
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Dear experts on RDMA，

    I'm sorry to bother you again. 

    Do you know how to make soft-roce (on server) can send message 

to the hard-roce (like Mellanox cx4 card) on a client? We tried rdma-core 

25.0 and 26.0. The rdma-core can support both soft-roce and hard-roce.

But it seems that the soft-roce (server) and hard-roce (client) can not 

communicate via "ib_send_bw", "ib_read_bw" and so on, but can 

communicate via "rping". 

    Do you ever try to use soft-roce and hard-roce together? 

Do they work well? I really wonder why they can not communicate with

each other. Best wishes,

Qi

