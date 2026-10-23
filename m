Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792783710;
	b=fsNoXlblVHTzi4WCiGyaYzZjbOzf3PvbTbBv+NDkaSvWMMha8qOUxTqafK60Wp9irOBL
	 cEMTa9mjd1+CBjr2321bcajSse/yiI7DUCSY9yomxVto+eM71NfzqqwSshzU8WkxbUHmz
	 111Uci27OQ7UxFCFDN9o7YRz1aEF/kS3LMcnIIWm5X8Vgqwo3nsqG5b4HErWq31x3zfmF
	 8lseo43llBNqIMkMa/K+H+FYRxS2jbfzokMVUyn8A0Q1YFVAW79pm68Z9SKkZu6yJTW2+
	 S4k8KPytPIIH3iaNvaN8jaK9stTDd6R7xJ6j8re4obQCHUcjdbVDycmj1qucGC0gldA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792783710;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:X-ThreadId:Date:From:To:Cc:Message-Id:In-Reply-To:
	 References:Subject:Content-Type:Content-Transfer-Encoding;
	bh=YucjGLPVfjFQRU45mLqNxfKpDbA20oUVWgMR9JAb1tE=;
	b=VtDfGkg99gr9CitWv9s2ubsISAAGJm0BIKQd0SdAQS4qEy/cIde1YUIGGCq8PbfCl4ff
	 0jNokitFGZpGtnPc03GFpWG6I/MB1DNKAvTd66F8QDa8BQ2uSFPrgdtE7j4ANwdYQ8XOU
	 LhVvGFe5IMvssPpVOzXACHy4k/XaS1YmFfZOAlzAQs8gExlYbGRB7G2+fLUdeIpRMKOoW
	 AG0XDxanMVVbQFxAZ2hr5WZGhLR1UA49QaXaDZVt6KsdQyg6/wP8VaoqHn8gyu14i4Dfq
	 Qi0oyHbzCLs05WNE6/+MUfcvUBblDiR/4kCj4OTrUS15ZEZoI0HjFNlVfY55OOMjZ8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Fv/EWdvS";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 464E9606A31B
	for <linux-rdma@vger.kernel.org>; Fri, 23 Oct 2026 19:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Fv/EWdvS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AECC1F01825;
	Fri, 23 Oct 2026 19:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792783709;
	bh=YucjGLPVfjFQRU45mLqNxfKpDbA20oUVWgMR9JAb1tE=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=Fv/EWdvSoEHNA+oPFuDoUMSYCe/A8jE5QeZcHfUOWCxMkIAgMdWDJIGlFJtIfSwOw
	 rBS8oHlXekVuB2T2zyfoPwEe+cnk9rrbLXIeNfvmoEy38Ot6muKE+JnKgkpB8pZ5fD
	 jiOknz2jijQokVCSH+vd4J5r/PSmHKxrKcqep6E+wFRooJ+oTXwr0Im5tXszgaLinw
	 5zjz/rkfd/lnjwqTydtVVu8rldQmAlZgWOuWlrFe9dPpH4kPXZaXp3WWUtkAX7iTew
	 Ky1C1FdKLFdA/xUbYh1gEZmJHm2uz8ZjKo4FdCbtzmhix7dgxntIGk0e2vNVnGy0zd
	 43/vicoHOyypw==
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfauth.phl.internal (Postfix) with ESMTP id B42DFF40067;
	Fri, 23 Oct 2026 15:28:28 -0400 (EDT)
Received: from phl-imap-15 ([10.202.2.104])
  by phl-compute-10.internal (MEProxy); Fri, 23 Oct 2026 15:28:28 -0400
X-ME-Sender: <xms:XLXbamPKaYrOct-oPCf8AdL6uUqpW8LZ1opzc5t0nxMUPIOGMmaJsQ>
    <xme:XLXbavzxskPNp8AoNDVeQCKeCKvV_N65gYgVSIbwlBw_GoGPuR4p2Jhap7VbGz9aQ
    s3zd7Vx5_JFlcFKI9fGfCMbWAn7Pgr7TxaO2MsyPOrxtlMVMzoQcI4>
X-ME-Proxy-Cause: dmFkZTG2L7w9+ScBpps3pcT0gwT0auqlzz1dl7rMhFhKSOXbas2lU+Y26mDIzeydpBNhn4
    JwRaDiu+jXZdhEQHtqEqxEAulDYDADlNfr46ksPsTKfZaJYnC30pv68fkfNcX2aH1I4Bjp
    pK7GorRcJPYVu5g7KXJXZvHOa9F9rQTBuqEmGaPo/7/lxPG6TwTeGgP6/OQC1xe6MVru3w
    FSrSOXcMkT0AbUAb0HxM2FJuE3YYtx7Q5+WgF9hoX0IDgUR0pJsHYaSkzn5/1mmnsq/WrB
    yGvHSzv9klKbKfXL4fKD9b8m1cgUp9/FC2Ud0wsPvF6FbJpf9PMXGjIhyIwNn6O2t4DQfm
    7WAvklUskMvjTvsoiaQimItyQpq4pw+uQYCsIGKDHGgQv0OTBwlhs4eRI7l7LXwxJMJxzq
    uHLU97pljr0/np0wxzeux4NtwEHjo0Ukj1/1v78iQfTSksbfJ4irljXzNLO6dePTXWbC7I
    7PnG7QVH5Yb9Ey3BggdiEoPyvMUoUrms2tKzafuvyADkwa5ugsfnIMezIH+hQAFrDk6IRV
    Ty/sO5BhRquQL3rIa5RaLAKlMYgApwCwIykUsRSJx2vXoOYTSaC22SLkRwEdSTjhEJMmG6
    pwB5PHwsVQih0034lMqN+Ai6EWY/wE+oJRAvLOSnnO585GhkIJnODMIkSv8A
X-ME-Proxy: <xmx:XLXbahfaBil3GIisT2k61LJkr5GORrfY_vMLFVWYeZcAKHorhXXg6A>
    <xmx:XLXbarkF8N8mO-13B8YvVMQNxBgXSPXY8Xg-zOSOB_DIWVegzSDsRA>
    <xmx:XLXbau82nvWdN0mHDqyyMsfSKZWOLxRy4pcPZ_RlrNl7gLXReI3ryw>
    <xmx:XLXbapEyQScfJc7xAAlMzKDHdL6aScjLrfym051jJNLr9pLg_esnVw>
    <xmx:XLXbaqJto1JIcjYjnFHJDRl6pOex_IipizShwDEzc5o5uKJDgg5AWL0v>
Feedback-ID: ifa6e4810:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 95437782738; Fri, 23 Oct 2026 15:28:28 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-ThreadId: A6RPtEbxHI2V
Date: Fri, 23 Oct 2026 15:28:08 -0400
From: "Chuck Lever" <cel@kernel.org>
To: "Li Xiasong" <lixiasong1@huawei.com>
Cc: "Jeff Layton" <jlayton@kernel.org>, NeilBrown <neil@brown.name>,
 "Olga Kornievskaia" <okorniev@redhat.com>, "Dai Ngo" <Dai.Ngo@oracle.com>,
 "Tom Talpey" <tom@talpey.com>, "Trond Myklebust" <trondmy@kernel.org>,
 "Anna Schumaker" <anna@kernel.org>, linux-nfs@vger.kernel.org,
 linux-rdma@vger.kernel.org, stable@vger.kernel.org, yuehaibing@huawei.com,
 zhangchangzhong@huawei.com, weiyongjun1@huawei.com
Message-Id: <bd63c152-702b-4043-a4f2-092593c0dc1a@slotpi15m67>
In-Reply-To: <20261023125033.528835-2-lixiasong1@huawei.com>
References: <20261023125033.528835-1-lixiasong1@huawei.com>
 <20261023125033.528835-2-lixiasong1@huawei.com>
Subject: Re: [PATCH 1/3] rpcrdma: Serialize notification registration with device
 removal
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On 10/23/26 8:50 AM, Li Xiasong wrote:
> Use a module-wide mutex to protect the client-data lookup, removal-state
> check, notification publication and reference acquisition against the
> transition to REMOVING.

I thought a mutex might be a little heavy-weight, but registration and
unregistration happen once per connection, and NVMe has used a mutex
for this purpose since 2016 without complaints.


> +	mutex_lock(&rpcrdma_device_mutex);
> +	rd = rpcrdma_get_client_data(device);

The kernel-doc comments for rpcrdma_rn_register() and
rpcrdma_rn_unregister() should now carry a "Context:" section
noting that both take rpcrdma_device_mutex and may sleep. The
unregister path is reached from rpcrdma_ep_destroy(), which can run
from the CM event handler, so callers need to be able to see that
requirement without reading the function body.

Otherwise this one looks good to me.


-- 
Chuck Lever (Come to NFS bake-a-thon! https://nfsv4bat.org)
