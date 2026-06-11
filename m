Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 215371F4C8E
	for <linux-rdma@vger.kernel.org>; Thu, 11 Jun 2026 06:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781157995; cv=none; b=A1pwCbcBXQjrXufqjg9Rb1VW0W3U9bV7MUSBDNUr3Sdy9xLxgVV0ULKHK0v9qoonPxDGnDcidY98TJTZr4mEIN8hSn8CJwxbQxLkWfehF1h6GRGQCzqqpXhFVVHik6iSCg+j6hXWLjjjTDGTX5LPEjKYhl/L76X9/cK6pO/Fin8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781157995; c=relaxed/simple;
	bh=KzFBtbZCsFIB1C0x8hhlcVuxnERR7LA7E4Ddc1WdmLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KfW737Fl2cUXE5d4wvuxtyf1+g967VUNmL3va+ERJM7W1fZpa7zNwnGd7+PkbTkQwHHN8JF/7ZJZu12OhC4r+gfRUv5hoSiABQjxHv1/easE22EaawYs3TSCLcSiatzfJrrvvVTBCmKQgOedNZE6oEm2zezc4qMFH9J2UDdTOjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ldFLJqzI; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ldFLJqzI"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781157990;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KzFBtbZCsFIB1C0x8hhlcVuxnERR7LA7E4Ddc1WdmLU=;
	b=ldFLJqzIcmnVhtrkuzj24N8ayQkAjfXil6/utIeI5rCajukudFBDL0jyltS/Br9yoOVIg6
	cIEDLY2t2DSnr8clJdGGZgOwkYBWJqnpVraplDMcAumZ3wjX/1Wq6QDyXzaDBXnDyGGT3J
	4niTI2/0emmAXBld5AECTLSheKv42iE=
From: Tao Cui <cui.tao@linux.dev>
To: michaelgur@nvidia.com
Cc: edwards@nvidia.com,
	jgg@ziepe.ca,
	leon@kernel.org,
	linux-rdma@vger.kernel.org,
	phaddad@nvidia.com,
	yishaih@nvidia.com,
	Tao Cui <cuitao@kylinos.cn>
Subject: [PATCH rdma-next 5/9] RDMA/core: Fix FRMR set pinned push error path
Date: Thu, 11 Jun 2026 14:06:05 +0800
Message-ID: <20260611060606.44899-1-cui.tao@linux.dev>
In-Reply-To: <20260610000145.820592-6-michaelgur@nvidia.com>
References: <20260610000145.820592-6-michaelgur@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Tao Cui <cuitao@kylinos.cn>

> Add destruction of FRMR handles in case the push to the pool fails.
> This prevents resources leak in case pool page allocation fails.
>
> Fixes: 020d189d16a6 ("RDMA/core: Add pinned handles to FRMR pools")
> Signed-off-by: Michael Guralnik <michaelgur@nvidia.com>

Reviewed-by: Tao Cui <cuitao@kylinos.cn>

Thanks
--
Tao
