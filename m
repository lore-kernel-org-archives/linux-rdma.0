From: Khalid Aziz <khalid.aziz@oracle.com>
Subject: Re: [PATCH v17 12/15] media/v4l2-core, arm64: untag user pointers in
 videobuf_dma_contig_user_get
Date: Wed, 19 Jun 2019 14:05:20 -0600
Message-ID: <5ea75db0-20e9-7423-8670-967eedd56440@oracle.com>
References: <cover.1560339705.git.andreyknvl@google.com>
 <7fbcdbe16a2bd99e92eb4541248469738d89a122.1560339705.git.andreyknvl@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <7fbcdbe16a2bd99e92eb4541248469738d89a122.1560339705.git.andreyknvl@google.com>
Content-Language: en-US
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Andrey Konovalov <andreyknvl@google.com>, linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, linux-media@vger.kernel.org, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>, Szabolcs Nagy <Szabolcs.Nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Kostya Serebryany <kcc@google.com>, Mauro Carvalho Chehab <mchehab+samsung@kernel.org>, Felix Kuehling <Felix.Kuehling@amd.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Jacob Bramley <Jacob.Bramley@arm.com>, Leon Romanovsky <leon@kernel.org>, Christoph Hellwig <hch@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>, Dave Martin <Dave.Martin@arm.com>, Evgeniy Stepanov <eugenis@google.com>, Kevin Brodsky <kevin.brodsky@arm.com>, Kees Cook <keescook@chromium.org>, Ruben Ayrapetyan <Ruben.Ayrapetyan@arm.com>, Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>, Alex Williamson <alex.williamson@redhat.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, Dmitry Vyukov <dvyukov@google.com>, Greg Kroah-Hartman <gregkh@linuxfou>
List-Id: linux-rdma@vger.kernel.org

On 6/12/19 5:43 AM, Andrey Konovalov wrote:
> This patch is a part of a series that extends arm64 kernel ABI to allow to
> pass tagged user pointers (with the top byte set to something else other
> than 0x00) as syscall arguments.
> 
> videobuf_dma_contig_user_get() uses provided user pointers for vma
> lookups, which can only by done with untagged pointers.
> 
> Untag the pointers in this function.
> 
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Acked-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
> ---

Patch looks good, but commit log should be updated to not be specific to
arm64.

Reviewed-by: Khalid Aziz <khalid.aziz@oracle.com>



>  drivers/media/v4l2-core/videobuf-dma-contig.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> exact_copy_from_user
> diff --git a/drivers/media/v4l2-core/videobuf-dma-contig.c b/drivers/media/v4l2-core/videobuf-dma-contig.c
> index e1bf50df4c70..8a1ddd146b17 100644
> --- a/drivers/media/v4l2-core/videobuf-dma-contig.c
> +++ b/drivers/media/v4l2-core/videobuf-dma-contig.c
> @@ -160,6 +160,7 @@ static void videobuf_dma_contig_user_put(struct videobuf_dma_contig_memory *mem)
>  static int videobuf_dma_contig_user_get(struct videobuf_dma_contig_memory *mem,
>  					struct videobuf_buffer *vb)
>  {
> +	unsigned long untagged_baddr = untagged_addr(vb->baddr);
>  	struct mm_struct *mm = current->mm;
>  	struct vm_area_struct *vma;
>  	unsigned long prev_pfn, this_pfn;
> @@ -167,22 +168,22 @@ static int videobuf_dma_contig_user_get(struct videobuf_dma_contig_memory *mem,
>  	unsigned int offset;
>  	int ret;
>  
> -	offset = vb->baddr & ~PAGE_MASK;
> +	offset = untagged_baddr & ~PAGE_MASK;
>  	mem->size = PAGE_ALIGN(vb->size + offset);
>  	ret = -EINVAL;
>  
>  	down_read(&mm->mmap_sem);
>  
> -	vma = find_vma(mm, vb->baddr);
> +	vma = find_vma(mm, untagged_baddr);
>  	if (!vma)
>  		goto out_up;
>  
> -	if ((vb->baddr + mem->size) > vma->vm_end)
> +	if ((untagged_baddr + mem->size) > vma->vm_end)
>  		goto out_up;
>  
>  	pages_done = 0;
>  	prev_pfn = 0; /* kill warning */
> -	user_address = vb->baddr;
> +	user_address = untagged_baddr;
>  
>  	while (pages_done < (mem->size >> PAGE_SHIFT)) {
>  		ret = follow_pfn(vma, user_address, &this_pfn);
> 
