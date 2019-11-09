Return-Path: <SRS0=JC7s=ZB=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4DBAC17440
	for <linux-rdma@archiver.kernel.org>; Sat,  9 Nov 2019 17:28:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDAA7214E0
	for <linux-rdma@archiver.kernel.org>; Sat,  9 Nov 2019 17:28:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=netronome-com.20150623.gappssmtp.com header.i=@netronome-com.20150623.gappssmtp.com header.b="w7ip27ny"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbfKIR2O (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sat, 9 Nov 2019 12:28:14 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:37504 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726467AbfKIR2O (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Sat, 9 Nov 2019 12:28:14 -0500
Received: by mail-pl1-f195.google.com with SMTP id g8so1528090plt.4
        for <linux-rdma@vger.kernel.org>; Sat, 09 Nov 2019 09:28:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=iXmvJKuzGMS+aNTjizicdUcbTc9VbFkffW11ne/FTxI=;
        b=w7ip27nyf+UU1UiT5EHE+T0cN9v6+gGsNTfQ2tATS5SKHrKej+mFtU9rVy944/dXt/
         cGyLTbAqsccW1ira/2jVrc+v5r8DwTGgZd8QP2e3F0d/LLS5OPTzhhvEzbOXyw6sDpvH
         kxn+Ll26EfSE260D6v8YSRUTOUPOWrGW8k2F3uNbcQtPpsBmz6Ypa6QPWAfSzmG2hmo7
         uf4qmbbGySzmlXJlgILLeMNqm/4tRICMENh/A7fUUDUIkqPguE9jB05VzbaW5mDjjJch
         5B9aHLjBZKemJoDl5Wsw6Q7sQWzn0C5QHj79XGl7q8/UikH8wOUGcxYltAPpbzB03VV2
         ysQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=iXmvJKuzGMS+aNTjizicdUcbTc9VbFkffW11ne/FTxI=;
        b=GPBNORBFvhTl2r7HEZcqphzliLgJK+KyFw0i/cSilKVDMvxmo2UKmYXnTIqax5n4ja
         rDz1MCo4907iQbeAw5lUtmjeDCS88fh9lYCnR4QRZIggw8rGo5JRLdwbuwqtI2Uuv2z8
         a9FGNxl46J7YBaGwmlsAr/DOWtJazR3Y4wL12pkDkv0cu6fuerjoh0h0qZEfZywOShKC
         aVm9++CJSswq9NB2jtVAsUq1JVp/4GvwXYI+D3YigfqmP0yItzux7KFcLqo3HzIb2RA2
         hEw2HBk/dHSFIjgR2V0grZm9v6SDU7zEFohIYpTLO98p7xZv7VYCd0+L4cGQOysJv+4W
         DiBA==
X-Gm-Message-State: APjAAAX/NRSQu+p3RLTUn7uTrw85O8jSbmbsh5iiyQGx+7+bUhJ/EIfY
        VEVowOMOaHJZQZSFd/7pVpgFsQ==
X-Google-Smtp-Source: APXvYqyyAZ2DzfD0ZECVqidVgGvxfeRELxDI8SDSfzcAPUtKW9GtcEYiAmTJquF3TMWr7LylGZ0EDA==
X-Received: by 2002:a17:902:b610:: with SMTP id b16mr399162pls.70.1573320492622;
        Sat, 09 Nov 2019 09:28:12 -0800 (PST)
Received: from cakuba (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id i16sm9009121pfa.184.2019.11.09.09.28.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Nov 2019 09:28:12 -0800 (PST)
Date:   Sat, 9 Nov 2019 09:28:09 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Parav Pandit <parav@mellanox.com>,
        David M <david.m.ertman@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [PATCH net-next 00/19] Mellanox, mlx5 sub function support
Message-ID: <20191109092809.0af281c4@cakuba>
In-Reply-To: <20191109111809.GA9565@nanopsycho>
References: <20191107160448.20962-1-parav@mellanox.com>
        <20191107153234.0d735c1f@cakuba.netronome.com>
        <20191108121233.GJ6990@nanopsycho>
        <20191108144054.GC10956@ziepe.ca>
        <AM0PR05MB486658D1D2A4F3999ED95D45D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20191108111238.578f44f1@cakuba>
        <20191108201253.GE10956@ziepe.ca>
        <20191108134559.42fbceff@cakuba>
        <20191109004426.GB31761@ziepe.ca>
        <20191109084659.GB1289838@kroah.com>
        <20191109111809.GA9565@nanopsycho>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Sat, 9 Nov 2019 12:18:09 +0100, Jiri Pirko wrote:
> >Are these constant long email threads a way that people are just trying
> >to get me to do this work for them?  Because if it is, it's working...  
> 
> Maybe they are just confused, like I am :)

+1 :)
