Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793816793;
	b=fVWu3DVMjaX1QLwOWdFkLp9sTyOl5j5LuudlIsCFbN3AUmbmWwdzxn2Oqut7fiIyvc6s
	 ksGy2dTtW3HJU4vnL6k2xV3tVva7XeaG8NbnfFrym4ulcnfBOvhzO/m3CUuxX93Te0h53
	 /oh8/u1kl6nsFcT6Kwfe03LSW6i3LlY0eSPWK4HsoD9psBifKJcx3V5IPjSrY3Qy6sL3D
	 FzSCq0Qr4m8EXKjzSzONVGb5PqzCVrCxryox9J41McTcF5+Hk8AFRGWzFsXR6BwVHJNuw
	 bWp9VVkFbY2+o35zEFocko0Sm3xjmN8fNHWJA7866W3NLjltCyUZlNs0Iisa/rYuCAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793816793;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ORUcxA55UuVITjtRgToBDlRC+kVwe+yacH6xTA+/tEQ=;
	b=YQiw7yHMx1QGRIV921CV3ZVqr5ekBuhcz6ZrXjt/76fWRhLmunR+KXxZZtiY6+LN/woW
	 DClv3y7Tjr/puL/a4DcPisoQo2C1us1V2UpBhwF3LrHCyWhuIPMuCEHOa6UikYegf+lbc
	 QTzo9PefxdE5WfmqLBFk2T+KMrhQ4t4GpWBu/Tsb/7aWswYRWPYfwgvQHS7+ywhdgejtd
	 +V9Y16CmFb8lHeMv1njwY3MUTLAfrxCyrxeiyf1SmZAX6dP0m6vFViPjAWM2IrPXUlD63
	 B79o+v8Y867u+v5hkL0xXAstB0FCWWugneKOM7kEGL2YYejon8Wi4LqRcspEqBuWqYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bcVe+Ai1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E179606C440
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 18:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bcVe+Ai1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E80961F000C1;
	Wed,  4 Nov 2026 18:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793816793;
	bh=ORUcxA55UuVITjtRgToBDlRC+kVwe+yacH6xTA+/tEQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bcVe+Ai1sy65PQs6NQohmoeIh0QibaQQAuiWZWmL8MvHgJswYNzr8vYn169GB5S18
	 dKs9JqDDJA4HRgOxf1q3XFo0CniuSWdkiqKupStshqXrNOKVOLSrySk6KpHeIivxtf
	 3QmfMR/WSiyGldFm8Hz6hDzBQDCplwqQaWiD6IgF/uNdxYW5pAIHHEN47wsjI0kb6z
	 Sag+nv5Jl9mt4qncQnzgE7Afuc71VlHZf07eFXnknj554T9q+mTEWULzbQx4MsV9J8
	 sGNesAjbbDZwM6p78pd17KLM2KS1ezvxoPFALXBzeitFdlxA4QDqFi2fnZU48n6jxN
	 gi48IF+1s+ONg==
Message-ID: <sashiko-outbox-197839@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] RDMA/ipoib: disable the AH reaper work for good on
 teardown
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chengyu Liu" <lui2012qwq@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261104181753.1245369-1-lui2012qwq@gmail.com>
References: <20261104181753.1245369-1-lui2012qwq@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 18:26:32 +0000
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
- [High] RDMA/ipoib: disable_delayed_work_sync() permanently kills ah_reap_=
task on stop
--

commit f899e0252adbe06b9816121305967a356ff478eb
Author: Chengyu Liu <lui2012qwq@gmail.com>

RDMA/ipoib: disable the AH reaper work for good on teardown

This commit replaces cancel_delayed_work() with disable_delayed_work_sync()
in ipoib_stop_ah_reaper() to prevent a running ipoib_reap_ah() callback from
re-arming itself afterIPOIB_STOP_REAPER is set.

> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband=
/ulp/ipoib/ipoib_ib.c
> index 81bbb3f7c1132..b53906e463cd9 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> @@ -736,11 +736,11 @@ static void ipoib_start_ah_reaper(struct ipoib_dev_=
priv *priv)
>  static void ipoib_stop_ah_reaper(struct ipoib_dev_priv *priv)
>  {
>  	set_bit(IPOIB_STOP_REAPER, &priv->flags);
> -	cancel_delayed_work(&priv->ah_reap_task);
> +	disable_delayed_work_sync(&priv->ah_reap_task);

[Severity: High]
Does calling disable_delayed_work_sync() here permanently disable
priv->ah_reap_task across interface restarts and heavy flushes, causing
retired struct ipoib_ah and struct ib_ah entries on priv->dead_ahs to stop
being reaped?

ipoib_stop_ah_reaper() is called from ipoib_ib_dev_stop(), which runs not
only on final teardown, but also during ndo_stop (ipoib_stop()), TX timeout
recovery (ipoib_ib_tx_timeout_work()), and heavy device flushes in
__ipoib_ib_dev_flush():

    if (level =3D=3D IPOIB_FLUSH_HEAVY) {
        netdev_lock_ops(dev);
        if (test_bit(IPOIB_FLAG_INITIALIZED, &priv->flags))
            ipoib_ib_dev_stop(dev);

        result =3D ipoib_ib_dev_open(dev);
        netdev_unlock_ops(dev);

disable_delayed_work_sync() leaves the work item's disable count incremente=
d.
When the device is subsequently reopened via ipoib_ib_dev_open() ->
ipoib_start_ah_reaper():

    static void ipoib_start_ah_reaper(struct ipoib_dev_priv *priv)
    {
        clear_bit(IPOIB_STOP_REAPER, &priv->flags);
        queue_delayed_work(priv->wq, &priv->ah_reap_task,
                           round_jiffies_relative(HZ));
    }

priv->ah_reap_task is never re-enabled with enable_delayed_work(), so
queue_delayed_work() silently returns false and ipoib_reap_ah() never runs
again while the interface is up, leaving AHs added by ipoib_free_ah() on
priv->dead_ahs without periodic reaping.

Would cancel_delayed_work_sync() suffice here instead? Because
set_bit(IPOIB_STOP_REAPER, &priv->flags) is called before
cancel_delayed_work_sync(), __cancel_work_sync() temporarily disables the
work while waiting for any in-flight ipoib_reap_ah() callback to finish (wh=
ich
swallows a racing re-arm) and then re-enables the work before returning.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104181753.1245=
369-1-lui2012qwq@gmail.com?part=3D1
