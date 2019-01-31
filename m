From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v4 0/9] mmu notifier provide context informations
Date: Thu, 31 Jan 2019 11:55:35 -0800
Message-ID: <20190131115535.7eeecf501615f8bad2f139eb@linux-foundation.org>
References: <20190123222315.1122-1-jglisse@redhat.com>
        <20190131161006.GA16593@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190131161006.GA16593@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jerome Glisse <jglisse@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, Christian =?ISO-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>, Jan Kara <jack@suse.cz>, Felix Kuehling <Felix.Kuehling@amd.com>, Jason Gunthorpe <jgg@mellanox.com>, Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <zwisler@kernel.org>, Dan Williams <dan.j.williams@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, Radim =?UTF-8?Q?Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Michal Hocko <mhocko@kernel.org>, Ralph Campbell <rcampbell@nvidia.com>, John Hubbard <jhubbard@nvidia.com>, kvm@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, linux-fsdevel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-rdma@vger.kernel.org

On Thu, 31 Jan 2019 11:10:06 -0500 Jerome Glisse <jglisse@redhat.com> wrote:

> Andrew what is your plan for this ? I had a discussion with Peter Xu
> and Andrea about change_pte() and kvm. Today the change_pte() kvm
> optimization is effectively disabled because of invalidate_range
> calls. With a minimal couple lines patch on top of this patchset
> we can bring back the kvm change_pte optimization and we can also
> optimize some other cases like for instance when write protecting
> after fork (but i am not sure this is something qemu does often so
> it might not help for real kvm workload).
> 
> I will be posting a the extra patch as an RFC, but in the meantime
> i wanted to know what was the status for this.

The various drm patches appear to be headed for collisions with drm
tree development so we'll need to figure out how to handle that and in
what order things happen.

It's quite unclear from the v4 patchset's changelogs that this has
anything to do with KVM and "the change_pte() kvm optimization" hasn't
been described anywhere(?).

So..  I expect the thing to do here is to get everything finished, get
the changelogs completed with this new information and do a resend.

Can we omit the drm and rdma patches for now?  Feed them in via the
subsystem maintainers when the dust has settled?
