From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: rping is not resolving ipv6 addresses
Date: Sun, 11 Oct 2009 13:52:46 -0600
Message-ID: <20091011195246.GA1397@obsidianresearch.com>
References: <1254957121.23471.17.camel@wilder.ibm.com> <adavdiqn63u.fsf@cisco.com> <1255114672.3533.8.camel@wilder.ibm.com> <15ddcffd0910091353w51bddc60w8452ca107de296fb@mail.gmail.com> <1255122901.3533.20.camel@wilder.ibm.com> <20091009224604.GG5191@obsidianresearch.com> <0AA9B9870A0545E6BCCF3A5EF4BAB34E@amr.corp.intel.com> <4AD18944.1040404@Voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4AD18944.1040404-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "David J. Wilder" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Aleksey Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Oct 11, 2009 at 09:29:08AM +0200, Or Gerlitz wrote:
> Sean Hefty wrote:
> > The rdma cm was never fully coded or tested for ipv6 support.
 
> Sean, even if not fully coded/tested, some work has been done, e.g
> commits 38617c64 "RDMA/addr: Add support for translating IPv6
> addresses" and 1f5175ad "RDMA/cma: Add IPv6 support". I suggest
> we'll try to see what does it take to make this better or even fully
> support ipv6.

Or is right, these are kernel bugs, if nobody is able to work on them
then I think we all have to accept that these parts of the OFA stack
are unfinished and unmaintained - and see if that can be delt with.

> Jason, can you restate what are the two problems you saw from
> David's reports? the 1st was related to scope in link-local
> addresses, and what's the 2nd?

The kernel must not accept a link local address with 0 scope id

When using link local addresses the kernel must bind to the interface
index in the scope id.

The scope is ignored for other addresses scopes.

The rules will be more complex if a source and dest are specified, in
that case the scopes must match.

This is the same basic problem as the other issues regarding ND and
route resolution, the RDMA CM does not follow the same procedures as
TCP does, and the variations produce bugs.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
