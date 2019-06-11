From: Khalid Aziz <khalid.aziz@oracle.com>
Subject: Re: [PATCH v16 03/16] lib, arm64: untag user pointers in strn*_user
Date: Tue, 11 Jun 2019 14:06:09 -0600
Message-ID: <dd2de772-bd55-86e3-0812-2e01ae97f8fa@oracle.com>
References: <cover.1559580831.git.andreyknvl@google.com>
 <14f17ef1902aa4f07a39f96879394e718a1f5dc1.1559580831.git.andreyknvl@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <14f17ef1902aa4f07a39f96879394e718a1f5dc1.1559580831.git.andreyknvl@google.com>
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
Cc: Mark Rutland <mark.rutland@arm.com>, Szabolcs Nagy <Szabolcs.Nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Kostya Serebryany <kcc@google.com>, Felix Kuehling <Felix.Kuehling@amd.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Jacob Bramley <Jacob.Bramley@arm.com>, Leon Romanovsky <leon@kernel.org>, Christoph Hellwig <hch@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>, Dave Martin <Dave.Martin@arm.com>, Evgeniy Stepanov <eugenis@google.com>, Kevin Brodsky <kevin.brodsky@arm.com>, Kees Cook <keescook@chromium.org>, Ruben Ayrapetyan <Ruben.Ayrapetyan@arm.com>, Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>, Alex Williamson <alex.williamson@redhat.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, Dmitry Vyukov <dvyukov@google.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Yishai Hadas <yishaih@mellanox.com>J
List-Id: linux-rdma@vger.kernel.org

On 6/3/19 10:55 AM, Andrey Konovalov wrote:
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
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
> ---
>  lib/strncpy_from_user.c | 3 ++-
>  lib/strnlen_user.c      | 3 ++-
>  2 files changed, 4 insertions(+), 2 deletions(-)

Looks good.

Reviewed-by: Khalid Aziz <khalid.aziz@oracle.com>

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
