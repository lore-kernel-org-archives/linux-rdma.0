Return-Path: <SRS0=3rQv=ZW=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDC23C432C3
	for <linux-rdma@archiver.kernel.org>; Sat, 30 Nov 2019 18:04:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9243E2075C
	for <linux-rdma@archiver.kernel.org>; Sat, 30 Nov 2019 18:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1575137060;
	bh=Jq+0QWF+G2UqV/pJYC/7P5NiRyF2boAYyRsnf9uoUl4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=cV1bPSBchXZj8BoKjJF3fSAIgJ7/8n/h0wazj7bCCiUxj3PPzAMh/6P1WmidOCR4Z
	 Z6QOOrv8NwYjGk1U1zGkKxxVIaVKn9zvykxivEYqEedJHLEV3iqHjITh3871Wz+lGV
	 2fB7e7UXqFn93pAgKPxXVJsUiSeEnRjMfjGkrCEw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbfK3SET (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sat, 30 Nov 2019 13:04:19 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:36470 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726799AbfK3SET (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Sat, 30 Nov 2019 13:04:19 -0500
Received: by mail-lj1-f194.google.com with SMTP id r19so1473277ljg.3
        for <linux-rdma@vger.kernel.org>; Sat, 30 Nov 2019 10:04:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KeWj67j7t721qCfI+6RxBQ+EmlY5X5BSvtw/QcsnMlI=;
        b=XsL2lb1FqLtCS9t+CqPorBjTDZfJvIvGqBi0ylnknkqqXQseOaRQaOWu/tb9DhKJzR
         x7ytWVqaMqaxS+rJJogCAe5sHqKPDP9Yxts6Nqc2xTQdGcrm2XMQYmSAm7Z8PBly5old
         FXQc3INX/SwS53DN6wz/J5itJUXkelIOzYTsQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KeWj67j7t721qCfI+6RxBQ+EmlY5X5BSvtw/QcsnMlI=;
        b=hkJNB/LGhrjU1VvaOVFh+mQEPoDXLGXs6DeyALSV499mZ/a84tR0vyAFbo5P99Ebwt
         Ivi7EwiCehqIEuuelGFRVP2/JErcQ7yvP8HPYxWrRg0UDtlnkNXjZX1i3YpVEFVQtnLq
         xHCxqo4M9iJa9WRGbtSRE7faDK1kBJndsr6timEVnIZ1/4BBm/yKDNEu/SEpRkMBE49Z
         kA8G7+c1BFRAvJU87PQ++DxnWTG0bC9j9tCCJ/JxlHoIgfVDDQcBvVAhH2RMsAyhBNP2
         qebsN00C1Z/Llml8WKEnyYrYHCAwmFi9U9kjwV77b9LIpcVNnkvf0o7n0z94K4Yv64G6
         hv5A==
X-Gm-Message-State: APjAAAUrw+SkXX8XnY0Q3OUXlI0C6psmnSCnTxOoHg6qmRmx6T9IL/Lz
        K+U2it5aZ7UQIV6Phv+bY0itR7ys4zo=
X-Google-Smtp-Source: APXvYqzZwTanhSeIffwp25HMe7xhfbEVkNlJM30Fq+/xm99Pqr62M3j017Nc14JXRI0G4Cy1Lhn/lA==
X-Received: by 2002:a2e:910b:: with SMTP id m11mr16785098ljg.213.1575137052611;
        Sat, 30 Nov 2019 10:04:12 -0800 (PST)
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com. [209.85.167.48])
        by smtp.gmail.com with ESMTPSA id v5sm7224079ljk.67.2019.11.30.10.04.10
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 Nov 2019 10:04:11 -0800 (PST)
Received: by mail-lf1-f48.google.com with SMTP id r15so21928460lff.2
        for <linux-rdma@vger.kernel.org>; Sat, 30 Nov 2019 10:04:10 -0800 (PST)
X-Received: by 2002:ac2:555c:: with SMTP id l28mr4691328lfk.52.1575137048166;
 Sat, 30 Nov 2019 10:04:08 -0800 (PST)
MIME-Version: 1.0
References: <20191125204248.GA2485@ziepe.ca>
In-Reply-To: <20191125204248.GA2485@ziepe.ca>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 30 Nov 2019 10:03:52 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiqguF5NakpL4L9XCmmYr4wY0wk__+6+wHVReF2sVVZhA@mail.gmail.com>
Message-ID: <CAHk-=wiqguF5NakpL4L9XCmmYr4wY0wk__+6+wHVReF2sVVZhA@mail.gmail.com>
Subject: Re: [GIT PULL] Please pull hmm changes
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>,
        "Kuehling, Felix" <Felix.Kuehling@amd.com>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        Ralph Campbell <rcampbell@nvidia.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Mon, Nov 25, 2019 at 12:42 PM Jason Gunthorpe <jgg@mellanox.com> wrote:
>
> You will probably be most interested in the patch "mm/mmu_notifier: add an
> interval tree notifier".

I'm trying to read that patch, and I'm completely unable to by the
absolutely *horrid* variable names.

There are zero excuses for names like "mmn_mm". WTF?

I'll try to figure the code out, but my initial reaction was "yeah,
not in my VM".

                   Linus
