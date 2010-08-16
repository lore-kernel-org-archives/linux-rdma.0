From: Tarick Bedeir <tarick-LDovhz+uhNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: RDMA tutorial feedback
Date: Mon, 16 Aug 2010 11:39:25 -0500
Message-ID: <AANLkTin49UW3==170jBuhMJvJrcxFYGvUCF8-Xyqmz3J@mail.gmail.com>
References: <AANLkTimDVeCu1ZTZTr1TvZF2vkSQ0keDVs4eheriywNN@mail.gmail.com>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF25A9708393@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A9708393-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Aug 16, 2010 at 1:00 AM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wro=
te:
>> When I started working on an IB-aware app last year, I couldn't find
>> much in the way of an RDMA/verbs/IB tutorial on the web. =A0This doe=
sn't
>> seem to have changed, so I put together a few posts on my blog that =
I
>> hope will be of use to the next guy who's got to start from scratch:
>>
>> http://thegeekinthecorner.wordpress.com/
>>
>> I'm very interested in the community's feedback.
>
> I think having something like this is great.
>
> Since you've started this work, additional APIs and functionality hav=
e been added to the librdmacm which are intended to simplify connection=
 establishment. =A0Notable changes include the addition of an rdma_geta=
ddrinfo() call and support for synchronous operation. =A0If you downloa=
d the latest librdmacm package from the OFA site, you can take a look a=
t the new samples, rdma_server and rdma_client, which show how to make =
use of the new functionality.
>
> A few wrapper functions around libibverbs calls were also added, but =
as those are inline calls, their use is limited.

That's good to know -- I'll work on a post describing synchronous
operation and rdma_getaddrinfo().

Thank you for the feedback!

Tarick
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
