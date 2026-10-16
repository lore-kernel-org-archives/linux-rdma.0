Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAF3D394783
	for <linux-rdma@vger.kernel.org>; Fri, 16 Oct 2026 03:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792122451; cv=pass; b=jOMGKTy2OcLHnVLf8yr8FpLSU7EsnxA5GzTjERheXCahCPjYkQU5W8m4Grwnoxjmi+DCVEu94BwtP1k05NvXBFZERwmcxH3hcKbNQBzqukfiUkuoYbYAPFRAHhNdzAK3HTTv/MqMhlKQzjJWB2gC0d9g1uy/u4sgi27FGiQ6D5I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792122451; c=relaxed/simple;
	bh=yIqaxTNLPE/vMy/0DU9sa+0IDVj0xY6z4OXgkTYvMWU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lU8M/aFM5IFl/xklGcwtO8oOZREYYjklplRfRAFAuwXUj1bCt01Ek2PjkN3TaSLLNmFbPie0E1G+Vhz0lKyPSh8aB3AVlBQW4eO8ljJVn88160EPTZMF+ORpytucEoYSt0wkj7ir/UM+DGQGUFugPBpGkCezGHBtosMJ1IIqZQ0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ze2o046M; arc=pass smtp.client-ip=74.125.82.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ze2o046M"
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-151de818519so1407c88.0
        for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 20:47:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792122448; cv=none;
        d=google.com; s=arc-20260327;
        b=WCdJ4PvqRpF48gqNO+ZmOX+uKbfZjghASk5V6IX36AvrwRBs+SskfeJgr9LMorc1A4
         G4FkCXTJYKb1gWoD3CvYf6lpvE1RiCnv0nwOXrL78ggjq/kxPfjA+NqLlAVWiYmRvhuY
         qrvT3hHsm9hNHd451ZH4DBJhK0vb/ArlxtV3z5ENbPe8OtKyhljzWkA1qViAz0FSdmgn
         EN3b1igujz8JqpGL3pBkU+FtyOuEEAqYCULaGAnnI5oLw3HY6NSlAFNEJeMxP738KkFn
         sxlp1eEWH1XbNsK6DliMIv8Rsdk+PhQRCsndu/ISDtmCL7gQ5A67fuQauZEFcKKa7zw2
         CIBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Gh+SJsV9qd4zf8kFfRpYPnxqBTL6SxzjJrawXU6GjJ0=;
        fh=vCCdkP5TjWW5c1iLETAOm0mm0LZOmo3riw9QRhsBNZE=;
        b=Wy2RF1oeVNpW9JfS5jSmbBtPvlf3U5z0Gc+V3ZBu2mOT65Zd/5Gy0JMjSgLbrQWy+m
         kfEf19OZghnlxIYFNtVdPraPZpD68sLEnYE0uYB42lbWu722XwXdZK/LwdoAxg7nfNTf
         Z3FB23eZrv9HuVTGhowQy8MZBlsR+PlQ0nmSF3CujV6x1AYRXaKRmLpIL8nwvDddHs/v
         LzlYeyUFWFsJTaExvV/6MkK1xG3uixpeBr91hYJgGsFzYOTTOAB/kcMzpDnprunyMndk
         G/HO64/bgCci4q1XunhN9rzdsWAHu667pMcvkRrncB4987Z7OERNWH0nFeROi7F5yiF5
         O/5g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792122448; x=1792727248; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Gh+SJsV9qd4zf8kFfRpYPnxqBTL6SxzjJrawXU6GjJ0=;
        b=Ze2o046MsQnUhX95Qx8RRE6oTjnMyKvrbZUPdkIlQv3ilJV+OCSQYcvGfv2psGX0ok
         7cIkM0oqJ5WWuhIhOfmZNJNRu4A3OfvUYnc+1D5u5/nNwt8GjRfAY6WEcBukbpoD/jug
         5SLFj4AcRQnJ6VRqH+I45R0G1KvSdTbN8k6HaReX0OR5+Qu4VzjWWJDhpReGFWBOd0vj
         96avSwFMqNy1uZqntdfa6I8RYk5odShkNi9ZAkvz7piOyVMpS05lWbVwAv7F/6vxJFfZ
         678yQ0cZUptLYOsvvBAGS73oVaBUNo29Hl73MB+pkaY9DmcNSMUG1lskW6+g3orE2FQ2
         qdqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792122448; x=1792727248;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Gh+SJsV9qd4zf8kFfRpYPnxqBTL6SxzjJrawXU6GjJ0=;
        b=tcZkEAbdtx2KIW7Nvmb4zWoIGRzRahOBLHzunzJqUDR9dY/EjX/P2ElgwlzgO2YeiM
         G2pZUO7pTsq2Usop9Ap2PcW+SgBBQdbwtbCXDM32qIfYKHFM2vMSRRU/xSBUvTfJnCQk
         b4yhKfX7ucmBD3+TGutdo/vDstOECE6OTSvkqwGbxOnCOrREKngFySko6UP8D3/jQX+w
         uJyljJNDqyg15KKsAa2xW29DLzfXtkVkwWC6i6LMM63OQbuzeM2ouI7QuEmPqlujYEb0
         YuOtb+S9SGDge5A0O54F+mzfdOhTfAgJI/88GZlsPoLvgyngbIQwKQAtDMHD2y9wMmdu
         OiuQ==
X-Forwarded-Encrypted: i=1; AKwUvBxMVLLO1UbY25i/ezDRU6EhZX/KV/BA/Y7MPDQR74daBebHxTH+UWqSRUt4XEt8TcKfgOwUgpUn/1E/@vger.kernel.org
X-Gm-Message-State: AFq9FYIk81DknkEWvFV6Ycy+5gxJLQMVaWbFeCxJztFPkuTMrC+zNnc7
	NF8HRTWUwOcfORrt6WUHgEpdSCF1In/U/z7KTSle50DdxghAK5mj28S6ez8iG8WY/49x4ZPIqAb
	dAt7e/f83M4gGAsqVCo5gqErTyGR/rPb8MdESGfAH
X-Gm-Gg: AYBFou2IYv5KSQ9yiNrHn5TfG7dWH21gfHYKOncrz7enh0OQYFuN/lyDXU4qxB1o5/g
	9I0a7QsTyO1JIeOJbQkirtueOWkK+jazxl4RNArINedLPNBhvLhOnIxFOv3k8b8fv6w0XRt6VLs
	fBGbadvb3hyxvGS8o4JjPEGVsoOEd3xPvXaNBYLBMqhCG6AxSPpT86cxWF3LkfVWPawKCHpdg+K
	hmdWc7b3ZNEvvtnvvYsE54+QKNeHKI8XeotfcmSC6zNUrxD7+Bxhl8HUE9p+avReG5Ga2fD4Jze
	JSmg86kfoB452c87VCvgMrcrYHLFUB71z7fSAb5d3FJalkwMvSbYPA==
X-Received: by 2002:a05:7022:170c:b0:17f:fbc9:996a with SMTP id
 a92af1059eb24-182bbde9b6amr279955c88.3.1792122446355; Thu, 15 Oct 2026
 20:47:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261014173945.373295-3-almasrymina@google.com> <179209665863.434549.6637198029989888049@kernel.org>
In-Reply-To: <179209665863.434549.6637198029989888049@kernel.org>
From: Mina Almasry <almasrymina@google.com>
Date: Thu, 15 Oct 2026 20:47:09 -0700
X-Gm-Features: AclHuK_vtqKDxgWFbxG4BSVZCPmFFjYvhXzuIZSuzOmkSqaPQBtSf8jQ4Wou4a0
Message-ID: <CAHS8izMnj6t5CX3THvGoorPa8krD1RvouXzKQpgZOkUMs8Bzow@mail.gmail.com>
Subject: Re: [PATCH net-next v3 2/6] net: skbuff: add napi_pp_get_page() and
 use it in tcp_recvmsg_dmabuf()
To: netdev-bot+sashiko@kernel.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-rdma@vger.kernel.org, bpf@vger.kernel.org, ayush.sawal@chelsio.com, 
	andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org, 
	kuba@kernel.org, pabeni@redhat.com, tariqt@nvidia.com, horms@kernel.org, 
	steffen.klassert@secunet.com, herbert@gondor.apana.org.au, 
	ncardwell@google.com, kuniyu@google.com, john.fastabend@gmail.com, 
	sd@queasysnail.net, ebiggers@kernel.org, kees@kernel.org, 
	aleksandr.loktionov@intel.com, petrm@nvidia.com, u.kleine-koenig@baylibre.com, 
	j.raczynski@samsung.com, wang.zhan@smartx.com, willemb@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 15, 2026 at 1:37=E2=80=AFPM <netdev-bot+sashiko@kernel.org> wro=
te:
>
> Thank you for your contribution! Sashiko AI review found more severe
> issue(s) in other patches of this series. This mail is only an FYI, in ca=
se
> you want to address the nit picks below when you respin.
>
> Low priority / nit picks for your consideration:
>
> - [Low] The commit message says that "no symmetric helper existed to
>   acquire" a page_pool reference, "forcing callers like=E2=80=A6
>
> --
>
> net: skbuff: add napi_pp_get_page() and use it in tcp_recvmsg_dmabuf()
>
> This commit adds napi_pp_get_page(), which takes a page_pool pp_ref_count
> reference on a netmem if it belongs to a page_pool, as the counterpart to
> napi_pp_put_page(). It also converts tcp_recvmsg_dmabuf() to use it,
> wrapped in WARN_ON_ONCE(), in place of the open-coded atomic_long_inc().
>
> > While napi_pp_put_page() releases a page_pool pp_ref_count reference on
> > a netmem, no symmetric helper existed to acquire one, forcing callers
> > like tcp_recvmsg_dmabuf() to open-code atomic_long_inc() on
> > niov->desc.pp_ref_count.
>
> [Severity: Low]
> Is this description accurate? A helper for this increment already exists
> in include/net/page_pool/helpers.h:
>
> static inline void page_pool_ref_netmem(netmem_ref netmem)
> {
>         atomic_long_inc(netmem_get_pp_ref_count_ref(netmem));
> }
>
> io_uring/zcrx.c already calls it in a similar zero-copy rx handoff:
>
>         page_pool_ref_netmem(net_iov_to_netmem(niov));
>
> Documentation/networking/netmem.rst also names page_pool_ref_netmem() as
> the API for holding a page_pool reference. The new napi_pp_get_page()
> calls it internally too.
>
> Compared with page_pool_ref_netmem(), napi_pp_get_page() adds the
> netmem_compound_head() lookup and a netmem_is_pp() check whose bool
> result tells the caller whether the netmem is page_pool backed. Later
> patches in the series seem to depend on that result, for example in
> skb_netmem_ref(), which falls back to get_netmem() when it is false.
>
> Could the commit message explain the page_pool membership check and
> return value, rather than saying no helper existed? As written, it is
> not clear why tcp_recvmsg_dmabuf() doesn't just call
> page_pool_ref_netmem().
>
>

Commit message is accurate. There is no helper that mirror
napi_pp_put_page(), only a hepler that unconditionally increaments
pp-ref and barfs if you give it a non-pp-page.

I think we're meant to ignore low (and sometimes medium) comments,
unless they're obviously correct?

--=20
Thanks,
Mina
