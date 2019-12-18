Return-Path: <SRS0=iKbm=2I=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B8F3C43603
	for <linux-rdma@archiver.kernel.org>; Wed, 18 Dec 2019 16:53:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3676218AC
	for <linux-rdma@archiver.kernel.org>; Wed, 18 Dec 2019 16:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1576688008;
	bh=8wQs1XkJLWxaSqLQNyUTZjlo2s26d8DLzjXMN4uSzOg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=R3flCPHn4iDI5X42XACo2+p8/l0q709N1W2wYk55WuO4rGLIJUZfPoPbgLw5mUhZt
	 s4KEAja6F78S4lCYrWUhi3I93JzU57E1kKTsnNddTKBv5Ic6wZKQiHoVlo4oSFS0kF
	 wjJAhjdDz9/XlxHzTvcZsR6Q/I5IjUZU+ziGh7qs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727184AbfLRQx0 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 18 Dec 2019 11:53:26 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:44459 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726955AbfLRQx0 (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 18 Dec 2019 11:53:26 -0500
Received: by mail-lj1-f195.google.com with SMTP id u71so2909975lje.11
        for <linux-rdma@vger.kernel.org>; Wed, 18 Dec 2019 08:53:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3qRY5XWsuCN6n8xU9fQoJH+pjwO3CHxgP4k/GmBdPYo=;
        b=IQ/5SIJ292ei03NolmBfEocYNplOmoBhNP+TWlRlx+4myoE2yY3tCOpuPqX84ODewr
         ZxIOOBR4eB7XLKzlxlNHA06k/cN6HUup8nG4oOWMpGflrWzw93Hd0PHehXWWyDZ6ZG3V
         w6hWLdp59SrCGRimV2hdbFAi3ES7UIYg62ve8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3qRY5XWsuCN6n8xU9fQoJH+pjwO3CHxgP4k/GmBdPYo=;
        b=Wdtta43/IZB2LnuLONyvR8UF4WTS5kTWHkIbEPNr8rMtyb8Lj5jMpisJlZkuNmEcs6
         Ld92aWTLuGrft5MmH3ZY6YqHr4c1XH3NV7GDK+IiUCC5+CP6uE0vz0CH4Eq7GHpIv9In
         LGf8M5QfioCIqQAbZ/v+U3sQC5cHYE+qyzTK8AFkE+8Jl7FxfA+0enL2XPVocVmz1E4S
         QZ3Hvy5+EAWzSG5YVLSK5wyny/bLMJYjlWazMcukImhMW92qJTTIRAi1dErxYLeZnTKI
         SiVLcUl0CPARdwZf7Nj+qZuWNN3QUSiziQlUhLPCetCtknCUN3bf4QjAevk6vOqqb5fj
         xPSw==
X-Gm-Message-State: APjAAAVdX8s84e9TQmMzMaU9kLU75ypJu7D0CjtLoqrPw4riu9Sw//au
        Cp9/pnuyjTec1KhMOCtr1guup/mWw6g=
X-Google-Smtp-Source: APXvYqyB0XE5286SS35atXbyKYnAqhk0U5dR6V+JlvSImHBYt6BsJVIRv8B0QGFHeWg3rghp7sz/HQ==
X-Received: by 2002:a2e:7816:: with SMTP id t22mr2535320ljc.161.1576688003573;
        Wed, 18 Dec 2019 08:53:23 -0800 (PST)
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com. [209.85.208.182])
        by smtp.gmail.com with ESMTPSA id n23sm1442593lfa.41.2019.12.18.08.53.22
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Dec 2019 08:53:22 -0800 (PST)
Received: by mail-lj1-f182.google.com with SMTP id j6so2928363lja.2
        for <linux-rdma@vger.kernel.org>; Wed, 18 Dec 2019 08:53:22 -0800 (PST)
X-Received: by 2002:a2e:9041:: with SMTP id n1mr2508178ljg.133.1576688001995;
 Wed, 18 Dec 2019 08:53:21 -0800 (PST)
MIME-Version: 1.0
References: <20191125204248.GA2485@ziepe.ca> <CAHk-=wiqguF5NakpL4L9XCmmYr4wY0wk__+6+wHVReF2sVVZhA@mail.gmail.com>
 <CAHk-=wiQtTsZfgTwLYgfV8Gr_0JJiboZOzVUTAgJ2xTdf5bMiw@mail.gmail.com>
 <20191203024206.GC5795@mellanox.com> <20191205160324.GB5819@redhat.com>
 <20191211225703.GE3434@mellanox.com> <20191213101916.GD624164@phenom.ffwll.local>
 <20191218145913.GO16762@mellanox.com>
In-Reply-To: <20191218145913.GO16762@mellanox.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 18 Dec 2019 08:53:05 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgR7OSE9Bn2+MbOYDbiu7n1RQaQhdc6gkEywXL9rMFcpw@mail.gmail.com>
Message-ID: <CAHk-=wgR7OSE9Bn2+MbOYDbiu7n1RQaQhdc6gkEywXL9rMFcpw@mail.gmail.com>
Subject: Re: [GIT PULL] Please pull hmm changes
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     Jerome Glisse <jglisse@redhat.com>,
        Ralph Campbell <rcampbell@nvidia.com>,
        David Airlie <airlied@linux.ie>,
        "Kuehling, Felix" <Felix.Kuehling@amd.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@lst.de>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Wed, Dec 18, 2019 at 6:59 AM Jason Gunthorpe <jgg@mellanox.com> wrote:
>
> Do you think calling it 'mmn_subscriptions' is clear?

Why do you want that "mmn"?

Guys, the "mmn" part is clear from the _context_. The function name is

When the function name is something like "mmu_interval_read_begin()",
and the filename is "mm/mmu_notifier.c", you do NOT NEED silly
prefixes like "mmn" for local variables.

They add NOTHING.

And they make the code an illegible mess.

Yes, global function names need to be unique, and if they aren't
really core, they want some prefix that explains the context, because
global functions are called from _outside_ the context that explains
them.

But if it's a "struct mmu_interval_notifier" pointer, and it's inside
a file that is all about these pointers, it shouldn't be called
"mmn_xyz".  That's not a name. That's line noise.

So call it a "notifier". Maybe even an "interval_notifier" if you
don't mind the typing. Name it by something _descriptive_. And if you
want.

And "subscriptions" is a lovely name. What does the "mmn" buy you?

Just to clarify: the names I really hated were the local variable
names (and the argument names) that were all entirely within the
context of mm/mmu_notifier.c. Calling something "mmn_mm" is a random
jumble of letters that looks more like you're humming than you're
speaking.

Don't mumble. Speak _clearly_.

The other side of "short names" is that some non-local conventions
exist because they are _so_ global. So if it's just a mm pointer, call
it "mm". We do have some very core concepts in the kernel that
permeate _everything_, and those core things we tend to have very
short names for. So whenever you're working with VM code, you'll see
lots of small names like "mm", "vma", "pte" etc. They aren't exactly
clear, but they are _globally_ something you read and learn when you
work on the Linux VM code.

That's very diofferent from "mmn" - the "mmn" thing isn't some global
shorthand, it is just a local abomination.

So "notifier_mm" makes sense - it's the mm for a notifier. But
"mmn_notifier" does not, because "mmn" only makes sense in a local
context, and in that local context it's not any new information at
all.

See the difference? Two shorthands, but one makes sense and adds
information, while the other is just unnecessary and pointless and
doesn't add anything at all.

                Linus
