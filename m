Return-Path: <SRS0=kv28=YD=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACA65C4360C
	for <linux-rdma@archiver.kernel.org>; Thu, 10 Oct 2019 06:51:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7DC752190F
	for <linux-rdma@archiver.kernel.org>; Thu, 10 Oct 2019 06:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1570690271;
	bh=cpHGWJw053LHTk3J91iR2pmi5DUo5CDVevWtCP6butI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=i47FW0LONvklWUqnXquwuxejs5kBOpFXho9SSGXUsxJeDOsabw0SXvr6yMmDW5JDU
	 eeJhOD76Bc9ySQsk5NSZe98fYq3mxbSvDK8YOU0hRumb2xqUnlFP8JRkd0D6s/uypy
	 rWKl9h5ci7jjSadYSXJ1lTqzueBHfggTupRtEl2s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727207AbfJJGvK (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 10 Oct 2019 02:51:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:49230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727116AbfJJGvK (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 10 Oct 2019 02:51:10 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B817218AC;
        Thu, 10 Oct 2019 06:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570690270;
        bh=cpHGWJw053LHTk3J91iR2pmi5DUo5CDVevWtCP6butI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=D2v7F3fFd98Ve5XnU9TcMMPThwwvmPdmox1efJj5g6fhbA9+easu7A76SOzvrDM0H
         RAqrgAJ44iKDh/0M/OVqzSThCaiSe54u1Fs9Ote6KXkt9R1E7w4QEGTs1Ne+qzvmgh
         L/FQAqmx7QVVehpunBPQdoCVUTqZet8gCcNwDPY0=
Date:   Thu, 10 Oct 2019 09:51:07 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Yizhuo Zhai <yzhai003@ucr.edu>
Cc:     Moni Shoua <monis@mellanox.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zhiyun Qian <zhiyunq@cs.ucr.edu>,
        Chengyu Song <csong@cs.ucr.edu>
Subject: Re: Potential NULL pointer deference in RDMA
Message-ID: <20191010065107.GI5855@unreal>
References: <CABvMjLTZ3ztSR6XkHa94iLTnHDK3-P3wRo+31UdivSMavzeq4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABvMjLTZ3ztSR6XkHa94iLTnHDK3-P3wRo+31UdivSMavzeq4g@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Wed, Oct 09, 2019 at 09:44:58PM -0700, Yizhuo Zhai wrote:
> Hi All:
> drivers/infiniband/sw/rxe/rxe_verbs.c:
> The function to_rdev() could return NULL, but no caller in this file
> checks the return value but directly dereference them, which seems
> potentially unsafe. Callers include rxe_query_device(),
> rxe_query_port(), rxe_query_pkey(), etc.


All NULL returns in to_r*() function are useless and can be removed.

Thanks
>
>
> --
> Kind Regards,
>
> Yizhuo Zhai
>
> Computer Science, Graduate Student
> University of California, Riverside
