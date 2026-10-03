Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F85C3921FA
	for <linux-rdma@vger.kernel.org>; Sat,  3 Oct 2026 20:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791061017; cv=none; b=ps3ZwFR2w+x6IcPeHzyapbm6gijbhfpFW9a8A+JtX6gsGD+dUWLpVFmO+O1kyRntHO7IYo5UQ3TLbQjk+cH55rlOjmXYFfuz86eCKnOfZ19DXXKtV14yEFXow3cc93oJV3AzzhQ7kOTBEG4Ph3duHes67+2/JC4TFafrtaS3EsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791061017; c=relaxed/simple;
	bh=cMRVqfOvzm+pWJUftca4KVt1MTAlK6Hehhdd2ke52aU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=WSzSI+GQHm9gYa7DS0Tz9CNj4SN8kM1T09sLrrgUBHT4sXdNu6CI9r9t3J8tG1iRsK5AElMyWzGflN+Fq4OBpw9zZB4LKrvqq0r3Dk1Lp2IiFPBJxZ+qHIVvONLtqcKvnpYwS4tF9xUimiUqyDjsRVsgHPXfxxv6k8IPHx7xOpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g7KB1s3y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g7KB1s3y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB2C41F0089B;
	Sat,  3 Oct 2026 20:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791061016;
	bh=35wQIWZ7CnMju6dHDpirB5kRjJDh92KhswKZMsMmR/4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=g7KB1s3yrn19+pr4v5L8N0F8MTE5xByHzGvH4URSJ6i7L+k37Zj5J5nKJzwThN4pG
	 pNse6lL8XDvGhlhNXaRDTZ7vJx92D1bJHl92rXC9CbbDIn2ZIhWVncvqIp11hb/mSV
	 o4ZvS2eQ8T8JSbEh58IJJtEqp56frWaBItHF0udYOsMezFCO5SrN3BW6FJRTEu9/iC
	 cgpWqVhjk6EczsghU56msJdfy/t9LcFcMhxhYNRdmtcmnoAcVRh/stN72uHPgNlzim
	 hJ1N2DDrAmSoCWbGjgHPmVjjDRyUhjlvt2s//GCk1TQ1Q2hyPH94wH1jxdb+KNV+TR
	 FfToiBJiizaPA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] net/mlx5: retain command mailboxes after timeout
Reply-To: sashiko-reviews@lists.linux.dev
To: "Manjunath Patil" <manjunath.b.patil@oracle.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261002205649.2029588-1-manjunath.b.patil@oracle.com>
References: <20261002205649.2029588-1-manjunath.b.patil@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 20:56:55 +0000
Message-Id: <20261003205655.CB2C41F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] mlx5: race condition causes uninitialized memory use on command ti=
meout
--

commit 9bc189299b20224d8c729888220a0891ddf01904
Author: Manjunath Patil <manjunath.b.patil@oracle.com>

net/mlx5: retain command mailboxes after timeout

This commit fixes a DMA pool reallocation issue by giving the command entry
ownership of the mailboxes on timeout and freeing them when the final
reference is dropped. It also serializes completion claims and firmware
reference handoffs under alloc_lock.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/=
ethernet/mellanox/mlx5/core/cmd.c
> index 84583dc5eb1c0..22508b26972de 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
[ ... ]
> @@ -1163,6 +1170,10 @@ static void wait_func_handle_exec_timeout(struct m=
lx5_core_dev *dev,
>  		       mlx5_command_str(ent->op), ent->op);
> =20
>  	ent->ret =3D -ETIMEDOUT;
> +	/* The real handler may have claimed the completion but still be using
> +	 * the mailboxes. Keep them with the entry until its last reference.
> +	 */
> +	set_bit(MLX5_CMD_ENT_STATE_RETAIN_MSGS, &ent->state);
>  	mlx5_cmd_comp_handler(dev, 1ULL << ent->idx, true);
>  }

[Severity: High]
Does setting the timeout error and retain flag without locks here race with
the real completion handler?=20

If a blocking command times out just as the hardware completes it, this can
set ent->ret =3D -ETIMEDOUT while the EQ handler in mlx5_cmd_comp_handler()
is simultaneously checking or updating it.

[ ... ]
> @@ -1744,38 +1816,33 @@ static void mlx5_cmd_comp_handler(struct mlx5_cor=
e_dev *dev, u64 vec, bool force
>  	struct mlx5_cmd_stats *stats;
>  	unsigned long flags;
>  	unsigned long vector;
> +	bool pending;
> +	bool drop_fw_ref;
> =20
>  	/* there can be at most 32 command queues */
>  	vector =3D vec & 0xffffffff;
>  	for (i =3D 0; i < (1 << cmd->vars.log_sz); i++) {
>  		if (test_bit(i, &vector)) {
>  			ent =3D cmd->ent_arr[i];
> -
> -			if (forced && ent->ret =3D=3D -ETIMEDOUT)
> -				set_bit(MLX5_CMD_ENT_STATE_TIMEDOUT,
> -					&ent->state);
> -			else if (!forced) /* real FW completion */
> -				clear_bit(MLX5_CMD_ENT_STATE_TIMEDOUT,
> -					  &ent->state);
> +			pending =3D mlx5_cmd_claim_completion(dev, ent, vec, forced,
> +							    &drop_fw_ref);

[Severity: High]
Can this overwrite the concurrently set -ETIMEDOUT with 0 on success?

If the timeout from wait_func_handle_exec_timeout() occurs concurrently with
this completion handler, the following code later in mlx5_cmd_comp_handler()
can overwrite the error:

    if (!ent->ret) {
        if (!cmd->checksum_disabled)
            ent->ret =3D verify_signature(ent);

If the timeout occurs between the if (!ent->ret) check and the
ent->ret =3D verify_signature(ent) assignment, it appears this would hide t=
he
timeout from the waiting thread.

[ ... ]
> @@ -2008,9 +2082,12 @@ static int cmd_exec(struct mlx5_core_dev *dev, voi=
d *in, int in_size, void *out,
>  	}
> =20
>  	err =3D mlx5_cmd_invoke(dev, inb, outb, out, out_size, callback, contex=
t,
> -			      pages_queue, token, force_polling);
> +			      pages_queue, token, force_polling, &retain_msgs);
>  	if (callback && !err)
>  		return 0;
> +	/* The entry releases retained DMA mailboxes with its final reference. =
*/
> +	if (retain_msgs)
> +		goto out_up;
> =20
>  	if (err > 0) /* Failed in FW, command didn't execute */
>  		err =3D deliv_status_to_err(err);

[Severity: High]
Does this cause uninitialized memory to be used if the race described above
occurs?

If retain_msgs is true but err was overwritten to 0 by the completion handl=
er,
this skips copying the output buffer and returns success (0).=20

Would this leave the caller with uninitialized memory in the output buffer,
potentially leading to data corruption or crashes when the caller assumes it
contains valid firmware responses?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261002205649.2029=
588-1-manjunath.b.patil@oracle.com?part=3D1
