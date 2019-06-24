From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v18 15/15] selftests, arm64: add a selftest for passing
 tagged pointers to kernel
Date: Mon, 24 Jun 2019 18:38:06 +0100
Message-ID: <20190624173805.GK29120@arrakis.emea.arm.com>
References: <cover.1561386715.git.andreyknvl@google.com>
 <0999c80cd639b78ae27c0674069d552833227564.1561386715.git.andreyknvl@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <0999c80cd639b78ae27c0674069d552833227564.1561386715.git.andreyknvl@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrey Konovalov <andreyknvl@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, linux-media@vger.kernel.org, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, Vincenzo Frascino <vincenzo.frascino@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Kees Cook <keescook@chromium.org>, Yishai Hadas <yishaih@mellanox.com>, Felix Kuehling <Felix.Kuehling@amd.com>, Alexander Deucher <Alexander.Deucher@amd.com>, Christian Koenig <Christian.Koenig@amd.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, Jens Wiklander <jens.wiklander@linaro.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 24, 2019 at 04:33:00PM +0200, Andrey Konovalov wrote:
> --- /dev/null
> +++ b/tools/testing/selftests/arm64/tags_test.c
> @@ -0,0 +1,29 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <unistd.h>
> +#include <stdint.h>
> +#include <sys/prctl.h>
> +#include <sys/utsname.h>
> +
> +#define SHIFT_TAG(tag)		((uint64_t)(tag) << 56)
> +#define SET_TAG(ptr, tag)	(((uint64_t)(ptr) & ~SHIFT_TAG(0xff)) | \
> +					SHIFT_TAG(tag))
> +
> +int main(void)
> +{
> +	static int tbi_enabled = 0;
> +	struct utsname *ptr, *tagged_ptr;
> +	int err;
> +
> +	if (prctl(PR_SET_TAGGED_ADDR_CTRL, PR_TAGGED_ADDR_ENABLE, 0, 0, 0) == 0)
> +		tbi_enabled = 1;

Nitpick: with the latest prctl() patch, you can skip the last three
arguments as they are ignored.

Either way:

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
