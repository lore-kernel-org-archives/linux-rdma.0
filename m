From: shuah <shuah@kernel.org>
Subject: Re: [PATCH v16 16/16] selftests, arm64: add a selftest for passing
 tagged pointers to kernel
Date: Mon, 10 Jun 2019 16:08:10 -0600
Message-ID: <2bc277f8-e67e-30e0-5824-8184c2b03237@kernel.org>
References: <cover.1559580831.git.andreyknvl@google.com>
 <9e1b5998a28f82b16076fc85ab4f88af5381cf74.1559580831.git.andreyknvl@google.com>
 <201906072055.7DFED7B@keescook>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201906072055.7DFED7B@keescook>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>, Andrey Konovalov <andreyknvl@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, linux-media@vger.kernel.org, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Yishai Hadas <yishaih@mellanox.com>, Felix Kuehling <Felix.Kuehling@amd.com>, Alexander Deucher <Alexander.Deucher@amd.com>, Christian Koenig <Christian.Koenig@amd.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, Jens Wiklander <jens.wiklander@linaro>
List-Id: linux-rdma@vger.kernel.org

On 6/7/19 9:56 PM, Kees Cook wrote:
> On Mon, Jun 03, 2019 at 06:55:18PM +0200, Andrey Konovalov wrote:
>> This patch is a part of a series that extends arm64 kernel ABI to allow to
>> pass tagged user pointers (with the top byte set to something else other
>> than 0x00) as syscall arguments.
>>
>> This patch adds a simple test, that calls the uname syscall with a
>> tagged user pointer as an argument. Without the kernel accepting tagged
>> user pointers the test fails with EFAULT.
>>
>> Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
> 
> I'm adding Shuah to CC in case she has some suggestions about the new
> selftest.

Thanks Kees.

> 
> Reviewed-by: Kees Cook <keescook@chromium.org>
> 
> -Kees
> 

Looks good to me.

Acked-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
