Return-Path: <SRS0=fADM=YW=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1A65CA9EC2
	for <linux-rdma@archiver.kernel.org>; Tue, 29 Oct 2019 06:51:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C205B20663
	for <linux-rdma@archiver.kernel.org>; Tue, 29 Oct 2019 06:51:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CL6G3Dj7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbfJ2GvS (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 29 Oct 2019 02:51:18 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20574 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728151AbfJ2GvR (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 29 Oct 2019 02:51:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572331877;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AidnK+uvjnCKI1z5Vgx3iKDp/jnVEf9xSY9VUc4dCQY=;
        b=CL6G3Dj7BuIIuK5lxmeUuNZyxy2Lc6JSEvu150yVGFBO55U6b2nht8mncI2QdA991JQ1Vt
        JkcAXbUF7knqrWZmBePypdbqF6yXvwCHtVFHk5y5M1IVAh/gOjCx7U1uxDlVqF1Ufo7TI1
        AsWDSLWXewe1EBruwBwB8TjcIAw7Axs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-429-es_1DkE0Na6wqdlbPowblA-1; Tue, 29 Oct 2019 02:51:10 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 14DEA800C80;
        Tue, 29 Oct 2019 06:51:10 +0000 (UTC)
Received: from localhost (unknown [10.66.128.227])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 81D2560BF1;
        Tue, 29 Oct 2019 06:51:09 +0000 (UTC)
Date:   Tue, 29 Oct 2019 14:51:07 +0800
From:   Honggang LI <honli@redhat.com>
To:     bvanassche@acm.org, dledford@redhat.com, jgg@ziepe.ca
Cc:     linux-rdma@vger.kernel.org
Subject: Re: [rdma-core patch v2] srp_daemon: Use maximum initiator to target
 IU size
Message-ID: <20191029065107.GB22221@dhcp-128-227.nay.redhat.com>
References: <20191025132343.14086-1-honli@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20191025132343.14086-1-honli@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: es_1DkE0Na6wqdlbPowblA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Drop this patch as depended kernel patch has been rejected.
I rewrite this patch and file a pull request on github for v3.

https://github.com/linux-rdma/rdma-core/pull/598

Thanks

