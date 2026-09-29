Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33934337107;
	Tue, 29 Sep 2026 18:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790706256; cv=none; b=jSMtSGCC8D3EqX3qHe+BKBG/0HeAJrVaFOR4487jyPds6gOR9O0MD6ywS/VESX19i8NmD8GBR0UgeaSuCweiTsE0478ip86qR5czZS/BQbVrVW+0uKzNQuvO6o9EkxMt2KfI+0m6f5gytHs4b8216QzDdYanlfoQ6YvklbnLAh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790706256; c=relaxed/simple;
	bh=bCKAXOI8bf25NreAlLh/UkZt5umg9EKeaK+9E+SMpaE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=ZB65kiydYHxwoL/ul03r4v9lzk+4vUIFXNR7z4Itq7XnOFiTDTnG3kh+BNjetRbwWU/+9/SCnJzjmfpDaW6xrZVzIwMFHXdJuP4iTBQj01qMQQg6IUE0UNYIe6i64n9tJDhT3+l++Jt6w78AvO6gFi6ukTw5Pi99NPAYVieCbEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=adNsMilw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="adNsMilw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D81F1F000FF;
	Tue, 29 Sep 2026 18:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790706254;
	bh=v/jUEFA+22kywh0WuP2V7ovZVrZnpeFIRLKmHTOQZd0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=adNsMilwIobQswqqhzV5YjO/B8q9uWcKkW4J8HWS/aYrK0G9g3ScPivEREzn07Wmz
	 sMarWhJATGf3gGteVgUo1oEpe2l3y9mCZimdOOYci850VgdoUEKjDVBersmgAX73MR
	 fkgTDWHbLDUu5Cl1/knecGKdis/rsHE98G5xc6c/F/VFcPe44qNUOjEGf1X50gcAWA
	 RcdXAezzB2F0d9XtwQ46qdVhfaq84iSmVay7y9wD2FoS5zLRWPEMjjC43WDzBSMMnD
	 BtGSspujIEEEJ60fIDKc4uQpkV4AYTcV8+pAuxwkYKZGm/K9/kmlQkijCDo1SO4grQ
	 UuHfizaxFXCuQ==
From: Leon Romanovsky <leon@kernel.org>
To: "Md. Haris Iqbal" <haris.iqbal@ionos.com>, 
 Jack Wang <jinpu.wang@ionos.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Danil Kipnis <danil.kipnis@cloud.ionos.com>, 
 Quanye Yang <quanyeyang@proton.me>
Cc: Jack Wang <jinpu.wang@cloud.ionos.com>, linux-rdma@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Farhad Alemi <farhad.alemi@berkeley.edu>
In-Reply-To: <20260922-rtrs-fix-warning-rtrs-clt-rdma-cm-handler-v1-1-2076c0ee1455@proton.me>
References: <20260922-rtrs-fix-warning-rtrs-clt-rdma-cm-handler-v1-1-2076c0ee1455@proton.me>
Subject: Re: [PATCH] RDMA/rtrs-clt: Reject invalid queue_depth from the
 peer
Message-Id: <179070625191.3970688.14171007336657402873.b4-ty@kernel.org>
Date: Tue, 29 Sep 2026 14:24:11 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Tue, 22 Sep 2026 21:09:58 -0700, Quanye Yang wrote:
> queue_depth is taken from the server's CM private_data and later
> used as a session invariant.  A peer can send 0, which the client
> stores and then trips WARN_ON() in create_con_cq_qp() when the
> next connection is set up.
> 
> Reject a zero queue_depth on ESTABLISHED, same as a bad
> magic or version, and fail the handshake with -ECONNRESET.
> 
> [...]

Applied, thanks!

[1/1] RDMA/rtrs-clt: Reject invalid queue_depth from the peer
      https://git.kernel.org/rdma/rdma/c/724cd362162ca7

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

