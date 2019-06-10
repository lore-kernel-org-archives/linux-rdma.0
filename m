From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v16 07/16] mm, arm64: untag user pointers in
 get_vaddr_frames
Date: Mon, 10 Jun 2019 15:29:34 +0100
Message-ID: <20190610142933.GC10165@c02tf0j2hf1t.cambridge.arm.com>
References: <cover.1559580831.git.andreyknvl@google.com>
 <da1d0e0f6d69c15a12987379e372182f416cbc02.1559580831.git.andreyknvl@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <da1d0e0f6d69c15a12987379e372182f416cbc02.1559580831.git.andreyknvl@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrey Konovalov <andreyknvl@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, linux-media@vger.kernel.org, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, Vincenzo Frascino <vincenzo.frascino@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Kees Cook <keescook@chromium.org>, Yishai Hadas <yishaih@mellanox.com>, Felix Kuehling <Felix.Kuehling@amd.com>, Alexander Deucher <Alexander.Deucher@amd.com>, Christian Koenig <Christian.Koenig@amd.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, Jens Wiklander <jens.wiklander@linaro.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 03, 2019 at 06:55:09PM +0200, Andrey Konovalov wrote:
> This patch is a part of a series that extends arm64 kernel ABI to allow to
> pass tagged user pointers (with the top byte set to something else other
> than 0x00) as syscall arguments.
> 
> get_vaddr_frames uses provided user pointers for vma lookups, which can
> only by done with untagged pointers. Instead of locating and changing
> all callers of this function, perform untagging in it.
> 
> Signed-off-by: Andrey Konovalov <andreyknvl@google.com>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
