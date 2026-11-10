Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794313627;
	b=RpULvvTLVWA0EyQV3QmD5V4trQny2iuOo3M0xT7602PHuoibRi6TS+cBqOrO8XjYNdWP
	 EenrOIeS4iMDq294eEdYRtWR+nYW0oxFMBMRidQ0sZaE7nA8otse6jPhJ4sh/gDoV3KJi
	 eVHh6a18d39ZLgtGEOW478aHhmR0AGPX8gxwLDB362y7CJ7duXGDEWxOSBcOzp6HOYNou
	 RlA6SyiWz+KUGUNd1uHFokaP0LvyTlPhyHLe9p/7bnCj7yjeS8oFRSQQwccYvk+FPk8ho
	 qpzVHCRzf7ObAqhEFLzCm8ISHkRO2NyAdZB4WOAtDa1Wyak76DQdrxrJo3nEJk9msqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794313627;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=gKNP0kpq94P2tZDhfN86Im9NarGt0FVwTAkCzvmGlSY=;
	b=fpm+nv8RI7OzDcYr3vHiVAHCiKZbIod+dn8mm0wX/hS8uWuilXqFzIR2Gh5Isb0OQGWp
	 loxwh7mAZ6U8kDE/rTD4r1EI/n4y/Gn/s8eRaA0fMgtZFge5iotbtH7y/2YYuzRZ3RByA
	 EC1hIr+oHgn7CaSCF4XkV0+Dn6KIfi6jXhtxcVutMZzxa8PXKrqV6SBooKlr3IAgodMLN
	 pMsIUqMJaGi1V7mr/RMuISfQVQkYVhLg+JJJY9KfGYz+HxLFcrz8/kI/tz0FaA1Sv51XL
	 ASKI6mZ9n+8FzniHYjcedKxizz/0uSJMbqFqI24HkVAo0e0A0tkA4aHRJw9f0u4fZ+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JYE7Gozj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F835606A31C
	for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 12:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JYE7Gozj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A90C81F0089F;
	Tue, 10 Nov 2026 12:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794313626;
	bh=gKNP0kpq94P2tZDhfN86Im9NarGt0FVwTAkCzvmGlSY=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=JYE7GozjyXfrdWZ+bklrSo+56EoSecFmU5XvCjsKukYP8HM0HApaaOPCyzlkDPj9g
	 lO8m/TwB7Wxwvq33Iks/HzF0auSJJTF3C/f7LQ0nbZOaIbeCSVB/q8tIaeiPiSVvWB
	 3mxv1aFcI7LB83P4jhDtCm/9kmYKtkPoKPOGz6NWefOdiJbJyIaKo0vtz+UbXJK9n6
	 SRZmnRaKVmAYBP2kb9tx4SdMViXzYmER/or1KZwsIo7fN7cJMkZ3LsBt9e6+i5Mjsc
	 pAPaUc5OvMmMmT1hMUOZm8qWmXx+KM7S9WeRQzS1pnDx85ZNWQoO9vZdnmoVuin2wr
	 Jx9tM4MRek72A==
Message-ID: <sashiko-outbox-207015@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH for-next] RDMA/hns: Add reset fence before freeing DMA
 memory when destroy mbox fails
Reply-To: sashiko-reviews@lists.linux.dev
To: "Junxian Huang" <huangjunxian6@hisilicon.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261110115609.1981900-1-huangjunxian6@hisilicon.com>
References: <20261110115609.1981900-1-huangjunxian6@hisilicon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 12:27:04 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 5 potential
issues to consider:
- [High] RDMA/hns: 60s hang and reset self-deadlock in
  hns_roce_v2_mbox_rst_fence()
- [High] RDMA/hns: deadlock on hw_destroy_rwsem and rtnl_lock in
  hns_roce_v2_mbox_rst_fence()
- [High] RDMA/hns: deadlock between hns_roce_bond_work() and
  hns_roce_bond_suspend()
- [Medium] RDMA/hns: mbox_rst_fence() skipped when QP is already in
  IB_QPS_RESET
- [Medium] RDMA/hns: missing mbox_rst_fence() in hns_roce_v2_clear_hem()
  before freeing HEM DMA
--

commit 6ff74b25e6e4537bbfa0dd1dc9ea208112c6077d
Author: Junxian Huang <huangjunxian6@hisilicon.com>

RDMA/hns: Add reset fence before freeing DMA memory when destroy mbox fails

This commit adds a reset fence callback (mbox_rst_fence) that waits for
ops->ae_dev_reset_cnt() to increment before freeing context DMA memory
when a destroy or QP-reset mailbox fails or runs during a device reset.

> diff --git a/drivers/infiniband/hw/hns/hns_roce_cmd.c b/drivers/infiniban=
d/hw/hns/hns_roce_cmd.c
> index 1943031b0dbed..885900e68779e 100644
> --- a/drivers/infiniband/hw/hns/hns_roce_cmd.c
> +++ b/drivers/infiniband/hw/hns/hns_roce_cmd.c
> @@ -287,5 +287,10 @@ int hns_roce_create_hw_ctx(struct hns_roce_dev *dev,
> =20
>  int hns_roce_destroy_hw_ctx(struct hns_roce_dev *dev, u8 cmd, unsigned l=
ong idx)
>  {
> -	return hns_roce_cmd_mbox(dev, 0, 0, cmd, idx);
> +	int ret;
> +
> +	ret =3D hns_roce_cmd_mbox(dev, 0, 0, cmd, idx);
> +	dev->hw->mbox_rst_fence(dev, ret);
> +
> +	return ret;
>  }

[Severity: Medium]
Should hns_roce_v2_clear_hem() also call mbox_rst_fence() before its
callers free HEM DMA memory?

hns_roce_v2_clear_hem() issues HNS_ROCE_CMD_DESTROY_QPC_BT0,
HNS_ROCE_CMD_DESTROY_MPT_BT0, HNS_ROCE_CMD_DESTROY_CQC_BT0, and
HNS_ROCE_CMD_DESTROY_SRQC_BT0 (and higher hop steps) directly via
hns_roce_cmd_mbox() rather than hns_roce_destroy_hw_ctx().  When a HEM
chunk refcount drops to zero or creation unwinds via hns_roce_table_put()
or hns_roce_table_mhop_put(), a failed or reset-skipped clear_hem() leaves
the coherent DMA pages backing the context chunks and base address tables
exposed to hardware access when free_mhop_hem() or hns_roce_free_hem()
immediately frees them.

> diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infinib=
and/hw/hns/hns_roce_hw_v2.c
> index a8f319a57f25a..e17569a532e4e 100644
> --- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
> +++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
> @@ -1317,6 +1317,43 @@ static bool check_device_is_in_reset(struct hns_ro=
ce_dev *hr_dev)
>  	return false;
>  }
> =20
> +static void hns_roce_v2_mbox_rst_fence(struct hns_roce_dev *hr_dev,
> +				       int mbox_ret)
> +{
> +#define FENCE_POLL_INTERVAL_US 1000
> +#define FENCE_TIMEOUT_US (60 * 1000 * 1000)
> +	struct hns_roce_v2_priv *priv =3D hr_dev->priv;
> +	struct hnae3_handle *handle =3D priv->handle;
> +	const struct hnae3_ae_ops *ops =3D handle->ae_algo->ops;
> +	unsigned long cnt;
> +	unsigned long val;
> +	int ret;
> +
> +	might_sleep();
> +
> +	if (!mbox_ret && !check_device_is_in_reset(hr_dev))
> +		return;
> +
> +	cnt =3D ops->ae_dev_reset_cnt(handle);
> +	if (cnt !=3D hr_dev->reset_cnt)
> +		return;
> +
> +	if (!check_device_is_in_reset(hr_dev)) {
> +		struct hnae3_ae_dev *ae_dev =3D pci_get_drvdata(hr_dev->pci_dev);
> +		enum hnae3_reset_type rst_type =3D hr_dev->is_vf ?
> +			HNAE3_VF_FUNC_RESET : HNAE3_FUNC_RESET;
> +
> +		ops->set_default_reset_request(ae_dev, rst_type);
> +		ops->reset_event(hr_dev->pci_dev, handle);
> +	}
> +
> +	ret =3D read_poll_timeout(ops->ae_dev_reset_cnt, val, val > cnt,
> +				FENCE_POLL_INTERVAL_US, FENCE_TIMEOUT_US,
> +				false, handle);
> +	if (ret)
> +		dev_err(hr_dev->dev, "reset fence timeout.\n");
> +}

[Severity: High]
Can hns_roce_v2_mbox_rst_fence() stall for 60 seconds per resource and
self-deadlock the reset task during HNAE3_INIT_CLIENT and HNAE3_UP_CLIENT?

During reset rebuild, hclge_reset_rebuild() (and hclgevf_reset_rebuild())
increments hw_reset_done_cnt before invoking HNAE3_INIT_CLIENT while
keeping HCLGE_STATE_RST_HANDLING set until the rebuild finishes:

drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c:hclge_reset_rebuild=
() {
    ...
	hdev->rst_stats.hw_reset_done_cnt++;

	ret =3D hclge_notify_roce_client(hdev, HNAE3_UNINIT_CLIENT);
	if (ret)
		return ret;
    ...
	ret =3D hclge_notify_roce_client(hdev, HNAE3_INIT_CLIENT);
    ...
}

When HNAE3_INIT_CLIENT runs __hns_roce_hw_v2_init_instance(),
hns_roce_hw_v2_get_cfg() sets the new hr_dev->reset_cnt to the already
incremented ops->ae_dev_reset_cnt(handle) value.  Because
ops->ae_dev_resetting(handle) tests HCLGE_STATE_RST_HANDLING,
check_device_is_in_reset(hr_dev) still returns true throughout
HNAE3_INIT_CLIENT and HNAE3_UP_CLIENT.

Any call to hns_roce_v2_mbox_rst_fence() during this window - such as
error unwind in hns_roce_init() on the reset workqueue thread itself, or
any resource destruction after ib_register_device() before
HCLGE_STATE_RST_HANDLING is cleared - sees check_device_is_in_reset() as
true (even when mbox_ret =3D=3D 0) and cnt =3D=3D hr_dev->reset_cnt, so it =
blocks
in read_poll_timeout() for 60 seconds per context waiting for a reset that
cannot run because the reset task itself is blocked holding
hdev->reset_sem.

[Severity: High]
Does polling ops->ae_dev_reset_cnt() inside uverbs destroy callbacks
deadlock against HNAE3_DOWN_CLIENT on ufile->hw_destroy_rwsem?

CPU0 (uverbs destroy / close)     CPU1 (NIC reset workqueue)
-----------------------------     --------------------------
down_read(&ufile->hw_destroy_rwsem)
  hns_roce_destroy_hw_ctx()
    hns_roce_v2_mbox_rst_fence()
      ops->reset_event(...)
                                  hclge_reset_prepare()
                                    hclge_notify_roce_client(HNAE3_DOWN_CLI=
ENT)
                                      hns_roce_hw_v2_reset_notify_down()
                                        rdma_user_mmap_disassociate()
                                          down_write(&ufile->hw_destroy_rws=
em)
      read_poll_timeout(ae_dev_reset_cnt, ...)
        <-- waits 60s for CPU1 to finish reset

When userspace destroys a QP, CQ, MR, or SRQ or closes a uverbs FD, the
caller holds ufile->hw_destroy_rwsem (and kernel ULPs such as IPoIB may
similarly hold rtnl_lock).  On the NIC reset workqueue,
hclge_reset_prepare() must finish HNAE3_DOWN_CLIENT and acquire rtnl_lock
before hclge_reset_prepare_wait() issues the hardware reset and before
hclge_reset_rebuild() increments hw_reset_done_cnt.

Because hns_roce_hw_v2_reset_notify_down() calls
rdma_user_mmap_disassociate(), which takes down_write(&ufile->hw_destroy_rw=
sem),
the reset thread blocks waiting for the destroy thread while the destroy
thread polls for 60 seconds waiting for the reset thread.  After
read_poll_timeout() times out, the driver frees the QPC/CQC/MPT/SRQC DMA
memory before the hardware reset has even started.

[Severity: High]
Does calling hns_roce_v2_mbox_rst_fence() from hns_roce_bond_work()
deadlock against hns_roce_bond_suspend() during reset?

CPU0 (bond_grp->bond_work)        CPU1 (NIC reset workqueue)
--------------------------        --------------------------
hns_roce_bond_work()
  ...
  hns_roce_exit()
    hns_roce_v2_mbox_rst_fence()
      ops->reset_event(...)
                                  hclge_reset_prepare()
                                    hns_roce_hw_v2_reset_notify_down()
                                      hns_roce_bond_suspend()
                                        cancel_delayed_work_sync(&bond_work)
      read_poll_timeout(ae_dev_reset_cnt, ...)
        <-- waits 60s for CPU1 to finish reset

When hns_roce_bond_work() uninitializes a slave function via
hns_roce_exit() and a destroy mailbox fails or races with a reset,
hns_roce_v2_mbox_rst_fence() waits for ops->ae_dev_reset_cnt() to
increment.  However, before the hardware reset runs,
hns_roce_hw_v2_reset_notify_down() calls hns_roce_bond_suspend(), which
blocks in cancel_delayed_work_sync(&bond_grp->bond_work).  The reset
cannot proceed until read_poll_timeout() times out after 60 seconds per
resource, freeing the context DMA memory before the hardware is reset.

> @@ -5943,6 +5980,8 @@ static int hns_roce_v2_destroy_qp_common(struct hns=
_roce_dev *hr_dev,
>  			ibdev_err_ratelimited(ibdev,
>  					      "failed to modify QP to RST, ret =3D %d.\n",
>  					      ret);
> +
> +		hr_dev->hw->mbox_rst_fence(hr_dev, ret);
>  	}
> =20
>  	send_cq =3D hr_qp->ibqp.send_cq ? to_hr_cq(hr_qp->ibqp.send_cq) : NULL;

[Severity: Medium]
Can a QP destroyed after a reset-skipped modify-to-RESET bypass
mbox_rst_fence()?

If a caller modifies a QP to IB_QPS_RESET via hns_roce_v2_modify_qp()
while a reset is in progress, hns_roce_cmd_mbox() skips posting the
mailbox and returns 0, and hns_roce_v2_modify_qp() sets
hr_qp->state =3D IB_QPS_RESET without fencing.  When
hns_roce_v2_destroy_qp_common() is then called, modify_qp_is_ok(hr_qp)
returns false because hr_qp->state is already IB_QPS_RESET (which is also
always false for IB_QPT_GSI), so mbox_rst_fence() is skipped and the QP's
WQE, doorbell, and TRRL/IRRL DMA buffers are freed before the hardware
reset completes.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110115609.1981=
900-1-huangjunxian6@hisilicon.com?part=3D1
