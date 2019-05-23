From: Khalid Aziz <khalid.aziz@oracle.com>
Subject: Re: [PATCH v15 00/17] arm64: untag user pointers passed to the kernel
Date: Thu, 23 May 2019 11:51:40 -0600
Message-ID: <6049844a-65f5-f513-5b58-7141588fef2b@oracle.com>
References: <cover.1557160186.git.andreyknvl@google.com>
 <20190517144931.GA56186@arrakis.emea.arm.com>
 <CAFKCwrj6JEtp4BzhqO178LFJepmepoMx=G+YdC8sqZ3bcBp3EQ@mail.gmail.com>
 <20190521182932.sm4vxweuwo5ermyd@mbp> <201905211633.6C0BF0C2@keescook>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <201905211633.6C0BF0C2@keescook>
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
To: Kees Cook <keescook@chromium.org>, Catalin Marinas <catalin.marinas@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>, kvm@vger.kernel.org, Szabolcs Nagy <Szabolcs.Nagy@arm.com>, Will Deacon <will.deacon@arm.com>, dri-devel@lists.freedesktop.org, Linux Memory Management List <linux-mm@kvack.org>, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Jacob Bramley <Jacob.Bramley@arm.com>, Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org, amd-gfx@lists.freedesktop.org, Dmitry Vyukov <dvyukov@google.com>, Dave Martin <Dave.Martin@arm.com>, Evgenii Stepanov <eugenis@google.com>, linux-media@vger.kernel.org, Kevin Brodsky <kevin.brodsky@arm.com>, Ruben Ayrapetyan <Ruben.Ayrapetyan@arm.com>, Andrey Konovalov <andreyknvl@google.com>, Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>, Alex Williamson <alex.williamson@redhat.com>, Yishai Hadas <yishaih@mellanox.com>, Mauro
List-Id: linux-rdma@vger.kernel.org

On 5/21/19 6:04 PM, Kees Cook wrote:
> As an aside: I think Sparc ADI support in Linux actually side-stepped
> this[1] (i.e. chose "solution 1"): "All addresses passed to kernel must
> be non-ADI tagged addresses." (And sadly, "Kernel does not enable ADI
> for kernel code.") I think this was a mistake we should not repeat for
> arm64 (we do seem to be at least in agreement about this, I think).
> 
> [1] https://lore.kernel.org/patchwork/patch/654481/


That is a very early version of the sparc ADI patch. Support for tagged
addresses in syscalls was added in later versions and is in the patch
that is in the kernel.

That part "Kernel does not enable ADI for kernel code." is correct. It
is a possible enhancement for future.

--
Khalid
