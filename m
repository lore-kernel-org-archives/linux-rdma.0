From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm: event plig-in API fixed to compile with g++
Date: Wed, 7 Jul 2010 16:58:25 +0300
Message-ID: <20100707135825.GK22860@me>
References: <4C2312F0.8020308@dev.mellanox.co.il>
 <20100705181143.GG22860@me>
 <AANLkTilUABmkKA8W-vIVWyTuDR8Gte9jtxmDUL1SiAte@mail.gmail.com>
 <20100705184144.GH22860@me>
 <AANLkTina2lO8M65L465jXjO1ukaAudUO1ZNk8opfKtQc@mail.gmail.com>
 <20100705225227.GI22860@me>
 <AANLkTinWEuCtSSfVc1Ti0SjgmUl3vnEY-DDd1nkWtlne@mail.gmail.com>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25A116CA8F@orsmsx501.amr.corp.intel.com>
 <adamxu4mtov.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <adamxu4mtov.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10:00 Tue 06 Jul     , Roland Dreier wrote:
> 
> Seems that anyone who cared could already easily write a tiny shim in C
> and then write the rest of their plugin in C++.  Or are there deeper
> issues than names of methods?

I think that it is likely deeper. For instance if C++ stuff will use
OpenSM structures, functions, include files, etc.. So this will
automatically will add some limitations for using normal C in OpenSM
core code.

I highly suspect that all those "requirements" are resulted by using C++
in some third party's *proprietary* plugs. Which is fine in general, but
completely unrelated to OpenSM development - I don't think that we should
care.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
