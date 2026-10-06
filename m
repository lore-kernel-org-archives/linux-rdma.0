Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B667839B943;
	Tue,  6 Oct 2026 23:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791330104; cv=none; b=K+jwi1Q2StQQ2qL75KJQSutkY06QAl7AXwx0UuclytVCk0tm3OAyQhJI7lIym4hDCyEf4H+GfS4RsyvAK8QGC3svWyQCdA89+1yjNaJEdOPPQtnBP2GWAqKC4tPxLNx5+RX5LDyEI6MQNxb5gDxeGTOAoT04UTLxl3LCjt/FkLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791330104; c=relaxed/simple;
	bh=PybJNUmx9WRt8Ct6859jzq/2JNqYgZecMmHvEK9oG5k=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=pdkvODNN6wmO/w80l+sizYmRu+pTb+aGGDskhCnJqjDSDlqvP27sxxxjvNshDGDXOTujNRqjXi6WSjjtvGaymmrL7bHT/W0g5GvEPeRJXtRmgO8JNLvMjIBqsU+Vl+L3t0/6JKZ7Td97lkOJsr5nxXPIVGel0ESd/M5MW2dtM0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NyeDp0c4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NyeDp0c4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BC3C1F0089B;
	Tue,  6 Oct 2026 23:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791330103;
	bh=PybJNUmx9WRt8Ct6859jzq/2JNqYgZecMmHvEK9oG5k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NyeDp0c4szoux4RkQ+kRIpdbnTs7XBNCy8FDWEamqInceLCybLSly0qDV7sD6tmmr
	 vhlxd8d3gtELYJnNhZFvHeU9334tYbb1r7chFqag2nZbmyQKOqA93+JR322fliWMAr
	 XuyQ/33CiATfLU25Der5PcnwFUgtvkyAxcswLBrkGb46v1xZo9lQZIBhSD4ldUdE5q
	 AhSI5H39U0s+5SsjzbMfWrRnPHhwcuDmVnKnqWwyMgU1oc0RvGLL5fpznPLZHHzjx7
	 BvnRILQg2FI3afrcODJsC3DTt1KaMDSOQUHrOuzo3tUfCHbpU3lucpIxcOeNdzDSju
	 eKXJexj7nZg6A==
Message-ID: <sashiko-outbox-162517@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v1 2/8] sunrpc: fail only the RPC a transport
 refuses
Reply-To: sashiko-reviews@lists.linux.dev
To: "Pranjal Shrivastava" <praan@google.com>
Cc: linux-rdma@vger.kernel.org, "Chuck Lever" <cel@kernel.org>, "Anna
 Schumaker" <anna@kernel.org>, linux-pci@vger.kernel.org, "Jeff Layton" <jlayton@kernel.org>
In-Reply-To: <20261006233248.705086-3-praan@google.com>
References: <20261006233248.705086-1-praan@google.com>
 <20261006233248.705086-3-praan@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 06 Oct 2026 23:41:42 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> A transport returns -EREMOTEIO from ->send_request() for a request
> whose P2PDMA pages it cannot move. Retrying doesn't help, but today
> the error stops xprt_transmit(), finds whichever task is draining
> the transmit queue, and leaves the refused request queued.
>=20
> Dequeue the request, on -EREMOTEIO, cancel only its own task with
> rpc_task_try_cancel(), and keep draining. Setting tk_status instead
> would not work, a dequeued task looks transmitted and would wait for
> a reply that never comes.
>=20
> Signed-off-by: Pranjal Shrivastava <praan@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261006233248.7050=
86-1-praan@google.com?part=3D2

