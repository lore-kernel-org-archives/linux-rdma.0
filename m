From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Status of "ummunot" branch?
Date: Mon, 10 Jun 2013 11:26:27 -0600
Message-ID: <20130610172627.GC2391@obsidianresearch.com>
References: <20130605171426.GC30184@obsidianresearch.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F65DC0D@xmb-rcd-x01.cisco.com>
 <20130605181853.GB1946@obsidianresearch.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F65DF6F@xmb-rcd-x01.cisco.com>
 <20130605190529.GA3044@obsidianresearch.com>
 <51B023B9.9050000@mellanox.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F66B79C@xmb-rcd-x01.cisco.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F66E403@xmb-rcd-x01.cisco.com>
 <20130607235731.GA25942@obsidianresearch.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F676E59@xmb-rcd-x01.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <EF66BBEB19BADC41AC8CCF5F684F07FC4F676E59-nsZYYkk5h5QQ2GdVW7+PtKBKnGwkPULj@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 10, 2013 at 02:49:24PM +0000, Jeff Squyres (jsquyres) wrote:
> On Jun 7, 2013, at 4:57 PM, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> 
> >> We talked about this at the MPI Forum this week; it doesn't seem
> >> like ODP fixes any MPI problems.
> > 
> > ODP without 'register all address space' changes the nature of the
> > problem, and fixes only one problem.
> 
> I agree that pushing all registration issues out of the application
> and (somewhere) into the verbs stack would be a nice solution.

Well, it creates a mess in another sense, because now you've lost
context. When your MPI goes to do a 1byte send the kernel may well
prefetch a few megabytes of page tables, whereas an implementation in
userspace still has the context and can say, no I don't need that..

Maybe a prefetch WR can restore the lost context, donno..

> That being said, everyone I've talked to about ODP finds it very,
> very strange that the kernel would keep memory registrations around
> for memory that is no longer part of a process.  Not only does it

MRs are badly named. They are not 'memory registrations'. They are
'address registrations'. Don't conflat address === memory in your
head, then it seems weird :)

The memory the address space points to is flexible.

The address space is tied to the lifetime of the process.

It doesn't matter if there is no memory mapped to the address space,
the address space is still there.

Liran had a good example. You can register address space and then use
mmap/munmap/MAP_FIXED to mess around with where it points to.

A practical example of using this would be to avoid the need to send
scatter buffer pointers to the remote. The remote writes into a memory
ring and the ring is made 'endless' by clever use of remapping.

> "Register all address space" is the moral equivalent of not having
> userspace registration, so let's talk about it in those terms.
> Specifically, there's a subtle difference between:
> 
> a) telling verbs to register (0...2^64) 
> b) telling verbs that the app doesn't want to handle registration

I agree, a verb to do 'B' is a cleaner choice than trying to cram this
kind of API into A...

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
