Received: from mail-ej2-f42.google.com (mail-ej2-f42.google.com [74.125.228.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F20C14508E0
	for <linux-rdma@vger.kernel.org>; Sat,  3 Oct 2026 19:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791056255; cv=pass; b=kySEroKgfhOMokH2efj4L2F2Fq5gIK5ieRqbC8z2lGM2W3H+c7dVgCx0MhNXB7bVLMqXT0GJUeflvuQBllFMoyx2AKTZG14FGU62pbvg6Z53TSE+RkaCexnzJf2R/1nD3OqEE7jOy8yyWMCkZ3R9aMwoIpQK+hejFHJFH3DQF9s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791056255; c=relaxed/simple;
	bh=RQdISwCIeTHJRNNRYXKnQccif86ZtXCpqBErB1KRL7U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=U9XIFI9TzxLD+GSJFOlvilBOvrfkTCMmTIziMOPd36oZDCp2KDQ2MjMQAsnpRzw3RTeeNa8ZdfrOqCOYFjXcDAWkb+s1ZyBC94ZDy/cG76nr4N6Sr7+oyqsB8aFso01nSb87esh8VOshJGTWsndTODJcHJGLeDJG6wUUtsw4NlM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=p2qBkOJb; arc=pass smtp.client-ip=74.125.228.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p2qBkOJb"
Received: by mail-ej2-f42.google.com with SMTP id a640c23a62f3a-c2e59b029a9so10069066b.2
        for <linux-rdma@vger.kernel.org>; Sat, 03 Oct 2026 12:37:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791056252; cv=none;
        d=google.com; s=arc-20260327;
        b=LM01LqE1EMy5E4uqUWmzf5o1WpoydJTgbRTyWpXkZG4bnonKE85Uv44pv2PIoSU6SH
         9/HO3EBSnbIwOnjALKtye4QGYOAqD40lR6UKuqV41Ll5eSszP+G6SdxbgShc7bC3dAjF
         5JuTHSSUaULd8T9NjjKtbFAi4Mytc2/RPn7D902oGR+gb31uOxwzWd3wUe01LHNg6HFw
         UsfLU8jtg5liuQMbJN1vWeqWZXBg639u2XnAgBWnR1fHzN9qimJBJeUETt6m97hBOSac
         nH59rPcrJwecdSen1wFpaGxkjmekwDXFHkSViiCal1dQb5K7mDIoCBmecCSGcvnV8AVy
         OctA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+1sgNjTuEhjk9Api27Ek7GbjZW7LaWBth9pDAUxc4Wk=;
        fh=akeMxUohyzUbalhCRmGThzR8k1hMdhtyuhz/zRqVQZg=;
        b=TDt9I/bPn4ZJ46BTxz7Z/EBwf6sFUTjdlyPWWUOVF67xUgTxe86TI2LGMTfXlrnItV
         8ljAf2zD1pBbm3gazvadxZILzgrSiSwJYp7JsAXlLUoQ01ICGrIdjBuKZlpLb5pLg7Mp
         8jjVmm5LsWstZ1+PW98djtbtzU08sRWNJECuBvwLPRCekPAfUYyQGCEJGVkL+vfTXzzt
         joGW5LICNEJEXMiNU6WwAYkS+MJCEjTC+jRygCRjUIwIrtTWwqbZWaeA8OSlZ2Szcv0a
         1cjeZaSeeSWAbo76y11o2Si3Ge5MdKbxDavPMWzx2FIGws3c0uEgAM3oR41EvZmCsTo+
         nSVQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791056252; x=1791661052; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+1sgNjTuEhjk9Api27Ek7GbjZW7LaWBth9pDAUxc4Wk=;
        b=p2qBkOJbe0JoIVZCajmcrQTxkDnY+IOH3/Tk7u4MNIVFwtr+MwYQD/b8Wiq+6L1Z5D
         XH8mXaO7g+fmFom3HdXa+rO/y6TynLCKTZZpNl6SscUG+2P0WMrwx5aRc3kjGm6PfhRd
         1Rr8zmBaUPRzZe1ZoIUjLsdfPRDUU8P5zuF9k9YDE+0VfkHUzJduxWdNTQ6ThddUKhmO
         2M7odiGaEisdf693nRTuGLEe1H63qaLVrTKKCXqkbNhho+sqeZzA8Euk8bvc1Bq1rnMp
         omDjAxvICJx04pmTcLSMIRTpsmpop8GR/dN9vInYBmrSD2ufRbKFagmEqiFPTI5+Rh+f
         Ylcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791056252; x=1791661052;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+1sgNjTuEhjk9Api27Ek7GbjZW7LaWBth9pDAUxc4Wk=;
        b=gnDEORb9IMu1sztxy6RIsKj4zmByr8iEBl9tSVASVRTs/YyOYuQtVd/k8KbqmD4oHM
         jp2a9D483qfj06blTTLDNGgFKW7CXJH+dueoGBao4jAgZJ2aC0uh2XTm4SvxFQ1cQ24Y
         M5T8sw3rVL0bjiNlbdmkQ+rsBtHD30xM3N8qZk8Llt0MA7QFL6KEyr1PNxFnahwQywOw
         03IIa4XiwL1agpOpqarBT7RBne8L3ImrdrnAz04vH8pgKVKog/Li3BPplm6sBBZ4UKZG
         8LT7vUce2iV269IIq4Wvp1RUJExckzjivCI4NXeMpmTsY0Kc6m2XVkIWr+uAMV7/tTuC
         IqZw==
X-Forwarded-Encrypted: i=1; AKwUvBzabl3S1P2eiPAPaTYb4bYFHgN0JkKd9lBAAR2oNJ+7p0Dw/v8vxsdxBJoWYIwh0g+yMQDi8GZRVq85@vger.kernel.org
X-Gm-Message-State: AFq9FYI3/1k40+qoFlr2K0EFyhDuEeM7wxmdj+iEuFNTY7QvsgKFv3Im
	9z1bhvdnJbUNgT2QVjbmheIdPb47f5getqKbZODvGEWLhO6McyqF6om64c+htwExMFoWbSEey32
	oTHesT+tCH7HixDJnSfarNPkXiyt2BeU=
X-Gm-Gg: AYBFou1PdKfxacwbJ9Thzjr0tFwK1aOlVKah35Lsytkc0gjp+HVlNuShhPkyWGsw/nv
	VuobMVjtlQOseFCamzzcoP7NfCBkIczG7PI1TQdxEj2pgsMugFzRzYkfFqd3F1y52Eox3E6/py/
	gQwykzXtpU2Tik7Auzan3BbuwHmnqnFJ7aSN2XcVsit4+1i2IyK0hf6SxBWyQr2flhvDJciXwtl
	3o/x88gjJtr7yvziUa9HkCri0jvOzixmTyejnhhNAfEtLzL8jPMlsqTN5r6TL0cksXCW8UIIQbW
	lgG6zMmckuXWZVrg3XBt0LIIuD7Ml6qxosvajlRe/i3GtNE1p7JvtillUqbWBQcd1j0+mgmJjl4
	4ehYe5Et5gGUHpNeS7th1Nw==
X-Received: by 2002:a05:6402:1ed0:b0:6aa:a040:cc0b with SMTP id
 4fb4d7f45d1cf-6af9e26f8demr6033264a12.1.1791056251842; Sat, 03 Oct 2026
 12:37:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260927063607.3691520-1-nicoyip.dev@gmail.com> <179072873236.434549.5842458403458661428@kernel.org>
In-Reply-To: <179072873236.434549.5842458403458661428@kernel.org>
From: Chengfeng Ye <nicoyip.dev@gmail.com>
Date: Sun, 4 Oct 2026 03:37:18 +0800
X-Gm-Features: AclHuK9p6aQ_J43EOVKpodci3vxNOzsM7jVie2jHyLl0wZCCleShlxslsIU4Ncg
Message-ID: <CAAo+4rVATDapayqSFFjRaNxFod=bnUGk66opVVUgdwVBr48FNg@mail.gmail.com>
Subject: Re: [PATCH net] net/smc: Serialize early link group cleanup with termination
To: netdev-bot+sashiko@kernel.org
Cc: alibuda@linux.alibaba.com, dust.li@linux.alibaba.com, 
	sidraya@linux.ibm.com, mjambigi@linux.ibm.com, tonylu@linux.alibaba.com, 
	guwen@linux.alibaba.com, davem@davemloft.net, edumazet@google.com, 
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, ubraun@linux.ibm.com, 
	kgraul@linux.ibm.com, linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 30, 2026 at 8:38=E2=80=AFAM <netdev-bot+sashiko@kernel.org> wro=
te:
>
> Thank you for your contribution! Sashiko AI review found 2 potential
> issue(s) to consider.
>
> Critical: 0 =C2=B7 High: 1 =C2=B7 Medium: 1 =C2=B7 Low: 0 (1)
>
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwor=
k
> know by including "pw-bot: cr" as a separate line at the end of your repl=
y
> (one such reply per series is enough).
>
> - [High] The patch covers only one of the two callers of
>   smc_lgr_cleanup_early().
> - [Medium] Early cleanup can free the link group while a
>   smc_lgr_free_work() callback that has already started is still using=E2=
=80=A6
>
> Pre-existing issues:
> - [Low] In __smc_lgr_terminate() (net/smc/smc_core.c:1573-1574), the
>   comment says "cancel free_work sync, will terminate when lgr->freeing=
=E2=80=A6
>
> --
>
> net/smc: Serialize early link group cleanup with termination
>
> This commit makes smc_lgr_cleanup_early() check and claim lgr->freeing
> under lgr_lock before it calls __smc_lgr_terminate(). This stops early
> cleanup from racing with the other teardown paths. It also makes
> smc_conn_abort() hold a temporary link group reference across
> smc_conn_free() and early cleanup.
>
> > diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
> > index e9f93b3ab435b..97b0a0b510664 100644
> > --- a/net/smc/af_smc.c
> > +++ b/net/smc/af_smc.c
> > @@ -1011,12 +1011,16 @@ static void smc_conn_abort(struct smc_sock *smc=
, int local_first)
> >       struct smc_link_group *lgr =3D conn->lgr;
> >       bool lgr_valid =3D false;
> >
> > -     if (smc_conn_lgr_valid(conn))
> > +     if (local_first && smc_conn_lgr_valid(conn)) {
> >               lgr_valid =3D true;
> > +             smc_lgr_hold(lgr);
> > +     }
>
> [Severity: High]
> This adds a reference for the smc_conn_abort() caller, because the new
> lgr->freeing check needs the link group to still be allocated. Does the
> other caller of smc_lgr_cleanup_early() need the same protection?
>
> net/smc/smc_core.c:smc_conn_create() {
>     ...
>                 write_lock_bh(&lgr->conns_lock);
>                 rc =3D smc_lgr_register_conn(conn, true);
>                 write_unlock_bh(&lgr->conns_lock);
>                 if (rc) {
>                         smc_lgr_cleanup_early(lgr);
>                         goto out;
>                 }
>         }
>         smc_lgr_hold(conn->lgr); /* lgr_put in smc_conn_free() */
>     ...
> }
>
> The hold is only taken after registration succeeds. On the failure path,
> smc_lgr_cleanup_early() runs without a reference of its own.
>
> For SMC-R first contact, smc_lgr_register_conn() fails through
> smcr_lgr_conn_assign_link() only when the new link is no longer
> SMC_LNK_ACTIVATING. As far as I can tell, that happens only when
> __smcr_link_clear() resets the link inside a teardown's smc_lgr_free(). T=
hat
> teardown drops the link's lgr reference and then the initial one. For
> example:
>
> smc_smcr_terminate_all(NULL)   /* reboot notifier via smc_lgrs_shutdown()=
 */
>     list_splice_init(&smc_lgr_list.list, &lgr_free_list);
>     lgr->freeing =3D 1;
>     __smc_lgr_terminate(lgr, false)
>         smc_lgr_free()
>             smcr_link_clear()->__smcr_link_clear()  /* link UNUSED, lgr p=
ut */
>             smc_lgr_put(lgr); /* theoretically last lgr_put */
>                 __smc_lgr_free()->kfree(lgr)
>
> The connecting thread (connect() or the smc_hs_wq listen worker) then see=
s
> registration fail and calls smc_lgr_cleanup_early() on the freed lgr. The=
re,
> smc_lgr_list_head() reads lgr->is_smcd and the new check reads
> lgr->freeing.
>
> The commit message says:
>
>     The extra reference keeps the group alive until early cleanup has
>     checked teardown ownership.
>
> The smc_conn_create() caller has the same lifetime requirement. Is a
> use-after-free from early cleanup racing with termination still reachable
> through that path? The window is narrow. It looks like it needs a teardow=
n
> such as a reboot to run during an SMC-R first-contact handshake.
>
> >
> >       smc_conn_free(conn);
> > -     if (local_first && lgr_valid)
> > +     if (lgr_valid) {
> >               smc_lgr_cleanup_early(lgr);
> > +             smc_lgr_put(lgr);
> > +     }
> >  }
> >
> >  /* check if there is a rdma device available for this connection. */
> > diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> > index 9974149659c2f..b166a379753c7 100644
> > --- a/net/smc/smc_core.c
> > +++ b/net/smc/smc_core.c
> > @@ -688,6 +688,11 @@ void smc_lgr_cleanup_early(struct smc_link_group *=
lgr)
> >
> >       smc_lgr_list_head(lgr, &lgr_lock);
> >       spin_lock_bh(lgr_lock);
> > +     if (lgr->freeing) {
> > +             spin_unlock_bh(lgr_lock);
> > +             return;
> > +     }
> > +     lgr->freeing =3D 1;
>
> [Severity: Medium]
> Can early cleanup free the link group while a smc_lgr_free_work() callbac=
k
> that has already started is still using it?
>
> After freeing is claimed here, __smc_lgr_terminate() only does a
> non-synchronous cancel:
>
> net/smc/smc_core.c:__smc_lgr_terminate() {
>     ...
>         /* cancel free_work sync, will terminate when lgr->freeing is set=
 */
>         cancel_delayed_work(&lgr->free_work);
>         lgr->terminating =3D 1;
>     ...
> }
>
> free_work is queued on system_percpu_wq, not lgr->tx_wq. So
> destroy_workqueue(lgr->tx_wq) in smc_lgr_free() does not flush it. The
> callback also holds no lgr reference.
>
> Suppose the callback has started but has not yet reached the freeing chec=
k:
>
> net/smc/smc_core.c:smc_lgr_free_work() {
>     ...
>         smc_lgr_list_head(lgr, &lgr_lock);
>         spin_lock_bh(lgr_lock);
>         if (lgr->freeing) {
>     ...
> }
>
> Teardown can then run to completion. smc_lgr_free() drops the initial
> reference, and the new smc_lgr_put() in smc_conn_abort() drops the last
> one. __smc_lgr_free() then frees the lgr and its embedded free_work, and
> the callback goes on to dereference freed memory.
>
> The commit message says:
>
>     This also prevents early cleanup from racing with the delayed free
>     worker
>
> It looks like the freeing flag only prevents a second teardown while the
> object is still allocated. It does not keep the lgr alive for a worker th=
at
> lost the race. Is the commit message accurate here?
>
> To trigger this, the SMC_LGR_FREE_DELAY_* timer has to expire during the
> creator's abort. That looks like it needs an unusual stall or a jiffies
> jump.
>
> [Severity: Low]
> This isn't a bug introduced by this patch, but the comment in
> __smc_lgr_terminate() quoted above says "cancel free_work sync". The code
> calls cancel_delayed_work(), which does not wait for a callback that is
> already running.
>
> What protects a pending smc_lgr_free_work() is its own re-check of
> lgr->freeing under lgr_lock, not a synchronous cancel. Early cleanup now
> reaches this code after claiming freeing. Could the comment be updated to
> match the code?
>
> >       /* do not use this link group for new connections */
> >       if (!list_empty(&lgr->list))
> >               list_del_init(&lgr->list);
>
> --
> Sashiko AI review =C2=B7 https://netdev-ai.bots.linux.dev/sashiko/#/patch=
set/20260927063607.3691520-1-nicoyip.dev%40gmail.com

The issues (incomplete fix and comment consistency) identified are
addressed in v2
https://lore.kernel.org/netdev/179105277608.1402591.16173087244761956438@ke=
rnel.org/T/#t

Best regards,
Chengfeng
