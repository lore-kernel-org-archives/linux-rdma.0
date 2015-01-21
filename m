From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH FIX For-3.19 v4 0/7] IB/ipoib: follow fixes for multicast handling
Date: Wed, 21 Jan 2015 12:37:52 -0800
Message-ID: <CAG4TOxO3wTguFbffxPFANrVTQo7=gVDzEAWwoDhh_acNTixXpQ@mail.gmail.com>
References: <cover.1421725318.git.dledford@redhat.com> <54BE7F66.4070404@dev.mellanox.co.il>
 <CAL1RGDVPCH3h7nZMd9=4rFPqbKEGZiXQC+Atvfwj5kWcf2S3Qg@mail.gmail.com> <CAJ3xEMi5vGc-Urv_7RSWCn9-ZAiq0WzVn3y0__jrTc48jM9gpQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMi5vGc-Urv_7RSWCn9-ZAiq0WzVn3y0__jrTc48jM9gpQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eyal Perry <eyalpe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 21, 2015 at 12:34 PM, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> Because Doug's changes fixed some bad, easy-to-reproduce issues.  On
>> the other hand we don't want to introduce new regressions to fix the
>> old issues.
>
> See above, we did introduced regressions.

Yes, I know, that's my whole point.

We need to fix the current 3.19-rc code, and the two choices are to
keep the fixes we added during 3.19 or revert back to 3.18.

Doug's opinion is that your proposed fix is broken, and we don't have
an alternate fix.

So I suggest we revert the whole series from 3.19 and get this right for 3.20.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
