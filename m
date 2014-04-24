From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] mm: get_user_pages(write,force) refuse to COW in
	shared areas
Date: Thu, 24 Apr 2014 15:30:55 +0200
Message-ID: <20140424133055.GA13269@redhat.com>
References: <alpine.LSU.2.11.1404040120110.6880@eggly.anvils>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1404040120110.6880@eggly.anvils>
Sender: owner-linux-mm@kvack.org
To: Hugh Dickins <hughd@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>, Roland Dreier <roland@kernel.org>, Konstantin Khlebnikov <koct9i@gmail.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Mauro Carvalho Chehab <m.chehab@samsung.com>, Omar Ramirez Luna <omar.ramirez@copitl.com>, Inki Dae <inki.dae@samsung.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-rdma@vger.kernel.org, linux-media@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Hi Hugh,

Sorry for late reply. First of all, to avoid the confusion, I think the
patch is fine.

When I saw this patch I decided that uprobes should be updated accordingly,
but I just realized that I do not understand what should I write in the
changelog.

On 04/04, Hugh Dickins wrote:
>
> +		if (gup_flags & FOLL_WRITE) {
> +			if (!(vm_flags & VM_WRITE)) {
> +				if (!(gup_flags & FOLL_FORCE))
> +					goto efault;
> +				/*
> +				 * We used to let the write,force case do COW
> +				 * in a VM_MAYWRITE VM_SHARED !VM_WRITE vma, so
> +				 * ptrace could set a breakpoint in a read-only
> +				 * mapping of an executable, without corrupting
> +				 * the file (yet only when that file had been
> +				 * opened for writing!).  Anon pages in shared
> +				 * mappings are surprising: now just reject it.
> +				 */
> +				if (!is_cow_mapping(vm_flags)) {
> +					WARN_ON_ONCE(vm_flags & VM_MAYWRITE);
> +					goto efault;
> +				}

OK. But could you please clarify "Anon pages in shared mappings are surprising" ?
I mean, does this only apply to "VM_MAYWRITE VM_SHARED !VM_WRITE vma" mentioned
above or this is bad even if a !FMODE_WRITE file was mmaped as MAP_SHARED ?

Yes, in this case this vma is not VM_SHARED and it is not VM_MAYWRITE, it is only
VM_MAYSHARE. This is in fact private mapping except mprotect(PROT_WRITE) will not
work.

But with or without this patch gup(FOLL_WRITE | FOLL_FORCE) won't work in this case,
(although perhaps it could ?), is_cow_mapping() == F because of !VM_MAYWRITE.

However, currently uprobes assumes that a cowed anon page is fine in this case, and
this differs from gup().

So, what do you think about the patch below? It is probably fine in any case,
but is there any "strong" reason to follow the gup's behaviour and forbid the
anon page in VM_MAYSHARE && !VM_MAYWRITE vma?

Oleg.

--- x/kernel/events/uprobes.c
+++ x/kernel/events/uprobes.c
@@ -127,12 +127,13 @@ struct xol_area {
  */
 static bool valid_vma(struct vm_area_struct *vma, bool is_register)
 {
-	vm_flags_t flags = VM_HUGETLB | VM_MAYEXEC | VM_SHARED;
+	vm_flags_t flags = VM_HUGETLB | VM_MAYEXEC;
 
 	if (is_register)
 		flags |= VM_WRITE;
 
-	return vma->vm_file && (vma->vm_flags & flags) == VM_MAYEXEC;
+	return 	vma->vm_file && is_cow_mapping(vma->vm_flags) &&
+		(vma->vm_flags & flags) == VM_MAYEXEC;
 }
 
 static unsigned long offset_to_vaddr(struct vm_area_struct *vma, loff_t offset)

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
