Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BC2D2D979F;
	Tue, 27 Jan 2026 13:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769521798; cv=none; b=eupEqadJaX/YttSmsMXOdWVZrRWVmccThcavkNycjUqyWVFCdrbJx0cbJdfOhpLNori46pqhhuLv6xIo1QXNSTw8l+XWSF6tCXoTxiBLb6Q6WksGfWnoCo9pMgc0iLy5o5xlMKBbpMhgy0bfJxtylyChllU6VWzvaTjQB4q4CPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769521798; c=relaxed/simple;
	bh=xJU6Yuhq5fJsCgB2olMgIDeTq7BGYRCyFgfx+0nnVog=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n/zu9L6VDpqS73QaxTIFbFECmI9lHobZgok4wegqZGHRgRub+8mGh4woLHYUCLrBZtvHzSzhLYTmgVf8HTWO7kSdFULgQ199tVEX/JWWKgSqSDVOBvkjX0K6h3t1wwPzuy1BNVRTpIv91UMS6G3wNwFz04YZZs49TYTDF8s3YXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d1ngN13m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d1ngN13m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85131C116C6;
	Tue, 27 Jan 2026 13:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769521797;
	bh=xJU6Yuhq5fJsCgB2olMgIDeTq7BGYRCyFgfx+0nnVog=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d1ngN13m7IgYqLmjsuowA02OOYZy8cHLn1RTksWhhAMFWrvDA+LGB+6ow9o9sl4MK
	 LCkjI2qoQOX04TJ7DpYdAE+Fd+E3qbFgj8/I2PD9TgdbcAZjDTbZ7EJNIFQwrOVzsE
	 53IAUNkNQxaLkdTq5n5PCji4nDUen0ewG/JMZqaq1dBnR3Js4jib3Il5AS09xiS8Uz
	 XKRsqEf8Vd1B7KDdeF4oe//mZ3D56UePRhJkFXwk61n/S2IXfi4AVpBu9HW+tigH5i
	 N5KrzCKJIXUc2WJRkTGmOcnA4njPJDdYJExYjr7pBxjtJs6MMaQ1iYUTlIHHYT67X8
	 6JwI2v/f7oA2w==
Date: Tue, 27 Jan 2026 13:49:51 +0000
From: Simon Horman <horms@kernel.org>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Donald Hunter <donald.hunter@gmail.com>,
	Jiri Pirko <jiri@resnulli.us>, Jonathan Corbet <corbet@lwn.net>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>, Mark Bloch <mbloch@nvidia.com>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-rdma@vger.kernel.org,
	Gal Pressman <gal@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>,
	Carolina Jubran <cjubran@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH net-next V6 07/14] devlink: Add parent dev to devlink API
Message-ID: <aXjCf2iRC5VsRC5A@horms.kernel.org>
References: <1769340723-14199-1-git-send-email-tariqt@nvidia.com>
 <1769340723-14199-8-git-send-email-tariqt@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1769340723-14199-8-git-send-email-tariqt@nvidia.com>

On Sun, Jan 25, 2026 at 01:31:56PM +0200, Tariq Toukan wrote:
> From: Cosmin Ratiu <cratiu@nvidia.com>
> 
> Upcoming changes to the rate commands need the parent devlink specified.
> This change adds a nested 'parent-dev' attribute to the API and helpers
> to obtain and put a reference to the parent devlink instance in
> info->user_ptr[1].
> 
> To avoid deadlocks, the parent devlink is unlocked before obtaining the
> main devlink instance that is the target of the request.
> A reference to the parent is kept until the end of the request to avoid
> it suddenly disappearing.
> 
> This means that this reference is of limited use without additional
> protection.
> 
> Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
> Reviewed-by: Carolina Jubran <cjubran@nvidia.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

...

Hi Cosmin, all,

The netlink_gen.[ch] and spec changes in this patch do not seem consistent.

$ tools/net/ynl/ynl-regen.sh -f
$ git diff
diff --git a/net/devlink/netlink_gen.c b/net/devlink/netlink_gen.c
index 6b691bdbf037..f4c61c2b4f22 100644
--- a/net/devlink/netlink_gen.c
+++ b/net/devlink/netlink_gen.c
@@ -39,11 +39,6 @@ devlink_attr_param_type_validate(const struct nlattr *attr,
 }

 /* Common nested types */
-const struct nla_policy devlink_dl_parent_dev_nl_policy[DEVLINK_ATTR_DEV_NAME + 1] = {
-       [DEVLINK_ATTR_BUS_NAME] = { .type = NLA_NUL_STRING, },
-       [DEVLINK_ATTR_DEV_NAME] = { .type = NLA_NUL_STRING, },
-};
-
 const struct nla_policy devlink_dl_port_function_nl_policy[DEVLINK_PORT_FN_ATTR_CAPS + 1] = {
        [DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR] = { .type = NLA_BINARY, },
        [DEVLINK_PORT_FN_ATTR_STATE] = NLA_POLICY_MAX(NLA_U8, 1),
diff --git a/net/devlink/netlink_gen.h b/net/devlink/netlink_gen.h
index d4db82a00522..2817d53a0eba 100644
--- a/net/devlink/netlink_gen.h
+++ b/net/devlink/netlink_gen.h
@@ -13,7 +13,6 @@
 #include <uapi/linux/devlink.h>

 /* Common nested types */
-extern const struct nla_policy devlink_dl_parent_dev_nl_policy[DEVLINK_ATTR_DEV_NAME + 1];
 extern const struct nla_policy devlink_dl_port_function_nl_policy[DEVLINK_PORT_FN_ATTR_CAPS + 1];
 extern const struct nla_policy devlink_dl_rate_tc_bws_nl_policy[DEVLINK_RATE_TC_ATTR_BW + 1];
 extern const struct nla_policy devlink_dl_selftest_id_nl_policy[DEVLINK_ATTR_SELFTEST_ID_FLASH + 1];
@@ -30,19 +29,12 @@ int devlink_nl_pre_doit_dev_lock(const struct genl_split_ops *ops,
 int devlink_nl_pre_doit_port_optional(const struct genl_split_ops *ops,
                                      struct sk_buff *skb,
                                      struct genl_info *info);
-int devlink_nl_pre_doit_parent_dev_optional(const struct genl_split_ops *ops,
-                                           struct sk_buff *skb,
-                                           struct genl_info *info);
 void
 devlink_nl_post_doit(const struct genl_split_ops *ops, struct sk_buff *skb,
                     struct genl_info *info);
 void
 devlink_nl_post_doit_dev_lock(const struct genl_split_ops *ops,
                              struct sk_buff *skb, struct genl_info *info);
-void
-devlink_nl_post_doit_parent_dev_optional(const struct genl_split_ops *ops,
-                                        struct sk_buff *skb,
-                                        struct genl_info *info);

 int devlink_nl_get_doit(struct sk_buff *skb, struct genl_info *info);
 int devlink_nl_get_dumpit(struct sk_buff *skb, struct netlink_callback *cb);
;
