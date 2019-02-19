From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v5 0/9] mmu notifier provide context informations
Date: Tue, 19 Feb 2019 12:49:36 -0800
Message-ID: <CAPcyv4gZ=aJSixVwOCrxAf_fn4emx68_80SSFQdzGvvN0mHLGg@mail.gmail.com>
References: <20190219200430.11130-1-jglisse@redhat.com> <CAPcyv4gq23RXk3BTqP2O+gi3FGE85NSGXD8bdLk+_cgtZrn+Kg@mail.gmail.com>
 <20190219203032.GC3959@redhat.com> <20190219204017.GP738@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190219204017.GP738@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: Jerome Glisse <jglisse@redhat.com>, Linux MM <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Jani Nikula <jani.nikula@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, Jan Kara <jack@suse.cz>, Andrea Arcangeli <aarcange@redhat.com>, Peter Xu <peterx@redhat.com>, Felix Kuehling <Felix.Kuehling@amd.com>, Ross Zwisler <zwisler@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Michal Hocko <mhocko@kernel.org>, Ralph Campbell <rcampbell@nvidia.com>, John Hubbard <jhubbard@nvidia.com>, KVM list <kvm@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Feb 19, 2019 at 12:41 PM Jason Gunthorpe <jgg@mellanox.com> wrote:
>
> On Tue, Feb 19, 2019 at 03:30:33PM -0500, Jerome Glisse wrote:
> > On Tue, Feb 19, 2019 at 12:15:55PM -0800, Dan Williams wrote:
> > > On Tue, Feb 19, 2019 at 12:04 PM <jglisse@redhat.com> wrote:
> > > >
> > > > From: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
> > > >
> > > > Since last version [4] i added the extra bits needed for the change=
_pte
> > > > optimization (which is a KSM thing). Here i am not posting users of
> > > > this, they will be posted to the appropriate sub-systems (KVM, GPU,
> > > > RDMA, ...) once this serie get upstream. If you want to look at use=
rs
> > > > of this see [5] [6]. If this gets in 5.1 then i will be submitting
> > > > those users for 5.2 (including KVM if KVM folks feel comfortable wi=
th
> > > > it).
> > >
> > > The users look small and straightforward. Why not await acks and
> > > reviewed-by's for the users like a typical upstream submission and
> > > merge them together? Is all of the functionality of this
> > > infrastructure consumed by the proposed users? Last time I checked it
> > > was only a subset.
> >
> > Yes pretty much all is use, the unuse case is SOFT_DIRTY and CLEAR
> > vs UNMAP. Both of which i intend to use. The RDMA folks already ack
> > the patches IIRC, so did radeon and amdgpu. I believe the i915 folks
> > were ok with it too. I do not want to merge things through Andrew
> > for all of this we discussed that in the past, merge mm bits through
> > Andrew in one release and bits that use things in the next release.
>
> It is usually cleaner for everyone to split patches like this, for
> instance I always prefer to merge RDMA patches via RDMA when
> possible. Less conflicts.
>
> The other somewhat reasonable option is to get acks and send your own
> complete PR to Linus next week? That works OK for tree-wide changes.

Yes, I'm not proposing that they be merged together, instead I'm just
looking for the acked-by / reviewed-by tags even if those patches are
targeting the next merge window.
