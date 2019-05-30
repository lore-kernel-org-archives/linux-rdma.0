From: Khalid Aziz <khalid.aziz@oracle.com>
Subject: Re: [PATCH v15 05/17] arms64: untag user pointers passed to memory
 syscalls
Date: Thu, 30 May 2019 10:05:55 -0600
Message-ID: <f79336b5-46b4-39c0-b754-23366207e32d@oracle.com>
References: <cover.1557160186.git.andreyknvl@google.com>
 <00eb4c63fefc054e2c8d626e8fedfca11d7c2600.1557160186.git.andreyknvl@google.com>
 <20190527143719.GA59948@MBP.local>
 <20190528145411.GA709@e119886-lin.cambridge.arm.com>
 <20190528154057.GD32006@arrakis.emea.arm.com>
 <11193998209cc6ff34e7d704f081206b8787b174.camel@oracle.com>
 <20190529142008.5quqv3wskmpwdfbu@mbp>
 <b2753e81-7b57-481f-0095-3c6fecb1a74c@oracle.com>
 <20190530151105.GA35418@arrakis.emea.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20190530151105.GA35418@arrakis.emea.arm.com>
Content-Language: en-US
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>, kvm@vger.kernel.org, Christian Koenig <Christian.Koenig@amd.com>, Szabolcs Nagy <Szabolcs.Nagy@arm.com>, Will Deacon <will.deacon@arm.com>, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, Lee Smith <Lee.Smith@arm.com>, linux-kselftest@vger.kernel.org, Vincenzo Frascino <vincenzo.frascino@arm.com>, Jacob Bramley <Jacob.Bramley@arm.com>, Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org, amd-gfx@lists.freedesktop.org, linux-arm-kernel@lists.infradead.org, Dave Martin <Dave.Martin@arm.com>, Evgeniy Stepanov <eugenis@google.com>, linux-media@vger.kernel.org, Kees Cook <keescook@chromium.org>, Ruben Ayrapetyan <Ruben.Ayrapetyan@arm.com>, Andrey Konovalov <andreyknvl@google.com>, Kevin Brodsky <kevin.brodsky@arm.com>, Alex Williamson <alex.williamson@redhat.com>, Mauro Carvalho Chehab <mchehab@kernel.org>Dmitry Vyukov <d>
List-Id: linux-rdma@vger.kernel.org

On 5/30/19 9:11 AM, Catalin Marinas wrote:
> On Wed, May 29, 2019 at 01:16:37PM -0600, Khalid Aziz wrote:
>> mmap() can return the same tagged address but I am uneasy about kernel
>> pre-coloring the pages. Database can mmap 100's of GB of memory. That is
>> lot of work being offloaded to the kernel to pre-color the page even if
>> done in batches as pages are faulted in.
> 
> For anonymous mmap() for example, the kernel would have to zero the
> faulted in pages anyway. We can handle the colouring at the same time in
> clear_user_page() (as I said below, we have to clear the colour anyway
> from previous uses, so it's simply extending this to support something
> other than tag/colour 0 by default with no additional overhead).
> 

On sparc M7, clear_user_page() ends up in M7clear_user_page defined in
arch/sparc/lib/M7memset.S. M7 code use Block Init Store (BIS) to clear
the page. BIS on M7 clears the memory tags as well and no separate
instructions are needed to clear the tags. As a result when kernel
clears a page before returning it to user, the page is not only zeroed
out, its tags are also cleared to 0.

>>> Since we already need such loop in the kernel, we might as well allow
>>> user space to require a certain colour. This comes in handy for large
>>> malloc() and another advantage is that the C library won't be stuck
>>> trying to paint the whole range (think GB).
>>
>> If kernel is going to pre-color all pages in a vma, we will need to
>> store the default tag in the vma. It will add more time to page fault
>> handling code. On sparc M7, kernel will need to execute additional 128
>> stxa instructions to set the tags on a normal page.
> 
> As I said, since the user can retrieve an old colour using ldxa, the
> kernel should perform this operation anyway on any newly allocated page
> (unless you clear the existing colour on page freeing).>

Tags are not cleared on sparc on freeing. They get cleared when the page
is allocated again.

>>>> We can try to store tags for an entire region in vma but that is
>>>> expensive, plus on sparc tags are set in userspace with no
>>>> participation from kernel and now we need a way for userspace to
>>>> communicate the tags to kernel.
>>>
>>> We can't support finer granularity through the mmap() syscall and, as
>>> you said, the vma is not the right thing to store the individual tags.
>>> With the above extension to mmap(), we'd have to store a colour per vma
>>> and prevent merging if different colours (we could as well use the
>>> pkeys mechanism we already have in the kernel but use a colour per vma
>>> instead of a key).
>>
>> Since tags can change on any part of mmap region on sparc at any time
>> without kernel being involved, I am not sure I see much reason for
>> kernel to enforce any tag related restrictions.
> 
> It's not enforcing a tag, more like the default colour for a faulted in
> page. Anyway, if sparc is going with default 0/untagged, that's fine as
> well. We may add this mmap() option to arm64 only.
> 
>>>> From sparc point of view, making kernel responsible for assigning tags
>>>> to a page on page fault is full of pitfalls.
>>>
>>> This could be just some arm64-specific but if you plan to deploy it more
>>> generically for sparc (at the C library level), you may find this
>>> useful.
>>
>> Common semantics from app developer point of view will be very useful to
>> maintain. If arm64 says mmap with MAP_FIXED and a tagged address will
>> return a pre-colored page, I would rather have it be the same on any
>> architecture. Is there a use case that justifies kernel doing this extra
>> work?
> 
> So if a database program is doing an anonymous mmap(PROT_TBI) of 100GB,
> IIUC for sparc the faulted-in pages will have random colours (on 64-byte
> granularity). Ignoring the information leak from prior uses of such
> pages, it would be the responsibility of the db program to issue the
> stxa. On arm64, since we also want to do this via malloc(), any large
> allocation would require all pages to be faulted in so that malloc() can
> set the write colour before being handed over to the user. That's what
> we want to avoid and the user is free to repaint the memory as it likes.
> 

On sparc, any newly allocated page is cleared along with any old tags on
it. Since clearing tag happens automatically when page is cleared on
sparc, clear_user_page() will need to execute additional stxa
instructions to set a new tag. It is doable. In a way it is done already
if page is being pre-colored with tag 0 always ;) Where would the
pre-defined tag be stored - as part of address stored in vm_start or a
new field in vm_area_struct?

--
Khalid
