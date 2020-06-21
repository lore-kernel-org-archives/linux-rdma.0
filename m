Return-Path: <SRS0=qlRK=AC=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E483C433E0
	for <linux-rdma@archiver.kernel.org>; Sun, 21 Jun 2020 15:11:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09FC823441
	for <linux-rdma@archiver.kernel.org>; Sun, 21 Jun 2020 15:11:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernelim-com.20150623.gappssmtp.com header.i=@kernelim-com.20150623.gappssmtp.com header.b="Qj1e79Y3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730251AbgFUPLQ (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 21 Jun 2020 11:11:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730235AbgFUPLQ (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Sun, 21 Jun 2020 11:11:16 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79426C061795
        for <linux-rdma@vger.kernel.org>; Sun, 21 Jun 2020 08:11:14 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id p19so2764608wmg.1
        for <linux-rdma@vger.kernel.org>; Sun, 21 Jun 2020 08:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelim-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wlu5CSGF8CrDN81mFhVGaO3IVLDqpGhWNBGwGpsa/M4=;
        b=Qj1e79Y3ru9wpHk0ukJCfQnDoAYKhRkEeGyq9Kn3g2b3ZgpRYn7p4Knlt2rfVMOnHt
         GjZX742CSXvD1f0wZDcErX61WLTCJNkQuAqxM86Uz3Zhi5t0C5FT9RAzeb0wgFYhvyKQ
         c0IZO08Z3SvP/sI/pkQcBSIBUDmu45KLcc6hKhbvnxW6A9zikTodd0QdAU7ATMzaymwa
         aSrkbPSuHCTe7kpRLQxLKiSOJ9GJ+gfqvmrLXci1UTM6187ob8zyO2cuRCqYIS6kDODO
         tC40VFnjaC3g/MpQ6VlfemRa0FvAaGArqpG5ROAXt3V8UC6ziKjW45H6MKyCsNefM4Si
         qW3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wlu5CSGF8CrDN81mFhVGaO3IVLDqpGhWNBGwGpsa/M4=;
        b=oanv55IlqixmhfIVp3XJvNCdjzD9z+Bh/xgCaNSEDVSPq12ZkWOY0fRSX2W7kEyPRM
         TU7Uouv0rKHXcg04lLledLx3kRPsUGIllbnBM4qvQSTgNcFusTgsMlcTe9Sdz1DrFjyt
         zcaDyfhMoKJfGVult/ZGTOcX4V5kbwDtlwejQoa9EpT5xxnWS2IJ/ZyzT3oymLIVFEag
         4ugZ54DE7THvW0hVSgSYpe3x5YymlHga5bJWDTap4J8lf+hEPWfe053G0KI7UGWrbIG0
         KItQhP3rwz11etPxnLDjYOlshSKf5qWIwyuZZA3SAFZcTOFmzkETHuHZACGaTQayuI9m
         79zA==
X-Gm-Message-State: AOAM532o/0gns9saOPNcM4A5o6zP79rZniLHfrB53DxTSXbxk/MPr+uS
        YyLZfkacsNpm4gXPkl2pxamQ4Q==
X-Google-Smtp-Source: ABdhPJyU4j9XhMKvlecebzMKcPjq02ryR4G1WefdAk2S+NHTaXkNFOyyrvqC0FQJqx+uZ4ra1xuTxg==
X-Received: by 2002:a7b:c18f:: with SMTP id y15mr6161450wmi.85.1592752272155;
        Sun, 21 Jun 2020 08:11:12 -0700 (PDT)
Received: from gmail.com ([141.226.9.235])
        by smtp.gmail.com with ESMTPSA id 33sm7524335wri.16.2020.06.21.08.11.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jun 2020 08:11:11 -0700 (PDT)
Date:   Sun, 21 Jun 2020 18:11:09 +0300
From:   Dan Aloni <dan@kernelim.com>
To:     Chuck Lever <chuck.lever@oracle.com>
Cc:     linux-rdma@vger.kernel.org,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>
Subject: Re: [PATCH] xprtrdma: Wake up re_connect_wait on disconnect
Message-ID: <20200621151109.GA3006346@gmail.com>
References: <20200620171805.1748399-1-dan@kernelim.com>
 <AC3CC4DE-C508-4F95-9F0D-B2977CD7301F@oracle.com>
 <E3C3C032-CAB9-4AA7-B574-0A037A4F37FC@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E3C3C032-CAB9-4AA7-B574-0A037A4F37FC@oracle.com>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Sun, Jun 21, 2020 at 10:49:53AM -0400, Chuck Lever wrote:
> >> diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
> >> index 2ae348377806..8bd76a47a91f 100644
> >> --- a/net/sunrpc/xprtrdma/verbs.c
> >> +++ b/net/sunrpc/xprtrdma/verbs.c
> >> @@ -289,6 +289,7 @@ rpcrdma_cm_event_handler(struct rdma_cm_id *id, struct rdma_cm_event *event)
> >> 		ep->re_connect_status = -ECONNABORTED;
> >> disconnected:
> >> 		xprt_force_disconnect(xprt);
> >> +		wake_up_all(&ep->re_connect_wait);
> >> 		return rpcrdma_ep_destroy(ep);
> >> 	default:
> >> 		break;
> 
> This hunk does not apply on top of fixes I've already sent to Anna for 5.8-rc1.
> 
> So, if you don't object, I'll adjust your patch (this hunk and the description)
> before sending it along to Anna.

Sure, go ahead. Thanks for working on this!

-- 
Dan Aloni
