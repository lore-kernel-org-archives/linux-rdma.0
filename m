Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794312900;
	b=3+7Vcye8C4xrOb9vSQ41C3bSmvb4vpzCMP7rhch4Q3GAYU6p5SvmSJraTnpjdBY8bu5M
	 Y2E68N43ZEV6uhhYFtIQO+3SPfI5cLIsJjb0nzkQen/BYmDORMOWhHC1F6j6To0HBkrPE
	 DAhdILPLzeaDsKivez85xF0bXevYi5N93EV9exrDgfrnOOgrIE3QkUS2dnkjol8Wf8PzJ
	 eEpEaTj0RPHVL+56+y7INe85G97XkcMUsdjNxmPsyP2AvhlKd2idLkil8cBKxmjTDTVnB
	 NFf8Os53Bcq4ElAAhaKRKnbdSRftNlLmq2O1a5uxtEl0UlWKrtINk116P6877He8e7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794312900;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=qz9Cg/+Lb0BoddJpAlf9vuo5dFigQSPPYLNDQ49b5og=;
	b=Z/J8JN5VxCEATLYHkDEdxvFHtdSCfND2HGlqe6P/uUz5Xr7MBoYMK+bCVzJC6B0NEIYq
	 wsWGmmxECDvd5cGEEt61Y2eCKKFXggpzR/T2m1PVSX07Mu8XmquH0d8z3xBiO/bQTaUbA
	 XuGCutx732HK75BuGIC93ays2wTs4iwoT0gOtcJ2rBLeCR0zv+s1t/brvhTsaJIm6SvtO
	 HXobPa1MsdmsTVpDEuuFlOtC4y0eugmTpUSvKGliGIuZxzrOjQeyFcW6oVQCNKqTgwr7u
	 d4qR2OhoOPGBFkx4ZkJcFHcBkd1h6yB3Jwj+egaKqqjKbC+t3zDrNQksu8QvAx2XeBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I83LR7wi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA92B606A31C;
	Tue, 10 Nov 2026 12:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I83LR7wi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D0F01F0089F;
	Tue, 10 Nov 2026 12:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794312899;
	bh=qz9Cg/+Lb0BoddJpAlf9vuo5dFigQSPPYLNDQ49b5og=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=I83LR7wiT0O/eZpQPZN1xM/PMVVJQkMFyt9p4NCgPMD4V8mZTfREIiqvcAkKoTKN7
	 zNzff4tPoD3ewxUVFgoAXmd9KE1CMw/MWfrUcUGsi4MPI9xcY94GefLmFFtZLrzyvv
	 piD74h9Tj4giYwy5n/joMXw1CfHknf3AOeRJmLORJH++sk6/7aAbxgNZNxzmu7pxoe
	 7PQTOBKojEghR0pPYtL/+eh8DOilPmL0iIjks/4tC2jeEHAInPovQwqrPJnMJxAn8h
	 A7C+Q+beN1r/YGkiwItzNA9acDSKKHuzPKbvWD1c0PIxrvtZKpjh900tlvibYuD9WF
	 LAyRVnvcygujg==
Subject: Re: [PATCH net-next v2 2/3] RDMA/ionic: Use the ionic command timeout
 for the admin queue
From: netdev-bot+sashiko@kernel.org
To: nikhil.rao@amd.com
Cc: brett.creeley@amd.com, andrew+netdev@lunn.ch, davem@davemloft.net,
 edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 abhijit.gangurde@amd.com, allen.hubbe@amd.com, jgg@ziepe.ca, leon@kernel.org,
 jiri@resnulli.us, horms@kernel.org, corbet@lwn.net, skhan@linuxfoundation.org,
 rdunlap@infradead.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-doc@vger.kernel.org, eric.joyner@amd.com,
 ArunKumar.Prakash@amd.com
Date: Tue, 10 Nov 2026 12:14:57 +0000
Message-ID: <179431289755.994134.3080122667953359752@kernel.org>
In-Reply-To: <20261105-b4-ionic-cmd-timeout-v2-2-35a9a2aa48b1@amd.com>
References: <20261105-b4-ionic-cmd-timeout-v2-2-35a9a2aa48b1@amd.com>
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

Critical: 0 · High: 1 · Medium: 0 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The fix is incomplete: an RDMA LIF reset at 2 seconds can still
  happen on the AH busy-wait path.
- [Low] The commit fixes a user-visible bug: a spurious RDMA LIF reset,
  after which every verb fails with -ENODEV.

--

RDMA/ionic: Use the ionic command timeout for the admin queue

This patch changes the RDMA admin queue watchdog in ionic_admin_dwork().
It used a fixed 2 second threshold and now uses HZ * ionic_cmd_timeout(),
which is 5 seconds by default. The AH create/destroy busy-wait keeps its
fixed 2 second bound.

> diff --git a/drivers/infiniband/hw/ionic/ionic_admin.c b/drivers/infiniband/hw/ionic/ionic_admin.c
> index 0ccd869ad8e6a..b463ad8b4e804 100644
> --- a/drivers/infiniband/hw/ionic/ionic_admin.c
> +++ b/drivers/infiniband/hw/ionic/ionic_admin.c
> @@ -18,8 +18,6 @@
>  #define IONIC_ADMIN_BUSY_RETRY_COUNT	2000
>  #define IONIC_ADMIN_BUSY_RETRY_MS	1
>  
> -/* admin queue will be considered failed if a command takes longer */
> -#define IONIC_ADMIN_TIMEOUT	(HZ * 2)
>  #define IONIC_ADMIN_WARN	(HZ / 8)
>  
>  /* will poll for admin cq to tolerate and report from missed event */
> @@ -28,6 +26,11 @@
>  /* work queue for polling the event queue and admin cq */
>  struct workqueue_struct *ionic_evt_workq;
>  
> +static unsigned long ionic_admin_timeout(struct ionic_ibdev *dev)
> +{
> +	return HZ * ionic_cmd_timeout(dev->lif_cfg.lif);
> +}
> +

[Severity: Low]
This fixes a user-visible problem, but the patch has no Fixes: tag.
The 2 second IONIC_ADMIN_TIMEOUT removed above was added by f3bdbd42702c
("RDMA/ionic: Create device queues to support admin operations"), which
is in released kernels.

Should this carry a Fixes: tag for that commit?

ionic_admin_timeout() also depends on ionic_cmd_timeout(). That function
does not exist at the baseline. The previous patch in the series, "ionic:
make the command timeout per device", adds it and describes itself as
"No functional change". If this fix is picked for stable without that
patch, it won't build.

Could the commit message mention this dependency?

>  static void ionic_admin_timedout(struct ionic_aq *aq)
>  {
>  	struct ionic_ibdev *dev = aq->dev;
> @@ -294,7 +297,7 @@ static void ionic_admin_dwork(struct work_struct *ws)
>  		}
>  
>  		if (time_is_after_eq_jiffies(aq->stamp +
> -					     IONIC_ADMIN_TIMEOUT)) {
> +					     ionic_admin_timeout(dev))) {

[Severity: High]
Only the watchdog in ionic_admin_dwork() moves to ionic_cmd_timeout()
here. Can the RDMA LIF still be reset after 2 seconds through the AH
busy-wait path?

ionic_create_ah_cmd() and ionic_destroy_ah_cmd() in ionic_controlpath.c
set IONIC_ADMIN_F_BUSYWAIT for non-sleepable callers. In that case
ionic_admin_busy_wait() still gives up after about 2 seconds:

drivers/infiniband/hw/ionic/ionic_admin.c:ionic_admin_busy_wait() {
	for (try_i = 0; try_i < IONIC_ADMIN_BUSY_RETRY_COUNT; ++try_i) {
		if (completion_done(&wr->work))
			return 0;

		mdelay(IONIC_ADMIN_BUSY_RETRY_MS);
		...
	}
	...
	ionic_admin_timedout(aq);
	return -ETIMEDOUT;
}

ionic_admin_timedout() then queues the same reset that the watchdog
uses:

	/* Reset ALL adminq if any one times out */
	if (atomic_read(&aq->admin_state) < IONIC_ADMIN_KILLED)
		queue_work(ionic_evt_workq, &dev->reset_work);

After that, ionic_reset_work() calls ionic_kill_rdma_admin(dev, true),
and every later verb fails with -ENODEV. The commit message describes
this same failure.

This path seems easy to reach. cm_alloc_msg() in
drivers/infiniband/core/cm.c creates its AH without
RDMA_CREATE_AH_SLEEPABLE:

	ah = rdma_create_ah(mad_agent->qp->pd, &cm_id_priv->av.ah_attr, 0);

cm.c also destroys those AHs with flags 0. On RoCE, every IB CM message
therefore goes through the 2 second busy-wait:

cm_alloc_msg()
  rdma_create_ah()
    ionic_create_ah()
      ionic_create_ah_cmd()
        ionic_admin_wait()
          ionic_admin_busy_wait()
            ionic_admin_timedout()

This happens when firmware takes between 2 seconds and cmd_timeout to
service the AH command. It can also happen when ionic_admin_post() puts
the AH command on the queue chosen by raw_smp_processor_id() % aq_count,
behind a slow command. The watchdog now allows that slow command up to
cmd_timeout, but the busy-wait still gives up at 2 seconds.

The kernel-doc for ionic_cmd_timeout() in ionic_api.h calls it the
"device and admin queue command timeout". The busy-wait doesn't follow
it.

Later in the series, "ionic: add devlink param for command timeout"
allows cmd_timeout from 5 to 255 seconds. It says it "replaces the device
command and admin queue timeouts". ionic_admin_busy_wait() is not changed
anywhere in the series, so the gap gets wider.

The commit message says:

    The AH create/destroy busy-wait keeps its fixed 2 second bound.

It doesn't say that reaching this bound still resets the whole RDMA LIF.
Should the busy-wait also be bounded by ionic_cmd_timeout(), or should
its expiry not trigger the LIF reset?

>  			/* Timeout threshold not met */
>  			ibdev_dbg(&dev->ibdev, "no progress after %ums\n",
>  				  (u32)jiffies_to_msecs(jiffies - aq->stamp));

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261105-b4-ionic-cmd-timeout-v2-0-35a9a2aa48b1%40amd.com
