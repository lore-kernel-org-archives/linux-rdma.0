From: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: Status of "ummunot" branch?
Date: Wed, 5 Jun 2013 18:45:13 +0000
Message-ID: <EF66BBEB19BADC41AC8CCF5F684F07FC4F65DF6F@xmb-rcd-x01.cisco.com>
References: <51ADB948.5080903@mellanox.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F659155@xmb-rcd-x01.cisco.com>
 <51ADD489.3020902@mellanox.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F65AE40@xmb-rcd-x01.cisco.com>
 <51AEE53C.2090603@mellanox.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F65C855@xmb-rcd-x01.cisco.com>
 <51AF3FA8.7000900@mellanox.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F65D5D3@xmb-rcd-x01.cisco.com>
 <20130605171426.GC30184@obsidianresearch.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F65DC0D@xmb-rcd-x01.cisco.com>
 <20130605181853.GB1946@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130605181853.GB1946-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Content-ID: <F3BDAE28B9D21A40A2AE0F822080C2CB-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Jun 5, 2013, at 11:18 AM, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:

>> Are you saying that the 2nd malloc will magically be registered
>> (with the new physical address)?
> 
> Yes, that is the whole point.

Interesting.

> ODP fundamentally fixes the *bug* where the HCA's view of process
> memory can become inconsistent with the kernel's view.

Hum.  I was under the impression that with today's code (i.e., not ODP), if you

a = malloc(N);
ibv_reg_mr(..., a, N, ...);
free(a);

(assuming that the memory actually left the process at free)

Then the relevant kernel verbs driver was notified, and would unregister that device.  ...but I'm an MPI guy, not a kernel guy -- it seems like you're saying that my impression was wrong (which doesn't currently matter because we intercept free/sbrk and unregister such memory, anyway).

> 'magically be registered' is the wrong way to think about it - the
> registration of VA=0x100 is simply kept, and any change to the
> underlying physical mapping of the VA is synchronized with the HCA.

What happens if you:

a = malloc(N * page_size);
ibv_reg_mr(..., a, N * page_size, ...);
free(a);
// incoming RDMA arrives targeted at buffer a

Or if you:

a = malloc(N * page_size);
ibv_reg_mr(..., a, N * page_size, ...);
free(a);
a = malloc(N / 2 * page_size);
// incoming RDMA arrives targeted at buffer a that is of length (N*page_size)

It does seem quite odd, abstractly speaking, that a registration would survive a free/re-malloc (which is arguably a "different" buffer).

That being said, it still seems like MPI needs a registration cache.  It is several good steps forward if we don't need to intercept free/sbrk/whatever, but when MPI_Send(buf, ...) is invoked, we still have to check that the entire buf is registered.  If ibv_reg_mr(..., 0, 2^64, ...) was supported, that would obviate the entire need for registration caches.  That would be wonderful.

> Right, this was discussed at the Enterprise Summit a few weeks
> ago. I'm sure Roland would welcome patches...


That's why I asked at the beginning of this thread.  He didn't provide any details about what still needs to be done, though.  :-)

-- 
Jeff Squyres
jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
For corporate legal information go to: http://www.cisco.com/web/about/doing_business/legal/cri/

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
