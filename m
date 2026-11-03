Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793734990;
	b=IcyVV8Q159TUtM00ta5AZTsW4BuoTCyDH4FFdLaYUKzuf0Nm7NEW1m3vet2gZb8FD73Z
	 PviisUFQnu6xpz9Tk6bvzZnaLoVgRab0qWSFs97RW4cRcozc64xNSFFCtrMYXwudCVyAV
	 aiII2RjMShp7lU2MRNNxx0yrNsN6FlfO3XTs6Gft0BzzCRxdbEEFhWLV5Bfy9GRA7xwJd
	 LR62L085bBqtvSpuS8fatN7STqoJtU6plMkQxlCWZaYi+BXAPHcJ68mDgIv646ku1BVin
	 UTU6qjWYRNiFbQc22wv0TP90JE0/Ic393KsPe2AtGCQ6I1T0mHgELxVjlSbCOUOA0Jw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793734990;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type:Content-Transfer-Encoding;
	bh=7S5/u5T5HoRt+WgopwfUlnozirDDqF3uE1rfiHHdDWM=;
	b=sdosd0x7MekuGfWqjf2MqgKOFwPbBYzP0Ea8AMHCTfmL2d3+kjMr7Mv8w6/UOwjJ3gvr
	 BUxkSYt36YQYVlfPKT0SNZSlFa7KveR978F+3ZYOIlRSiey8mPaEVH9xJInnual3RhWHN
	 rv7F4TQG2Ucxgz1K5lQXCpEmnLUMOd8lmbFC9iDbHgGof2LsdTXQBPRf2PkxkP3/vT/JK
	 cLs5wxW91eCoJwti+6crvnxb2cZIfPbBov/iQEpfECzyGHYckN9o4v6HIy6itGNOMTrV7
	 hBikmcYl7QiH//bIWhH5OTwQhta0IDvQqwG4NhNUfrqjZ68MqNi1ZKPt6f5eM73hZ8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VtNMC8Wb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D2B606A32C
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 19:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VtNMC8Wb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FE9B1F00919
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 19:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793734984;
	bh=7S5/u5T5HoRt+WgopwfUlnozirDDqF3uE1rfiHHdDWM=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=VtNMC8WbfyrDEABw+9Plok8xpTDFfx3X0NR/TmpLo6OGJSBainK2QlWPH5oLw8waj
	 X2vh5qmxMdGedZPtQFHuqDyZEzaugrIxbbPdYMReOwXM+nDOuPQc5ZnQ3GN39AUpBb
	 fwuoV+qlQYxSZ02VsxspvhJGp1qUyLmhEYvTfmstdmEzHDYpHd/ApSPO5+jJSEq1ok
	 kq48/oWAwKT+DBKUaJ0QD2uyIE47Uzq6wtsA/9kJL42yDv8TdHpkMV+qk8QUx4rC7C
	 fwrn47czjO2Su2H5t892kPBtTgrW9RWsv14K3L6kGU7SUW+kJ6UhvEZ2kvX/ZYpYcH
	 chf3RpwlGk3QA==
Received: from stl-compute-04.internal (stl-compute-04.internal [10.204.2.64])
	by mailfauth.stl.internal (Postfix) with ESMTP id E49AB780043;
	Tue,  3 Nov 2026 14:43:03 -0500 (EST)
Received: from stl-imap-11 ([10.204.2.102])
  by stl-compute-04.internal (MEProxy); Tue, 03 Nov 2026 14:43:03 -0500
X-ME-Sender: <xms:RznqaqDFnYnhBs6VBXhZuVGDsTN8LMdtEGaeFJEY7A1jg0hFcJV7hA>
    <xme:RznqavW4ySLiKXKRYavqGKRSVx50S0L9vVJs9sDU7ZJfJB6UqFxYy-wyN9-cjgWp7
    BuiU_xTnjLDigK_-i8DmC620d_Sr82otwW4x90z6CUvYqUbOS1XZDwM>
X-ME-Proxy-Cause: dmFkZTF6jdgJTnG/88IvnT1koKJkzo80iv8lqf3UK57QDiQLhcfJ2d/jjpVpHT+5MDucbx
    PadCb3he6cXgrlw7RX5YNhVllz6eHvQltJzBrG1eSvqTtCk2vqVu9/x9uUKQ4kBLwD2nd8
    5FTDp2cKKMkmqdDXTQrA5auKwuGrDOj+N8tVr/KgMNs92G7z0AQjHDRtzHoOiHi0Kb5LD3
    4vZgDtDUj3O+cvnb2+MtVKRwul6XaPqa4r7Yqh9OS43QVCZlX5KMK/hApX1Vc8G++FIDnh
    5+nNxavBvehgtywXjGeUprD9o4w6IVEqg7g099wrRc2f+P+9HC+HSkham59/XfA9tltbsi
    QSRJ4ZmiCtbMAz2y927SaDa+ZyF0lLwhCXsW0jCSgHKOCDbv8rBR9kEd8muwd2kbhmZXiZ
    0tDSDZr58AM87tCDGJc+9S4AJbFQK9cjdUoN/aLkhxkzZgYbADq+4gZKlsPbxVjoUG6fMc
    0l/ah9JDWeikmmNzRlxNR9t2gQKZtVAm0VcoLh3r6xGaDC74mozOOgnOnONNT8dHhgJoel
    hscQD+eA7rSJfXDsfsZ9mZc5UtkIdk7sZjP9O/5C1pM5xgePoNIB+EwACzj3n2UgLOtF54
    QYoXjgeoVmnatg5a5Hc1ySW+J/TXBTbfdKOvAnrv5FlLDnMIuigWSAwXbGQA
X-ME-Proxy: <xmx:Rznqai63dj78PQsYgK7x_WNMUGddlwNhcovZEj5oENCMjauCq9H2zg>
    <xmx:RznqasnANpKmIdrTwqtU56PwMYHI0sXIHnvr2GgHUrFfgfnEISrASQ>
    <xmx:Rznqavp_hcE7SmiScLde8HM1X__IciR3wWBpSXf5EDuBNUonbfKPAQ>
    <xmx:Rznqajt5l282eg7Ia17hRXIUx93RPttlD09C9d0cztr6DHpFbFTg_Q>
    <xmx:RznqasH7p_qMPW7wU9AlXbumiNWiEXIltHePYU4VLf3h_FHHWQs2gGhx>
Feedback-ID: i927946fb:Fastmail
Received: by mailuser.stl.internal (Postfix, from userid 501)
	id 8B33119C0069; Tue,  3 Nov 2026 14:43:03 -0500 (EST)
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
Date: Tue, 03 Nov 2026 21:42:14 +0200
From: "Leon Romanovsky" <leon@kernel.org>
To: "Jacob Moroni" <jmoroni@google.com>
Cc: "Mohamad Pishdar" <mohamadpishdar@gmail.com>,
 security <security@kernel.org>, "Jason Gunthorpe" <jgg@ziepe.ca>,
 linux-rdma@vger.kernel.org, shiraz.saleem@intel.com,
 "Tatyana Nikolova" <tatyana.e.nikolova@intel.com>
Message-Id: <9288a5fb-7a41-4bf1-8d5e-b364ea1ab7a1@app.fastmail.com>
In-Reply-To: 
 <CAHYDg1RCL-TKjig0_X-wSNHEGKNXJA+K-SnCUdOkDZh_4rswQg@mail.gmail.com>
References: 
 <CAAAp7fgvKfLqxsZrvmq2+xtq=_AuGOmKLYijAsMk=bKCJFkSGQ@mail.gmail.com>
 <20261103121246.GF264423@unreal>
 <CAHYDg1RCL-TKjig0_X-wSNHEGKNXJA+K-SnCUdOkDZh_4rswQg@mail.gmail.com>
Subject: Re: [PATCH] RDMA/irdma: Restore original PD on rereg_user_mr failure
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Yes, i just reading and answering in FIFO mode.

On Tue, Nov 3, 2026, at 15:39, Jacob Moroni wrote:
> Hi,
>
> Looks like we discovered the same thing at around the same time.
>
> I think this patch which was just merged should fix it:
>
> https://lore.kernel.org/linux-rdma/179371200572.1726055.11640512427251640287.b4-ty@kernel.org/T/#m8e7c4a912cb2539b08e2603cf751fcf16d13b291
>
> Thanks,
> Jake
