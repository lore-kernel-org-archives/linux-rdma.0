Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 643FA3A1D02;
	Mon, 12 Oct 2026 04:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791778675; cv=none; b=nU0L8NZBcXAY5Wh9c0y0VIwjg5scp3+8VKTpzApWU85SaUtoh5xfyaZygawalljNXAT+55R3iN2iujeWZXdKnBo7yH5WdGJuZNtuQEL4mU0Nn/EM/A+MkZhw2bBUke8P1QQ1M6Nlfk54nJtEkPLMCxYvdvucZ3mzo/gRGXbzYlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791778675; c=relaxed/simple;
	bh=ubRW8ZjcpVAzfxMZu5PF2y+wMwQMGvAbUuCbysq+iS8=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=S11kvzMKFEsMfNsivEgD1I2B3eIj3a2vHMwfkQUcqQA/YCkMOyWo3AapnxwMdqBtg94NVgyZyqP1vHCu1jLFjFQ8cDi0M3hlOuVZwE1lQVzOCkIu1pP0Vj6NQUA8SZe2/e0LOaG9EaObVxtMEUWWUrzwO8Hh2/hKFNvAtXZMCmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cVzMHXqy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cVzMHXqy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63F441F0089B;
	Mon, 12 Oct 2026 04:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791778669;
	bh=YHoRLb9iqxerjC8rW1H47+58wAtLkdc4MBbuATQYxeo=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=cVzMHXqyvgMq/O13p+7GjTeTelK0lZBkN8+T9Q1pnGOhZpFXXRf2xCUVUs4wqpPso
	 094f3AHzDpjqEJvQT0DbfQoulkRiakcSpwiTfuIeoQlkfnBdski9hKp3K7LSimeYYv
	 nFUfQ8vnrI3YEML/KkNttNo8LilFcK8OJRrn3ou0T5L0ACHbMewJd/Hpn073M/6MMl
	 SCuUCR3sRWyjxJH+T5/YllYIrWgA7giB+NX+4rD30fTcdAg1X8UjRPWmsYAKT0JNOK
	 s63Lr5gRL/LCTFRG3P+mS5f4zv5i2FaTTPVMge/RKGcCmz8V5GcWD6MiYQJXstQNDl
	 iQ3Bd4z5FlD6Q==
Subject: Re: [PATCH net-next v9 11/13] net/rds: hold connection references in
 lookup, sockets and c_passive
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org
Date: Mon, 12 Oct 2026 04:17:48 +0000
Message-ID: <179177866895.434549.7210189401396244719@kernel.org>
In-Reply-To: <20261008031333.1142174-12-achender@kernel.org>
References: <20261008031333.1142174-12-achender@kernel.org>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] The commit's attribution trailers contradict each other.

--

net/rds: hold connection references in lookup, sockets and c_passive

This patch makes struct rds_connection pointers carry real references in
rds_conn_lookup(), __rds_conn_create(), the rs->rs_conn sendmsg cache and
parent->c_passive. It also serializes the rs_conn cache and the ToS
ioctls under rs_lock, which closes a syzbot-reported KCSAN data race
between concurrent rds_sendmsg() calls on the same socket.

Closes: https://syzkaller.appspot.com/bug?extid=879c1877016972360186

> Reported-by: syzbot+879c1877016972360186@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=879c1877016972360186
> Signed-off-by: Sharath Srinivasan <sharath.srinivasan@oracle.com>
> [achender: substantial reimplementation for net-next: upstream has no
>  conn reaper, per-conn workers hold no references (destroy cancels
>  them synchronously before the final put), and the sendmsg cache is
>  serialized with rs_lock instead of UEK's socket flag; rewrite commit
>  message]
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

[Severity: Low]
This isn't a bug, but do the attribution trailers match each other?

The From: author is Allison Henderson. The first Signed-off-by is
Sharath Srinivasan's, though, and there is no Co-developed-by: tag for
him.

Documentation/process/submitting-patches.rst says the first SoB entry
signals primary authorship. It also says each Co-developed-by: must be
immediately followed by that co-author's SoB.

The "[achender: ...]" bracket note is the convention a handler uses when
editing someone else's patch. Because of it, the chain reads as Sharath's
patch carried by Allison.

The message also calls this a "substantial reimplementation" that is only
"Based on the Oracle UEK commits". That suggests Sharath's bare SoB
certifies code he did not write in this form.

Would it be better to pick one of these two layouts?

  - Make Sharath the author and keep the bracket note.

  - Keep Allison as the author, add "Co-developed-by: Sharath Srinivasan"
    immediately before his Signed-off-by, and drop the bracket note.

For comparison, "net/rds: split connection destroy into quiesce and
kref-governed free" and "net/rds: wait for connections to be freed on
transport unload" in the same series are authored by Sharath. They use
this same trailer layout, and there it is consistent.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261008031333.1142174-1-achender%40kernel.org
