From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v15 03/17] lib, arm64: untag user pointers in strn*_user
Date: Wed, 22 May 2019 11:41:03 +0100
Message-ID: <20190522104103.r5any4us4zz7gwvg@mbp>
References: <cover.1557160186.git.andreyknvl@google.com>
 <861418ff7ed7253356cb8267de5ee2d4bd84196d.1557160186.git.andreyknvl@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <861418ff7ed7253356cb8267de5ee2d4bd84196d.1557160186.git.andreyknvl@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrey Konovalov <andreyknvl@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, linux-media@vger.kernel.org, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, Vincenzo Frascino <vincenzo.frascino@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Kees Cook <keescook@chromium.org>, Yishai Hadas <yishaih@mellanox.com>, Felix Kuehling <Felix.Kuehling@amd.com>, Alexander Deucher <Alexander.Deucher@amd.com>, Christian Koenig <Christian.Koenig@amd.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, Jens Wiklander <jens.wiklander@linaro.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, May 06, 2019 at 06:30:49PM +0200, Andrey Konovalov wrote:
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
> Signed-off-by: Andrey Konovalov <andreyknvl@google.com>

Just to keep track of where I am with the reviews while the ABI
discussion continues:

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
