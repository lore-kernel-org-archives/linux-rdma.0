Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E33367293
	for <linux-rdma@vger.kernel.org>; Wed, 22 Jul 2026 09:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784713039; cv=none; b=pswtdd1bhRNWhNxKsA4E7zaXf3/e1cJsiqeQQVvwBqDjn2WpR0z3PNLj2MGxFRsUTFdikepSBdtvAXr9o+Z31Cb0h2JcvCj99j/EiNbgcOwOiXCL4FReMdsv8ibSS1fp+e/Yt8XUAjAf+yLJnaWNr5/Bdr6iJuSbBrJGwpuvnck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784713039; c=relaxed/simple;
	bh=yldOk7bdyEXx2PGVeucRaawWCNLHOP1+jbEXNUX7zWY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=bJRb+FVUcj4iSQBhVu1YpqdxEbuB//m8tT9IfXekTVvngyeYrqXnI/WPoWqIIzSXBdAwWtt2QV0P35zyLhXim3CMQdQV9WieKNml7KV5JMjc9hBqhKC0UuOT9x/81TgwSRBKfWV8EqCSCRNgR7TcHy6stDphUJBxBaf78hsGnuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C+gnclCl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C+gnclCl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6F961F000E9;
	Wed, 22 Jul 2026 09:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784713038;
	bh=b9GpPzy2wmUN1Dgv181Qj4KUfNGLsjuIzoyQ3dLqW30=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=C+gnclClGWAq/VAiW0EwzCtH8q4GOLKBaDJ16TPhe8Dp8k2w9PIRoVAOZuCiFD2qA
	 5u1OciTIRtHhB+0uL3WAuvmLBslddLv1h1C9OIgEdmhYQ5CDZ55k4rd4QzuaOE16xH
	 2xOWQPYAYUwDdPG1XDF/YrOZ0mrp0ZiNw4sl+mS50+giM01aiVHDxvzy22t/TkgRsc
	 o+uV44m6cCAbgL5/iEPaUva0AJXp5gaDI3sihlmgZ3aSlJuqwlnl4ZbLgIIv8V9JJm
	 UfQdvvsHMAG3R7k2OpB6qfvHwLplwWJ/ITFVfCPitbaTiuc/iJFNJQ9/XVTVUHQCl4
	 LJnz7PNFXvjCA==
From: Leon Romanovsky <leon@kernel.org>
To: linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>, 
 Michael Margolin <mrgolin@amazon.com>
Cc: sleybo@amazon.com, matua@amazon.com, gal.pressman@linux.dev
In-Reply-To: <20260722083603.30334-1-mrgolin@amazon.com>
References: <20260722083603.30334-1-mrgolin@amazon.com>
Subject: Re: [PATCH for-next v11 0/6] Introduce Completion Counters
Message-Id: <178471303575.2834192.2276579632279006979.b4-ty@kernel.org>
Date: Wed, 22 Jul 2026 05:37:15 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Wed, 22 Jul 2026 08:35:57 +0000, Michael Margolin wrote:
> Add core infrastructure for Completion Counters, a light-weight
> alternative to polling CQ for tracking operation completions. The
> related rdma-core support is linked in [1].
> 
> Define the UVERBS_OBJECT_COMP_CNTR ioctl object with create, destroy,
> modify and read methods for both success and error counters. Add a QP
> attach method on the QP object to associate a completion counter with a
> queue pair.
> 
> [...]

Applied, thanks!

[1/6] RDMA/core: Add Completion Counters support
      https://git.kernel.org/rdma/rdma/c/bfcc2118d1044e
[2/6] RDMA/core: Prevent destroying in-use completion counters
      https://git.kernel.org/rdma/rdma/c/60ecf0e6a8c2ce
[3/6] RDMA/core: Expose Completion Counter capabilities to userspace
      https://git.kernel.org/rdma/rdma/c/71aaa6941dba78
[4/6] RDMA/core: Add Completion Counters to resource tracking
      https://git.kernel.org/rdma/rdma/c/553e6b1d7391e7
[5/6] RDMA/efa: Update device interface
      https://git.kernel.org/rdma/rdma/c/3cc3972a1cb0b2
[6/6] RDMA/efa: Add Completion Counters support
      https://git.kernel.org/rdma/rdma/c/154ec876721226

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

