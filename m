From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: Status of "ummunot" branch?
Date: Thu, 6 Jun 2013 08:52:57 +0300
Message-ID: <51B023B9.9050000@mellanox.com>
References: <51ADD489.3020902@mellanox.com> <EF66BBEB19BADC41AC8CCF5F684F07FC4F65AE40@xmb-rcd-x01.cisco.com> <51AEE53C.2090603@mellanox.com> <EF66BBEB19BADC41AC8CCF5F684F07FC4F65C855@xmb-rcd-x01.cisco.com> <51AF3FA8.7000900@mellanox.com> <EF66BBEB19BADC41AC8CCF5F684F07FC4F65D5D3@xmb-rcd-x01.cisco.com> <20130605171426.GC30184@obsidianresearch.com> <EF66BBEB19BADC41AC8CCF5F684F07FC4F65DC0D@xmb-rcd-x01.cisco.com> <20130605181853.GB1946@obsidianresearch.com> <EF66BBEB19BADC41AC8CCF5F684F07FC4F65DF6F@xmb-rcd-x01.cisco.com> <20130605190529.GA3044@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130605190529.GA3044-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 05/06/2013 22:05, Jason Gunthorpe wrote:
> On Wed, Jun 05, 2013 at 06:45:13PM +0000, Jeff Squyres (jsquyres) wrote:
>> What happens if you:
>>
>> a = malloc(N * page_size);
>> ibv_reg_mr(..., a, N * page_size, ...);
>> free(a);
>> // incoming RDMA arrives targeted at buffer a
> 
> Haggai should comment on this, but my impression/expectation was
> you'll get a remote protection fault/
> 
>> Or if you:
>>
>> a = malloc(N * page_size);
>> ibv_reg_mr(..., a, N * page_size, ...);
>> free(a);
>> a = malloc(N / 2 * page_size);
>> // incoming RDMA arrives targeted at buffer a that is of length (N*page_size)
> 
> again, I expect a remote protection fault.
> 
> Noting of course, both of these cases are only true if the underlying
> VM is manipulated in a way that makes the pages unmapped (eg
> mmap/munmap, not free)

That's right. If pages are unmapped and a remote operation tries to
access them the QP will be closed with a protection error.

> 
> I would also assume that attempts to RDMA write read only pages
> protection fault as well.
Right.

> Haggai: A verb to resize a registration would probably be a helpful
> step. MPI could maintain one registration that covers the sbrk
> region and one registration that covers the heap, much easier than
> searching tables and things.

That's a nice idea. Even without this verb, I think it is possible to
develop a registration cache that covers those regions though. When you
find out you have some part of your region not registered, you can
register a new, larger region that covers everything you need. For new
operations you only use the newer region. Once the previous, smaller
region is not used, you de-register it.

What do you think?

Haggai

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
