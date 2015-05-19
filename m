From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/mad: Clean up ib_find_send_mad to use only the ib_mad_hdr
Date: Tue, 19 May 2015 21:41:09 +0300
Message-ID: <CAJ3xEMgjC23tcidh2pYrQMSeSzqGG3XztzDEf0eLz8dtYhHTEA@mail.gmail.com>
References: <CAJ3xEMjtndfHJOh-JSTzaXuXTNrx2wzDkBcS67T6AwFztcckgQ@mail.gmail.com>
	<20150514173557.GB10941@phlsvsds.ph.intel.com>
	<555ABF9E.6010502@mellanox.com>
	<1432054868.3114.67.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432054868.3114.67.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 19, 2015 at 8:01 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> I try to stick within the recommended length of git log subject as
> indicated to me by vim when I'm editing my commit messages.  Whatever
> happens to fit inside that limit (or at least close to it, I'm not a
> real stickler on it) I go with unless you really need to capture some
> important detail in the subject.
>
> However, there's no need to resubmit these.  I can always edit the
> subjects in place.  Ira are you OK with the changes I made above?

Doug,

Thanks for fixing these commit titles, looks much better.

The issue I have tried to put on the table goes way beyond this or
that limitation on commit titles lengths. It's about being short,
clear and strict, avoid lengthy names of variables and functions which
add nothing to proper maintenance. Ira, in your next commits, maybe
look a bit around, e.g on commit titles of patches made by Sean to
similar areas (mad, sa client, cm, cma and such), and try to get the
spirit, happy upstreaming...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
