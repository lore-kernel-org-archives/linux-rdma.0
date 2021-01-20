Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05F28C433E0
	for <linux-rdma@archiver.kernel.org>; Wed, 20 Jan 2021 03:29:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B479C207CF
	for <linux-rdma@archiver.kernel.org>; Wed, 20 Jan 2021 03:29:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728723AbhATD22 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 19 Jan 2021 22:28:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:41078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730611AbhATD2W (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 19 Jan 2021 22:28:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 228F3207CF;
        Wed, 20 Jan 2021 03:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611113261;
        bh=qwEcfH8ALpqHY4QLfXxIVBaWUbQ0T6hlJaiVM7mRZdU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VyN5nSoXEFapU3Jg30vfsvoVbFxqnjgMOSPghyhGOoJxvWb1QZwmYkiRY4qKK7EHL
         kgsnI89IxEpOR1vadSvmo54StSfs2IK9WhOQkNMGEHj7oPhVe1RezCxh4ogl3vIZi0
         n8cVI2LfrHpGToBy5JUupb8i6/uJIzez5MIWMqK3h09EXLMpfBYW0qp2zk7gKP3OlQ
         g+XcwK5PwrujswPdKhFLy55BCDzdSD7p5cw5/MdWvk4gd/GQswywHkvfJ+KHA9FxfH
         66Wh3Lkna+5CB6irWR2hEs91EvxE7fK9f+rcoyG2tQAQdHz7LzNzZ9pE4lJkKTddpM
         SNqluNAMET8gw==
Date:   Tue, 19 Jan 2021 19:27:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>, Parav Pandit <parav@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, Vu Pham <vuhuong@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [net-next V7 03/14] devlink: Support add and delete devlink
 port
Message-ID: <20210119192739.0b3d8cf4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210118201231.363126-4-saeed@kernel.org>
References: <20210118201231.363126-1-saeed@kernel.org>
        <20210118201231.363126-4-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Mon, 18 Jan 2021 12:12:20 -0800 Saeed Mahameed wrote:
> From: Parav Pandit <parav@nvidia.com>

Saeed, this is closed to being merged - when you post the next version
please make sure to CC appropriate folks, in particular anyone who ever
commented on previous versions. Alex, DSA, Edwin, at a quick look but
maybe more.

> @@ -1362,6 +1373,33 @@ struct devlink_ops {
>  	int (*port_function_hw_addr_set)(struct devlink *devlink, struct devlink_port *port,
>  					 const u8 *hw_addr, int hw_addr_len,
>  					 struct netlink_ext_ack *extack);
> +	/**
> +	 * @port_new: Port add function.
> +	 *
> +	 * Should be used by device driver to let caller add new port of a
> +	 * specified flavour with optional attributes.

I think you missed my suggestion from v5, please replace this sentence
with:

	Add a new port of a specified flavor with optional attributes.

Saying that the callback is used by the callee doesn't sound right.

Same below, and also in patch 4.

> +	 * Driver must return -EOPNOTSUPP if it doesn't support port addition
> +	 * of a specified flavour or specified attributes. Driver should set
> +	 * extack error message in case of failure. Driver callback is called
> +	 * without holding the devlink instance lock. Driver must ensure
> +	 * synchronization when adding or deleting a port. Driver must register
> +	 * a port with devlink core.
> +	 */
> +	int (*port_new)(struct devlink *devlink,
> +			const struct devlink_port_new_attrs *attrs,
> +			struct netlink_ext_ack *extack,
> +			unsigned int *new_port_index);
> +	/**
> +	 * @port_del: Port delete function.
> +	 *
> +	 * Should be used by device driver to let caller delete port which was
> +	 * previously created using port_new() callback.

ditto

> +	 * Driver must return -EOPNOTSUPP if it doesn't support port deletion.
> +	 * Driver should set extack error message in case of failure. Driver
> +	 * callback is called without holding the devlink instance lock.
> +	 */
> +	int (*port_del)(struct devlink *devlink, unsigned int port_index,
> +			struct netlink_ext_ack *extack);
>  };
