From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 02/11] ipath: replace open-coded ARRAY_SIZE with macro
Date: Wed, 11 Apr 2012 17:13:08 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC791647@FMSMSX108.amr.corp.intel.com>
References: <1334105725-9081-1-git-send-email-jim.cromie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1334105725-9081-1-git-send-email-jim.cromie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jim Cromie <jim.cromie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "infinipath-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org" <infinipath-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: "trivial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <trivial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> From: Jim Cromie [mailto:jim.cromie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
> Subject: [PATCH 02/11] ipath: replace open-coded ARRAY_SIZE with macro
> 
> 
> Signed-off-by: Jim Cromie <jim.cromie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

I noticed a similar issue in ipath_iba6110.c around line 599.

Do you want me to correct or do you want to catch it with a single patch?

Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
