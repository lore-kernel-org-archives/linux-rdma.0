From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v15 05/17] arms64: untag user pointers passed to memory
 syscalls
Date: Tue, 28 May 2019 16:56:45 +0100
Message-ID: <20190528155644.GD28398@e103592.cambridge.arm.com>
References: <cover.1557160186.git.andreyknvl@google.com>
 <00eb4c63fefc054e2c8d626e8fedfca11d7c2600.1557160186.git.andreyknvl@google.com>
 <20190527143719.GA59948@MBP.local>
 <20190528145411.GA709@e119886-lin.cambridge.arm.com>
 <20190528154057.GD32006@arrakis.emea.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190528154057.GD32006@arrakis.emea.arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrew Murray <andrew.murray@arm.com>, Mark Rutland <mark.rutland@arm.com>, kvm@vger.kernel.org, Christian Koenig <Christian.Koenig@amd.com>, Szabolcs Nagy <Szabolcs.Nagy@arm.com>, Will Deacon <will.deacon@arm.com>, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, Lee Smith <Lee.Smith@arm.com>, linux-kselftest@vger.kernel.org, Vincenzo Frascino <vincenzo.frascino@arm.com>, Jacob Bramley <Jacob.Bramley@arm.com>, Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org, amd-gfx@lists.freedesktop.org, linux-arm-kernel@lists.infradead.org, Evgeniy Stepanov <eugenis@google.com>, linux-media@vger.kernel.org, Kees Cook <keescook@chromium.org>, Ruben Ayrapetyan <Ruben.Ayrapetyan@arm.com>, Andrey Konovalov <andreyknvl@google.com>, Kevin Brodsky <kevin.brodsk>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 28, 2019 at 04:40:58PM +0100, Catalin Marinas wrote:

[...]

> My thoughts on allowing tags (quick look):
>
> brk - no

[...]

> mlock, mlock2, munlock - yes
> mmap - no (we may change this with MTE but not for TBI)

[...]

> mprotect - yes

I haven't following this discussion closely... what's the rationale for
the inconsistencies here (feel free to refer me back to the discussion
if it's elsewhere).

Cheers
---Dave
