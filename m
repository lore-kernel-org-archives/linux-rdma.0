Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793603308;
	b=HfvZ3VDNvLv6eaC9TGkEqlkm5FTralkEEWAyV4Nati5PaBgMV1yt/BZhhmrnd1zMyuRG
	 rpVMzkNFrEYVk5nxGInGdk7q6tjWGWB6bhzT8yypLCHdNd0Oal3yAJlRXg2ZdCQEkVFZQ
	 pOdObiQglskJCbAwt17xnmGNQHbBQTSynPbyX1TrR4SBesTaVSFSPL1RJRL1UCYzmve1l
	 V2zNKuB3LCE37KVZ31R7DS/v5jBbyGu2eD1NA0lZVTpRwEVPFZI8Bdkw+K1T7+46u3ck8
	 J6IiIMf1oZ/tEEdsK/3RnyDCLcFA6vYwKYNi03e60Khjrs2i/zpGVvUJCK4Jg34rf4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793603308;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=zrcWP2a8X1n8k3Py9mOPaYb/7kRAzdx/GI1swepp1Ew=;
	b=SJLp7VBNL293vmakDTEktCArz9pb5VVa2nEy+mNvOL4hm+Y+BedjYalxEcmxhOpuOu3l
	 4QplyidWLLhfgfkeE2glEoC79OOR8oOo++TW2FuDV8V4GOatJ0DevYbF0NtvMY8dKJ5ws
	 0eMc3sUfVlG1gl6CSBU6T/IPNVug9DWV73xqiR56sNaJpdm4bgtycs+MmNFuc1xmmxb6B
	 1HWiktc7+l+20+GuKuTK+oqE22l3kGosFRsQbJcx5aWqsGAYQbXCZ1kldCQW4BxI6eygw
	 uUBsvlswy2QpS/bCv1YyWJVXjL2yIRBUe0JPg/dWqfMqUR1JJvn1sooUbu69CTejGvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=U2Yo3rKP;
	arc=none smtp.remote-ip=209.85.214.176
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24EA7606A324
	for <linux-rdma@vger.kernel.org>; Mon,  2 Nov 2026 07:08:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 24EA7606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=U2Yo3rKP
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2e9f6a16afcso63855ad.1
        for <linux-rdma@vger.kernel.org>; Sun, 01 Nov 2026 23:08:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793603307; x=1794208107; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zrcWP2a8X1n8k3Py9mOPaYb/7kRAzdx/GI1swepp1Ew=;
        b=U2Yo3rKPnQzXKeMCikld3FP1BamaCBYqlH/U+8nwQJoF8vmIWGUiklJJREDHGCTz6J
         zvSOdftczq1M4eBo3BrVuseaj+ClqinGHa5dYEr7jm2ugPeRPyHoW5rZOt8MyBfYaHhU
         mvknNo3SQw4Ae40W+vezpcZ4+4X6NCq9USjKLAxWAPrX1jhea9oQtknVF0gUrM8CFOOw
         wxzQuXNx2A8VGD0CbpkJGuNsAiDqSqkisjoUzxbpjbb1CcaspfrQCANuE/J1DSFbnk1Q
         0+T7QGVJT8CsxrkqEizciJj2+C3LOIu78Syy0C9ceVBB3SY3dSwsInXDnBYeo6Zmy4T8
         AxyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793603307; x=1794208107;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zrcWP2a8X1n8k3Py9mOPaYb/7kRAzdx/GI1swepp1Ew=;
        b=NrdSwjUJvmtcEzvqMIp18kFTHf92C0T82KV+DJoNMACpef3WZtfIhhVJu+/6rVGqh5
         t7HuVhXeEKc3VzSmQdJwUcpqcMBxgfc4VokXvqJUHdWFgeikQBXi1KDJ/hni66o5XAGT
         dzRlSPqMCO86BvN8fxQJUq9AFK4IwUg1knqyoyHnx6V3uGmKZ6uLOokR/YCL27juoVh3
         c9zaoKOtsjCYSc61+tHdSFy0djcaon7ywBLbPeFCn8E0wOQ7VCzs3yVR6Q1sEKDy+rRH
         SE6o9J62bwHzKLDOxCyegRELEwAIegkw/j3wMBptaW2rHeimHR8MWhxufGpE4mSYfFyV
         YGiA==
X-Forwarded-Encrypted: i=1; AKwUvBzG4ET+/a+81bNUEs3zhfkY8ZHkqZnhqbi2muclS/QfZeYsANOZL4P/LdhL0At9DX6exF19h/f3WnlX@vger.kernel.org
X-Gm-Message-State: APuU4Z+ogM4tBKkuX4xXg7fvH3BVsv59Yf+FhVz1M069FLDPLwbzuAiP
	M9hHJal0zTa3p/HK3pBSvzzk4r8qfpJPJKje/D2RmETiQKjk6yFovS4dDByndoW5rQ==
X-Gm-Gg: AYBFou1+gJszIUmVnSNkJJGQB9aYQw5cfJQ1ZHDDDeVpOxWcklndimU6lWuI/UxdBvO
	pEQudYovf9F5w4dv8G1rcCtaN7ly1Sar/rszZuO1OfAZZNzE48HoCXLnTVwKD9ZCSI9lnQlVoqW
	K507Z18HcQFzuYfDuQorTGM+9NVXb6tS+WfOU2DPqi223xONoCeYnq6la21XerDMIaAaG7uv6UV
	ZeTbjnPqfSXvDF4Leu49g+Xmgqo+B1KX77H2N825E8IMAqwAcGOFCu3XAUMDN7htIyWCrYNUeQv
	gYeozz/d2LVL+o6W150UO2NfKGLeE67Cg7MUc/rVMAG37bZwelHg85R74xvzgeyYtn6jN4kIZI3
	t1vZeV6OSFKh/yl5CneCm9tYcyQ2z1YWCT/B7eUXjG7UH7Ius8C8DGHLaxrvxd1xMfiHbE/Lmix
	HKZW4JUzn+yRswx7THhvEiQtM9piUAv81TsxpBTVghDoP4B9RSqIUHwof1g3LnZulUufzFgl0O9
	euToCb+Nu20ovpvW585Th5+UCO9v7eccj8IwdpM2ogsC7fGMMlbLPjfDNYlcyaWLLDY7OJm8dMo
	sFi4Cqro5BSgYOqp1COdZnzgefF7kayu+XViGEXzXlI4T8txl80bAWLaeCIMWx0OXQ==
X-Received: by 2002:a17:902:dad1:b0:2d5:c090:3810 with SMTP id d9443c01a7336-2eb1b6c6ae5mr17165485ad.2.1793603306869;
        Sun, 01 Nov 2026 23:08:26 -0800 (PST)
Received: from google.com (105.211.142.34.bc.googleusercontent.com. [34.142.211.105])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eb38e9633fsm23648075ad.0.2026.11.01.23.08.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 23:08:25 -0800 (PST)
Date: Mon, 2 Nov 2026 07:08:18 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Chuck Lever <cel@kernel.org>
Cc: linux-nfs@vger.kernel.org, Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>, Jeff Layton <jlayton@kernel.org>,
	linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Logan Gunthorpe <logang@deltatee.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, linux-pci@vger.kernel.org,
	linux-rdma@vger.kernel.org, Shivaji Kant <shivajikant@google.com>,
	Tom Talpey <tom@talpey.com>, Leon Romanovsky <leon@kernel.org>,
	Unnati Sachan <unnatisachan@google.com>
Subject: Re: [RFC PATCH v1 0/8] nfs: PCI P2PDMA for O_DIRECT over RDMA
Message-ID: <aug24hqstLnpzfOW@google.com>
References: <20261006233248.705086-1-praan@google.com>
 <4af1c065-538a-45eb-ad56-6517c29dd126@slotpi15m67>
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
In-Reply-To: <4af1c065-538a-45eb-ad56-6517c29dd126@slotpi15m67>

On Wed, Oct 07, 2026 at 05:20:50PM -0400, Chuck Lever wrote:
> On 10/6/26 7:32 PM, Pranjal Shrivastava wrote:
> > Enable NFS O_DIRECT to and from PCI peer-to-peer DMA (P2PDMA) memory
> > on RDMA mounts. This replaces the initial RFC [1] and builds on the
> > Direct I/O modernization series [2].
>
> Hi Praan,
>
> Good to see this moving.

Hi Chuck,

Thanks a lot for the detailed review!

> > 6. pNFS: excluded for now. Route P2PDMA I/O through the MDS, or let
> >    each layout driver opt in?
> >
> > Known issue: the pNFS check happens at extraction. If a mount gains
> > pNFS afterwards (e.g. after migration), a rescheduled WRITE could
> > reach a layout driver. I plan to decide once per O_DIRECT call and
> > force the MDS path when P2PDMA pages are allowed.
>
> I think we need to have a path to supporting DS I/O with P2PDMA.
>
> The deployment sites that want P2PDMA O_DIRECT are the same sites
> running flexfiles, and flexfiles with a co-located DS is where
> LOCALIO actually offers quite a benefit. So for question 6 I'd say:
> layout driver opt-in, flexfiles first, and the flexfiles LOCALIO
> path is part of that.

Makes sense. Layout driver opt-in it is, with flexfiles first.

> Although it is fine for a prototype, forcing the MDS path will
> always be the slow path. Can v1 be designed so the follow-on is
> additive? As posted it might not be. The P2PDMA refusals sit in
> the MDS-only pgio path and at page extraction, and the decision is
> made once and never revisited where the RPC is built.
>
>  - The krb5i/krb5p refusal is in nfs_pgio_prepare(). Flexfiles and
>    filelayout install their own rpc_call_prepare, so a DS RPC never
>    sees it and gets as far as call_encode, where gss_wrap() encrypts
>    device memory in place before xprtrdma has a chance to refuse.
>
>  - ff_layout_read_pagelist() and ff_layout_write_pagelist() open an
>    nfsd_file through ff_local_open_fh() without going through
>    nfs_local_p2pdma_check().
>
> If the auth refusal lives in the RPC client (any XDRBUF_P2PDMA
> buffer under an RPCAUTH_AUTH_DATATOUCH flavor) and the rest lives
> in the transport, then every RPC gets checked no matter who built
> it, and enabling flexfiles later is a small series on top instead
> of reworking already-merged code.

Agreed, the checks shouldn't depend on who builds the RPC. For v2,
I plan to:

 - Move the krb5i/krb5p refusal into rpcauth_wrap_req_encode(), right
   after the encoder tags the buffer and before gss_wrap_req_integ()
   and gss_wrap_req_priv() touch the pages. Both of them currently
   turn an encoder failure into -EMSGSIZE / -EIO, so they'd pass the
   error up instead. The check in nfs_pgio_prepare() goes away.

 - Make the LOCALIO decision in nfs_initiate_pgio(), which is where
   both the generic pgio path and flexfiles hand a header over to
   nfs_local_doio(). That covers ff_local_open_fh() as well.

 - Add a layout driver flag for P2PDMA, with no driver setting it in
   this series, and decide once per O_DIRECT call. A layout driver
   that hasn't opted in gets the MDS path, which also closes the
   migration race. Flexfiles, including its LOCALIO path, would then
   be a small series on top.

> > 1. Layering: "RDMA transport, !pNFS" is only a hint, and each RPC
> >    re-checks its transport. Should the transport advertise P2PDMA
> >    capability up front instead? That would also allow LOCALIO on
> >    TCP mounts, which this series refuses.
>
> Yes, please. LOCALIO never goes near the NIC, so a TCP mount has
> no reason to be refused. Advertise the capability and keep the
> per-RPC check as the backstop; that covers both cases.

Ack. I'll add a transport capability that xprtrdma advertises. NFS
uses it as the extraction hint, and xprt_request_transmit() refuses
a tagged request on a transport without it, which also replaces the
three xs_* guards you pointed out below. The per-RPC device check in
xprtrdma stays as the backstop.

With LOCALIO out of v2 (below), a TCP mount still refuses P2PDMA
pages for now, but the capability leaves room for LOCALIO to opt in
later.

> > 5. LOCALIO: the check uses sb->s_bdev, which misses multi-device
> >    filesystems. Is there a better way to ask whether a file can do
> >    P2PDMA? Should misaligned I/O fall back to an RPC instead of
> >    failing with -EINVAL?
>
> s_bdev turns out to be the smaller part of this. I went looking
> for ways LOCALIO could still CPU-touch the payload after the
> checks pass, and found these:

[...]

> I don't see a clean fix for 1 or 2. The VFS does not have a "DIO
> or fail" knob, and a filesystem's data path isn't visible from the
> block queue. Perhaps for v1, drop LOCALIO for P2PDMA pages and
> bring it back under a filesystem allowlist when the flexfiles
> work needs it.

Thanks for digging into this. I missed the -ENOTBLK fallback and the
btrfs checksums, and you're right that the cover letter overclaims
there.

Agreed, v2 won't use LOCALIO for P2PDMA pages; they go out as a
regular RPC instead. FWIW, the XFS dma-buf direct I/O RFC [1] hits
the same fallbacks and refuses them explicitly for dma-buf iterators,
so that may turn out to be a cleaner way back for LOCALIO than an
allowlist for P2PDMA pages.

> On alignment: yes, fall back to an RPC. Decide inside
> nfs_local_p2pdma_check() from offset, count and
> bdev_logical_block_size(), and return NULL when it doesn't line up.
> The RDMA path has no alignment requirement, so returning -EINVAL
> here makes LOCALIO strictly worse than not having it. That change
> also lets you delete the two duplicated error exits.

Makes sense. I'll do that when LOCALIO comes back, along with the
short write restart you pointed out below.

> Nits:
>
> 8/8 doesn't build with CONFIG_NFS_V4=n. nfs_direct_extract_pages()
> calls pnfs_enabled_sb(), which is only defined inside the
> IS_ENABLED(CONFIG_NFS_V4) block in fs/nfs/pnfs.h, and the #else
> branch has no stub.

Oops, thanks. Will fix.

> In rpcrdma_marshal_req(), a P2PDMA WRITE is forced to
> rpcrdma_readch without checking that head and tail fit the inline
> send threshold. The READ side checks rpcrdma_nonpayload_inline();
> the WRITE side should too, or fall back to a Position Zero Read
> chunk, or return -EREMOTEIO. From code audit.

Agreed. I'll check head and tail against the inline send threshold
and return -EREMOTEIO when they don't fit, same as the READ side.
The non-payload part of an NFS WRITE is small, so a Position Zero
Read chunk doesn't seem worth it for now.

> On a server returning READ data inline despite the Write chunk:
> you're right that RFC 8166 section 4.3.2.2 requires the responder
> to use the offered chunk, so failing the RPC is correct. It does
> surface as a per-RPC "RPC call returned error 121" printk from
> call_status(), though. A tracepoint and a quiet error path would
> be better.

Ack. I'll add a tracepoint in rpcrdma_decode_msg() and keep
-EREMOTEIO quiet in call_status().

> A short LOCALIO write restarts via nfs_local_pgio_restart() with
> offset and count advanced, and the residual can then fail the
> alignment check with -EINVAL after most of the bytes have landed.

Good catch. This goes away with LOCALIO in v2, and I'll keep it in
mind for when it comes back.

> The same three-line P2PDMA guard appears in xs_local, xs_udp and
> xs_tcp send_request. One check in xprt_request_transmit() keyed on
> a transport flag would cover the socket transports and anything
> that comes later.

Ack, that's covered by the capability above.

Thanks,
Praan

[1] https://lore.kernel.org/all/20261016091919.971295-1-anuj1072538@gmail.com/
