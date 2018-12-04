From: Jerome Glisse <jglisse@redhat.com>
Subject: Re: [PATCH 3/3] mm/mmu_notifier: contextual information for event
 triggering invalidation
Date: Tue, 4 Dec 2018 09:48:55 -0500
Message-ID: <20181204144854.GB3917@redhat.com>
References: <20181203201817.10759-1-jglisse@redhat.com>
 <20181203201817.10759-4-jglisse@redhat.com>
 <20181204081746.GJ26700@rapoport-lnx>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181204081746.GJ26700@rapoport-lnx>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Rapoport <rppt@linux.ibm.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <zwisler@kernel.org>, Jan Kara <jack@suse.cz>, Dan Williams <dan.j.williams@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Michal Hocko <mhocko@kernel.org>, Christian Koenig <christian.koenig@amd.com>, Felix Kuehling <felix.kuehling@amd.com>, Ralph Campbell <rcampbell@nvidia.com>, John Hubbard <jhubbard@nvidia.com>, kvm@vger.kernel.org, linux-rdma@vger.kernel.org, linux-fsdevel@vger.kernel.org, dri-devel@lists.freedesktop.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 04, 2018 at 10:17:48AM +0200, Mike Rapoport wrote:
> On Mon, Dec 03, 2018 at 03:18:17PM -0500, jglisse@redhat.com wrote:
> > From: Jérôme Glisse <jglisse@redhat.com>

[...]

> > diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
> > index cbeece8e47d4..3077d487be8b 100644
> > --- a/include/linux/mmu_notifier.h
> > +++ b/include/linux/mmu_notifier.h
> > @@ -25,10 +25,43 @@ struct mmu_notifier_mm {
> >  	spinlock_t lock;
> >  };
> > 
> > +/*
> > + * What event is triggering the invalidation:
> 
> Can you please make it kernel-doc comment?

Sorry should have done that in the first place, Andrew i will post a v2
with that and fixing my one stupid bug.



> > + *
> > + * MMU_NOTIFY_UNMAP
> > + *    either munmap() that unmap the range or a mremap() that move the range
> > + *
> > + * MMU_NOTIFY_CLEAR
> > + *    clear page table entry (many reasons for this like madvise() or replacing
> > + *    a page by another one, ...).
> > + *
> > + * MMU_NOTIFY_PROTECTION_VMA
> > + *    update is due to protection change for the range ie using the vma access
> > + *    permission (vm_page_prot) to update the whole range is enough no need to
> > + *    inspect changes to the CPU page table (mprotect() syscall)
> > + *
> > + * MMU_NOTIFY_PROTECTION_PAGE
> > + *    update is due to change in read/write flag for pages in the range so to
> > + *    mirror those changes the user must inspect the CPU page table (from the
> > + *    end callback).
> > + *
> > + *
> > + * MMU_NOTIFY_SOFT_DIRTY
> > + *    soft dirty accounting (still same page and same access flags)
> > + */
> > +enum mmu_notifier_event {
> > +	MMU_NOTIFY_UNMAP = 0,
> > +	MMU_NOTIFY_CLEAR,
> > +	MMU_NOTIFY_PROTECTION_VMA,
> > +	MMU_NOTIFY_PROTECTION_PAGE,
> > +	MMU_NOTIFY_SOFT_DIRTY,
> > +};
