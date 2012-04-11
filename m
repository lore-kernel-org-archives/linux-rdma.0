From: Jim Cromie <jim.cromie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 02/11] ipath: replace open-coded ARRAY_SIZE with macro
Date: Wed, 11 Apr 2012 12:02:58 -0600
Message-ID: <CAJfuBxx7=Eoj8m7MgKCfuJnJwa0D0JsnKTP22Wp8CvVPYAw2oA@mail.gmail.com>
References: <1334105725-9081-1-git-send-email-jim.cromie@gmail.com> <32E1700B9017364D9B60AED9960492BC791647@FMSMSX108.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <32E1700B9017364D9B60AED9960492BC791647-AtyAts71sc88Ug9VwtkbtrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "infinipath-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org" <infinipath-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "trivial-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <trivial-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 11, 2012 at 11:13 AM, Marciniszyn, Mike
<mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> From: Jim Cromie [mailto:jim.cromie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
>> Subject: [PATCH 02/11] ipath: replace open-coded ARRAY_SIZE with macro
>>
>>
>> Signed-off-by: Jim Cromie <jim.cromie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
> I noticed a similar issue in ipath_iba6110.c around line 599.
>
> Do you want me to correct or do you want to catch it with a single patch?
>
> Mike

interesting - spatch didnt do it cuz the array.cocci file
checks for <liinux/kernel.h>, and didnt find it here.

my tree is on another branch now, can you do it ?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
