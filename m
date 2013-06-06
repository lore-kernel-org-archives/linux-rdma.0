From: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: Status of "ummunot" branch?
Date: Thu, 6 Jun 2013 02:58:19 +0000
Message-ID: <EF66BBEB19BADC41AC8CCF5F684F07FC4F65F35E@xmb-rcd-x01.cisco.com>
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
 <20130605190529.GA3044@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130605190529.GA3044-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Content-ID: <67C2B3D37458FF4DB5F7813191D966ED-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Jun 5, 2013, at 12:05 PM, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:

>> It does seem quite odd, abstractly speaking, that a registration
>> would survive a free/re-malloc (which is arguably a "different"
>> buffer).
> 
> Not at all: the purpose of the registration is to allow access via
> RDMA to a portion of the process's address space. The address space
> doesn't change, but what it is mapped to can vary.

I still think it's really weird.  When I do this:

a = malloc(N);
ibv_reg_mr(..., a, N, ...);
free(a);
b = malloc(M);

If b just happens to be partially or wholly registered by some quirk of the malloc() system (i.e., some/all of the virtual address space in b happens to have been covered by a prior malloc/ibv_reg_mr)... that's just weird.

>> If ibv_reg_mr(...,
>> 0, 2^64, ...) was supported, that would obviate the entire need for
>> registration caches.  That would be wonderful.
> 
> Yes, except that this shifts around where the registration overhead
> ends up. Basically the HCA driver now has the registration cache you
> had in MPI, and all the same overheads still exist.

There's fewer verbs drivers than applications, right?

> Haggai: A verb to resize a registration would probably be a helpful
> step. MPI could maintain one registration that covers the sbrk
> region and one registration that covers the heap, much easier than
> searching tables and things.

If we still have to register buffers piecemeal, a non-blocking registration verb would be quite helpful.

> Also bear in mind that all RDMA access protections will be disabled if
> you register the entire process VM, the remote(s) can scribble/read
> everything..


No problem for MPI/HPC...  :-)

-- 
Jeff Squyres
jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
For corporate legal information go to: http://www.cisco.com/web/about/doing_business/legal/cri/

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
