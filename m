Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC9831A275
	for <linux-rdma@vger.kernel.org>; Fri,  4 Sep 2026 00:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788480223; cv=none; b=o4wIKP4uc1ueCC+4Hd62UyDOf2nQ33GYnOwe+tTTwaJ33+PZ2jBnKT8z3V+4VhwboxJEeAJ++tQwUWGOLrwG+EMUnR5TaQr0Enq7KDlfU8IrJbs6pf67jwChEM4IbD/Q17JrgqyuGSMutGITOIlGgJK0s8nFqBUDElslp3hhpgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788480223; c=relaxed/simple;
	bh=D0nHprDzWaQ5vckhiU0yy/mBG86ygw/J9FkMZWTC+ag=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PQ78EdTe3W+R+k6M3XJu6zz/tC6+OPtGJhCV+4T1tBAwgHAXgqZTyC+mv4Zm1YjdTi6KHquv3QfQ/cFm2UAGZkau/ljqv63L3HdmZnbtyGNZhhrbvlCCG900b+SGurhAb7KDagWM+YFbPMN65jL+EkiJmnf2C8pYE2WhV3vxeys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=Vd5RKA0d; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Vd5RKA0d"
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-9371bcf1f8fso33889385a.1
        for <linux-rdma@vger.kernel.org>; Thu, 03 Sep 2026 17:03:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1788480220; x=1789085020; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kOea8DDTPYAMKujTIWToVwz9oXeaPyJmeAGA6YNU+9U=;
        b=Vd5RKA0dnK02QIh7lYCqsjPgygW/Un5DOuB286JjovJdvds3qGkY8PZlaEZ2IEmlDt
         hjR/VEESFQHY5P+9BEICzPmT8hwJqun698AvXR66rTzNOVRC9jsI/P5kNX2tVpxRplh2
         +woElaloslHHsnHsJcXDan8jUrtsaNKFx2azkxFu0d9uekYZXaZVdFxWwNeRgHpXqQ3L
         IERvwWWkmN/j4arhhZvn4DChHIZTEBGhh8XQjJOT3OF7XPo/DntruoUMcTKhR0d8ZCSB
         93M5dnSEmWRu3qvM+Oj+ttirvW9+G+NE1okpmjF8MT+nMT9FDqLVa/Vtguj7vfvyAjAQ
         J/cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788480220; x=1789085020;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kOea8DDTPYAMKujTIWToVwz9oXeaPyJmeAGA6YNU+9U=;
        b=BnbOWpr0xT5XKBb9JHZHbZ0IZn9Bj6DtPesj8vLnkMTt0PWH/klrMdQYtmAVJFRF9N
         rXySviydJqOfmjstmN13dc1fvBJOMaVYrP2hr/ppPIw+swLhvLLiCDUfTL7khmVeAjJN
         6/NWRkYskRuhqG2Ym4UN8p90+N54V00SHS2fJFP2hLTzDKr/1ic2CEvKqZMtE0WtKZDZ
         8ZSvIhFxMOTthQ1YGstRiNpPBHTqr56kWv4fOtQoN/11fwJpPAt797ae4ADBdWBiRQ8c
         Mf1rMLkylWHS661B72Ve1nF7np5/ydgjarLqLXQwPduesRwixHQyCc+TTQ7DSTNNb8mm
         CMmQ==
X-Forwarded-Encrypted: i=1; AKwUvBzv7eWJzKCNVw+8n9bYFX+S4Ei7cVaCRXrXts5Mv5r9DL9ZTxzWFQ1iFLjlxA9mOCtn7wx7CtG6o5Bf@vger.kernel.org
X-Gm-Message-State: AFuF++lujXYQKqf6KbRPww1wr5zLnmMRegCQIt0rtpRCdIMTd0Y15p1l
	/BEtF6DruMYKnZeaTwD91yXH+GSuY/awK/MhmB25AVa6qjhEivV1dwYGtAkFyxcpu5FgOTaAkmt
	qwf/O
X-Gm-Gg: AYBFou0sKre1Sj+LWxkYbP2jk+zLr1CDUFoR9T/ZDhtM0Xbbtll9+yHzOFBEpl+fDkZ
	CkOb4QMTplmQcg7+0rdleapaYUmwTcT3/DTin1ujfins00FLNAjceYXJNSX/lIRNcbmZHbBPYm2
	vH4dEdRm59h6NwUtQ0uMLquky24AYW1Fokdfa1XWJdLM36Q7LpLybxW1StgJgJWVBWuQRYIivuT
	/JRHdwQGKMhe4Kiz6XzpNEQAzT70N+qVaN8ziPc6jNIzJbxvAZ0QkbZUZwlo0cCDO+gBu3s2RmY
	X0+H8T7OKHWa2ODsCY/+yzxvQRL9gzSTDUBrwaU3p2+gsXQUEdc/hl/vTHwvBNKMDkEoh5xWykA
	AxF8S860BXAGB1/Us9uV/qu9qYezVS/kprsIxGg9bzPRKsCN9iJeyhM6DOZAf8fN2O/MU8lxWur
	2+scnxZ6LJ+hNyd7NKVB7lLQ5VDtW05mGtCBxMtB39gAcGKx/+2oLLOQp/ffWO5wPTDFyf3Yn4a
	TifImemYdA7tkqySCtxhv2PF3wbkRkseuCewQpcFaOlnw==
X-Received: by 2002:a05:620a:3725:b0:937:3aae:1385 with SMTP id af79cd13be357-939803241c0mr201191885a.11.1788480220331;
        Thu, 03 Sep 2026 17:03:40 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9397fb655c3sm83981585a.27.2026.09.03.17.03.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 17:03:39 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1x2HP8-00000000jYc-1nkF;
	Thu, 03 Sep 2026 21:03:38 -0300
Date: Thu, 3 Sep 2026 21:03:38 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: leon@kernel.org, Dean Luick <dean.luick@cornelisnetworks.com>,
	Breandan Cunningham <brendan.cunningham@cornelisnetworks.com>,
	Arnd Bergmann <arnd@arndb.de>, linux-rdma@vger.kernel.org
Subject: Re: [PATCH v5 00/24] Migrate to hfi2 driver
Message-ID: <20260904000338.GP2890729@ziepe.ca>
References: <178845806706.2825126.2210865708266527909.stgit@awdrv-04>
 <20260903175949.GO2890729@ziepe.ca>
 <4d55cfa6-ee84-4688-b15b-3c35b06a89fd@cornelisnetworks.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d55cfa6-ee84-4688-b15b-3c35b06a89fd@cornelisnetworks.com>

On Thu, Sep 03, 2026 at 02:22:05PM -0400, Dennis Dalessandro wrote:
> On 9/3/26 1:59 PM, Jason Gunthorpe wrote:
> > On Thu, Sep 03, 2026 at 01:54:27PM -0400, Dennis Dalessandro wrote:
> > > While sharing similar bones, the chip for the Cornelis Networks next
> > > generation fabric technology has some fundamental differences that
> > > resulted in a near complete re-write of the driver. It also does not
> > > use the private cdev interface that the hfi1 driver exposes. After
> > > discussing this with the RDMA maintainers we have decided to go with
> > > the approach of moving to a new driver and declaring hfi1 obsolete.
> > > 
> > > It is desirable to keep hfi1 around temporarily to let user APIs
> > > catch up to support access through the uverbs device rather than the
> > > private hfi1 cdev.
> > > 
> > > This driver is designed to support future products as well.
> > > 
> > > Portions of this series were developed with the assistance of a large
> > > language model (LLM), reviewed and verified by the author. Each
> > > commit affected carries an "Assisted-by: LLM" trailer per
> > > Documentation/process/coding-assistants.rst.
> > > 
> > > This series applies on top of the rdma/for-next branch.
> > > 
> > > Changes since v4:
> > > - cport.c: rate-limit the "Op N SS failed" error log in cport_req_fn() and fix a
> > >    use-after-free where msg->req->hdr fields were read after cwput(msg) had
> > >    already freed msg, by moving the error log before the cwput() call.
> > > - mad.c: treat undersized CH_OP_UMAD_9B/16B payloads in cport_umad_handler() as
> > >    a normal, expected occurrence (e.g. periodic SM keep-alive/poll probes)
> > >    rather than a protocol error; count them via n_vl15_dropped and silently
> > >    drop instead of returning MSG_RSP_STATUS_INVALID_STATE, to avoid flooding
> > >    the console.
> > > - Updated the AI attribution trailer on all commits from
> > >    "Assisted-by: AGENT:MODEL" to the simplified "Assisted-by: LLM" per updated
> > >    upstream guidance.
> > 
> > There are over a hundred sashiko messages, this change log seems far
> > to small. Are you addressing them?
> 
> Those were corrected in v3. See the "Changes since v2" or is there another
> Sashiko report I need to look in to?

Yeah, you need to check every time. v4 got hundreds more. This series
got hundreds of comments too.

https://sashiko.dev/#/patchset/178845806706.2825126.2210865708266527909.stgit%40awdrv-04

You probably need to run it locally to handle something so big

Like this for example looks pretty obviously right:

 This file contains structures like diag_pkt that are meant to communicate
 between kernel and user code. Should this file be exported to include/uapi/
 instead of remaining in the internal driver directory? Keeping it in the
 internal driver directory prevents it from being exported to userspace by
 the headers_install targets.

This looks kinda serious:

 This is a pre-existing issue, but does this code allow unprivileged users to
 spoof hardware job keys via user namespaces?
 If an attacker creates a new user namespace, their global UID maps to local
 UID 0 and they gain CAP_SYS_ADMIN locally. When generate_jkey() evaluates
 from_kuid(current_user_ns(), uid), it would resolve to 0. Additionally,
 capable(CAP_SYS_ADMIN) would evaluate to true against the attacker's namespace.
 Should this use init_user_ns rather than current_user_ns() to properly
 enforce hardware tenant isolation and prevent bypassing administrative
 bounds?

And so on.

If you don't fix them now, we will be deluged by bug fix patches and I
don't want to deal with that.

Jason
