Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.43
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793099800;
	b=TjX4eQ31fkmz21lI2LiogLxVrR2o4rKTt8wXxppkDAO4Gqo1LeeEGzhlrjejDtZygH+W
	 LM1ftJblpRJT3U6OojlhgrwA2EdnMyUhZhUcdU9ljXWlxBi4FnS7wRCE3whBUAk+ISE3H
	 +nEKKR8FDSU9w943C2k8tFSYT/JOQzgTmDzDYO52Vro/1+mEIgmxzDbBpwU4ypyrG3ijC
	 TVfBAMyeFGhUKmq+YbCieSd+dnoygWcPp1GdDi3sNbN1iplh2M3E1b1zJFu9pZfmSEsg9
	 qkv7gOUz6zznRn/oKpgEu0WOeTQQHagYve2AeexoTUIuIySGithJWgWVhrzB5MS1q7Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793099800;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=5deC3X/qxpVsXoeGtzPsqbNEXUMUJEJ5cVWR11tROm4=;
	b=ziZF787LqeJ9WV76u6zAg38IKXw6LfUk5LHYeyhEx+7JORrHwPM3EyGvhPNJDI7XTkuX
	 tFD0BMKMz5YctiiaSoihD0E+JRRpbl1nNFEaNOcIKgfPE+mu+KolNtFwQciNxGKKreSMN
	 XFOZQTgH9us/ZmSpyAu5Aghzn8ysLMmjoX8mcLpdPK08ZzrJHOkrIk7XgTnncjLCPbGar
	 tYlvMEiGkpDdzjV6nUjxApc28Cazm0hxmAe5/9wGTs+MVdbQvfKZDNaRvIt6y2hOJspgQ
	 ATv0GZ6bAflLEqMD3JwVZJ3oHQ+uHk4Tvgk74emfZPLBlXwbVu6pBczf9T4s8J9fZIQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=OItje1WS;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.43
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 263B1606A322
	for <linux-rdma@vger.kernel.org>; Tue, 27 Oct 2026 11:16:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 263B1606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=OItje1WS
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6aa77d4d968so923216a12.0
        for <linux-rdma@vger.kernel.org>; Tue, 27 Oct 2026 04:16:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793099798; cv=none;
        d=google.com; s=arc-20260327;
        b=cgm2ojgU+Lz168x4eIOeTknPG02mYbiVlt6ll28RdM/ti9P9Nxs2VjDVrkDu3e/DUo
         o2Yrxx8o/5CSTtCDg8FQg+l7G76r+8ksw3wsEMge9/Buw3cu1tMCe4BL4cgjMAZWoHIi
         Ka4ZqCiNitWI7hNWJ2B0dSoLvCI2Gn2UEGoFuenFuHQ5DMngoMHf39h/xeEG+fxnlyoT
         mS85k4m8RoTYjWkJvRxBasEJG2GeAlIB57rjKERQ1eIp2S7RAQYPUwxn5lhibgvGMuEs
         Ygx5pVBKAxEGAPJEjFsj0XTjfrKwsCHTV9An2e4eTEeLFcjtXK78mmghl+y82cWy0H4x
         hNcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5deC3X/qxpVsXoeGtzPsqbNEXUMUJEJ5cVWR11tROm4=;
        fh=D9xHWxCI4LVPJuDSayfkvkCpQI11HldYCjS2ObDXJCI=;
        b=mVIgZgJu2C8EprIWXDfEzjV0JKhdMPZL8Fr0UpEcK0PSmNK9rTX/9tCrGh4b4f1ZiD
         18CFixvJhafJJAkVvICbFjgJ0eRzkVKUx5CI3pTTXRbsMC8Yle/ebO6nOrfTuM3vvLiN
         F1tRI4zJ+jD3ObLtUl36n6YP6IC6r4tFw90ivHy+6xOXDA1oVVAptUWNWS94k/Fxme3L
         DCtGvCJ2RtsirgUZNujbAtJOAja7isaJB/PI9HbMHQJQtbIPJZH6lI1ij2aNPu0vA2EP
         VNIsjCXHFKOpUXT5NgjRxb4mQRH+QWWDE2CJDX3HWaqbqa78GmX7dGTKTxjX3Qb3hs8b
         /Wsg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793099798; x=1793704598; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5deC3X/qxpVsXoeGtzPsqbNEXUMUJEJ5cVWR11tROm4=;
        b=OItje1WSFvSTAstbC+cKC8DxLKsH6FK00DsAH49fDoZJM4EO4zDF2cvDcuLWO+uzqS
         cwjlALT5y/XfGhvM4NumPBnnVtxNqkR274zklkWGeYtVGVPN4X0HGCVFnT1uEGvZRnK7
         nXvBVKdVT5peHBHwly80YwSc2w3NABFnUY8bZGMi2yFkaqhryZnZWRgqoM0rAmgcTW4G
         pPB5Peow/dCV1LKs0Gr8WiSaFfXJkB9ZXZirPTqoTFLn1wrkdx2lWaZq8u0i4zyWP8C6
         bjNEwN2uU/Eooo6t5vu7Fbts5LKooztoJbsyPQReD97VrA6+GO8rzx9/4/oX8l3nJXwk
         paPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793099798; x=1793704598;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5deC3X/qxpVsXoeGtzPsqbNEXUMUJEJ5cVWR11tROm4=;
        b=UqwrHx+DLBBj4gIAUO+y32k3GEBmJU+zYJqkhkAMNzTPluCYx6Ctxrx944d9wr8PSe
         sNbF3Tq3Vhkm53xfqugklmU8C40ew8ciOxbeEgqDeM7A6qcL5sGlu7ATJj93YfRHTW2w
         PsXS7HbDKvqlveacD3KpIKNaP5qQGbKy0h+BnbjoBwmRVUcVAHu4D0bOHHgaseo0LNyd
         EVF4BfH1tD2/fMLkgLglSsqVC7yrT1LAAesb0hMWI93PZpZXDtBQx0nfntpb1/0D1wvl
         434ihuFyZMCuwUerFxAPa/zXXdJn9KgQwKZiyihzZmk+AlPEgnPZePAK21brg0fUBHfO
         cE4g==
X-Forwarded-Encrypted: i=1; AKwUvBzBrlhfQpfTVJrgxrcIu9CCGGigJFSOPm3cFFGTHssoiQk+vovLuX4JQidv+GOhbmIkG5dO4GFjHxeh@vger.kernel.org
X-Gm-Message-State: AFq9FYLzLQzmfDrgEIi6ZO2yN7QJE9aLjp+oBcU/NphYxB+o0I2ZcRX3
	Kk1ewKV3TXeEsTN0gtHnd1XTWqkl2L3Le0arLZAR/IfN1EJ+kseaTAMAFiseWlzvIW6p8kEQmS2
	W+3PRHxcyZUqHFNY2/n0ThIwW97ORFcY=
X-Gm-Gg: AYBFou1O7TPSUElmCLXgCmw5HzFUkNx1SFX2JmfcQCdW/5l4Yy6LbDG5Ke6krpFDUUu
	y1z7F+fTKFckY1TyaStV385tMRfiLBUxRBK0jhx4TP3PqT5iN6A9/RYQ9plEknxoa7+J73YjZSf
	Io84B6GSC2Y34UWqnpZzjC6WUf7Hhs7XzcDYHYGSgY1JEL/THUq5WL049n7M/exHeNYi510p2uk
	e27D2wLhvjCrJPwL0u/VzTenKUtYJivl5RDsuUm49B2M7Q9xvvm8yEUv8pPvhfcp/Ld3XQLzUvP
	4Yy0B7Q7MCLo26TijuzCN48Gkxu03BOzQdqiyx2BKuwpWrmxDyISO6YYMFk/Ttos3J6OiBBtNeB
	DtzkpKtHt+4qfbj56KPXyBoO90Vr+6CcnJuY9FwL+65n6RnH7I+ipdm1qUDpud8w+25+6
X-Received: by 2002:a05:6402:a205:20b0:6b4:28d7:7b63 with SMTP id
 4fb4d7f45d1cf-6b4429fa178mr11365764a12.0.1793099798184; Tue, 27 Oct 2026
 04:16:38 -0700 (PDT)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261013091716.1210420-1-nicoyip.dev@gmail.com>
 <20261013091716.1210420-3-nicoyip.dev@gmail.com> <atisUaV2eIC2yTvX@linux.alibaba.com>
In-Reply-To: <atisUaV2eIC2yTvX@linux.alibaba.com>
From: Chengfeng Ye <nicoyip.dev@gmail.com>
Date: Tue, 27 Oct 2026 19:16:26 +0800
X-Gm-Features: AclHuK_A9PQEX0bWaCldRlg_sgr4SoZSYs9VVnOgllyUlJVTjvMgBfD6Uvd22n8
Message-ID: <CAAo+4rXas4BS85yfiDSPvDhzpWkjoKBiZSHn9VeV0VcATTO0Aw@mail.gmail.com>
Subject: Re: [PATCH net v3 2/3] net/smc: serialize early link group cleanup
 with termination
To: dust.li@linux.alibaba.com
Cc: alibuda@linux.alibaba.com, sidraya@linux.ibm.com, mjambigi@linux.ibm.com, 
	davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com, 
	tonylu@linux.alibaba.com, guwen@linux.alibaba.com, horms@kernel.org, 
	linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Dust,

Sorry for the late reply.

On Wed, Oct 21, 2026 at 8:13=E2=80=AFPM Dust Li <dust.li@linux.alibaba.com>=
 wrote:
>
> On 2026-10-13 17:17:15, Chengfeng Ye wrote:
> >smc_lgr_cleanup_early() enters __smc_lgr_terminate() even when another
> >teardown path has already claimed lgr->freeing. Both callers can observe
> >lgr->terminating clear before either sets it, then tear down the same
> >link group, causing use-after-free and duplicate resource release.
> >
> >  BUG: KASAN: use-after-free in __smc_lgr_terminate+0x393/0x3a0
> >  Write of size 1 at addr ffff8880bf2c0300 by task poc/106
> >  Call Trace:
> >   __smc_lgr_terminate+0x393/0x3a0
> >   __smc_connect+0x2e3d/0x4930
> >   smc_connect+0x42c/0x580
> >   __sys_connect+0xfc/0x130
> >   __x64_sys_connect+0x6d/0xb0
> >
> >Check freeing under the link group list lock before unlinking the group
> >or entering termination. The existing locked freeing transition then
> >claims exclusive teardown ownership; an early cleanup that loses the
> >claim leaves teardown to the existing owner and does not remove the grou=
p
> >from a device teardown's private list.
> >
> >Keep a temporary link group reference across smc_conn_free() and early
> >cleanup in smc_conn_abort(). Once the connection is unregistered, a
> >termination worker can finish without taking its socket lock. The extra
> >reference keeps the allocation alive until the ownership check returns.
> >
> >A new group is published before its first connection is registered. Hold
> >it before publication until registration or failed-registration cleanup
> >finishes. The reference keeps the allocation alive, but teardown can sti=
ll
> >destroy the group's resources before registration. Take the list lock
> >around the freeing check and first registration, nesting conns_lock as i=
n
> >the reuse path. Reject a group already claimed for teardown and clear
> >conn->lgr, since that connection never acquired a group reference.
> >
> >On success, acquire the connection reference before dropping the tempora=
ry
> >hold. A later terminator sees the registered connection and must acquire
> >its socket lock before removing it. On failure, keep the temporary hold
> >through early cleanup and then release it. Reused groups retain their
> >existing reference protocol.
> >
> >This depends on "net/smc: serialize link group free work scheduling" for
> >the standalone freeing bool and the locked early-cleanup transition.
> >
> >Fixes: f9aab6f2ce57 ("net/smc: immediate freeing in smc_lgr_cleanup_earl=
y()")
> >Cc: stable@vger.kernel.org
> >Assisted-by: GPT-6.1-Sol
> >Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
> >---
> >Changes in v3:
> >- Serialize first registration with the teardown claim under the group l=
ist
> >  lock, nesting conns_lock in the same order as connection reuse.
> >- Reject groups already being freed and clear conn->lgr on that path.
> >- Document the scheduling fix prerequisite in the permanent commit messa=
ge.
> >
> >Changes in v2:
> >- Pin newly created link groups before publication, covering the
> >  registration failure handoff to early cleanup. Drop the temporary hold
> >  after cleanup on failure, or after the connection hold on success.
> >- Send after the free-work scheduling fix and reuse its standalone
> >  freeing bool and locked early-cleanup transition.
> >- Pin the link group across the smc_conn_abort() early-cleanup ownership
> >  check.
> >
> >v1: https://lore.kernel.org/r/20260927063607.3691520-1-nicoyip.dev@gmail=
.com/
> >
> >v2: https://lore.kernel.org/r/20261003183237.2284245-3-nicoyip.dev@gmail=
.com/
> >
> > net/smc/af_smc.c   |  8 ++++++--
> > net/smc/smc_core.c | 21 ++++++++++++++++++---
> > 2 files changed, 24 insertions(+), 5 deletions(-)
> >
> >diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
> >index e9f93b3ab435..97b0a0b51066 100644
> >--- a/net/smc/af_smc.c
> >+++ b/net/smc/af_smc.c
> >@@ -1011,12 +1011,16 @@ static void smc_conn_abort(struct smc_sock *smc,=
 int local_first)
> >       struct smc_link_group *lgr =3D conn->lgr;
> >       bool lgr_valid =3D false;
> >
> >-      if (smc_conn_lgr_valid(conn))
> >+      if (local_first && smc_conn_lgr_valid(conn)) {
> >               lgr_valid =3D true;
> >+              smc_lgr_hold(lgr);
> >+      }
> >
> >       smc_conn_free(conn);
> >-      if (local_first && lgr_valid)
> >+      if (lgr_valid) {
> >               smc_lgr_cleanup_early(lgr);
> >+              smc_lgr_put(lgr);
> >+      }
> > }
> >
> > /* check if there is a rdma device available for this connection. */
> >diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> >index 660cd41ec720..c1bb284c4233 100644
> >--- a/net/smc/smc_core.c
> >+++ b/net/smc/smc_core.c
> >@@ -693,6 +693,10 @@ void smc_lgr_cleanup_early(struct smc_link_group *l=
gr)
> >
> >       smc_lgr_list_head(lgr, &lgr_lock);
> >       spin_lock_bh(lgr_lock);
> >+      if (lgr->freeing) {
> >+              spin_unlock_bh(lgr_lock);
> >+              return;
> >+      }
> >       /* do not use this link group for new connections */
> >       if (!list_empty(&lgr->list))
> >               list_del_init(&lgr->list);
> >@@ -999,6 +1003,7 @@ static int smc_lgr_create(struct smc_sock *smc, str=
uct smc_init_info *ini)
> >               lgr->buf_type =3D lgr->net->smc.sysctl_smcr_buf_type;
> >               atomic_inc(&lgr_cnt);
> >       }
> >+      smc_lgr_hold(lgr); /* lgr_put in smc_conn_create() */
> >       smc->conn.lgr =3D lgr;
> >       spin_lock_bh(lgr_lock);
> >       list_add_tail(&lgr->list, lgr_list);
> >@@ -2049,15 +2054,25 @@ int smc_conn_create(struct smc_sock *smc, struct=
 smc_init_info *ini)
> >               if (rc)
> >                       goto out;
> >               lgr =3D conn->lgr;
> >-              write_lock_bh(&lgr->conns_lock);
> >-              rc =3D smc_lgr_register_conn(conn, true);
> >-              write_unlock_bh(&lgr->conns_lock);
> >+              spin_lock_bh(lgr_lock);
> >+              if (lgr->freeing) {
> >+                      conn->lgr =3D NULL;
> >+                      rc =3D SMC_CLC_DECL_SYNCERR;
>
> This should not be SMC_CLC_DECL_SYNCERR, maybe SMC_CLC_DECL_INTERR or add
> a new error code.

No problem, I will use SMC_CLC_DECL_INTERR in v4.

> >+              } else {
> >+                      write_lock_bh(&lgr->conns_lock);
> >+                      rc =3D smc_lgr_register_conn(conn, true);
> >+                      write_unlock_bh(&lgr->conns_lock);
> >+              }
> >+              spin_unlock_bh(lgr_lock);
> >               if (rc) {
> >                       smc_lgr_cleanup_early(lgr);
> >+                      smc_lgr_put(lgr); /* lgr_hold in smc_lgr_create()=
 */
>
> smc_lgr_put() may call smcr_buf_free() -> vfree(), which may sleep.
> And you put it in the spinlock.

It seems the smc_lgr_put(lgr) is added after the
spin_unlock_bh(lgr_lock). Were you referring to another lock held by a
caller? I will keep this unchanged in v4, let me know if anything
should be adjusted further.

> Best regards,
> Dust
>

Best regards,
Chengfeng
