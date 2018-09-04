From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: Re: [PATCH v6 1/2] mm: migration: fix migration of huge PMD shared
 pages
Date: Tue, 4 Sep 2018 10:55:54 -0700
Message-ID: <4b275965-3e6e-2a68-4b39-d09902bbc573@oracle.com>
References: <20180829181424.GB3784@redhat.com>
 <20180829183906.GF10223@dhcp22.suse.cz> <20180829211106.GC3784@redhat.com>
 <20180830105616.GD2656@dhcp22.suse.cz> <20180830140825.GA3529@redhat.com>
 <20180830161800.GJ2656@dhcp22.suse.cz> <20180830165751.GD3529@redhat.com>
 <e0c0c966-6706-4ca2-4077-e79322756a9b@oracle.com>
 <20180830183944.GE3529@redhat.com> <20180903055654.GA14951@dhcp22.suse.cz>
 <20180904140035.GA3526@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180904140035.GA3526@redhat.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Jerome Glisse <jglisse@redhat.com>, Michal Hocko <mhocko@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Vlastimil Babka <vbabka@suse.cz>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, Davidlohr Bueso <dave@stgolabs.net>, Andrew Morton <akpm@linux-foundation.org>, stable@vger.kernel.org, linux-rdma@vger.kernel.org, Matan Barak <matanb@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Dimitri Sivanich <sivanich@sgi.com>
List-Id: linux-rdma@vger.kernel.org

On 09/04/2018 07:00 AM, Jerome Glisse wrote:
> On Mon, Sep 03, 2018 at 07:56:54AM +0200, Michal Hocko wrote:
>> On Thu 30-08-18 14:39:44, Jerome Glisse wrote:
>>> For all intents and purposes this is not a backport of the original
>>> patch so maybe we should just drop the commit reference and just
>>> explains that it is there to fix mmu notifier in respect to huge page
>>> migration.
>>>
>>> The original patches fix more than this case because newer featurers
>>> like THP migration, THP swapping, ... added more cases where things
>>> would have been wrong. But in 4.4 frame there is only huge tlb fs
>>> migration.
>>
>> And THP migration is still a problem with 4.4 AFAICS. All other cases
>> simply split the huge page but THP migration keeps it in one piece and
>> as such it is theoretically broken as you have explained. So I would
>> stick with what I posted with some more clarifications in the changelog
>> if you think it is appropriate (suggestions welcome).
> 
> Reading code there is no THP migration in 4.4 only huge tlb migration.
> Look at handle_mm_fault which do not know how to handle swap pmd, only
> the huge tlb fs fault handler knows how to handle those. Hence why i
> was checking for huge tlb exactly as page_check_address() to only range
> invalidate for huge tlb fs migration.

I agree with Jérôme that THP migration was added after 4.4.  But, I could
be missing something.

> But i am fine with doing the range invalidation with all.

Since the shared pmd patch which will ultimately go on top of this needs
the PageHuge checks, my preference would be Jérôme's patch.

However, IMO I am not certain we really need/want a separate patch.  We
could just add the notifiers to the shared pmd patch.  Back porting the
shared pmd patch will also require some fixup.

Either would work.  I'll admit I do not know what stable maintainers would
prefer.
-- 
Mike Kravetz
