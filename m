From: Vincenzo Frascino <vincenzo.frascino@arm.com>
Subject: Re: [PATCH v17 02/15] lib, arm64: untag user pointers in strn*_user
Date: Wed, 12 Jun 2019 15:28:15 +0100
Message-ID: <0bbc5f4f-9812-463c-48c1-4929bef801da@arm.com>
References: <cover.1560339705.git.andreyknvl@google.com>
 <a76c014f9b12a082d31ef1459907cabdab78491e.1560339705.git.andreyknvl@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <a76c014f9b12a082d31ef1459907cabdab78491e.1560339705.git.andreyknvl@google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Andrey Konovalov <andreyknvl@google.com>, linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, linux-media@vger.kernel.org, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Kees Cook <keescook@chromium.org>, Yishai Hadas <yishaih@mellanox.com>, Felix Kuehling <Felix.Kuehling@amd.com>, Alexander Deucher <Alexander.Deucher@amd.com>, Christian Koenig <Christian.Koenig@amd.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, Jens Wiklander <jens.wiklander@linaro.org>, Alex Williamson <alex.williamson@redhat.com>, Leon Romanovsky <leon@kernel.org>, Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, Dave Martin <Dave.Martin@arm.com>, Khalid Aziz <khalid.aziz@oracle.com>, enh <enh@google.com>, Jason Gunthorpe <jgg@ziepe.ca>
List-Id: linux-rdma@vger.kernel.org

On 12/06/2019 12:43, Andrey Konovalov wrote:
> This patch is a part of a series that extends arm64 kernel ABI to allow to
> pass tagged user pointers (with the top byte set to something else other
> than 0x00) as syscall arguments.
> 
> strncpy_from_user and strnlen_user accept user addresses as arguments, and
> do not go through the same path as copy_from_user and others, so here we
> need to handle the case of tagged user addresses separately.
> 
> Untag user pointers passed to these functions.
> 
> Note, that this patch only temporarily untags the pointers to perform
> validity checks, but then uses them as is to perform user memory accesses.
> 
> Reviewed-by: Khalid Aziz <khalid.aziz@oracle.com>
> Acked-by: Kees Cook <keescook@chromium.org>
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Andrey Konovalov <andreyknvl@google.com>

Reviewed-by: Vincenzo Frascino <vincenzo.frascino@arm.com>

> ---
>  lib/strncpy_from_user.c | 3 ++-
>  lib/strnlen_user.c      | 3 ++-
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/strncpy_from_user.c b/lib/strncpy_from_user.c
> index 023ba9f3b99f..dccb95af6003 100644
> --- a/lib/strncpy_from_user.c
> +++ b/lib/strncpy_from_user.c
> @@ -6,6 +6,7 @@
>  #include <linux/uaccess.h>
>  #include <linux/kernel.h>
>  #include <linux/errno.h>
> +#include <linux/mm.h>
>  
>  #include <asm/byteorder.h>
>  #include <asm/word-at-a-time.h>
> @@ -108,7 +109,7 @@ long strncpy_from_user(char *dst, const char __user *src, long count)
>  		return 0;
>  
>  	max_addr = user_addr_max();
> -	src_addr = (unsigned long)src;
> +	src_addr = (unsigned long)untagged_addr(src);
>  	if (likely(src_addr < max_addr)) {
>  		unsigned long max = max_addr - src_addr;
>  		long retval;
> diff --git a/lib/strnlen_user.c b/lib/strnlen_user.c
> index 7f2db3fe311f..28ff554a1be8 100644
> --- a/lib/strnlen_user.c
> +++ b/lib/strnlen_user.c
> @@ -2,6 +2,7 @@
>  #include <linux/kernel.h>
>  #include <linux/export.h>
>  #include <linux/uaccess.h>
> +#include <linux/mm.h>
>  
>  #include <asm/word-at-a-time.h>
>  
> @@ -109,7 +110,7 @@ long strnlen_user(const char __user *str, long count)
>  		return 0;
>  
>  	max_addr = user_addr_max();
> -	src_addr = (unsigned long)str;
> +	src_addr = (unsigned long)untagged_addr(str);
>  	if (likely(src_addr < max_addr)) {
>  		unsigned long max = max_addr - src_addr;
>  		long retval;
> 

-- 
Regards,
Vincenzo
