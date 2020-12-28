Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D76F5C433E6
	for <linux-rdma@archiver.kernel.org>; Mon, 28 Dec 2020 03:09:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A643220882
	for <linux-rdma@archiver.kernel.org>; Mon, 28 Dec 2020 03:09:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbgL1DI5 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 27 Dec 2020 22:08:57 -0500
Received: from spam.zju.edu.cn ([61.164.42.155]:32060 "EHLO zju.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726289AbgL1DI5 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sun, 27 Dec 2020 22:08:57 -0500
Received: by ajax-webmail-mail-app3 (Coremail) ; Mon, 28 Dec 2020 11:07:50
 +0800 (GMT+08:00)
X-Originating-IP: [10.192.85.18]
Date:   Mon, 28 Dec 2020 11:07:50 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   dinghao.liu@zju.edu.cn
To:     "Leon Romanovsky" <leon@kernel.org>
Cc:     kjlu@umn.edu, "Doug Ledford" <dledford@redhat.com>,
        "Jason Gunthorpe" <jgg@ziepe.ca>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        "Ursula Braun" <ubraun@linux.ibm.com>,
        =?UTF-8?Q?H=C3=A5kon_Bugge?= <haakon.bugge@oracle.com>,
        "Divya Indi" <divya.indi@oracle.com>,
        "Mauro Carvalho Chehab" <mchehab+huawei@kernel.org>,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH] IB/sa: Fix memleak in ib_nl_make_request
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20200917(3e19599d)
 Copyright (c) 2002-2020 www.mailtech.cn zju.edu.cn
In-Reply-To: <20201227071346.GB4457@unreal>
References: <20201220081317.18728-1-dinghao.liu@zju.edu.cn>
 <20201227071346.GB4457@unreal>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <17c0fdb1.7819.176a750f929.Coremail.dinghao.liu@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: cC_KCgDnjw0GTOlfohQeAA--.5655W
X-CM-SenderInfo: qrrzjiaqtzq6lmxovvfxof0/1tbiAgYEBlZdtRrnPgAYsj
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VW5Jw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

PiBPbiBTdW4sIERlYyAyMCwgMjAyMCBhdCAwNDoxMzoxNFBNICswODAwLCBEaW5naGFvIExpdSB3
cm90ZToKPiA+IFdoZW4gcmRtYV9ubF9tdWx0aWNhc3QoKSBmYWlscywgc2tiIHNob3VsZCBiZSBm
cmVlZAo+ID4ganVzdCBsaWtlIHdoZW4gaWJubF9wdXRfbXNnKCkgZmFpbHMuCj4gCj4gSXQgaXMg
bm90IHNvIHNpbXBsZSBhcyB5b3Ugd3JvdGUgaW4gdGhlIGRlc2NyaXB0aW9uLgo+IAo+IFRoZXJl
IGFyZSBubyBvdGhlciBwbGFjZXMgaW4gdGhlIGxpbnV4IGtlcm5lbCB0aGF0IGZyZWUKPiBTS0Jz
IGFmdGVyIG5ldGxpbmtfbXVsdGljYXN0KCkgZmFpbHVyZS4KPiAKCkl0J3MgY2xlYXIgZm9yIG1l
LCB0aGFua3MuCgpSZWdhcmRzLApEaW5naGFvCg==
