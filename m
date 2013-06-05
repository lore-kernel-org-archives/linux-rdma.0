From: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: Status of "ummunot" branch?
Date: Wed, 5 Jun 2013 18:10:11 +0000
Message-ID: <EF66BBEB19BADC41AC8CCF5F684F07FC4F65DC0D@xmb-rcd-x01.cisco.com>
References: <EF66BBEB19BADC41AC8CCF5F684F07FC4F657918@xmb-rcd-x01.cisco.com>
 <51ADA761.2080107@mellanox.com> <51ADB948.5080903@mellanox.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F659155@xmb-rcd-x01.cisco.com>
 <51ADD489.3020902@mellanox.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F65AE40@xmb-rcd-x01.cisco.com>
 <51AEE53C.2090603@mellanox.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F65C855@xmb-rcd-x01.cisco.com>
 <51AF3FA8.7000900@mellanox.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F65D5D3@xmb-rcd-x01.cisco.com>
 <20130605171426.GC30184@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130605171426.GC30184-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Content-ID: <084901AF0479B94694688E991C3DBF72-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Jun 5, 2013, at 10:14 AM, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:

>> a = malloc(x);    // a gets (va=0x100, pa=0x12345) back from malloc
>> MPI_Send(a, ...); // MPI registers 0x100 for len=x, and saves (0x100,x) in reg cache
>> free(a);
>> a = malloc(x);    // a gets (va=0x100, pa=0x98765) back from malloc
>> MPI_Send(a, ...); // MPI sees a=0x100 and things that it is already registered
>> // ...kaboom
> 
> ODP is supposed to completely solve this problem. The HCA's view and
> Kernels view of virtual to physical mapping becomes 100% synchronized,
> and there is no 'kaboom'. The kernel updates the HCA after the free,
> and after the 2nd malloc to 100% match the current virtual memory map
> in the process.

Are you saying that the 2nd malloc will magically be registered (with the new physical address)?

> AFAIK the ummunotify user space API was nak'd by the core kernel
> guys.

It was NAK'ed by Linus, saying "fix your own network stack; this is not needed in the general purpose part of the kernel" (remember that Roland initially developed this as a standalone, non-IB-related kernel module).  

> I got the impression people thought it would be acceptable as a
> rdma API, not a general API. So it is waiting on someone to recast the
> function within verbs to make progress...

'zactly.  Roland has this ummunot branch in his git tree, where he is in the middle of incorporating this functionality from the original ummunotify standalone kernel module into libibverbs and ibcore.

I started this thread asking the status of that branch.

-- 
Jeff Squyres
jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
For corporate legal information go to: http://www.cisco.com/web/about/doing_business/legal/cri/

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
