From: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: Status of "ummunot" branch?
Date: Wed, 12 Jun 2013 21:18:34 +0000
Message-ID: <EF66BBEB19BADC41AC8CCF5F684F07FC4F680A2B@xmb-rcd-x01.cisco.com>
References: <20130605171426.GC30184@obsidianresearch.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F65DC0D@xmb-rcd-x01.cisco.com>
 <20130605181853.GB1946@obsidianresearch.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F65DF6F@xmb-rcd-x01.cisco.com>
 <20130605190529.GA3044@obsidianresearch.com> <51B023B9.9050000@mellanox.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F66B79C@xmb-rcd-x01.cisco.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F66E403@xmb-rcd-x01.cisco.com>
 <20130607235731.GA25942@obsidianresearch.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F676E59@xmb-rcd-x01.cisco.com>
 <20130610172627.GC2391@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130610172627.GC2391-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Content-ID: <2226CE7DFE1D4148BC4CBCF82D0A109E-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Jun 10, 2013, at 1:26 PM, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:

>> I agree that pushing all registration issues out of the application
>> and (somewhere) into the verbs stack would be a nice solution.
> 
> Well, it creates a mess in another sense, because now you've lost
> context. When your MPI goes to do a 1byte send the kernel may well
> prefetch a few megabytes of page tables, whereas an implementation in
> userspace still has the context and can say, no I don't need that..

It seems like there are Big Problems on either side of this problem (userspace and kernel).

I thought that ummunotify was a good balance between the two -- MPI kept its registration caches (which are annoying, but we have long-since understood that *someone* has to maintain them), but it gets a bulletproof way to keep them coherent.  That is what is missing in today's solutions: bulletproofness (plus we have to use the horrid glibc malloc hooks, which are deprecated and are going away).

>> That being said, everyone I've talked to about ODP finds it very,
>> very strange that the kernel would keep memory registrations around
>> for memory that is no longer part of a process.  Not only does it
> 
> MRs are badly named. They are not 'memory registrations'. They are
> 'address registrations'. Don't conflat address === memory in your
> head, then it seems weird :)
> 
> The memory the address space points to is flexible.
> 
> The address space is tied to the lifetime of the process.
> 
> It doesn't matter if there is no memory mapped to the address space,
> the address space is still there.
> 
> Liran had a good example. You can register address space and then use
> mmap/munmap/MAP_FIXED to mess around with where it points to

...but this is not how people write applications.  Real apps use malloc (and some direct mmap, and perhaps even some shared memory).  They don't pay attention to the contiguiousness (is that a word?) of memory/addresses in the large scale.  To be clear: the most tightly bound codes *do* actually care about cache hits and locality, but that's in the small scale -- not in the large scale.  I would find it hard to believe that a real code would pay attention to where in its address range a given malloc() returns, for example.

*That's* what makes this whole concept weird.

It seems like this is a perfect kernel space concept, but is quite foreign to userspace developers.

> A practical example of using this would be to avoid the need to send
> scatter buffer pointers to the remote. The remote writes into a memory
> ring and the ring is made 'endless' by clever use of remapping.

I don't understand -- please explain your example a bit more...?

-- 
Jeff Squyres
jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
For corporate legal information go to: http://www.cisco.com/web/about/doing_business/legal/cri/

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
