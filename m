From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] opensm: fixing compilation issues in some header files
Date: Wed, 02 Jun 2010 09:28:29 -0700
Message-ID: <adaiq61tn4i.fsf@roland-alpha.cisco.com>
References: <4BAA34B2.9060808@dev.mellanox.co.il>
	<4C04F5E7.8030904@dev.mellanox.co.il> <20100601192205.GV28549@me>
	<4C057940.1020106@dev.mellanox.co.il> <20100602010314.GZ28549@me>
	<4C06084D.3070101@dev.mellanox.co.il> <20100602151806.GF28549@me>
	<AANLkTinyMA8WyFPee755nelj9gxJKTP7mQChYlDkUF4J@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinyMA8WyFPee755nelj9gxJKTP7mQChYlDkUF4J-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Hal Rosenstock's message of "Wed, 2 Jun 2010 11:30:29 -0400")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > g++ can be used as a (better) C compiler. Shouldn't compilation with
 > g++ be supported ?

g++ is not a C compiler.  C++ is not just a superset of C  The
differences in the semantics of void* pointers are just one example; in
addition C++ does not have designated initializers for structures, some
valid C names are reserved words in C++, etc.

 - R.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
