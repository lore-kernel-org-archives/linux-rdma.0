From: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: Status of "ummunot" branch?
Date: Fri, 7 Jun 2013 22:59:43 +0000
Message-ID: <EF66BBEB19BADC41AC8CCF5F684F07FC4F66E403@xmb-rcd-x01.cisco.com>
References: <51ADD489.3020902@mellanox.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F65AE40@xmb-rcd-x01.cisco.com>
 <51AEE53C.2090603@mellanox.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F65C855@xmb-rcd-x01.cisco.com>
 <51AF3FA8.7000900@mellanox.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F65D5D3@xmb-rcd-x01.cisco.com>
 <20130605171426.GC30184@obsidianresearch.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F65DC0D@xmb-rcd-x01.cisco.com>
 <20130605181853.GB1946@obsidianresearch.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F65DF6F@xmb-rcd-x01.cisco.com>
 <20130605190529.GA3044@obsidianresearch.com> <51B023B9.9050000@mellanox.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F66B79C@xmb-rcd-x01.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <EF66BBEB19BADC41AC8CCF5F684F07FC4F66B79C-nsZYYkk5h5QQ2GdVW7+PtKBKnGwkPULj@public.gmane.org>
Content-Language: en-US
Content-ID: <060A334B3965EF4A8284E186AC8BDC1E-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Jun 6, 2013, at 4:33 PM, Jeff Squyres (jsquyres) <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> wrote:

> I don't think this covers other memory regions, like those added via mmap, right?


We talked about this at the MPI Forum this week; it doesn't seem like ODP fixes any MPI problems.

1. MPI still has to have a memory registration cache, because ibv_reg_mr(0...sbrk()) doesn't cover the stack or mmap'ed memory, etc.

2. MPI still has to intercept (at least) munmap().

3. Having mmap/malloc/etc. return "new" memory that may already be registered because of a prior memory registration and subsequent munmap/free/etc. is just plain weird.  Worse, if we re-register it, ref counts could go such that the actual registration will never actually expire until the process dies (which could lead to processes with abnormally large memory footprints, because they never actually let go of memory because it's still registered).

4. Even if MPI checks the value of sbrk() and re-registers (0...sbrk()) when sbrk() increases, this would seem to create a lot of work for the kernel -- which is both slow and synchronous.  Example:

a = malloc(5GB);
MPI_Send(a, 1, MPI_CHAR, ...); // MPI sends 1 byte

Then the MPI_Send of 1 byte will have to pay the cost of registering 5GB of new memory.

-----

Unless we understand this wrong (and there's definitely a chance that we do!), it doesn't sound like ODP solves anything for MPI.  Especially since HPC applications almost never swap (in fact, swap is usually disabled in HPC environments).

What MPI wants is:

1. verbs for ummunotify-like functionality
2. non-blocking memory registration verbs; poll the cq to know when it has completed

-- 
Jeff Squyres
jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
For corporate legal information go to: http://www.cisco.com/web/about/doing_business/legal/cri/

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
