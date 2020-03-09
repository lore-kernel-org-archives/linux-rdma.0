Return-Path: <SRS0=IbQ/=42=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0792DC10F27
	for <linux-rdma@archiver.kernel.org>; Mon,  9 Mar 2020 15:13:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4471208C3
	for <linux-rdma@archiver.kernel.org>; Mon,  9 Mar 2020 15:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583766787;
	bh=/BaCMZJgnBix3u0Dng/VA0QEIEWGl0OhXuSq3/xgDm8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=j6viDIj4ydEqIwiigXwykUcZXZr7HgqNu5u136Ex6ALSElRWivk0z7SFYmoPZOh+i
	 km3o9Cx7O76Yg/vV07QvUXJEsOsAc2+AGDch4kWSWc0naIqFhkTSAo453EyrkSF+qE
	 HmL1Qw1NhKwR3APBhxX1iLvKF6fwga0lbzZwM748=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgCIPNH (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 9 Mar 2020 11:13:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:52668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726810AbgCIPNH (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 9 Mar 2020 11:13:07 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E692720873;
        Mon,  9 Mar 2020 15:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583766786;
        bh=/BaCMZJgnBix3u0Dng/VA0QEIEWGl0OhXuSq3/xgDm8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ox9jC0scpWN25jW2Rfn9lgqyswOk99NqXon1gU4iOm/PJSgn6leeJ7r1RKJqP06SK
         w3Q5IvZTcaVgT+qwmvFNMHH++GK/uclToluzKdVTvaffP4HIezr9Yz9SfP57CYbuzL
         hdO9KX0obJM0x8JdO5z1INw2DKJrpG0aHwT0THKI=
Date:   Mon, 9 Mar 2020 17:13:01 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Weihang Li <liweihang@huawei.com>
Cc:     dledford@redhat.com, jgg@ziepe.ca, linux-rdma@vger.kernel.org,
        linuxarm@huawei.com
Subject: Re: [PATCH v2 for-next 5/5] RDMA/hns: Optimize wqe buffer set flow
 for post send
Message-ID: <20200309151301.GD172334@unreal>
References: <1583462694-43908-1-git-send-email-liweihang@huawei.com>
 <1583462694-43908-6-git-send-email-liweihang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1583462694-43908-6-git-send-email-liweihang@huawei.com>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Fri, Mar 06, 2020 at 10:44:54AM +0800, Weihang Li wrote:
> From: Xi Wang <wangxi11@huawei.com>
>
> Splits hns_roce_v2_post_send() into three sub-functions: set_rc_wqe(),
> set_ud_wqe() and update_sq_db() to simplify the code.
>
> Signed-off-by: Xi Wang <wangxi11@huawei.com>
> Signed-off-by: Weihang Li <liweihang@huawei.com>
> ---
>  drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 472 ++++++++++++++---------------
>  1 file changed, 224 insertions(+), 248 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
