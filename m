From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v6 7/8] mm/mmu_notifier: pass down vma and reasons why
 mmu notifier is happening v2
Date: Thu, 11 Apr 2019 08:41:30 +0300
Message-ID: <20190411054130.GY3201@mtr-leonro.mtl.com>
References: <20190326164747.24405-1-jglisse@redhat.com>
 <20190326164747.24405-8-jglisse@redhat.com>
 <20190410234124.GE22989@iweiny-DESK2.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0358813453=="
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <20190410234124.GE22989@iweiny-DESK2.sc.intel.com>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Ira Weiny <ira.weiny@intel.com>
Cc: Jan Kara <jack@suse.cz>, kvm@vger.kernel.org, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, dri-devel@lists.freedesktop.org, Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, Ross Zwisler <zwisler@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>, Ralph Campbell <rcampbell@nvidia.com>, Arnd Bergmann <arnd@arndb.de>, John Hubbard <jhubbard@nvidia.com>, jglisse@redhat.com, Peter Xu <peterx@redhat.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, Dan Williams <dan.j.williams@intel.com>, Felix Kuehling <Felix.Kuehling@amd.com>, linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
List-Id: linux-rdma@vger.kernel.org


--===============0358813453==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DoqoDKVG8/W9HA34"
Content-Disposition: inline


--DoqoDKVG8/W9HA34
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 10, 2019 at 04:41:57PM -0700, Ira Weiny wrote:
> On Tue, Mar 26, 2019 at 12:47:46PM -0400, Jerome Glisse wrote:
> > From: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
> >
> > CPU page table update can happens for many reasons, not only as a result
> > of a syscall (munmap(), mprotect(), mremap(), madvise(), ...) but also
> > as a result of kernel activities (memory compression, reclaim, migratio=
n,
> > ...).
> >
> > Users of mmu notifier API track changes to the CPU page table and take
> > specific action for them. While current API only provide range of virtu=
al
> > address affected by the change, not why the changes is happening
> >
> > This patch is just passing down the new informations by adding it to the
> > mmu_notifier_range structure.
> >
> > Changes since v1:
> >     - Initialize flags field from mmu_notifier_range_init() arguments
> >
> > Signed-off-by: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: linux-mm@kvack.org
> > Cc: Christian K=C3=B6nig <christian.koenig@amd.com>
> > Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
> > Cc: Jani Nikula <jani.nikula@linux.intel.com>
> > Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
> > Cc: Jan Kara <jack@suse.cz>
> > Cc: Andrea Arcangeli <aarcange@redhat.com>
> > Cc: Peter Xu <peterx@redhat.com>
> > Cc: Felix Kuehling <Felix.Kuehling@amd.com>
> > Cc: Jason Gunthorpe <jgg@mellanox.com>
> > Cc: Ross Zwisler <zwisler@kernel.org>
> > Cc: Dan Williams <dan.j.williams@intel.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
> > Cc: Michal Hocko <mhocko@kernel.org>
> > Cc: Christian Koenig <christian.koenig@amd.com>
> > Cc: Ralph Campbell <rcampbell@nvidia.com>
> > Cc: John Hubbard <jhubbard@nvidia.com>
> > Cc: kvm@vger.kernel.org
> > Cc: dri-devel@lists.freedesktop.org
> > Cc: linux-rdma@vger.kernel.org
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > ---
> >  include/linux/mmu_notifier.h | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
> > index 62f94cd85455..0379956fff23 100644
> > --- a/include/linux/mmu_notifier.h
> > +++ b/include/linux/mmu_notifier.h
> > @@ -58,10 +58,12 @@ struct mmu_notifier_mm {
> >  #define MMU_NOTIFIER_RANGE_BLOCKABLE (1 << 0)
> >
> >  struct mmu_notifier_range {
> > +	struct vm_area_struct *vma;
> >  	struct mm_struct *mm;
> >  	unsigned long start;
> >  	unsigned long end;
> >  	unsigned flags;
> > +	enum mmu_notifier_event event;
> >  };
> >
> >  struct mmu_notifier_ops {
> > @@ -363,10 +365,12 @@ static inline void mmu_notifier_range_init(struct=
 mmu_notifier_range *range,
> >  					   unsigned long start,
> >  					   unsigned long end)
> >  {
> > +	range->vma =3D vma;
> > +	range->event =3D event;
> >  	range->mm =3D mm;
> >  	range->start =3D start;
> >  	range->end =3D end;
> > -	range->flags =3D 0;
> > +	range->flags =3D flags;
>
> Which of the "user patch sets" uses the new flags?
>
> I'm not seeing that user yet.  In general I don't see anything wrong with=
 the
> series and I like the idea of telling drivers why the invalidate has fire=
d.
>
> But is the flags a future feature?

It seems that it is used in HMM ODP patch.
https://patchwork.kernel.org/patch/10894281/

Thanks

>
> For the series:
>
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
>
> Ira
>
> >  }
> >
> >  #define ptep_clear_flush_young_notify(__vma, __address, __ptep)		\
> > --
> > 2.20.1
> >

--DoqoDKVG8/W9HA34
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcrtOKAAoJEORje4g2clin4zsP/AmYfZt5oiQTeSP4Xjgwykq0
CzkUmZpJm/vc8F5iiy8PVa00rdya2SH+kRF4wx01H0qC4YfOwxuQTDAekUbrMeHM
huKKVZbzds16MerDumdudWGmW+u2m9Qmt1MoDp7zcZ6kLHCtnQ3y905427D/M4yu
MdQd0LVxa05sk2Tb1D8krE9NkrHMR6nEGfHXE9AE3eSQf9WfqFjFHXGfvxDRylDR
XW/sjkdogpVrONpQ/ZbCPFroOoZS98CLfU894RO9DB/d7kTtWFiSsj3Uh+QR1p64
JWsVhxIERsBYE5PeJ6Y3amF0IXJi8SqiKxIAgi9Qs2xmBIbZBIUP0Snk982qLKzg
Arr7ShCqlg3Zuecwho9onbe3epsZkH9gdLqUqEOe8LXXlRGZ7GVmI6tkNg09SXNY
g7EsDhTMZ8qKGmpzel1qIK/o63ushKp+gtIrBxDLWBF6x61BIni1BkeJdxeKuB/3
OIoN1uETEA10OBIuCT4nH4t5S43CnaGx7B4gN8AY501XXjdeTMUmweO1bRhlwfaX
Ty/xN767bs3Jm9rFjBtAFpx9KYcUc+dOLQESqHvXDk8dL1A2ptljOBLqExzxdSqT
euS5qt4NsdH1vnhJRBFdhGKaIW9DG/t3s0mNKeP1nC62BGbdCfN7hZrKjetGhNxI
JppWRIdYbztvSoppOAp/
=pROR
-----END PGP SIGNATURE-----

--DoqoDKVG8/W9HA34--

--===============0358813453==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Content-Disposition: inline

X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KZHJpLWRldmVs
IG1haWxpbmcgbGlzdApkcmktZGV2ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8vbGlz
dHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vZHJpLWRldmVs

--===============0358813453==--
