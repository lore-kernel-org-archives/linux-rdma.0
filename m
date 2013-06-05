From: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: Status of "ummunot" branch?
Date: Wed, 5 Jun 2013 16:53:48 +0000
Message-ID: <EF66BBEB19BADC41AC8CCF5F684F07FC4F65D5D3@xmb-rcd-x01.cisco.com>
References: <EF66BBEB19BADC41AC8CCF5F684F07FC4F643196@xmb-rcd-x01.cisco.com>
 <CAJZOPZJc2Dq2jQgRspP_2c1j=4aJ40UxcBEcyiY_mhHPX1ptPw@mail.gmail.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F657918@xmb-rcd-x01.cisco.com>
 <51ADA761.2080107@mellanox.com> <51ADB948.5080903@mellanox.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F659155@xmb-rcd-x01.cisco.com>
 <51ADD489.3020902@mellanox.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F65AE40@xmb-rcd-x01.cisco.com>
 <51AEE53C.2090603@mellanox.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F65C855@xmb-rcd-x01.cisco.com>
 <51AF3FA8.7000900@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51AF3FA8.7000900-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Content-ID: <3FB431422EBF7847820AD5F9C935395B-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Jun 5, 2013, at 6:39 AM, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:

> Perhaps I'm missing something, but I believe ODP deals with the first
> two problems in the list (slide 8), even if it doesn't solve them
> completely.

Unfortunately, it does not.  If we could register(0 ... 2^64) and never have to worry about registered memory, that might be cool (depending on how that actually works) -- more below.

See this blog post that describes the freed registered memory issue:

    http://blogs.cisco.com/performance/registered-memory-rma-rdma-and-mpi-implementations/

and consider the following valid user code:

a = malloc(x);    // a gets (va=0x100, pa=0x12345) back from malloc
MPI_Send(a, ...); // MPI registers 0x100 for len=x, and saves (0x100,x) in reg cache
free(a);
a = malloc(x);    // a gets (va=0x100, pa=0x98765) back from malloc
MPI_Send(a, ...); // MPI sees a=0x100 and things that it is already registered
// ...kaboom

In short, MPI has to intercept free/sbrk/whatever so that it can update its registration cache.

> In the future we want to implement an implicit memory region covering
> the entire process address space, thus eliminating the need for memory
> registration almost completely (you might still want memory
> registration, or memory windows, in order to control permissions of
> remote operations).

This would be great, as long as it's fast, transparent, and has no subtle implementation effects (like causing additional RNR NAKs for pages that are still in memory, which, according to your descriptions, it sounds like it won't).

> We can also allow fork to work with our implementation. Copy-on-write
> will work with ODP regions by invalidating the HCA's page tables before
> modifying the pages to be read-only. A page fault from the HCA can then
> refill the pages, or even break COW in case of a write.

That would be cool, too.  fork() has been a continuing problem -- solving that problem would be wonderful.

If this ODP stuff becomes a new verb, it would be good:

- if these fork-fixing / register-infinite capabilities can be queried at run time (maybe on ibv_device_cap_flags?) so that ULPs can know to use this functionality
- if driver owners can get a heads up so that they can know to implement it

>> Why don't we have something like ummunotify yet?
> I think that the problem we are trying to solve is better handled inside
> the kernel. If you are going to change the HCA's memory mappings, you'd
> have to go through the kernel anyway.

If/when you allow registering all memory, then I think you're right -- the MPI-must-intercept-free/sbrk-whatever issue may go away (that's why I started this thread asking about register(0 .. 2^64)).  But without that, unless I'm missing something, I don't think it solves the MPI-must-catch-free-sbrk-etc. issues...?  And therefore, having some kind of ummunotify-like functionality as a verb would be a Very Good Thing.

-- 
Jeff Squyres
jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
For corporate legal information go to: http://www.cisco.com/web/about/doing_business/legal/cri/

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
