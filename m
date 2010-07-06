From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] opensm: event plig-in API fixed to compile with g++
Date: Tue, 06 Jul 2010 10:00:32 -0700
Message-ID: <adamxu4mtov.fsf@roland-alpha.cisco.com>
References: <4C2312F0.8020308@dev.mellanox.co.il> <20100705181143.GG22860@me>
	<AANLkTilUABmkKA8W-vIVWyTuDR8Gte9jtxmDUL1SiAte@mail.gmail.com>
	<20100705184144.GH22860@me>
	<AANLkTina2lO8M65L465jXjO1ukaAudUO1ZNk8opfKtQc@mail.gmail.com>
	<20100705225227.GI22860@me>
	<AANLkTinWEuCtSSfVc1Ti0SjgmUl3vnEY-DDd1nkWtlne@mail.gmail.com>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF25A116CA8F@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A116CA8F-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
	(Sean Hefty's message of "Tue, 6 Jul 2010 09:21:59 -0700")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > FWIW, I agree with Hal.  Support for external plug-ins written in C++ seems desirable.

Seems that anyone who cared could already easily write a tiny shim in C
and then write the rest of their plugin in C++.  Or are there deeper
issues than names of methods?

 - R.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
