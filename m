From: Jerome Glisse <jglisse@redhat.com>
Subject: Re: [PATCH v4 0/9] mmu notifier provide context informations
Date: Thu, 31 Jan 2019 15:33:59 -0500
Message-ID: <20190131203359.GA22145@redhat.com>
References: <20190123222315.1122-1-jglisse@redhat.com>
 <20190131161006.GA16593@redhat.com>
 <20190131115535.7eeecf501615f8bad2f139eb@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190131115535.7eeecf501615f8bad2f139eb@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>, Jan Kara <jack@suse.cz>, Felix Kuehling <Felix.Kuehling@amd.com>, Jason Gunthorpe <jgg@mellanox.com>, Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <zwisler@kernel.org>, Dan Williams <dan.j.williams@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Michal Hocko <mhocko@kernel.org>, Ralph Campbell <rcampbell@nvidia.com>, John Hubbard <jhubbard@nvidia.com>, kvm@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, linux-fsdevel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 31, 2019 at 11:55:35AM -0800, Andrew Morton wrote:
> On Thu, 31 Jan 2019 11:10:06 -0500 Jerome Glisse <jglisse@redhat.com> wrote:
> 
> > Andrew what is your plan for this ? I had a discussion with Peter Xu
> > and Andrea about change_pte() and kvm. Today the change_pte() kvm
> > optimization is effectively disabled because of invalidate_range
> > calls. With a minimal couple lines patch on top of this patchset
> > we can bring back the kvm change_pte optimization and we can also
> > optimize some other cases like for instance when write protecting
> > after fork (but i am not sure this is something qemu does often so
> > it might not help for real kvm workload).
> > 
> > I will be posting a the extra patch as an RFC, but in the meantime
> > i wanted to know what was the status for this.
> 
> The various drm patches appear to be headed for collisions with drm
> tree development so we'll need to figure out how to handle that and in
> what order things happen.
> 
> It's quite unclear from the v4 patchset's changelogs that this has
> anything to do with KVM and "the change_pte() kvm optimization" hasn't
> been described anywhere(?).
> 
> So..  I expect the thing to do here is to get everything finished, get
> the changelogs completed with this new information and do a resend.
> 
> Can we omit the drm and rdma patches for now?  Feed them in via the
> subsystem maintainers when the dust has settled?

Yes, i should have pointed out that you can ignore the driver patches
i will resumit them through the appropriate tree once the mm bits are
in. I just wanted to show case how i intended to use this. I will try
not to forget next time to clearly tag things that are just there to
show case and that will be merge latter through different tree.

I will do a v5 with kvm bits once we have enough testing and confidence.
So i guess this all will be delayed to 5.2 and 5.3 for driver bits.
The kvm bits are outcomes of private emails and previous face to face
discussion around mmu notifier and kvm. I believe the context information
will turn to be useful to more users than the ones i am doing it for.

Cheers,
Jérôme
