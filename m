From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v16 16/16] selftests, arm64: add a selftest for passing
 tagged pointers to kernel
Date: Fri, 7 Jun 2019 20:56:24 -0700
Message-ID: <201906072055.7DFED7B@keescook>
References: <cover.1559580831.git.andreyknvl@google.com>
 <9e1b5998a28f82b16076fc85ab4f88af5381cf74.1559580831.git.andreyknvl@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <9e1b5998a28f82b16076fc85ab4f88af5381cf74.1559580831.git.andreyknvl@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrey Konovalov <andreyknvl@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, linux-media@vger.kernel.org, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Yishai Hadas <yishaih@mellanox.com>, Felix Kuehling <Felix.Kuehling@amd.com>, Alexander Deucher <Alexander.Deucher@amd.com>, Christian Koenig <Christian.Koenig@amd.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, Jens Wiklander <jens.wiklander@linaro>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 03, 2019 at 06:55:18PM +0200, Andrey Konovalov wrote:
> This patch is a part of a series that extends arm64 kernel ABI to allow to
> pass tagged user pointers (with the top byte set to something else other
> than 0x00) as syscall arguments.
> 
> This patch adds a simple test, that calls the uname syscall with a
> tagged user pointer as an argument. Without the kernel accepting tagged
> user pointers the test fails with EFAULT.
> 
> Signed-off-by: Andrey Konovalov <andreyknvl@google.com>

I'm adding Shuah to CC in case she has some suggestions about the new
selftest.

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  tools/testing/selftests/arm64/.gitignore      |  1 +
>  tools/testing/selftests/arm64/Makefile        | 22 ++++++++++
>  .../testing/selftests/arm64/run_tags_test.sh  | 12 ++++++
>  tools/testing/selftests/arm64/tags_lib.c      | 42 +++++++++++++++++++
>  tools/testing/selftests/arm64/tags_test.c     | 18 ++++++++
>  5 files changed, 95 insertions(+)
>  create mode 100644 tools/testing/selftests/arm64/.gitignore
>  create mode 100644 tools/testing/selftests/arm64/Makefile
>  create mode 100755 tools/testing/selftests/arm64/run_tags_test.sh
>  create mode 100644 tools/testing/selftests/arm64/tags_lib.c
>  create mode 100644 tools/testing/selftests/arm64/tags_test.c
> 
> diff --git a/tools/testing/selftests/arm64/.gitignore b/tools/testing/selftests/arm64/.gitignore
> new file mode 100644
> index 000000000000..e8fae8d61ed6
> --- /dev/null
> +++ b/tools/testing/selftests/arm64/.gitignore
> @@ -0,0 +1 @@
> +tags_test
> diff --git a/tools/testing/selftests/arm64/Makefile b/tools/testing/selftests/arm64/Makefile
> new file mode 100644
> index 000000000000..9dee18727923
> --- /dev/null
> +++ b/tools/testing/selftests/arm64/Makefile
> @@ -0,0 +1,22 @@
> +# SPDX-License-Identifier: GPL-2.0
> +
> +include ../lib.mk
> +
> +# ARCH can be overridden by the user for cross compiling
> +ARCH ?= $(shell uname -m 2>/dev/null || echo not)
> +
> +ifneq (,$(filter $(ARCH),aarch64 arm64))
> +
> +TEST_CUSTOM_PROGS := $(OUTPUT)/tags_test
> +
> +$(OUTPUT)/tags_test: tags_test.c $(OUTPUT)/tags_lib.so
> +	$(CC) -o $@ $(CFLAGS) $(LDFLAGS) $<
> +
> +$(OUTPUT)/tags_lib.so: tags_lib.c
> +	$(CC) -o $@ -shared $(CFLAGS) $(LDFLAGS) $^
> +
> +TEST_PROGS := run_tags_test.sh
> +
> +all: $(TEST_CUSTOM_PROGS)
> +
> +endif
> diff --git a/tools/testing/selftests/arm64/run_tags_test.sh b/tools/testing/selftests/arm64/run_tags_test.sh
> new file mode 100755
> index 000000000000..2bbe0cd4220b
> --- /dev/null
> +++ b/tools/testing/selftests/arm64/run_tags_test.sh
> @@ -0,0 +1,12 @@
> +#!/bin/sh
> +# SPDX-License-Identifier: GPL-2.0
> +
> +echo "--------------------"
> +echo "running tags test"
> +echo "--------------------"
> +LD_PRELOAD=./tags_lib.so ./tags_test
> +if [ $? -ne 0 ]; then
> +	echo "[FAIL]"
> +else
> +	echo "[PASS]"
> +fi
> diff --git a/tools/testing/selftests/arm64/tags_lib.c b/tools/testing/selftests/arm64/tags_lib.c
> new file mode 100644
> index 000000000000..8a674509216e
> --- /dev/null
> +++ b/tools/testing/selftests/arm64/tags_lib.c
> @@ -0,0 +1,42 @@
> +#include <stdlib.h>
> +
> +#define TAG_SHIFT	(56)
> +#define TAG_MASK	(0xffUL << TAG_SHIFT)
> +
> +void *__libc_malloc(size_t size);
> +void __libc_free(void *ptr);
> +void *__libc_realloc(void *ptr, size_t size);
> +void *__libc_calloc(size_t nmemb, size_t size);
> +
> +static void *tag_ptr(void *ptr)
> +{
> +	unsigned long tag = rand() & 0xff;
> +	if (!ptr)
> +		return ptr;
> +	return (void *)((unsigned long)ptr | (tag << TAG_SHIFT));
> +}
> +
> +static void *untag_ptr(void *ptr)
> +{
> +	return (void *)((unsigned long)ptr & ~TAG_MASK);
> +}
> +
> +void *malloc(size_t size)
> +{
> +	return tag_ptr(__libc_malloc(size));
> +}
> +
> +void free(void *ptr)
> +{
> +	__libc_free(untag_ptr(ptr));
> +}
> +
> +void *realloc(void *ptr, size_t size)
> +{
> +	return tag_ptr(__libc_realloc(untag_ptr(ptr), size));
> +}
> +
> +void *calloc(size_t nmemb, size_t size)
> +{
> +	return tag_ptr(__libc_calloc(nmemb, size));
> +}
> diff --git a/tools/testing/selftests/arm64/tags_test.c b/tools/testing/selftests/arm64/tags_test.c
> new file mode 100644
> index 000000000000..263b302874ed
> --- /dev/null
> +++ b/tools/testing/selftests/arm64/tags_test.c
> @@ -0,0 +1,18 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <unistd.h>
> +#include <stdint.h>
> +#include <sys/utsname.h>
> +
> +int main(void)
> +{
> +	struct utsname *ptr;
> +	int err;
> +
> +	ptr = (struct utsname *)malloc(sizeof(*ptr));
> +	err = uname(ptr);
> +	free(ptr);
> +	return err;
> +}
> -- 
> 2.22.0.rc1.311.g5d7573a151-goog
> 

-- 
Kees Cook
