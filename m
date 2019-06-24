From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v18 11/15] IB/mlx4: untag user pointers in
 mlx4_get_umem_mr
Date: Mon, 24 Jun 2019 18:40:15 +0100
Message-ID: <20190624174015.GL29120@arrakis.emea.arm.com>
References: <cover.1561386715.git.andreyknvl@google.com>
 <ea0ff94ef2b8af12ea6c222c5ebd970e0849b6dd.1561386715.git.andreyknvl@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ea0ff94ef2b8af12ea6c222c5ebd970e0849b6dd.1561386715.git.andreyknvl@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrey Konovalov <andreyknvl@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, linux-media@vger.kernel.org, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, Vincenzo Frascino <vincenzo.frascino@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Kees Cook <keescook@chromium.org>, Yishai Hadas <yishaih@mellanox.com>, Felix Kuehling <Felix.Kuehling@amd.com>, Alexander Deucher <Alexander.Deucher@amd.com>, Christian Koenig <Christian.Koenig@amd.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, Jens Wiklander <jens.wiklander@linaro.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 24, 2019 at 04:32:56PM +0200, Andrey Konovalov wrote:
> This patch is a part of a series that extends kernel ABI to allow to pass
> tagged user pointers (with the top byte set to something else other than
> 0x00) as syscall arguments.
> 
> mlx4_get_umem_mr() uses provided user pointers for vma lookups, which can
> only by done with untagged pointers.
> 
> Untag user pointers in this function.
> 
> Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
> ---
>  drivers/infiniband/hw/mlx4/mr.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

This patch also needs an ack from the infiniband maintainers (Jason).

-- 
Catalin
