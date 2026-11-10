Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794319073;
	b=KUx+ZW3IVC0Y5A4+tQEnZfy6q4+pzbpirthDAEw9LaWGTpDc0KFOKKOLzPFvjBCxP8Mx
	 a9o2GXC2sz5TkXzlqKP5W58IIGhg6NqPQrmILAlf7jjPib8Ce5GkZbuRTNMMCIz3vajnz
	 2ysQYOGQKCsuxzwn9a+W2ZGOlTCQR0t5838/BSmCId1d2FnQkN0MAyGWC1nmc6jqEjsPC
	 bHkm2bRrPnRXCR14MdufGUfPT0Ez9xszDZcZxoYoIz4Bj1GKwisVUCV9Gu/mRrlPinA+g
	 P8qs/nsp8d1rWiAupp7ZPrl7z+B78kk19ACaH60nsi/T8erSWhfv0kmEIdD9lVFPTuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794319073;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=roS45x5h65wmzYe0YUehtYdZbK+lZsU6DrKL88CsJ2c=;
	b=SjCLW2BC0nm66veRElP/vDHt1DvwbRsKT/PeXGU9bsXrRYGUUo/CsSIBrXfBXAnQcWib
	 0HWpwI7/pgITElYdeNRYVAJdjoX57ZglzBLZwQVBrOeiMVBo8Gq404f98mk7EJed3WFUo
	 8w0bUyR9TnhjyFGPit6gPRS79ds7L1mUVpMS2RwRzG9JX/mb/4L0k43m6weSpGhQtsY+e
	 yYQuOl+LHzJarBmUhQn5cVwIlres2/1GSSCqJJ9f7Xq+ECdqtD3fZUZoe9OytmAzpAJJF
	 2huNuvw+WxICvGlbjGjzeqkyzCl9AHhMEUxgUIBUSK13SV3BgGZFt6w1xCeFy9t+3Ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CfwNRpZa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E43F606A32A;
	Tue, 10 Nov 2026 13:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CfwNRpZa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7A1F1F008A6;
	Tue, 10 Nov 2026 13:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794319073;
	bh=roS45x5h65wmzYe0YUehtYdZbK+lZsU6DrKL88CsJ2c=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=CfwNRpZaGnwPUv+3R5FRiFCFIkFuI8AyWAXkYNppCwMF8htWSFcT++ft3y8saHGkK
	 BXctfc+MEq5eTGSceHv/b4kOvb7iopK0fanq43cnrLiUJ95ETcyojv1IGuCSfikWvl
	 o9SUwpjngQz6twIlFxYl+ITKPjcRo/PmlBFCswNeEGOPjrggBgz8olbveQcD1N81SP
	 paKTdyllnigzJIg1QZko5AAyaYWe19mDfw622yYD7oYaYh8aqmVcH+7xwDXupszKmb
	 z9y9m5RBzSRXSqXsb8n4G95lOuCfv+L9edIy+QqQ6HwP0LOwrmmcnQvlWekYxpo0XR
	 j+ItGf5NNdhuA==
Subject: Re: [PATCH net-next v11 04/12] net/rds: make rds_destroy_pending()
 report a connection's own destroy
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org
Date: Tue, 10 Nov 2026 13:57:52 +0000
Message-ID: <179431907250.994134.9563247907146216368@kernel.org>
In-Reply-To: <20261106031615.1047052-5-achender@kernel.org>
References: <20261106031615.1047052-5-achender@kernel.org>
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

- [Low] The commit message gets the history of RDS_DESTROY_PENDING and
  c_destroy_in_prog wrong, and it leaves out that mainline already had a…

--

net/rds: make rds_destroy_pending() report a connection's own destroy

This patch adds a per-connection c_destroy_in_prog flag. The flag is set
in rds_conn_destroy() before the unhash and synchronize_rcu(), and
rds_destroy_pending() tests it first. The patch also drops the unused
RDS_DESTROY_PENDING cp_flags bit and its dead test in rds_ib_is_unloading().

> The cp_flags bit that once served this purpose, RDS_DESTROY_PENDING
> from commit c90ecbfaf50d2 ("rds: Use atomic flag to track connections
> being destroyed"), was only ever set on the IB protocol-version path
> and lost its last set_bit in commit cdc306a5c9cd3 ("rds: make v3.1 as
> compat version"); it never covered the loopback path above, which
> commit c809195f5523 ("rds: clean up loopback rds_connections on netns
> deletion") added.

[Severity: Low]

Is this history accurate? Commit c90ecbfaf50d2 set the bit
unconditionally at the top of rds_conn_path_destroy(). That function
runs on every connection destroy, for every transport:

net/rds/connection.c:rds_conn_path_destroy() {
	struct rds_message *rm, *rtmp;

+	set_bit(RDS_DESTROY_PENDING, &cp->cp_flags);
    ...
}

The same commit also removed a c_destroy_in_prog field from struct
rds_connection. rds_conn_destroy() used to set that field in the same
place where this patch now adds the WRITE_ONCE():

net/rds/connection.c:rds_conn_destroy() {
    ...
-	conn->c_destroy_in_prog = 1;
 	/* Ensure conn will not be scheduled for reconnect */
 	spin_lock_irq(&rds_conn_lock);
    ...
}

Commit ebeeb1ad9b8a ("rds: tcp: use rds_destroy_pending() to synchronize
netns/module teardown and rds connection/workq management") then removed
that generic set_bit and the synchronize_rcu() from
rds_conn_path_destroy(). It moved the checks into rds_destroy_pending(),
defined as !check_net() || t_unloading(). That is the commit that took
away the per-connection coverage.

After ebeeb1ad9b8a, only the IB connect-complete version-mismatch
set_bit remained, and cdc306a5c9cd3 removed it.

Could the commit message say that this patch brings back a
c_destroy_in_prog field that mainline once had? It would also help to
say that the patch partly reverses the consolidation done in
ebeeb1ad9b8a, and that the global predicate stopped being enough once
c809195f5523 made rds_conn_exit() run rds_loop_net_exit() before
rds_loop_exit().

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261106031615.1047052-1-achender%40kernel.org
