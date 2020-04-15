Return-Path: <SRS0=HR9Y=57=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA995C2BA19
	for <linux-rdma@archiver.kernel.org>; Wed, 15 Apr 2020 19:33:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BB4F20732
	for <linux-rdma@archiver.kernel.org>; Wed, 15 Apr 2020 19:33:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2634139AbgDOTd4 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 15 Apr 2020 15:33:56 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45142 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2411908AbgDOTdq (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 15 Apr 2020 15:33:46 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 88A9B128B65D4;
        Wed, 15 Apr 2020 12:33:45 -0700 (PDT)
Date:   Wed, 15 Apr 2020 12:33:44 -0700 (PDT)
Message-Id: <20200415.123344.555133895779578194.davem@davemloft.net>
To:     jgg@ziepe.ca
Cc:     santosh.shilimkar@oracle.com, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, rds-devel@oss.oracle.com
Subject: Re: [PATCH] net/rds: Use ERR_PTR for rds_message_alloc_sgs()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <0-v1-a3e19ba593e0+f5-rds_gcc10%jgg@mellanox.com>
References: <0-v1-a3e19ba593e0+f5-rds_gcc10%jgg@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 15 Apr 2020 12:33:45 -0700 (PDT)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

RnJvbTogSmFzb24gR3VudGhvcnBlIDxqZ2dAemllcGUuY2E+DQpEYXRlOiBUdWUsIDE0IEFwciAy
MDIwIDIwOjAyOjA3IC0wMzAwDQoNCj4gRnJvbTogSmFzb24gR3VudGhvcnBlIDxqZ2dAbWVsbGFu
b3guY29tPg0KPiANCj4gUmV0dXJuaW5nIHRoZSBlcnJvciBjb2RlIHZpYSBhICdpbnQgKnJldCcg
d2hlbiB0aGUgZnVuY3Rpb24gcmV0dXJucyBhDQo+IHBvaW50ZXIgaXMgdmVyeSB1bi1rZXJuZWx5
IGFuZCBjYXVzZXMgZ2NjIDEwJ3Mgc3RhdGljIGFuYWx5c2lzIHRvIGNob2tlOg0KPiANCj4gbmV0
L3Jkcy9tZXNzYWdlLmM6IEluIGZ1bmN0aW9uIKFyZHNfbWVzc2FnZV9tYXBfcGFnZXOiOg0KPiBu
ZXQvcmRzL21lc3NhZ2UuYzozNTg6MTA6IHdhcm5pbmc6IKFyZXSiIG1heSBiZSB1c2VkIHVuaW5p
dGlhbGl6ZWQgaW4gdGhpcyBmdW5jdGlvbiBbLVdtYXliZS11bmluaXRpYWxpemVkXQ0KPiAgIDM1
OCB8ICAgcmV0dXJuIEVSUl9QVFIocmV0KTsNCj4gDQo+IFVzZSBhIHR5cGljYWwgRVJSX1BUUiBy
ZXR1cm4gaW5zdGVhZC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEphc29uIEd1bnRob3JwZSA8amdn
QG1lbGxhbm94LmNvbT4NCg0KQXBwbGllZCwgdGhhbmtzLg0K
