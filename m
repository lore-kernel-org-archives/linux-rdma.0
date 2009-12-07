From: yogeshwar sonawane <yogyas-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: release of debug/test tools for dapl and verbs
Date: Mon, 7 Dec 2009 17:29:39 +0530
Message-ID: <b681c62b0912070359m23d21bc2tf614258f2ae398d4@mail.gmail.com>
References: <Pine.LNX.4.62.0912042106220.7602@mailhub.cdac.in>
	 <603F8A3875DCE940BA37B49D0A6EA0AE3C99B6C0@azsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <603F8A3875DCE940BA37B49D0A6EA0AE3C99B6C0-uLM7Qlg6Mbekrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "javed-If5XQcfNmg0@public.gmane.org" <javed-If5XQcfNmg0@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi chien,

TED is an environment on top of uDAPL library. Hence TED can be run
over iWARP adapters using there uDAPL libraries.

Currently, TED source has uDAPL provider limits set for OFED uDAPL
library. Kindly have a look at them (dbg_def.h under src/include path)
and if required, change them. Things should work then.

Till now, we have not tested TED with iWARP adapters. In future, we
will try to do it.

Any questions/suggestions/feedback is welcome.

Thanks & Regards,
Yogeshwar

On Fri, Dec 4, 2009 at 9:52 PM, Tung, Chien Tin
<chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>>can be used over any implementation of uDAPL/verbs over IB. there wil=
l be
>>regular updations with new features, bug fixes, docs etc. suggestions=
 are
>>welcome.
>
> Will your tools work for iWARP adapters as well?
>
> Chien
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
