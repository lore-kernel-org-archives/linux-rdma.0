From: Adam Borowski <kilobyte@angband.pl>
Subject: Re: [PATCH 00/13] mmu_notifier kill invalidate_page callback
Date: Wed, 30 Aug 2017 16:57:42 +0200
Message-ID: <20170830145742.xird3lgsb3nemtye@angband.pl>
References: <20170829235447.10050-1-jglisse@redhat.com>
 <CA+55aFz6ArJ-ADXiYCu6xMUzdY=mKBtkzfJmLaBohC6Ub9t2SQ@mail.gmail.com>
 <20170830005615.GA2386@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20170830005615.GA2386@redhat.com>
Sender: owner-linux-mm@kvack.org
To: Jerome Glisse <jglisse@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Bernhard Held <berny156@gmx.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Andrea Arcangeli <aarcange@redhat.com>, Joerg Roedel <jroedel@suse.de>, Dan Williams <dan.j.williams@intel.com>, Sudeep Dutt <sudeep.dutt@intel.com>, Ashutosh Dixit <ashutosh.dixit@intel.com>, Dimitri Sivanich <sivanich@sgi.com>, Jack Steiner <steiner@sgi.com>, Paolo Bonzini <pbonzini@redhat.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, ppc-dev <linuxppc-dev@lists.ozlabs.org>, DRI <dri-devel@lists.freedesktop.org>, amd-gfx@lists.freedesktop.org, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "open list:AMD IOMMU (AMD-VI)" <iommu@lists.linux-foundation.org>, xen-devel <xen-dev>
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 29, 2017 at 08:56:15PM -0400, Jerome Glisse wrote:
> I will wait for people to test and for result of my own test before
> reposting if need be, otherwise i will post as separate patch.
>
> > But from a _very_ quick read-through this looks fine. But it obviously
> > needs testing.
> > 
> > People - *especially* the people who saw issues under KVM - can you
> > try out Jérôme's patch-series? I aded some people to the cc, the full
> > series is on lkml. Jérôme - do you have a git branch for people to
> > test that they could easily pull and try out?
> 
> https://cgit.freedesktop.org/~glisse/linux mmu-notifier branch
> git://people.freedesktop.org/~glisse/linux

Tested your branch as of 10f07641, on a long list of guest VMs.
No earth-shattering kaboom.


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ 
⣾⠁⢰⠒⠀⣿⡁ Vat kind uf sufficiently advanced technology iz dis!?
⢿⡄⠘⠷⠚⠋⠀                                 -- Genghis Ht'rok'din
⠈⠳⣄⠀⠀⠀⠀ 

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
