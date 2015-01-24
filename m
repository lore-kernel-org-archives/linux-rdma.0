From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH FIX For-3.19 v5 00/10] Fix ipoib regressions
Date: Fri, 23 Jan 2015 20:58:40 -0800
Message-ID: <CAL1RGDWPaOMAALwVSwkGdjqTSQUxqaqB-qZTF8dOP1j2iza8BA@mail.gmail.com>
References: <cover.1421936879.git.dledford@redhat.com> <CAJ3xEMi7mowr_qFMUXtM5m8p974qF39nPf-Qh-NOYK_jUzswSg@mail.gmail.com>
 <1421999125.3352.265.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1421999125.3352.265.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eyal Perry <eyalpe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>> Doug, Roland - eight rc1 patches followed ten rc6 fixes - sounds a bit
>> too much to me.
>
> We can do as we wish upstream, but these are going live in our product
> ASAP.  The original 8 rc1 patches took so long to get upstream that they
> had already been live in 6.5-z and 6.6 and were slated for 7.1.  We had
> a few customers report problems, but not as many as you might think.
> The new patches are going to go out and fix those problems, period.  I
> can't wait for 3.20 to fix these issues.  C'est la vie.
>
> FWIW, I expect that these patches (plus the one patch I didn't put in
> this same thread) to be live on production machines probably within 10
> days (or less).  I'll let you know how that goes.

Given the level of testing you've done, and the fact that the changes
are going to be in a Red Hat release, I'm inclined to try to get all
this into 3.19.  It may be more than Linus would take, and it's more
than I would like to take so late in the cycle, but really it seems
safer than reverting back to the status quo ante.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
