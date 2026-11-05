Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793845699;
	b=zkNRJ6vmNwEl4RyfKud5nI48cOlwRZMHOnaqaOcIdTpkeWhTlp/dUlW7oIOU8LAOT64k
	 icM6ScbYY4YGBYtkJXc1k2OU6PbiuQ4UrmSNFfdw422t+QN1CXQE6BtncxaT3INJeZ2io
	 YOiowLWO2NdEbN67FERiksbCMfsWv2+TsITccqMsRHYJAIEXF91VUNX2XJQkBGwI90JrZ
	 f7Oq1Umz00F+/OLKoY/WoHrOgn55Pcp14vW2eWZitBssby1y7Nsi75BIAfPm31gJ0yD7P
	 tVSPW8U73zCKSlQjD+MvcEX+fQ9EnEsjZ6E0W/zjIV1RKP5Ysmm1IgG/NYx5rEdnCOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793845699;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=MSSrs3hA4sehsJ4QBKoEVa31XjutO2EXaBE9aRerRRg=;
	b=yD2u8/lg0aSlOUoW3TPhmf8MyRScndeHaKtVI2tsdn1v6NxpDx/uVGykppMVOeeoggub
	 brd/ZXSH7vBFAWZzmPJrK1mrkdXgaRsWXGjJ0Vcv+Cnmr2ZKkKz/dsBm3ZjkTzrDZ8Ov5
	 ZbA/aRFlSV0utkEqzzgV6G6Rv8r5PyUptwAlAaSkTWIvWtqXvZL2mL7pjLAk9LzVQqsfE
	 zBkQGk8z37XzamRrqps4xUMZeAmT9MX+g0MmB3Hvt+oS36qRVdnhgmsq6RL1DBV0jmg/w
	 qR/a+bztTVqMSYUzQH5n5PGAhKoyRCEWOlpe/YZoSL/bY6Z3sMEbkJSI9uuAzxKnGDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NbhZ9YVE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A034B606A32D
	for <linux-rdma@vger.kernel.org>; Thu,  5 Nov 2026 02:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NbhZ9YVE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1E161F00919;
	Thu,  5 Nov 2026 02:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793845698;
	bh=MSSrs3hA4sehsJ4QBKoEVa31XjutO2EXaBE9aRerRRg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NbhZ9YVEv0bHze/22gD4VFpQf9Fem6I1HHXoej7lQ2OLyaDw1XowONFSHXzEXVTTZ
	 R0jGj20gBpGoTXJBkKNPXEvhe2hMydKTXQlzVrsAo7r+/S9y2cZ3L1oboG/43GW0AM
	 LGynce42aI6jg3Qkf4hOXRsVYCvqW7NWyBgclT3zT0c9aLiWU054Q5sQLBYLjArEDg
	 QMcJDQedxvbfWhSoEDO+X41ZpLfMQXhuyqVP9gnwho778Leu7s3tMaVHSjaxjJnWFR
	 Kp70g4NwM8Wd1fkyGB2K98VWZ+p9j/T7WXrp78aiVa8RHfEf5vHqI5+pLsdYSGd3jN
	 oQv7vzEtz0NPw==
Message-ID: <sashiko-outbox-198462@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] net/rds: drop the device reference for ODP memory
 regions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wentao Liang" <vulab@iscas.ac.cn>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261104022810.1484182-1-vulab@iscas.ac.cn>
References: <20261104022810.1484182-1-vulab@iscas.ac.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 02:28:17 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] net/rds: rds_ib_odp_mr_worker() queues rds_ib_dev_free() after rds=
_wq flush
--

commit 867b786572304fe8059ffdca78162ac460e2ac8e
Author: Wentao Liang <vulab@iscas.ac.cn>

net/rds: drop the device reference for ODP memory regions

This patch stores the rds_ib_device reference in ibmr->device when register=
ing
an ODP memory region in rds_ib_get_mr() and drops it in rds_ib_odp_mr_worke=
r()
after deregistering the MR.

> diff --git a/net/rds/ib_rdma.c b/net/rds/ib_rdma.c
> index db7e92e7bd29f..8cd8295f66a39 100644
> --- a/net/rds/ib_rdma.c
> +++ b/net/rds/ib_rdma.c
> @@ -591,6 +591,7 @@ void *rds_ib_get_mr(struct scatterlist *sg, unsigned =
long nents,
>  		}
>  		ibmr->u.mr =3D ib_mr;
>  		ibmr->odp =3D 1;
> +		ibmr->device =3D rds_ibdev;
> =20
>  		sge.addr =3D virt_addr;
>  		sge.length =3D length;
> @@ -697,5 +698,6 @@ static void rds_ib_odp_mr_worker(struct work_struct  =
*work)
> =20
>  	ibmr =3D container_of(work, struct rds_ib_mr, work.work);
>  	ib_dereg_mr(ibmr->u.mr);
> +	rds_ib_dev_put(ibmr->device);

[Severity: High]
Could dropping ibmr->device from rds_ib_odp_mr_worker() on rds_ib_mr_wq cau=
se
rds_ib_dev_free() to be queued onto rds_wq after rds_ib_unregister_client()
has already flushed rds_wq during module unload?

Unlike FRMRs, which call rds_ib_dev_put() synchronously in rds_ib_free_mr(),
ODP MRs defer teardown to rds_ib_mr_wq:

net/rds/ib_rdma.c:rds_ib_free_mr() {
	if (ibmr->odp) {
		INIT_DELAYED_WORK(&ibmr->work, rds_ib_odp_mr_worker);
		queue_delayed_work(rds_ib_mr_wq, &ibmr->work, 0);
		return;
	}
}

When the last RDS socket closes via rds_release() -> rds_rdma_drop_keys() ->
rds_ib_free_mr() (or rds_send_drop_to() -> rds_rdma_free_op() ->
rds_ib_free_mr()), rds_ib_flush_mrs() only flushes mr_8k_pool and mr_1m_pool
without flushing rds_ib_mr_wq before rds_release() drops the transport modu=
le
reference.

If the rds_rdma module is then unloaded, rds_ib_exit() runs
rds_ib_unregister_client() before rds_ib_mr_exit():

net/rds/ib.c:rds_ib_unregister_client() {
	ib_unregister_client(&rds_ib_client);
	/* wait for rds_ib_dev_free() to complete */
	flush_workqueue(rds_wq);
}

net/rds/ib.c:rds_ib_exit() {
	...
	rds_ib_unregister_client();
	rds_ib_destroy_nodev_conns();
	rds_ib_sysctl_exit();
	rds_ib_recv_exit();
	rds_trans_unregister(&rds_ib_transport);
	rds_ib_mr_exit();
}

If rds_ib_odp_mr_worker() is still pending on rds_ib_mr_wq when
rds_ib_unregister_client() runs, rds_ibdev->refcount will not drop to zero =
in
rds_ib_remove_one(), so rds_ibdev->free_work is not queued yet when
flush_workqueue(rds_wq) returns.

Then, at the end of rds_ib_exit(), rds_ib_mr_exit() calls
destroy_workqueue(rds_ib_mr_wq), which drains rds_ib_odp_mr_worker() and ca=
lls
rds_ib_dev_put(ibmr->device):

net/rds/ib.c:rds_ib_dev_put() {
	BUG_ON(refcount_read(&rds_ibdev->refcount) =3D=3D 0);
	if (refcount_dec_and_test(&rds_ibdev->refcount))
		queue_work(rds_wq, &rds_ibdev->free_work);
}

Wouldn't that queue rds_ibdev->free_work (rds_ib_dev_free) onto rds_wq right
as rds_ib_exit() returns, allowing rds_ib_dev_free() to execute after
rds_ib_mr_wq is destroyed, after ib_unregister_client() has completed, and
after the rds_rdma module is unmapped?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104022810.1484=
182-1-vulab@iscas.ac.cn?part=3D1
