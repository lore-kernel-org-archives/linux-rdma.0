From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [RESEND 5/7] IB/hfi1: Use the new FOLL_LONGTERM flag to get_user_pages_fast()
Date: Fri, 22 Mar 2019 15:14:26 -0700
Message-ID: <CAA9_cmdQjMekSFU09gLc87-PVx2iHeeh2jC6KeFY1UeadpPh4A@mail.gmail.com>
References: <20190317183438.2057-1-ira.weiny@intel.com> <20190317183438.2057-6-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190317183438.2057-6-ira.weiny@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: ira.weiny@intel.com
Cc: Andrew Morton <akpm@linux-foundation.org>, John Hubbard <jhubbard@nvidia.com>, Michal Hocko <mhocko@suse.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, "David S. Miller" <davem@davemloft.net>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Rich Felker <dalias@libc.org>, Yoshinori Sato <ysato@users.sourceforge.jp>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Ralf Baechle <ralf@linux-mips.org>, James Hogan <jhogan@kernel.org>, linux-mm <linux-mm@kvack.org>Linux Kernel Mailing List <l>
List-Id: linux-rdma@vger.kernel.org

On Sun, Mar 17, 2019 at 7:36 PM <ira.weiny@intel.com> wrote:
>
> From: Ira Weiny <ira.weiny@intel.com>
>
> Use the new FOLL_LONGTERM to get_user_pages_fast() to protect against
> FS DAX pages being mapped.
>
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> ---
>  drivers/infiniband/hw/hfi1/user_pages.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/infiniband/hw/hfi1/user_pages.c b/drivers/infiniband/hw/hfi1/user_pages.c
> index 78ccacaf97d0..6a7f9cd5a94e 100644
> --- a/drivers/infiniband/hw/hfi1/user_pages.c
> +++ b/drivers/infiniband/hw/hfi1/user_pages.c
> @@ -104,9 +104,11 @@ int hfi1_acquire_user_pages(struct mm_struct *mm, unsigned long vaddr, size_t np
>                             bool writable, struct page **pages)
>  {
>         int ret;
> +       unsigned int gup_flags = writable ? FOLL_WRITE : 0;

Maybe:

    unsigned int gup_flags = FOLL_LONGTERM | (writable ? FOLL_WRITE : 0);

?

>
> -       ret = get_user_pages_fast(vaddr, npages, writable ? FOLL_WRITE : 0,
> -                                 pages);
> +       gup_flags |= FOLL_LONGTERM;
> +
> +       ret = get_user_pages_fast(vaddr, npages, gup_flags, pages);
>         if (ret < 0)
>                 return ret;
>
> --
> 2.20.1
>
