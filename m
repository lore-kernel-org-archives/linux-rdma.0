Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 969A13C1D6A;
	Thu, 10 Sep 2026 23:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789084713; cv=none; b=bYlNodllgvzajUfycBPrdDHlesf+0SgkrqFv1xmdJY5y05XaASGc3TZA/ajkGRaAqVfJuVw5XmusawIDptUqLB+Z9EyoK0IYFvvzQ6uq0DaEofi2Ft8f5Me1bT1HLhqyPxMvgu1H3bJJO5Rh6dVkdvpLu+1xgUkAZNQrlzNjoJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789084713; c=relaxed/simple;
	bh=k58j7NDBInxNfkxhWKNGopHqLULZW73Agq8zH8RdG5I=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=cPI9V+cygC4PhLQ7WDatk2aZeVCpprW/kZukdMmGUVW4LRmuF8T7pWK3Vc3RWqET9dzNQvymlGHyv80nc5GjOyitycTrususDqRcisZE4lrfUc3E8iMvsf33z3WJ8L/ozKhXE7qyT9GA6/GsX0stPt/wdCXlTuFyqweI5VkOGhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GnEu00ya; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GnEu00ya"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B4E51F000FF;
	Thu, 10 Sep 2026 23:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789084712;
	bh=2HelFvPhBG/psKpt7JxccKdcmK+6ty71SYArvIEwCPg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GnEu00yaeUyfHxdlyleCOx97bC4rCcZZ1Mu8uohDHE7ypdJPUPbU2pwtp0LSIJm85
	 XdcthwKYGyDpKh9TzQiaUYBKItzHI0cMFkssh9EBonT50vl3v5QCMU4gpqPqnJL42s
	 6W4aR6NZNorT104H4FEUyXnDOpA4ITm6M31RfM99ActOoStHLGpUKfg+4T7RzpD6fG
	 JcfdfzNGDizidg2zMf3C5Hq7XsMkWWPh1RTV8Rsos5nuq5Mw49833VVmBZRqLOkyvD
	 9WicVtlTNrfKrtI2b/KBNwMCX37Rc8rA3GCclCQGcqjGax6cvH7GAz2DL/TIhpKPTr
	 j2he1azAumOEw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 08/10] vfio: selftests: Add mlx5 driver - HW init and
 command interface
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jason Gunthorpe" <jgg@nvidia.com>
Cc: linux-rdma@vger.kernel.org, kvm@vger.kernel.org
In-Reply-To: <8-v5-4cacb99249f6+1b4-mlx5st_jgg@nvidia.com>
References: <8-v5-4cacb99249f6+1b4-mlx5st_jgg@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 10 Sep 2026 23:58:31 +0000
Message-Id: <20260910235832.4B4E51F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:
- [High] Heap buffer overflow due to unvalidated `output_num_entries` from =
device firmware.
- [High] Missing ownership poll in `mlx5st_pages_slot_complete` can lead to=
 reading stale command output data.
- [Medium] Incorrect capability type encoding in QUERY_HCA_CAP causes the d=
river to query the wrong capabilities.
- [Medium] Left shift of a signed integer by 31 bits in `mlx5st_pages_slot_=
post` invokes undefined behavior.
- [Medium] Missing accounting for partially fulfilled async MANAGE_PAGES re=
claim requests
--

commit c45174d111898b9c629ff1e5161b87d70fe0fb38
Author: Jason Gunthorpe <jgg@ziepe.ca>
Date:   Wed Sep 9 23:57:34 2026 +0000

    vfio: selftests: Add mlx5 driver - HW init and command interface
   =20
    This commit adds an mlx5 selftest driver to program ConnectX devices
    through the bare-metal command interface. It sets up initialization pat=
hs
    including EQ creation, mailbox commands, and physical page allocation f=
or
    the hardware.

> diff --git a/tools/testing/selftests/vfio/lib/drivers/mlx5/mlx5.c b/tools=
/testing/selftests/vfio/lib/drivers/mlx5/mlx5.c
> new file mode 100644
> index 0000000000000..804801cc564e7
> --- /dev/null
> +++ b/tools/testing/selftests/vfio/lib/drivers/mlx5/mlx5.c
> @@ -0,0 +1,1414 @@
> [ ... ]
> +static void mlx5st_pages_slot_post(struct mlx5st_device *dev, void *in,
> +				    unsigned int ilen, unsigned int olen)
> +{
> +	mlx5st_cmd_post(dev, dev->pages_cmd_lay, dev->pages_in_mbox,
> +			dev->pages_out_mbox, in, ilen, olen,
> +			1 << dev->pages_slot);
> +}

[Severity: Medium]
Since dev->pages_slot can safely be 31 if the hardware exposes a command
queue size of 32, does shifting the signed integer literal 1 by 31 bits
invoke undefined behavior here? Should this be 1U << dev->pages_slot?

> [ ... ]
> +static void mlx5st_pages_slot_kick(struct mlx5st_device *dev)
> +{
> [ ... ]
> +	} else if (dev->pages_pending_reclaim) {
> +		batch =3D dev->pages_pending_reclaim < MAX_FW_PAGES_PER_CMD ?
> +				dev->pages_pending_reclaim :
> +				MAX_FW_PAGES_PER_CMD;
> +		dev->pages_pending_reclaim -=3D batch;
> +		mlx5st_pages_slot_reclaim(dev, dev->pages_pending_func_id,
> +					  batch);
> +	}
> +}
> [ ... ]
> +static void mlx5st_pages_slot_complete(struct mlx5st_device *dev)
> +{
> +	struct mlx5st_cmd_queue_entry *cmd =3D dev->pages_cmd_lay;
> +	void *cout;
> +
> +	dma_rmb();
> +
> +	cout =3D MLX5_ADDR_OF(cmd_queue_entry, cmd, command_output_inline_data);

[Severity: High]
Is there a missing ownership poll loop for the command queue entry before
consuming its output?

When mlx5st_process_events() receives an EQE for the async pages slot, it
directly calls mlx5st_pages_slot_complete(). Because of PCIe relaxed orderi=
ng,
the EQE completion DMA can become visible to the CPU before the command que=
ue
output DMA is fully written to memory and the ownership bit is cleared. Can
the driver read stale command output data if it does not poll the ownership
bit?

> +	if (MLX5_GET(enable_hca_out, cout, status) !=3D MLX5_CMD_STAT_OK)
> [ ... ]
> +	if (dev->pages_slot_is_reclaim) {
> +		unsigned int outlen =3D MLX5_ST_SZ_BYTES(manage_pages_out) +
> +				      dev->pages_reclaim_npages * 8;
> [ ... ]
> +		num_claimed =3D
> +			MLX5_GET(manage_pages_out, out, output_num_entries);
> +		for (i =3D 0; i < num_claimed; i++)
> +			iovas[i] =3D MLX5_ARRAY_GET64(manage_pages_out, out, pas,
> +						    i);

[Severity: High]
Does this code write past the bounds of the iovas array if the device
firmware returns a num_claimed value larger than the requested size?

The iovas array is allocated based on the requested batch size. Without
validating the hardware-supplied output_num_entries against the array bound=
s,
a misbehaving device might overflow this heap buffer.

[Severity: Medium]
If the hardware returns fewer pages than requested (num_claimed < batch),
are the shortfall pages permanently leaked?

In mlx5st_pages_slot_kick(), dev->pages_pending_reclaim is immediately
reduced by the requested batch size before the command is sent. It looks li=
ke
the remaining unreturned pages are neither freed nor added back to the
pending reclaim count here, meaning they will never be re-requested.

> +
> +		mlx5st_fw_pages_free(dev, num_claimed, iovas);
> [ ... ]
> +static void mlx5st_fw_pages_reclaim(struct mlx5st_device *dev, u16 func_=
id)
> +{
> [ ... ]
> +		mlx5st_cmd_exec(dev, in, inlen, out, outlen);
> +
> +		num_claimed =3D
> +			MLX5_GET(manage_pages_out, out, output_num_entries);
> +		for (i =3D 0; i < num_claimed; i++)
> +			iovas[i] =3D MLX5_ARRAY_GET64(manage_pages_out, out, pas,
> +						    i);

[Severity: High]
Is there a similar heap buffer overflow risk here?

If the firmware provides an output_num_entries larger than the batch size
the iovas array was allocated for, this loop will write past the bounds
of the heap allocation.

> [ ... ]
> +static void mlx5st_query_fl_caps(struct mlx5st_device *dev)
> +{
> +	u32 out[MLX5_ST_SZ_DW(query_hca_cap_out)] =3D {};
> +	u32 in[MLX5_ST_SZ_DW(query_hca_cap_in)] =3D {};
> +	bool fl_roce_en, fl_roce_dis;
> +
> +	/* Query RoCE capabilities */
> +	MLX5_SET(query_hca_cap_in, in, opcode, MLX5_CMD_OP_QUERY_HCA_CAP);
> +	MLX5_SET(query_hca_cap_in, in, op_mod,
> +		 MLX5_SET_HCA_CAP_OP_MOD_ROCE | HCA_CAP_OPMOD_GET_CUR);

[Severity: Medium]
Does the MLX5_SET_HCA_CAP_OP_MOD_ROCE constant need to be shifted left by 1?

If the constant is defined as 0x4, passing it unshifted results in an op_mod
of 5. This causes the hardware to interpret bits 15:1 as capability type 2
(MLX5_CAP_ODP) instead of RoCE, causing the driver to query the wrong
capabilities.

> +
> +	mlx5st_cmd_exec(dev, in, sizeof(in), out, sizeof(out));

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/0-v5-4cacb99249f6+1=
b4-mlx5st_jgg@nvidia.com?part=3D8
