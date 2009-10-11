From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: rping is not resolving ipv6 addresses
Date: Sun, 11 Oct 2009 09:29:08 +0200
Message-ID: <4AD18944.1040404@Voltaire.com>
References: <1254957121.23471.17.camel@wilder.ibm.com>	<adavdiqn63u.fsf@cisco.com> <1255114672.3533.8.camel@wilder.ibm.com>	<15ddcffd0910091353w51bddc60w8452ca107de296fb@mail.gmail.com>	<1255122901.3533.20.camel@wilder.ibm.com>	<20091009224604.GG5191@obsidianresearch.com> <0AA9B9870A0545E6BCCF3A5EF4BAB34E@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <0AA9B9870A0545E6BCCF3A5EF4BAB34E-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "David J. Wilder" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Aleksey Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sean Hefty wrote:
> The rdma cm was never fully coded or tested for ipv6 support.

Sean, even if not fully coded/tested, some work has been done, e.g commits 38617c64 "RDMA/addr: Add support for translating IPv6 addresses" and 1f5175ad "RDMA/cma: Add IPv6 support". I suggest we'll try to see what does it take to make this better or even fully support ipv6.

Jason, can you restate what are the two problems you saw from David's reports? the 1st was related to scope in link-local addresses, and what's the 2nd?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
