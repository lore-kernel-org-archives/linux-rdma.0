From: Jerome Glisse <jglisse@redhat.com>
Subject: Re: [PATCH v5 0/9] mmu notifier provide context informations
Date: Tue, 19 Feb 2019 15:30:33 -0500
Message-ID: <20190219203032.GC3959@redhat.com>
References: <20190219200430.11130-1-jglisse@redhat.com>
 <CAPcyv4gq23RXk3BTqP2O+gi3FGE85NSGXD8bdLk+_cgtZrn+Kg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPcyv4gq23RXk3BTqP2O+gi3FGE85NSGXD8bdLk+_cgtZrn+Kg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linux MM <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Jani Nikula <jani.nikula@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, Jan Kara <jack@suse.cz>, Andrea Arcangeli <aarcange@redhat.com>, Peter Xu <peterx@redhat.com>, Felix Kuehling <Felix.Kuehling@amd.com>, Jason Gunthorpe <jgg@mellanox.com>, Ross Zwisler <zwisler@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Michal Hocko <mhocko@kernel.org>, Ralph Campbell <rcampbell@nvidia.com>, John Hubbard <jhubbard@nvidia.com>, KVM list <kvm@vger.kernel.>
List-Id: linux-rdma@vger.kernel.org

On Tue, Feb 19, 2019 at 12:15:55PM -0800, Dan Williams wrote:
> On Tue, Feb 19, 2019 at 12:04 PM <jglisse@redhat.com> wrote:
> >
> > From: Jérôme Glisse <jglisse@redhat.com>
> >
> > Since last version [4] i added the extra bits needed for the change_pte
> > optimization (which is a KSM thing). Here i am not posting users of
> > this, they will be posted to the appropriate sub-systems (KVM, GPU,
> > RDMA, ...) once this serie get upstream. If you want to look at users
> > of this see [5] [6]. If this gets in 5.1 then i will be submitting
> > those users for 5.2 (including KVM if KVM folks feel comfortable with
> > it).
> 
> The users look small and straightforward. Why not await acks and
> reviewed-by's for the users like a typical upstream submission and
> merge them together? Is all of the functionality of this
> infrastructure consumed by the proposed users? Last time I checked it
> was only a subset.

Yes pretty much all is use, the unuse case is SOFT_DIRTY and CLEAR
vs UNMAP. Both of which i intend to use. The RDMA folks already ack
the patches IIRC, so did radeon and amdgpu. I believe the i915 folks
were ok with it too. I do not want to merge things through Andrew
for all of this we discussed that in the past, merge mm bits through
Andrew in one release and bits that use things in the next release.

Cheers,
Jérôme
