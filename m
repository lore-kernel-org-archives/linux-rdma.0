Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794083103;
	b=dVLAdJbNAMYDEcIsaFDIzeA16qIGNzfbtP5S0RrQpwAb34MFZm1537sXZRzkfmwcr3s+
	 Afw13XnTIlvWUktIDbzA0M/F0iEFV220QHMocIeMWjJgJ/A57O2o6lS2Ixy9rleUgVg8c
	 Qtf+5pG86CSxhCkZTmg0HRIsodQAKEcxpMNuLIEkNifj0N06pBxozkEFp8rqp5j9evdcc
	 xll7nVF8LR3Emdo48yuw6XnSA4T7t6elxEiVK7lrgOcFKQ8jqNGoawBnH/1g6pe0p9xIe
	 rcn9yhKqgHsNaSoENFUyJk4MFFLsAQuiCTeQbwqkpcj1iAxTckm4eF8wRnI7zU4YEGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794083103;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=oowdS+RUaXqQYhqTl8K+JWCk7L9i4EL13SAkeszSlFo=;
	b=uvbknP8C42UisOYq6Yvxshlqbwb4uBF1lwHyQNfOmkVSOIsSk0Zy704I/LVAJQkDzLnb
	 kQdda8q/rsMGY/e8O2iqgHmLyTU2VrY9uzKg/NnexwpD2Ets3ygl6+q8vf8/KV2WkV5ws
	 MBg8QcvIctT+6yHMWODq+uHQncjrKR8KomfRMrV5L1kBx1g0dXPbYQsWJRWCbDfmJeJOm
	 ktGEBa/Gt28UiPIeMxaHstyR77b5DoIZvVAPUfIiqBuzRtpzgZQMIFqNKSGSWI6VpS2dd
	 LCbc69RJOev/ik+IOmRFKbfegrhEAL+F1lZO59KgoeCXzGLYpWgEQv5TOQku170iJOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Dq2zs6qI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32F44606D82C;
	Sat,  7 Nov 2026 20:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Dq2zs6qI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28C9A1F008A4;
	Sat,  7 Nov 2026 20:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794083103;
	bh=oowdS+RUaXqQYhqTl8K+JWCk7L9i4EL13SAkeszSlFo=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Dq2zs6qI/0KvCnEtdM6veb857H8abtyWdUvxYQIl/M/oYaQ0d1R1zzqpiZQHEIJXM
	 8dmbv/0rUlJ3O9En6Za6pdpSlsgsesLA2BvdYa2ezMCXTYcsWpS5p/i31sBzX6W/y9
	 w987a1vYQn7amMHCo5g1Ch45JoQButEiRO0cbVBPU7gilncvJzovOU1g/qAJbhSIiH
	 IIbtaCKJWqVRH1Kdh0paOMBwKv9JCChfuO6lvQjdpGDw3eVeGSr/q+0TbxEiFAeTtW
	 VFsum4NorbjUiPWTp8bfaY3ozKA+EzjNekeqjl+fLYDgeDNEnAaFD+gXZ9TWwkHff0
	 JNe2GHioppMAw==
Subject: Re: [PATCH rdma-next 17/23] RDMA/mlx5: Validate EQE port and GSI port
 before indexing devr.ports[]
From: netdev-bot+sashiko@kernel.org
To: yishaih@nvidia.com
Cc: jgg@ziepe.ca, leon@kernel.org, linux-rdma@vger.kernel.org,
 netdev@vger.kernel.org, saeedm@nvidia.com, tariqt@nvidia.com,
 mbloch@nvidia.com, kuba@kernel.org, pabeni@redhat.com, edumazet@kernel.org,
 davem@davemloft.net, andrew+netdev@lunn.ch, dtatulea@nvidia.com,
 moshe@nvidia.com, maorg@nvidia.com
Date: Sat, 07 Nov 2026 20:25:01 +0000
Message-ID: <179408310169.994134.18411917783042594669@kernel.org>
In-Reply-To: <20261103163949.1554-18-yishaih@nvidia.com>
References: <20261103163949.1554-18-yishaih@nvidia.com>
X-sashiko-severity: Low
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

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] This patch makes the existing invalid-port check and warning in
  mlx5_ib_handle_event() (drivers/infiniband/hw/mlx5/main.c)…

--

RDMA/mlx5: Validate EQE port and GSI port before indexing devr.ports[]

This commit adds port validation to handle_port_change() and
mlx5_ib_create_gsi(). The port number from the NIC is checked with
rdma_is_port_valid() and limited to ARRAY_SIZE(devr.ports) before it is
used to index devr.ports[].

> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
> index f4f2ad80e76c4..c29102260989f 100644
> --- a/drivers/infiniband/hw/mlx5/main.c
> +++ b/drivers/infiniband/hw/mlx5/main.c
> @@ -3063,6 +3063,10 @@ static int handle_port_change(struct mlx5_ib_dev *ibdev, struct mlx5_eqe *eqe,
>  {
>  	u32 port = (eqe->data.port.port >> 4) & 0xf;
>  
> +	if (!rdma_is_port_valid(&ibdev->ib_dev, port) ||
> +	    port > ARRAY_SIZE(ibdev->devr.ports))
> +		return -EINVAL;
> +

[Severity: Low]
Does this early return make the port check and warning in
mlx5_ib_handle_event() unreachable?

mlx5_ib_handle_event() treats any non-zero return from
handle_port_change() as a reason to skip the event:

drivers/infiniband/hw/mlx5/main.c:mlx5_ib_handle_event() {
    ...
	case MLX5_EVENT_TYPE_PORT_CHANGE:
		if (handle_port_change(ibdev, work->param, &ibev))
			goto out;
		break;
	case MLX5_EVENT_TYPE_GENERAL_EVENT:
		handle_general_event(ibdev, work->param, &ibev);
		fallthrough;
	default:
		goto out;
	}

	ibev.device = &ibdev->ib_dev;

	if (!rdma_is_port_valid(&ibdev->ib_dev, ibev.element.port_num)) {
		mlx5_ib_warn(ibdev, "warning: event on port %d\n",  ibev.element.port_num);
		goto out;
	}
    ...
}

The only way to reach the rdma_is_port_valid() check is a successful
handle_port_change(). After this patch, a successful return always means
the port is valid.

Before the patch, a port change EQE with port 0 or a port above
phys_port_cnt went through handle_port_change() and returned 0 if its
sub_type was not PKEY (LID, GUID, CLIENT_REREG, or ACTIVE/DOWN on IB).
The caller's check then printed the "warning: event on port %d" message.

After the patch, the same event is dropped with no log message.

Could the warning be moved into the new early-return path in
handle_port_change()? Or, if the silent drop is intended, could the
caller's check be removed, since it is now dead code?

> +
>  	ibev->element.port_num = port;
>  
>  	switch (eqe->sub_type) {

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261103163949.1554-1-yishaih%40nvidia.com
