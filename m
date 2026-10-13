Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84B1851A725
	for <linux-rdma@vger.kernel.org>; Tue, 13 Oct 2026 15:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791904239; cv=none; b=K/5lHGg6SF2jIOW49cKjPEocAE7OQFVN2yEP9fkoDEmhnLQqnlfpAOGYY3YGNKOmvb/RJhAD1bI5fSpo+LtjYzdIfpj6H6isJ0zyQtKXQq5pYuhMzjh8lS9QC9CSMm1QkVMzMivI+0reFkxM68IsMwiNq5XZoXDE11HHT6c/FR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791904239; c=relaxed/simple;
	bh=4i+clkAnHMq1WrVxdizmuVHYjXYxRBFNyE0s3GYwA8w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CElW80kKg1M05/giw/ZkZCY4YdgHDuEysblaPQsCh30pa06oGD0+BWDsydrRgnTz3PN/sknMJUQvnZObnPn8qzs3nXzFljaXpB/SrY+aUx21l+nDQrK86doGTBGh9q1eZQvNh8ykSEip7sR0AobBnFNr2eEyQWGWHo+D2X+4Rjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QlDRsbXd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QlDRsbXd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7751F1F000FF;
	Tue, 13 Oct 2026 15:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791904236;
	bh=BlbH4/F5z/gFLEhtf4M6VSAR2FrGk6LTNriawPpgoh0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QlDRsbXdfCvgor8TjQOJYlf1eRvuqZEkFwbzx/LgV3e1HxHIfyUAPrHbnIvA26ff/
	 A4+U2GXcBt81GkKBSEydFOp1J6Koo76XEV2Svu6wDGS7zOuRlCmq+F2HmzbDIQ0NOG
	 LQWIOUfe2Mc4phFybW+VXH3hv9IaH3e+bdc3Tli6CnYil+fyZZ41HH/kGNuAtLNFbn
	 kGIaJwMlxN7miAfmMP5CosRiDiC3ehY94OCDUUhz/q+UN3Zkl4fWexVssLjz201PMp
	 gz48H4kARYTTM3aYYKqxsWu6kICh4wWX7XmX9GLdZBiTlqP+x5OKLxFQLsz89WwKKj
	 tIa4hthitLTNQ==
Date: Tue, 13 Oct 2026 18:10:32 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Tony Battersby <tonyb@cybernetics.com>
Cc: Moshe Shemesh <moshe@nvidia.com>, linux-rdma@vger.kernel.org
Subject: Re: mlx5_ib fails probe with old firmware
Message-ID: <20261013151032.GS219304@unreal>
References: <064dfa67-8fd4-40f0-b925-6d1e0cd42e6a@cybernetics.com>
 <6af095b1-4ca1-483e-94c4-50227507fa85@nvidia.com>
 <45f66939-7cf2-47c1-950e-df0fc8d554c9@cybernetics.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <45f66939-7cf2-47c1-950e-df0fc8d554c9@cybernetics.com>

On Tue, Oct 13, 2026 at 10:07:17AM -0400, Tony Battersby wrote:
> On 10/13/26 05:49, Moshe Shemesh wrote:
> >
> > On 10/9/2026 9:20 PM, Tony Battersby wrote:
> >> I have a number of Mellanox infiniband adapters out in the field with
> >> various firmware versions:
> >>
> >> lspci
> >> 01:00.0 Infiniband controller: Mellanox Technologies MT27600 [Connect-IB]
> >> Subsystem: Mellanox Technologies Device 0018
> >>
> >> lspci -n
> >> 01:00.0 0207: 15b3:1011
> >> Subsystem: 15b3:0018
> >>
> >> Ones with old firmware don't work:
> >>
> >> mlx5_core 0000:01:00.0: mlx5_pci_vsc_init:66:(pid 731): Failed to get valid vendor specific ID
> >> mlx5_core 0000:01:00.0: firmware version: 10.10.5020
> >> mlx5_core 0000:01:00.0: 63.008 Gb/s available PCIe bandwidth (8.0 GT/s PCIe x8 link)
> >> mlx5_core 0000:01:00.0: mlx5_cmd_out_err:810:(pid 731): QUERY_ISSI(0x10a) op_mod(0x0) failed, status bad system state(0x4), syndrome (0x408b33), err(-5)
> >> mlx5_core 0000:01:00.0: mlx5_core_set_issi:866:(pid 731): Query ISSI is not supported by FW, ISSI is 0
> >> mlx5_core 0000:01:00.0: mlx5_init_clock:1040:(pid 731): invalid device_frequency_khz, aborting HW clock init
> >> mlx5_core 0000:01:00.0: mlx5_cmd_out_err:810:(pid 731): QUERY_HCA_VPORT_CONTEXT(0x762) op_mod(0x0) failed, status bad operation(0x2), syndrome (0x3590f5), err(-22)
> >> infiniband mlx5_0: Couldn't create per-port data
> >> mlx5_ib.rdma: probe of mlx5_core.rdma.0 failed with error -12
> >>
> >> Ones with new firmware do work:
> >>
> >> mlx5_core 0000:01:00.0: firmware version: 10.12.780
> >> mlx5_core 0000:01:00.0: 63.008 Gb/s available PCIe bandwidth (8.0 GT/s PCIe x8 link)
> >> mlx5_core 0000:01:00.0: mlx5_init_clock:1614:(pid 755): invalid device_frequency_khz, aborting HW clock init
> >> mlx5_core 0000:01:00.0: Flow counters bulk query buffer size increased, bulk_query_len(1)
> >> mlx5_core 0000:01:00.0 mlx5_0: Port: 1 Link INIT
> >> mlx5_core 0000:01:00.0 mlx5_0: Port: 1 Link ACTIVE
> >>
> >> I can work around the problem with the following change:
> >>
> >> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
> >> index a457647edacd..4fc903c2a0be 100644
> >> --- a/drivers/infiniband/hw/mlx5/main.c
> >> +++ b/drivers/infiniband/hw/mlx5/main.c
> >> @@ -3611,7 +3611,7 @@ static int mlx5_port_immutable(struct ib_device *ibdev, u32 port_num,
> >>   
> >>                  err = mlx5_query_hca_vport_context(dev->mdev, 0, port_num, 0,
> >>                                                     &rep);
> >> -               if (err)
> >> +               if (0 && err)
> >>                          return err;
> >>          }
> >>
> >> This code was added in kernel 4.19 by commit b02289b3d60f ("RDMA:
> >> Validate grh_required when handling AVs").
> >>
> >> A similar problem was fixed in kernel 4.9 by commit f9c14e46748b
> >> ("net/mlx5: Fix query ISSI flow"), which is a source of some of the
> >> messages with the old firmware.
> >>
> >> Can anyone suggest a proper fix for this issue?  I can upgrade the
> >> firmware if necessary, but that would be less convenient than having a
> >> fix for the driver.
> > Hi Tony,
> > Thanks for your report.
> > Please try the following change:
> > diff --git a/drivers/infiniband/hw/mlx5/main.c 
> > b/drivers/infiniband/hw/mlx5/main.c
> > index a457647edacd..632a45f663f6 100644
> > --- a/drivers/infiniband/hw/mlx5/main.c
> > +++ b/drivers/infiniband/hw/mlx5/main.c
> > @@ -3605,7 +3605,8 @@ static int mlx5_port_immutable(struct ib_device 
> > *ibdev, u32 port_num,
> >          if (err)
> >                  return err;
> >
> > -       if (ll == IB_LINK_LAYER_INFINIBAND) {
> > +       if (ll == IB_LINK_LAYER_INFINIBAND &&
> > +           MLX5_CAP_GEN(dev->mdev, ib_virt)) {
> >                  if (ibdev->type == RDMA_DEVICE_TYPE_SMI)
> >                          port_num = smi_to_native_portnum(dev, port_num);
> >
> >
> >
> That does fix the problem with the old firmware.  However,
> the MLX5_CAP_GEN check triggers on both the old and new firmware (I
> added a printk to test). If that is intentional, then it looks good.
> 
> Tested-by: Tony Battersby <tonyb@cybernetics.com>

Thanks, Moshe will submit official patch.

> 
> 
