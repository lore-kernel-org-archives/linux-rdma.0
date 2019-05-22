From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v15 04/17] mm: add ksys_ wrappers to memory syscalls
Date: Wed, 22 May 2019 11:56:10 +0100
Message-ID: <20190522105609.jpmaiq3adyh6apx2@mbp>
References: <cover.1557160186.git.andreyknvl@google.com>
 <55496bc72542ec14c4c8de23a4df235644013911.1557160186.git.andreyknvl@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55496bc72542ec14c4c8de23a4df235644013911.1557160186.git.andreyknvl@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrey Konovalov <andreyknvl@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, linux-media@vger.kernel.org, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, Vincenzo Frascino <vincenzo.frascino@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Kees Cook <keescook@chromium.org>, Yishai Hadas <yishaih@mellanox.com>, Felix Kuehling <Felix.Kuehling@amd.com>, Alexander Deucher <Alexander.Deucher@amd.com>, Christian Koenig <Christian.Koenig@amd.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, Jens Wiklander <jens.wiklander@linaro.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, May 06, 2019 at 06:30:50PM +0200, Andrey Konovalov wrote:
> This patch is a part of a series that extends arm64 kernel ABI to allow to
> pass tagged user pointers (with the top byte set to something else other
> than 0x00) as syscall arguments.
> 
> This patch adds ksys_ wrappers to the following memory syscalls:
> 
> brk, get_mempolicy (renamed kernel_get_mempolicy -> ksys_get_mempolicy),
> madvise, mbind (renamed kernel_mbind -> ksys_mbind), mincore,
> mlock (renamed do_mlock -> ksys_mlock), mlock2, mmap_pgoff,
> mprotect (renamed do_mprotect_pkey -> ksys_mprotect_pkey), mremap, msync,
> munlock, munmap, remap_file_pages, shmat, shmdt.
> 
> The next patch in this series will add a custom implementation for these
> syscalls that makes them accept tagged pointers on arm64.
> 
> Signed-off-by: Andrey Konovalov <andreyknvl@google.com>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
