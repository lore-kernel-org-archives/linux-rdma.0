Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794107079;
	b=tJy3TICpBMmj/JTIxLta5mWFvZuJFCHjrWypvqtrbGH63atdFBuiYcRm2K9WnDPV7qCQ
	 8TRAqgyzuCG0h4n6mzxxBjH3hwnGA+0JD9kDojPhnvH93FqepJhVyu5x0G7C9ESzssWxy
	 SSR88cPNBCO5pQT/G57HcNbBJFuN5bDRKmdpuu88Pz1Vf0C07r6pQy1H2jhFQRXe2UWPt
	 66jV7vXVuglEPIG93H9cfb0pu6mMpFzScpJ9D38XU5KG7mBXb+zhyxnigntA2EswT/qYz
	 nzws8z5hHsmXVlklPE0i4EUf0ZH0FQ83Pu6CmrqLaJnV/JBra+B+gop2atHRYGpAqVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794107079;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=+4EPkDP6gNRwpvO49CMEXoJExK2bHkA8cFdH027EbT4=;
	b=I6YyaISAonwtREHvm9hYXxx+gr/lksOyRh6M7xgAcoI32mua7JmsB4mJSmEa850VBtoo
	 fWvdw5z7RFme8mSR1LBp7aH2DSiggDZOdrlxqqWsjwDecYkzV6ZAxeOcH48i+LXNvfILm
	 juXdrNFB73SEqCRfp4P4/g3u166NubnBfO1Vh7C3RDqbcPnMyiRQuEj28AVK/H61XGwp2
	 ylnPyaIGumU0WgVsay7wpW2c/09OAVcpOP3uxHNdjks+Gq2367lgGoOuoXYm1jHp+kCbc
	 HUnNi2Wc9r1YBrs160gyAproaq0S3fRytHex4R2BhwdVCjzMXTuLiexJw1YTAo576Og==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HdbpGNsl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB1B4606A31A;
	Sun,  8 Nov 2026 03:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HdbpGNsl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D43AB1F0089F;
	Sun,  8 Nov 2026 03:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794107078;
	bh=+4EPkDP6gNRwpvO49CMEXoJExK2bHkA8cFdH027EbT4=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=HdbpGNsl/BqlM/dC78GY58/tIXdic7Jmc8IFgBqDXxLdP4gWqUYROuaXUlwhX+EWt
	 G/u9VmwjMooDQebhaffRoa2Wa4vDR+lE7WaBurnNRc+2K6YwDJol5ZWPU6fWMzFG1a
	 8HdQo27Dc3hODMOqfatFpQArQf2xivBQfLzy7Amk/5BMPf0xQ3f+Sljw6Jdrn45EYm
	 V8x029tG9x67XWCiWXRNgg+ZsZi4hz5dlamY0oA5vJusKcOjBZO1tB+X38SSBL++4g
	 TXycuqVDu6bYdm2NUeyHDvhgDGzzqXiUqPNKNxIb/hAqkv++c0Xb3OYq0sc80gczS5
	 jIobktatOZTTQ==
Subject: Re: [PATCH] net/rds: drop the device reference for ODP memory regions
From: netdev-bot+sashiko@kernel.org
To: vulab@iscas.ac.cn
Cc: achender@kernel.org, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Date: Sun, 08 Nov 2026 03:04:37 +0000
Message-ID: <179410707739.994134.10076645291252563935@kernel.org>
In-Reply-To: <20261104022810.1484182-1-vulab@iscas.ac.cn>
References: <20261104022810.1484182-1-vulab@iscas.ac.cn>
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

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 0 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The patch adds rds_ib_dev_put(ibmr->device) to
  rds_ib_odp_mr_worker() (net/rds/ib_rdma.c:701).

--

net/rds: drop the device reference for ODP memory regions

The ODP path in rds_ib_get_mr() takes a reference on the rds_ib_device
but never stores or drops it, so the reference leaks. This patch stores
the device in ibmr->device. It drops the reference in
rds_ib_odp_mr_worker() after the MR has been deregistered.

> diff --git a/net/rds/ib_rdma.c b/net/rds/ib_rdma.c
> index db7e92e7bd29f..8cd8295f66a39 100644
> --- a/net/rds/ib_rdma.c
> +++ b/net/rds/ib_rdma.c

[ ... ]

> @@ -697,5 +698,6 @@ static void rds_ib_odp_mr_worker(struct work_struct  *work)
>  
>  	ibmr = container_of(work, struct rds_ib_mr, work.work);
>  	ib_dereg_mr(ibmr->u.mr);
> +	rds_ib_dev_put(ibmr->device);

[Severity: High]

Can this put now race with unloading the rds_rdma module?

After this change, the ODP worker on rds_ib_mr_wq can drop the last
rds_ib_device reference. The final put queues module code on rds_wq,
and rds_wq belongs to rds core:

net/rds/ib.c:rds_ib_dev_put() {
	...
	if (refcount_dec_and_test(&rds_ibdev->refcount))
		queue_work(rds_wq, &rds_ibdev->free_work);
}

The exit path flushes rds_wq only once, in rds_ib_unregister_client().
That happens before rds_ib_mr_wq is drained:

rds_ib_exit()
    rds_ib_unregister_client()
        ib_unregister_client(&rds_ib_client);
        /* wait for rds_ib_dev_free() to complete */
        flush_workqueue(rds_wq);
    rds_ib_destroy_nodev_conns();
    ...
    rds_ib_mr_exit()
        destroy_workqueue(rds_ib_mr_wq);

An ODP worker can still be pending when that flush runs. For example,
closing an RDS socket that owns an ODP MR goes through:

rds_release()
    rds_rdma_drop_keys()
        __rds_put_mr_final()
            rds_destroy_mr()
                rds_ib_free_mr()
                    queue_delayed_work(rds_ib_mr_wq, &ibmr->work, 0);
    ...
    rds_trans_put(rs->rs_transport);

Once rds_trans_put() drops the module reference, rmmod rds_rdma can go
ahead while that worker is still queued.

ODP workers can also be queued after the rds_wq flush. Messages on
nodev connections that carry op_odp_mr go through
rds_ib_destroy_nodev_conns() -> rds_conn_destroy() -> rds_rdma_free_op().

The worker might run on its own, or be drained by destroy_workqueue() in
rds_ib_mr_exit(). Either way, if it drops the final reference,
rds_ib_dev_free() is queued on rds_wq and nothing waits for it.

Could that work then run after the rds_rdma module text has been freed,
and touch the pools and PD after the module is gone?

Before this patch the ODP reference was leaked, so this ordering could
not happen. The comment above rds_ib_mr_exit() says the pool flushing
work queue should be idle by then, and that no longer seems to hold.

Would it make sense to flush rds_ib_mr_wq before the
flush_workqueue(rds_wq) in rds_ib_unregister_client()? Another option
would be to flush rds_wq again after rds_ib_mr_exit().

>  	kfree(ibmr);
>  }

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261104022810.1484182-1-vulab%40iscas.ac.cn
