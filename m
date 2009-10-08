From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] rdma/cm: allow user to specify IP to DGID mapping
Date: Fri, 9 Oct 2009 01:13:48 +0200
Message-ID: <15ddcffd0910081613wb5087eaj14eb65aebb0e91c0@mail.gmail.com>
References: <F0EFC2D8E6A340D48497497670C5969C@amr.corp.intel.com>
	 <F451C333D8CB45E4B4642C6BD1EDD3C3@amr.corp.intel.com>
	 <4ACAF913.3050909@voltaire.com>
	 <AA7E7C8FC2A04B9688CD69CEB7355DF8@amr.corp.intel.com>
	 <15ddcffd0910071523w4f229b14j905ad170ceb8c21f@mail.gmail.com>
	 <9F4DE6A2B4F644698E94F00C4FEEF30A@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9F4DE6A2B4F644698E94F00C4FEEF30A-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 8, 2009 at 1:42 AM, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote=
:
> My intent, which differs from Jason's, was to fully support the exist=
ing
> librdmacm interfaces as they are defined.

yes, I agree this is the way to go

> Implementation wise, if the user of the librdmacm calls rdma_resolve_=
addr with a
> src address, it's easy. =A0Without the src address, it's hard, but I =
may just be
> missing some easy interface for finding the src address.

note that dst can map to multiple src addresses, so you're just
looking for one of them... its doable, I will get you the details if
you still need them


>>> If a user sets the wrong address mapping or route, they should only=
 affect themselves

>> I wasn't sure to follow this comment, can you elaborate a bit more?

> I meant that if some bogus app wants to specify an IP to GID mapping =
that's
> invalid, the incorrect mapping should only affect connections for tha=
t app.

yes, this makes sense and I believe the rdma-cm code is written such
that one bugus ID doesn't leak its defections to other IDs

> I can somewhat implement an ACM + librdmacm solution entirely in user=
 space by
> layering the librdmacm over libibcm. =A0Because of the event reportin=
g, it would be limited
> in how it could be use, and is unlikely to be something that would ev=
er be supported.

yes, it would be limited and not really supportable, going that way
for research / experimentation and development is fine, just make sure
to never release that...

> Technically, rdma_resolve_addr could remain unchanged, in which case =
it will do
> everything it does today, which may include sending an ARP.  This is =
the
> specific operation that I'd like to avoid.

again, apps (both user and kernel ones) do use rdma_resolve_addr and
we want them to keep doing so (I thought we agreed on that). For
staging you may develop the type II address resolution prototype on
top of libibcm but later rdma_resolve_addr would call IBACM and then
sync with the kernel.

Basically, can we agree that rdma_resolve_addr(src, dst, timeout) of
type II it would look like

if (src)
  rdma_bind(src)
else
   call_some_user_space_networking_api_to_convert_dst_to_netdev/src
next,  now we have dev/pkey
- call ACM to resolve dst IP to GID and use dev/pkey for that
- sync the kernel rdma_cm with the resolution if needed for the
state-machine (hopefully its not a must at this point and can be done
when calling set_path).

Or
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
