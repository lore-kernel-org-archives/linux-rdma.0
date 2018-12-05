From: Jerome Glisse <jglisse@redhat.com>
Subject: Re: [PATCH 2/3] mm/mmu_notifier: use structure for
 invalidate_range_start/end calls
Date: Wed, 5 Dec 2018 10:53:57 -0500
Message-ID: <20181205155357.GA3536@redhat.com>
References: <20181203201817.10759-1-jglisse@redhat.com>
 <20181203201817.10759-3-jglisse@redhat.com>
 <20181205110416.GE22304@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181205110416.GE22304@quack2.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <zwisler@kernel.org>, Dan Williams <dan.j.williams@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Michal Hocko <mhocko@kernel.org>, Christian Koenig <christian.koenig@amd.com>, Felix Kuehling <felix.kuehling@amd.com>, Ralph Campbell <rcampbell@nvidia.com>, John Hubbard <jhubbard@nvidia.com>, kvm@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 05, 2018 at 12:04:16PM +0100, Jan Kara wrote:
> Hi Jerome!
> 
> On Mon 03-12-18 15:18:16, jglisse@redhat.com wrote:
> > From: Jérôme Glisse <jglisse@redhat.com>
> > 
> > To avoid having to change many call sites everytime we want to add a
> > parameter use a structure to group all parameters for the mmu_notifier
> > invalidate_range_start/end cakks. No functional changes with this
> > patch.
> 
> Two suggestions for the patch below:
> 
> > @@ -772,7 +775,8 @@ static void dax_entry_mkclean(struct address_space *mapping, pgoff_t index,
> >  		 * call mmu_notifier_invalidate_range_start() on our behalf
> >  		 * before taking any lock.
> >  		 */
> > -		if (follow_pte_pmd(vma->vm_mm, address, &start, &end, &ptep, &pmdp, &ptl))
> > +		if (follow_pte_pmd(vma->vm_mm, address, &range,
> > +				   &ptep, &pmdp, &ptl))
> >  			continue;
> 
> The change of follow_pte_pmd() arguments looks unexpected. Why should that
> care about mmu notifier range? I see it may be convenient but it doesn't look
> like a good API to me.

Saddly i do not see a way around that one this is because of fs/dax.c
which does the mmu_notifier_invalidate_range_end while follow_pte_pmd
do the mmu_notifier_invalidate_range_start

follow_pte_pmd does adjust the start and end address so that the dax
function does not have the logic to find those address. So instead of
duplicating that follow_pte_pmd inside the dax code i rather passed
around the range struct to follow_pte_pmd.

> 
> > @@ -1139,11 +1140,15 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
> >  				downgrade_write(&mm->mmap_sem);
> >  				break;
> >  			}
> > -			mmu_notifier_invalidate_range_start(mm, 0, -1);
> > +
> > +			range.start = 0;
> > +			range.end = -1UL;
> > +			range.mm = mm;
> > +			mmu_notifier_invalidate_range_start(&range);
> 
> Also how about providing initializer for struct mmu_notifier_range? Or
> something like DECLARE_MMU_NOTIFIER_RANGE? That will make sure that
> unused arguments for particular notification places have defined values and
> also if you add another mandatory argument (like you do in your third
> patch), you just add another argument to the initializer and that way
> the compiler makes sure you haven't missed any place. Finally the code will
> remain more compact that way (less lines needed to initialize the struct).

That is what i do in v2 :)

Thank you for looking to all this.

Cheers,
Jérôme
