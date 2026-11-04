Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793802048;
	b=gJ7jZltGALsL/n4wY7x2PY6sO0mtCe/KUJ+PA7b/ePJDHi2HxlGeaVfYdIakIC/VzIld
	 lIGUV7jDSh49SFMAFNCNGPdzakMnXc77nJtSekCHbE86tYshhXvxoKIu06avGRpGPORsk
	 cxX91KZTcP+VSyU5ktyaiCe5iYsVbWRI4NStqdjaAjbX3KwfSn9A35s5N33JINMVeNBsX
	 5kexvNZI751OkYvPk5uI4JW4fvw0IkUjnTWHAnKxqFiW8lU+Ees3q83cIXq+KMblBZxXX
	 XmpvfRJbte+m9cRCkMr36QZCHQotWeCYtM06xSlGqq0YlLvtpta/5WZ+FBxByW3ROAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793802048;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=yhC6V3tszaLh22vM9JwqJz5sDuowI1YkEC8+eZFC8nQ=;
	b=wVZU/mEMf5QwZml6iuqYhgMf3X5Vc5c2VUT6QqKOXO4gmampX4opz6DRbBFWJRX7W7eN
	 pQIqyO7yJXB3TDfHpB+EMH0BUjosv8UHodxP2atodOcotc7RsrnmB9JDkBb2iYlMwRtJ2
	 UYRje4bODeRg1I+RhWU8LDxJTIK5l7y3Aja9/3XQ3Hfv4UY7y2MSMhoaYTF0Zs+ozNnym
	 tMRLrCZ5lmHrErnN2WIoVx6npwbiqhYwLyaMe/tVBQQTCf58ZeME98KRu1FV4FFI6ku6t
	 RiV7nPEpsCeZan+OgFyzda/7PJ/OmNXgvX+FMPwBVx3gPQLgOR/6JpNqqV/+wv38Ypw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bGGMFKbc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B8C0606A31B;
	Wed,  4 Nov 2026 14:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bGGMFKbc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B8621F000C1;
	Wed,  4 Nov 2026 14:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793802048;
	bh=yhC6V3tszaLh22vM9JwqJz5sDuowI1YkEC8+eZFC8nQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bGGMFKbcd01mmhOy16P9dm9fCm+23gmFPsbEZY+LkVlBaJcOi/Q9c/XvqsCYBNMf7
	 LcGm5SDE+fpgODNe3/zKSuwFkZGy42cIzVKHKBjSoKGxsE+c9mKdtq/l2hAULh723M
	 L22idRoHI9uigCANa0msLLCWlZr3OrCnVHrQbGk9EHmUWlOejKXdfvF0gKcbZ4+jFN
	 m5vTID5zL6yWg9UlmKVQ/Yjb0ud7fCC83EFSIIYqclxWI0H/sxZc0QNd8IoDBJhRxH
	 QU+c57GNh2jObOEdk2wD3n1+RcdD0gcq82R3lUkCaJmfoJh/uRehjWMGC3lUCCpl3j
	 70Bx67q8yNqjQ==
Date: Wed, 4 Nov 2026 16:20:43 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Cc: Sagi Grimberg <sagi@grimberg.me>, Max Gurtovoy <mgurtovoy@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Mike Christie <michael.christie@oracle.com>,
	linux-rdma@vger.kernel.org, target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 0/6] IB/isert: fix the device removal use-after-free
Message-ID: <20261104142043.GG478286@unreal>
References: <20261104040318.1844865-1-yhlee@isslab.korea.ac.kr>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104040318.1844865-1-yhlee@isslab.korea.ac.kr>

On Wed, Nov 04, 2026 at 01:03:11PM +0900, Yehyeong Lee wrote:
> The RDMA_CM_EVENT_DEVICE_REMOVAL callback in ib_isert waits for the
> connection it was handed to reach ISER_CONN_DOWN and then frees it, a
> use-after-free against isert_connect_release(), and the wait deadlocks
> against the handler_mutex rdma_destroy_id() needs.  3/6 moves the teardown
> into an ib_client callback, as nvmet-rdma did in f1d4ef7d8883, and gives
> every connection one owner.  1/6 and 2/6 are older problems; 4/6, 5/6 and
> 6/6 close three holes the walk makes visible.
> 
> v7 -> v8
> 
> v7: https://lore.kernel.org/r/20261104012219.1759523-1-yhlee@isslab.korea.ac.kr
> 
> v6: https://lore.kernel.org/r/20261103223802.1697607-1-yhlee@isslab.korea.ac.kr
> 
> v5: https://lore.kernel.org/r/20261103125955.1530355-1-yhlee@isslab.korea.ac.kr
> 
> v4: https://lore.kernel.org/r/20261103032924.1073138-1-yhlee@isslab.korea.ac.kr
> 
> Sashiko v7 3/6 High: isert_connect_error() clears cm_id after
> ib_drain_qp() again, as before the series.  Before the drain the QP can
> still take an event, and isert_qp_event_callback() dereferences cm_id.
> 
> Sashiko v7 5/6 High: isert_device_get() matches the ib_device pointer
> instead of node_guid, the same key isert_remove_one() uses.  Two devices
> can share a node_guid, and the PD and the DMA mappings belong to one of
> them.
> 
> Measured over soft-RoCE with KASAN, 114 runs.  A test-only event delivered
> to isert_qp_event_callback() before the drain oopsed in rdma_notify() nine
> times over two runs of 3/6 as it was in v7 and not once in two runs of
> this series.  A connect on a second device sharing a node_guid failed
> rdma_create_qp() twice in both runs before 5/6 and not at all after it.
> The cells v7 passed are unchanged: no KASAN, no Oops, no lockdep splat and
> no refcount warning on either side, device_list empty after twenty link
> removals and re-adds, and the login park finishing in eight seconds.  I
> still could not measure the namespace move, for the reason given in v6.
> 
> Yehyeong Lee (6):
>   IB/isert: do not publish connections being released on a second list
>   IB/isert: drain the QP without holding isert_conn->mutex
>   IB/isert: tear connections down from an ib_client on device removal
>   IB/isert: drop the promotion reference when a connection errors out
>   IB/isert: do not build a new isert_device for a device being removed
>   IB/isert: only reinstate a connection that reached full feature phase
> 
>  drivers/infiniband/ulp/isert/ib_isert.c | 395 +++++++++++++++++-------
>  drivers/infiniband/ulp/isert/ib_isert.h |   9 +-
>  2 files changed, 294 insertions(+), 110 deletions(-)

So what do you expect from us now? You didn't bother to invest time into it,
by all these resubmissions, you clearly showed us that this is 100% AI work,
not reviewed, not tested, but marked for the stable@.

Thanks

> 
> 
> base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
> -- 
> 2.43.0
> 
