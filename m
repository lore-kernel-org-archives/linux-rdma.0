Return-Path: <SRS0=VPdv=2M=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2172CC2D0C0
	for <linux-rdma@archiver.kernel.org>; Sun, 22 Dec 2019 07:36:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E7BEC20733
	for <linux-rdma@archiver.kernel.org>; Sun, 22 Dec 2019 07:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577000194;
	bh=0WC+1oTzlfAyupoSI+DSrw5JYMGvrvIFyNFAfcLWXOU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=TJV6gXATFUW9vBd3PzxfZvi1togooBdlmXKw6vgmiWZ7I7qJggAMj891svpbYBIoC
	 YURPHE3zGRlZbB7mVsR0wpHr1X1DVjjsXeGzhc73QZVnaHu1Un3GsLbMZc+UZPYVGh
	 7tdKZBwbTOL80eEJfNB920ORuyBNss7dfcxecAGk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725840AbfLVHgd (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 22 Dec 2019 02:36:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:52934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725829AbfLVHgd (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sun, 22 Dec 2019 02:36:33 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 056A720665;
        Sun, 22 Dec 2019 07:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577000192;
        bh=0WC+1oTzlfAyupoSI+DSrw5JYMGvrvIFyNFAfcLWXOU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xipZG6De7qFFjB3eR17uSzDTlzuTptcago3K2kin/k1EeGL5KuIQzCLHYYkzkb3C6
         1i0cnEXRZZbv9csoCy1YKeIOyVH/SEw7lkb6MqcwZEa2WkhaSBrog3tWEVSdhznMXr
         yx90r/pV1eUSHLYSDRjnfWSQJb3FxC0Dm7+xDpM0=
Date:   Sun, 22 Dec 2019 09:36:29 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Danil Kipnis <danil.kipnis@cloud.ionos.com>
Cc:     Jack Wang <jinpuwang@gmail.com>, linux-block@vger.kernel.org,
        linux-rdma@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Bart Van Assche <bvanassche@acm.org>,
        Doug Ledford <dledford@redhat.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>, rpenyaev@suse.de
Subject: Re: [PATCH v5 02/25] rtrs: public interface header to establish RDMA
 connections
Message-ID: <20191222073629.GE13335@unreal>
References: <20191220155109.8959-1-jinpuwang@gmail.com>
 <20191220155109.8959-3-jinpuwang@gmail.com>
 <20191221101530.GC13335@unreal>
 <CAHg0HuxC9b+E9CRKuw4qDeEfz7=rwUceG+fFGfNHK5=H2aQMGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHg0HuxC9b+E9CRKuw4qDeEfz7=rwUceG+fFGfNHK5=H2aQMGw@mail.gmail.com>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Sat, Dec 21, 2019 at 03:27:55PM +0100, Danil Kipnis wrote:
> Hi Leon,
>
> On Sat, Dec 21, 2019 at 11:15 AM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > Perhaps it is normal practice to write half a company as authors,
> > and I'm wrong in the following, but code authorship is determined by
> > multiple tags in the commit messages.
>
> Different developers contributed to the driver over the last several
> years. Currently they are not working any more on this code. What tags
> in the commit message do you think would be appropriate to give those
> people credit for their work?

Signed-of-by/Co-developed-../e.t.c

But honestly without looking in your company contract, I'm pretty sure
that those people are not eligible for special authorship rights and
credits beyond already payed by the employer.

Thanks

>
> Best,
> Danil
