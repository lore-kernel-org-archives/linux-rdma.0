Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795560471;
	b=OruRFVXnqtJlnwU0mDYm7wMHMhI5TETK2Ehntkn1vriJN0Af4NoEtFKHzSXC32idwRbF
	 b9fkcY43aD9P8jj5+wI+52hFTLBUU2shCfcT/Icdi5LBVw81W8OdeuTnmlS19VIBx/TQ4
	 gCNovHVpk0u1oF9kHm7urCOT2M0vUOTDJ+5rb3RrU92UrlqUR0ZTXf+m0d7cFK0D9o0BX
	 2MFq/G0uobzlQTZoo4wsSIhARjkMD7d1J++7dQyw5fa1rA1Xxu4mODq2qV+SWy5i7BMqe
	 FGkYlC6K1+GCL4kABMKYw/TvWydSq97LcfV6n4wZ6I+W5TteoosCYsIJAe24LRSYaSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795560471;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=0R1qd0ZsGZVW1mj41hnJZL6GPjctmE+pDYfhYYzhDAg=;
	b=PDZp9VGgLX7aU9UdOWNTnyBisocrHAuKU3DjvXFV8jp191DphoZZeTadUCRcrK46FkcR
	 w4JVQghhMi6ljR09g5wRIfXooYJYb28Gow7iUwQbK0LZ54f2f6fDsMspgOnAPlRA03v7I
	 rqV8IGnYsQ+wO0FnLZh3SMEOrG8Ov/S/8MDIsQUSBYwRvVFcKtbUbqrZ5a5JjP1tt7RjE
	 nlxdXiBnJf9l/sB7PGLdXS7WJXnio1ZuP1DyHc1d8dfYT/XU+OYV70QV1lY/MM12x9U1j
	 PzaQEKmIAsBangIPgi6RMDB6tZya3I05F9WFvJficL8674HXpDpTmhP4v+Rwdy4OxDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NJ8pZ6EC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731DB606A31E;
	Tue, 24 Nov 2026 22:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NJ8pZ6EC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 470F01F000C6;
	Tue, 24 Nov 2026 22:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795560471;
	bh=0R1qd0ZsGZVW1mj41hnJZL6GPjctmE+pDYfhYYzhDAg=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=NJ8pZ6EC9yA6FRSGxZpPrg9xYa0CZA3wlj4Q1S5oCejZ5AfDJ+CTr9lIr26yq4V+v
	 WuKi8qT3aisUBL5wIIGNiN3UcMAtUO2H3ISmywkAl/xlBWU636Lq8auPolmN1zjt+h
	 U4Tpjs51k9zo3nTKtqV4NzoSltqnxSpzuEX8evEJFj+XWFcEZffcizl2DKg3ddaRm8
	 ndhQrqftOcO4KiYYWn0b6bfN4ZBSUX7wsWDC+kcJU9TLOykFnCFCiXUKLc2RoAIHVV
	 sHf+52SoDO3xggbocnDKMNd6ssxfy5sTfTowj+XwNkZxZIcrTiba2vemmsVllkKYBp
	 QTvxkI0RM2L+g==
Subject:
 Re: [PATCH net] net/mlx5: HWS, fix action STE double free on rule update
From: netdev-bot+sashiko@kernel.org
To: acassen@corp.free.fr
Cc: saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, moshe@nvidia.com,
 kliteyn@nvidia.com, vdogaru@nvidia.com, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org
Date: Tue, 24 Nov 2026 22:47:49 +0000
Message-ID: <179556046979.3135.2314506196260150359@kernel.org>
In-Reply-To: <20261123221310.4045513-1-acassen@corp.free.fr>
References: <20261123221310.4045513-1-acassen@corp.free.fr>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The patch leaves a second double free of action STEs on rule
  update in place.
- [Medium] This patch adds a new leak of the old action STE chunk when an
  update partially fails and the new actions need no action STEs…

--

net/mlx5: HWS, fix action STE double free on rule update

This patch clears rule->action_ste.action_tbl in hws_rule_create_init()
once the current chunk is saved into rule->old_action_ste during an
update. If the new actions need no action STEs, a later update or delete
no longer frees the same action STE chunk again.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/rule.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/rule.c
> index 0d4cb2b2393b9..cc94d3149d76a 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/rule.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/rule.c
> @@ -243,6 +243,8 @@ static void hws_rule_create_init(struct mlx5hws_rule *rule,
>  		 * new action STEs and a corresponding match STE.
>  		 */
>  		rule->old_action_ste = rule->action_ste;
> +		/* The rule may need no action STEs once updated */
> +		rule->action_ste.action_tbl = NULL;
>  	}

[Severity: High]

The subject says this fixes the action STE double free on rule update.
Can the old_action_ste slot still be freed twice, though?

When an update succeeds, hws_send_engine_update_rule() in send.c frees
the old chunk:

	} else if (priv->rule->status == MLX5HWS_RULE_STATUS_UPDATED) {
		/* Rule was updated, free the old action STEs */
		mlx5hws_rule_free_action_ste(&priv->rule->old_action_ste);

Neither mlx5hws_rule_free_action_ste() nor mlx5hws_action_ste_chunk_free()
clears old_action_ste.action_tbl after that. So the only guard in the
helper still passes on a later call:

	if (!action_ste->action_tbl)
		return;

One CQE with an opcode other than MLX5_CQE_REQ makes
hws_send_engine_poll_cq() set queue->err, and nothing clears it. After
that, every destroy on the queue goes through
hws_rule_destroy_hws()->hws_rule_destroy_failed_hws(), which does:

	/* Perhaps the rule failed updating - release old action STEs as well */
	mlx5hws_rule_free_action_ste(&rule->old_action_ste);

Any rule that was updated successfully before gets its old chunk freed a
second time here. The reproducer's flower rules, which lose and regain
their police action, are such rules. Eswitch teardown is one way to
reach this destroy path.

The cleanup work (hws_action_ste_pool_cleanup()->
hws_action_ste_table_destroy()) may kfree() the now empty table between
the two frees. In that case, mlx5hws_action_ste_chunk_free() would read
chunk->action_tbl->parent_elem->parent_pool->lock from freed memory.

The commit message calls this path "Not addressed here and not
triggered".

Would clearing action_ste->action_tbl inside
mlx5hws_rule_free_action_ste() after the free make every free site safe
to repeat? Combined with this change, that would cover this path as
well as the one fixed here.

[Severity: Medium]

Does this hunk now leak the old chunk when an update to actions with no
action STEs partially fails?

After this hunk, old_action_ste is the only reference to the old chunk.

Take an FDB rule with both RX and TX RTCs. One WQE may complete with an
error status without setting queue->err. Then
hws_send_engine_update_rule() zeroes only that RTC's used_id. The status
stays FAILING and does not become FAILED:

	if (!priv->rule->rtc_0 && !priv->rule->rtc_1)
		priv->rule->status = MLX5HWS_RULE_STATUS_FAILED;

hws_rule_destroy_hws() then takes either the skip_delete branch or the
normal DEACTIVATE path. Both free only rule->action_ste. The skip_delete
branch does:

	mlx5hws_rule_free_action_ste(&rule->action_ste);

and the DELETED completion in hws_send_engine_update_rule() does:

	mlx5hws_rule_free_action_ste(&priv->rule->action_ste);

action_ste.action_tbl is now NULL, so neither call frees anything. The
chunk held in old_action_ste is never released, so the pool is still
non-empty at teardown. Before this patch, the chunk was still in
action_ste, and delete freed it once.

The commit message notes "A failed update can leak it now also when it
needs no action STEs".

Would either of these avoid the leak?

  - free old_action_ste in the DELETED completion and in the
    skip_delete branch
  - restore action_ste from old_action_ste on partial failure

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261123221310.4045513-1-acassen%40corp.free.fr
