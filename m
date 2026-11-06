Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793974910;
	b=FF/FXzgvIkRyW6FKkckooyW08mYolpqoTCftueA3QqyTLKPZtsjVp8eoDCGZUUid69/f
	 8w8YJh+nXmK3R9t5cY7zbK4jX+afGtAeR7cd1nomo8czhWCnnsUKO8NpSnt0WiM0MRfOG
	 sQbFMCIKli3RDtplwxuQjQQACEyewCJNvKA4N/7p8/ZErRJdWcwnwac19vPY1oympkVhS
	 JgMaL9L07ZSNF+Y86l20+9r+ojWMynxqdb5kw3sbsQvQ3gNSv3KRFnJtJ0gV6vFK97hey
	 tF8Y780t9gPK9UqZZeKd9ghMNLI1Q9BzRhgbaUD9AW+dXjNmnZxtX9+wAHVqOMSw9wg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793974910;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:X-ThreadId:Date:From:To:Cc:Message-Id:In-Reply-To:
	 References:Subject:Content-Type:Content-Transfer-Encoding;
	bh=Qxmf++OdXmvNQjqneVICiQMhLuKJZ5A4y7qik8rj9LM=;
	b=orD6AM0sF1pyLs2e+exWCMtmemOCxV86/V9ULhm4AepdMbE1fLHurouw18NB21HAQu8n
	 9qYMI98K9s86oPd67zfxqLbJy748NBJ4VceTO9S/qwINQbLjhpXwGaHkIISWeGSmK7Zlg
	 wf0uQMOgphxRyba56+Me4GTgQ3LgTP6PaNf05jxpHHrP05IkQ2fPF2f/7so+Bd6ljYe8Y
	 70Phy/ujgK1TLSZmgbzJOdmlElwCks0hvdF2T7U4WHyLVzJ5nSf7hQ5T+Q5qrr06mkFtz
	 C//CNiZHCKm1mVH0Jvfuxo178pyqg9Nes6WB75toxNibFoyVKqWK3fgpIgYG1Wbj/3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YqGHO8SW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2472A606A326
	for <linux-rdma@vger.kernel.org>; Fri,  6 Nov 2026 14:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YqGHO8SW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EDE11F008A1;
	Fri,  6 Nov 2026 14:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793974909;
	bh=Qxmf++OdXmvNQjqneVICiQMhLuKJZ5A4y7qik8rj9LM=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=YqGHO8SWu091Ub4+rgIBUOs8cWBchcrwC5QfMN857vJ9NFt5+MGk2vdTY6aCkoQ5T
	 YygPEj2B6ZP8IkpQIj/jdECMyzDjWsCaGFies0Cf6KVBzFM17ZfE5H7ntoHHZyKFzd
	 2XLiv7aM8QeFddMy4FbZxnZupjX7HCFgOLE9xwl2P/8762T3TqG2mlIdxn2eUc4+k2
	 ngOq6a4dAk1roN57dQy3c7yj7EuerMbeiivm3LrXiXcWBzEicC4u7E/t8LYswZshkI
	 ykFuwpohKsprIfGGCw3wWmh/+yBhFM0AJexbIpaB6E5LRoK3zYAMLUDu9hSVNYw4Rq
	 sdT823/Rn2uug==
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfauth.phl.internal (Postfix) with ESMTP id C0F75F40066;
	Fri,  6 Nov 2026 09:21:48 -0500 (EST)
Received: from phl-imap-15 ([10.202.2.104])
  by phl-compute-10.internal (MEProxy); Fri, 06 Nov 2026 09:21:48 -0500
X-ME-Sender: <xms:fOLtatsKfokU5KJkkWd-39gRGRb7k52IKscKDPfPT-xuParxfB_Dsg>
    <xme:fOLtahQ13o993YBky7UwnDkzM2hCK0qylt1lWGQmIOdCHKrxM7fvIuopSzuACF2xz
    f43lmUWRHz-F1fWKLrMn1PNMidHYAD0Ijcu8PcOkhMxx54FAkH7lJU>
X-ME-Proxy-Cause: dmFkZTGb/nsXTrLbFf6NLkl4yzWUKasKf1vr/SxNKlfICOIyS4FfdI/SZtcFuJ1njZvNR/
    8XZxNGP8KhZASLsh1/+E4MZHUdelII678Nfg15/ktIau/mrQTXJ4XxcnaA6DuSvihEoxAF
    hijPsrJ/YpmaBTjVIGDx5jGYg3F+0l1dcFXDtMc/+9IQ6QB/WDtzl4egxbv/f0kDbhisxD
    B9glY/Ffo8D6K/DcpKd+gn7q/jdTq/PLM0Kfk+tNd2FcUW4pFXsZrPQqUaGWd0RnUY4Nwt
    FmCFAVZcMnuTTKmBJafbeV5LtE/5CIvBPYhXGkSQ1x/zvoCvsERJEWhgRWt4sGScRqpHfc
    W5LUWGBCMDPVD/5D2NpvFQrVWEFbWvHIhv4L9H1C7+SR2O7a/G+KaZh0gC/MGkWLcQr5Co
    l9ZU3OoJTqYvdV3MAoPo+ht2tTyTgh3nqYbJwvXX294K6YUKcGSItC7f5gC3HfqkpZzD1u
    k5VWi2ZcwpbVkcwuWPHZE6xcgMDXRsgjsI3S5ryO3vYTeLZ5S/Be+eZVYCdJW7BiIKcppz
    rvkxfLiF38/3RkZxR30CShy7KqHB/WxqTpG3+YlPgx1Dpf+wtq6WkI9ZqjHZlK/lK4pi5m
    qMvIftuxWLBwT+MjM+y0zHzklH4+Ze7WhH4XbICqhEimC7Wp7AISGti/AQoQ
X-ME-Proxy: <xmx:fOLtakEIDkvTAdGscgsNKfCWtqFUVxTZb0jXK7sGSqFgjrcLRQKE4A>
    <xmx:fOLtale7TrUD-y4BERRtaHBkawKSrLmvydKXYkIghnAI9RIrDaoUQA>
    <xmx:fOLtatr7ot5VWOKFR05-t8UaNEv6_SMvH9WOQqTxDJG82Dq9QSqs4w>
    <xmx:fOLtamCWDcUgGoOuyHLLKkFo5HHz37amnFGY5WQGGl_0obXF6RANTg>
    <xmx:fOLtamdoU3k4Q8rdOMh8vg7bgKsyL66HIQWJrvKY6TbdFmNlNBkJJpWY>
Feedback-ID: ifa6e4810:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 9F057782738; Fri,  6 Nov 2026 09:21:48 -0500 (EST)
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
X-ThreadId: AqskSCTaNkUk
Date: Fri, 06 Nov 2026 09:21:28 -0500
From: "Chuck Lever" <cel@kernel.org>
To: "J Louis Kaplan" <Louis.Kaplan@arm.com>
Cc: dai.ngo@oracle.com, jlayton@kernel.org, neil@brown.name,
 okorniev@redhat.com, tom@talpey.com, anna@kernel.org, jgg@ziepe.ca,
 leon@kernel.org, linux-nfs@vger.kernel.org, linux-rdma@vger.kernel.org,
 trondmy@kernel.org
Message-Id: <7e3bbd89-b01f-43b8-9ce7-b549e949b0f4@slotpi15m67>
In-Reply-To: <20261008225450.664642-1-Louis.Kaplan@arm.com>
References: <59261d53-53fc-4195-a7f4-d9f117bb0150@app.fastmail.com>
 <20261008225450.664642-1-Louis.Kaplan@arm.com>
Subject: Re: [RFC PATCH 3/6] svcrdma: Coalesce contiguous pages when mapping replies
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Thu, Oct 8, 2026, at 6:54 PM, J Louis Kaplan wrote:
> Glad to hear that. I'm happy to split out smaller parts of work from
> this patch series if helpful.

I have a soon-to-be posted series that converts svcrdma to send and
receive through the bio_vec array in rqstp->rq_bvec, and it rewrites
the code your patches touch. A companion series does the same
conversion for svcsock and has to be posted first, because the two
series share helpers in net/sunrpc.

As I alluded to before, our long-term goal for the transport code is
to replace the use of the xdr_buf.pages array with an array of
pointers to biovecs. The goal is to replace struct page pointers
as the common coin in the NFS stack from filesystem to network layer.
The refactor will continue to represent only one page with a biovec.

I think you should be able to continue your focused improvements to
svcrdma on top of this work.


-- 
Chuck Lever (Come to NFS bake-a-thon! https://nfsv4bat.org)
