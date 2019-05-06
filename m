From: Andrey Konovalov <andreyknvl@google.com>
Subject: Re: [PATCH v14 12/17] drm/radeon, arm64: untag user pointers
Date: Mon, 6 May 2019 15:44:15 +0200
Message-ID: <CAAeHK+wFq_NwhYtoGapcrKDnCxZUcquBuW_ZCae+8CAqtp3ndQ@mail.gmail.com>
References: <cover.1556630205.git.andreyknvl@google.com>
 <9a50ef07d927cbccd9620894bda825e551168c3d.1556630205.git.andreyknvl@google.com>
 <bfe5e11e-6dc4-352f-57eb-d527f965a2ef@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <bfe5e11e-6dc4-352f-57eb-d527f965a2ef@amd.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: "Kuehling, Felix" <Felix.Kuehling@amd.com>
Cc: Mark Rutland <mark.rutland@arm.com>, "Koenig@google.com" <Koenig@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Szabolcs Nagy <Szabolcs.Nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, Chintan Pandya <cpandya@codeaurora.org>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Jacob Bramley <Jacob.Bramley@arm.com>, Leon Romanovsky <leon@kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Dave Martin <Dave.Martin@arm.com>, Evgeniy Stepanov <eugenis@google.com>, linux-media@vger.ker
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 30, 2019 at 7:57 PM Kuehling, Felix <Felix.Kuehling@amd.com> wrote:
>
> On 2019-04-30 9:25 a.m., Andrey Konovalov wrote:
> > [CAUTION: External Email]
> >
> > This patch is a part of a series that extends arm64 kernel ABI to allow to
> > pass tagged user pointers (with the top byte set to something else other
> > than 0x00) as syscall arguments.
> >
> > radeon_ttm_tt_pin_userptr() uses provided user pointers for vma
> > lookups, which can only by done with untagged pointers. This patch
> > untags user pointers when they are being set in
> > radeon_ttm_tt_pin_userptr().
> >
> > In amdgpu_gem_userptr_ioctl() an MMU notifier is set up with a (tagged)
> > userspace pointer. The untagged address should be used so that MMU
> > notifiers for the untagged address get correctly matched up with the right
> > BO. This patch untags user pointers in radeon_gem_userptr_ioctl().
> >
> > Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
> > ---
> >   drivers/gpu/drm/radeon/radeon_gem.c | 2 ++
> >   drivers/gpu/drm/radeon/radeon_ttm.c | 2 +-
> >   2 files changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/gpu/drm/radeon/radeon_gem.c b/drivers/gpu/drm/radeon/radeon_gem.c
> > index 44617dec8183..90eb78fb5eb2 100644
> > --- a/drivers/gpu/drm/radeon/radeon_gem.c
> > +++ b/drivers/gpu/drm/radeon/radeon_gem.c
> > @@ -291,6 +291,8 @@ int radeon_gem_userptr_ioctl(struct drm_device *dev, void *data,
> >          uint32_t handle;
> >          int r;
> >
> > +       args->addr = untagged_addr(args->addr);
> > +
> >          if (offset_in_page(args->addr | args->size))
> >                  return -EINVAL;
> >
> > diff --git a/drivers/gpu/drm/radeon/radeon_ttm.c b/drivers/gpu/drm/radeon/radeon_ttm.c
> > index 9920a6fc11bf..dce722c494c1 100644
> > --- a/drivers/gpu/drm/radeon/radeon_ttm.c
> > +++ b/drivers/gpu/drm/radeon/radeon_ttm.c
> > @@ -742,7 +742,7 @@ int radeon_ttm_tt_set_userptr(struct ttm_tt *ttm, uint64_t addr,
> >          if (gtt == NULL)
> >                  return -EINVAL;
> >
> > -       gtt->userptr = addr;
> > +       gtt->userptr = untagged_addr(addr);
>
> Doing this here seems unnecessary, because you already untagged the
> address in the only caller of this function in radeon_gem_userptr_ioctl.
> The change there will affect both the userptr and MMU notifier setup and
> makes sure that both are in sync, using the same untagged address.

Will fix in v15, thanks!

>
> Regards,
>    Felix
>
>
> >          gtt->usermm = current->mm;
> >          gtt->userflags = flags;
> >          return 0;
> > --
> > 2.21.0.593.g511ec345e18-goog
> >
