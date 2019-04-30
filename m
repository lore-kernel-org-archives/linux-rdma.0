From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v13 16/20] IB/mlx4, arm64: untag user pointers in
 mlx4_get_umem_mr
Date: Tue, 30 Apr 2019 15:03:21 +0300
Message-ID: <20190430120321.GF6705@mtr-leonro.mtl.com>
References: <cover.1553093420.git.andreyknvl@google.com>
 <1e2824fd77e8eeb351c6c6246f384d0d89fd2d58.1553093421.git.andreyknvl@google.com>
 <20190429180915.GZ6705@mtr-leonro.mtl.com>
 <20190430111625.GD29799@arrakis.emea.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20190430111625.GD29799@arrakis.emea.arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Szabolcs Nagy <Szabolcs.Nagy@arm.com>, Will Deacon <will.deacon@arm.com>, Kostya Serebryany <kcc@google.com>, Eric Dumazet <edumazet@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, linux-arch@vger.kernel.org, linux-rdma@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Dave Martin <Dave.Martin@arm.com>, Evgeniy Stepanov <eugenis@google.com>, Kees Cook <keescook@chromium.org>, Ruben Ayrapetyan <Ruben.Ayrapetyan@arm.com>, Andrey Konovalov <andreyknvl@google.com>, Kevin Brodsky <kevin.brodsky@arm.com>, Dmitry Vyukov <dvyukov@google.com>, linux-mm@kvack.org, netdev@vger.kernel.org, Yishai Hadas <yishaih@mellanox.com>, linux-kernel@vger.kernel.org, Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Robin Murphy <robin.murphy@arm.com>, "David S. Miller" <davem@davemlo>
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 30, 2019 at 12:16:25PM +0100, Catalin Marinas wrote:
> (trimmed down the cc list slightly as the message bounces)
>
> On Mon, Apr 29, 2019 at 09:09:15PM +0300, Leon Romanovsky wrote:
> > On Wed, Mar 20, 2019 at 03:51:30PM +0100, Andrey Konovalov wrote:
> > > This patch is a part of a series that extends arm64 kernel ABI to allow to
> > > pass tagged user pointers (with the top byte set to something else other
> > > than 0x00) as syscall arguments.
> > >
> > > mlx4_get_umem_mr() uses provided user pointers for vma lookups, which can
> > > only by done with untagged pointers.
> > >
> > > Untag user pointers in this function.
> > >
> > > Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
> > > ---
> > >  drivers/infiniband/hw/mlx4/mr.c | 7 ++++---
> > >  1 file changed, 4 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/drivers/infiniband/hw/mlx4/mr.c b/drivers/infiniband/hw/mlx4/mr.c
> > > index 395379a480cb..9a35ed2c6a6f 100644
> > > --- a/drivers/infiniband/hw/mlx4/mr.c
> > > +++ b/drivers/infiniband/hw/mlx4/mr.c
> > > @@ -378,6 +378,7 @@ static struct ib_umem *mlx4_get_umem_mr(struct ib_udata *udata, u64 start,
> > >  	 * again
> > >  	 */
> > >  	if (!ib_access_writable(access_flags)) {
> > > +		unsigned long untagged_start = untagged_addr(start);
> > >  		struct vm_area_struct *vma;
> > >
> > >  		down_read(&current->mm->mmap_sem);
> > > @@ -386,9 +387,9 @@ static struct ib_umem *mlx4_get_umem_mr(struct ib_udata *udata, u64 start,
> > >  		 * cover the memory, but for now it requires a single vma to
> > >  		 * entirely cover the MR to support RO mappings.
> > >  		 */
> > > -		vma = find_vma(current->mm, start);
> > > -		if (vma && vma->vm_end >= start + length &&
> > > -		    vma->vm_start <= start) {
> > > +		vma = find_vma(current->mm, untagged_start);
> > > +		if (vma && vma->vm_end >= untagged_start + length &&
> > > +		    vma->vm_start <= untagged_start) {
> > >  			if (vma->vm_flags & VM_WRITE)
> > >  				access_flags |= IB_ACCESS_LOCAL_WRITE;
> > >  		} else {
> > > --
> >
> > Thanks,
> > Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
>
> Thanks for the review.
>
> > Interesting, the followup question is why mlx4 is only one driver in IB which
> > needs such code in umem_mr. I'll take a look on it.
>
> I don't know. Just using the light heuristics of find_vma() shows some
> other places. For example, ib_umem_odp_get() gets the umem->address via
> ib_umem_start(). This was previously set in ib_umem_get() as called from
> mlx4_get_umem_mr(). Should the above patch have just untagged "start" on
> entry?

ODP flows are not applicable to any driver except mlx5.
According to commit message of d8f9cc328c88 ("IB/mlx4: Mark user
MR as writable if actual virtual memory is writable"), the code in its
current form needed to deal with different mappings between RDMA memory
requested and VMA memory underlined.

>
> BTW, what's the provenience of such "start" address here? Is it
> something that the user would have malloc()'ed? We try to impose some
> restrictions one what is allowed to be tagged in user so that we don't
> have to untag the addresses in the kernel. For example, if it was the
> result of an mmap() on the device file, we don't allow tagging.

The *_reg_user_mr() is called from userspace through ibv_reg_mr() call [1]
and this is how "address" and access flags are provided.

Right now, the address should point to memory accessible by
get_user_pages(), however mmap-ed memory uses remap_pfn_range()
to provide such pages which makes them unusable for get_user_pages().

I would be glad to see this is a current limitation of RDMA stack and
not as a final design decision.

[1] https://linux.die.net/man/3/ibv_reg_mr

>
> Thanks.
>
> --
> Catalin
