Received: from mail-wm2-f9.google.com (mail-wm2-f9.google.com [74.125.225.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CF8438E8AB
	for <linux-rdma@vger.kernel.org>; Sun, 19 Jul 2026 18:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784484588; cv=none; b=s6uFOzcRQPMT1k+w2K4TkIBjeABUrp4QfQBqV85ksOplt9qWlPEh0VY/d5BO8Kxv8qqU/Yplpz4YYYlhqVMkNhm7HopjMLvwp5py2Bb1VXGKEhqVLZ9+esN0GcysNiIJdOA5Z0a4laDJLZql1c61AMTH0WYWFfKu+r1YpankN1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784484588; c=relaxed/simple;
	bh=RcuCVJLUxcCDd1eWJ/F0/033hxnFIW+7FtOC8MWJx2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PnsJJmUcrYVK/e9nimMbhHfY0qeVVeydqTyfUHzvxkyD5LkCWkt5sB9kPzyPIMpcFhaJ0ZUsz3FzQIiJg97/j/IRDUw7Quifi/qIvJZDxYpT+R26hINb6G8cTOUkYJ7iw7r/rY1BFPdzEgWf9BaqglhYP7a6N3ESYtMJMZ7JANk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JQ7ySA0B; arc=none smtp.client-ip=74.125.225.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JQ7ySA0B"
Received: by mail-wm2-f9.google.com with SMTP id 5b1f17b1804b1-49553da76dcso4232545e9.1
        for <linux-rdma@vger.kernel.org>; Sun, 19 Jul 2026 11:09:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784484581; x=1785089381; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RcuCVJLUxcCDd1eWJ/F0/033hxnFIW+7FtOC8MWJx2c=;
        b=JQ7ySA0Bvkd1lzXjNs2QQKPBkXN0jbOfH7A4QBF5oHqh+4L8+WTOzxZa2FgAyjwqJu
         CQSpGUK+gKs3w6KS46uAwjsEDxeAsJwEvsD1QqITXdwAyiz71+HX70Uto2JvGA0efMpk
         M4BO2kCbBkR0etoI71Ivzmk9Du+nfyaIwYxBvHRYpHUJXUeq19Lc5z/SdIToCzVVHuOG
         RGw92jAkdY5onh6wvJL/JyH/pHtOrmTs8pYlPZjIfSrE9RqcoMBe9baLO5LzdHRoGRT6
         qC0RcDeNY5H95vFDAdS7xfiAs6NDNGTVWgqVxI8IXOLSHic1u98jzVchO1IYQoLM+QMM
         9s9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784484581; x=1785089381;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RcuCVJLUxcCDd1eWJ/F0/033hxnFIW+7FtOC8MWJx2c=;
        b=ikImqfruTUw2vVkDQnofkuDoi0wDEWklk+yCJRE+rX7az/6jXeWzlM62EKw0PhH2y8
         w1QeK9PJId66bSv8cv7bkxdQOV77mDFQn6P8mCjsZHnMv9aCu0mJwelYzZ0fIl1Aryar
         bPqK9/mMhQBtry0TXJrbC0sWn9WftD2Fhzttr83orW7KDHJ5G/JUZb8oRhUowRV4AF+F
         mxzDqyDA6lfm+XQRUO6CdQYcRJHMDfD9elan3v3F2Sys7W1RCWhcQaDA3R4x1fmzRg4r
         3c/Rc8RomUNG5oy/+/WZNwlBwjpsg/z9OuLEd5K5UsdXvF1CSk5p8CQrD6GM1frCt6Nk
         oN2Q==
X-Forwarded-Encrypted: i=1; AHgh+RoO636Zb3s7PMlB7VljCR+ImTD08Zuz5u9ZNACulU9ynLVYKWdlUR/FySA9EdnQ+oe+LvNOXuNcUnbX@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/unlGwcQxslv3PZz8V2sDWW4al42GWTvY5TNO+KnfFK0RL78H
	O0sFkv+vZ09Zd3XWh28xSnLr3OVjnG298N0opZ10a6oJCb8WWuMb3o9M
X-Gm-Gg: AfdE7cls7uVLM9ykUiuqUtMOSD7b/ff3bdITwLH1OD8kI1/QXrS/X20vDCaSu05mJgW
	7zNVlYYlUCpiZSwiAPzVPiV+LtYskLVVzV7c9/VP75SLQZjI/lwdkjNw4GmAJKn9qBJIyh3rjz2
	GdzYnSH3KOym48aI/7yHOpzqNGXAFC5pE8FR4muIIDG+9/mFX7EwCv19j+zF4nD5vl6xKySxxzv
	EI/Z1ZHjGdaPskN9tNrCCmR9tspk3OIWTPCkZPMR/ANksPd0QlCOdpY2Hs4F8U3Z63PYoWw6/mn
	oep//YdZyyKjQ2d09QcqSv0nGwTVGUHJYGX6TOL46I3OM/iX2IBC6C6YtAHoI0eRPmzWU616Kwh
	b0HACLJcqaZdWnvLCEMdkfDerpPGkk0718g5bVE/FOrSzWsDtlNzGgmOFbjb6M+B2hVs8BYHjkY
	Bo
X-Received: by 2002:a05:600c:b85:b0:495:5365:c0d1 with SMTP id 5b1f17b1804b1-49553d85ea0mr67524515e9.14.1784484581394;
        Sun, 19 Jul 2026 11:09:41 -0700 (PDT)
Received: from fedora ([212.253.209.56])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f63edda29sm23296214f8f.32.2026.07.19.11.09.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2026 11:09:40 -0700 (PDT)
From: Serhat Kumral <serhatkumral1@gmail.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Zhu Yanjun <zyjzyj2000@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+8c9eede336e3a843750e@syzkaller.appspotmail.com
Subject: Re: [RFC PATCH 1/2] RDMA/rxe: drive UDP tunnel socket lifetime from the GID table
Date: Sun, 19 Jul 2026 20:54:47 +0300
Message-ID: <20260719175447.196499-1-serhatkumral1@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260718153927.GF701389@ziepe.ca>
References: <20260718153927.GF701389@ziepe.ca>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Don't get this, GID removal is asynchronous, so it will eventually
> complete, what is wrong with leaving the socks around but unsuable for
> a little bit? Does something break?

I checked this more closely. You are right that a kernel socket's
passive net reference keeps struct net itself allocated, so my
wording about closing the sockets before the net is freed was
inaccurate.

However, the passive reference does not defer the pernet exit
callbacks. cleanup_net runs those callbacks before dropping its base
passive reference. With CONFIG_PROC_FS, sock_inuse_exit_net() frees
net->core.prot_inuse; when per-netns UDP hash tables are enabled,
udp_pernet_table_free() also frees net->ipv4.udp_table. The eventual
udp_tunnel_sock_release() reaches udp_lib_unhash(), which accesses
this state while unhashing a still-hashed socket. A sufficiently
delayed close can therefore access freed pernet storage even though
struct net itself remains allocated.

The backstop is therefore intended to close any remaining hashed
sockets while the required protocol pernet state is still alive, not
to prevent a direct struct net UAF. I will reword the comment and
commit message accordingly in the next version.

Regarding the per-QP TX socket in init_net, agreed that it should be
investigated separately. I will keep that out of this series and look
at selecting the TX socket from the relevant GID/netns as a follow-up.
