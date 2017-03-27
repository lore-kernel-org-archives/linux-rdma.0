From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: Re: [PATCH v10 00/11] uapi: export all headers under uapi directories
Date: Mon, 27 Mar 2017 11:45:02 +0200
Message-ID: <be3fddad-8e04-e6aa-c486-c64864c5a061@6wind.com>
References: <CAK7LNARpx7f0eV5_AiPmNYT7MsRbGFOygJwjfAzX_7aCpuHwuw@mail.gmail.com>
 <1489496093-15315-1-git-send-email-nicolas.dichtel@6wind.com>
 <365519b5-d69e-34b7-fa2f-f11b8fabe69f@6wind.com>
 <CAK7LNAR_yp+O9jUZC8mKdaHgTiCkE7p2-ZbA9YZ8OGyp+uxhBQ@mail.gmail.com>
 <c963314f-bcde-f483-c6b1-cad975842e16@6wind.com>
 <CAK7LNAQJWNCRjWoKMH_Br1bwqtq+mQG-6yaWu5fwhC6sJ1fV8Q@mail.gmail.com>
Reply-To: nicolas.dichtel@6wind.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kbuild-owner@vger.kernel.org>
In-Reply-To: <CAK7LNAQJWNCRjWoKMH_Br1bwqtq+mQG-6yaWu5fwhC6sJ1fV8Q@mail.gmail.com>
Sender: linux-kbuild-owner@vger.kernel.org
To: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Michal Marek <mmarek@suse.com>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, David Airlie <airlied@linux.ie>, "David S. Miller" <davem@davemloft.net>, Russell King <linux@armlinux.org.uk>, bp@alien8.de, slash.tmp@free.fr, Daniel Vetter <daniel.vetter@ffwll.ch>, rmk+kernel@armlinux.org.uk, msalter@redhat.com, jengelh@inai.de, hch@infradead.org, Tobias Klauser <tklauser@distanz.ch>, mpe@ellerman.id.au, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "Dmitry V. Levin" <ldv@altlinux.org>, Herbert Xu <herbert@gondor.apana.org.au>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Hi Masahiro,

Le 27/03/2017 à 07:26, Masahiro Yamada a écrit :
> Hi Nocolas,
> 
> 
> 2017-03-24 18:03 GMT+09:00 Nicolas Dichtel <nicolas.dichtel@6wind.com>:
[snip]
> 
> 
> As a whole, this series is amazing.  Thanks for your great work!
Thank you. And thank you for taking time to review it.

> 
> 
> I added some comments, but they are trivial.
> 
> 
> 
> 
> I wanted to leave comments/questions on 10/11,
> but I could not find 10/11 in my mailbox.  I do not know why.
Note that you can download the mail from the kbuild patchwork, open it with your
email client and do a reply ;-)

> 
> 
> I am leaving comments on the cover-letter,
> the following are related to 10/11.
> 
> 
> 
> [1]
> 
>> mandatory-y += $(foreach hdr,$(opt-header), \
>>              $(if \
>>                $(wildcard \
>>                        $(srctree)/arch/$(SRCARCH)/include/uapi/asm/$(hdr) \
>>                        $(srctree)/arch/$(SRCARCH)/include/asm/$(hdr) \
>>                ), \
>>                $(hdr) \
>>                ))
> 
> What is this actually checking?
> 
> If ARCH has its own (uapi/)asm/{kvm.h,kvm_para.h,a.out.h},
> they are added to mandatory-y, then they are checked if they exist.
> But, we know they exist.
Yes, you're right. With english words : 'those files are mandatory only if they
exist', thus they are not mandatory at all :)

> 
> 
> This check reminds us only when we added asm/*.h
> but forgot to add uapi/asm/*.h
> 
> $(srctree)/arch/$(SRCARCH)/include/uapi/asm/$(hdr) seems unneeded at least.
> (perhaps, the whole hunk might be unneeded.)
I think we can remove the whole hunk (see also [2]).

> 
> 
> 
> [2]
> 
>> ifeq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/uapi/asm/a.out.h \
>>                 $(srctree)/arch/$(SRCARCH)/include/asm/a.out.h),)
>> header-n += a.out.h
>> endif
>>
>> ifeq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/uapi/asm/kvm.h \
>>                 $(srctree)/arch/$(SRCARCH)/include/asm/kvm.h),)
>> header-n += kvm.h
>> endif
>>
>> ifeq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/uapi/asm/kvm_para.h \
>>                 $(srctree)/arch/$(SRCARCH)/include/asm/kvm_para.h),)
>> header-n += kvm_para.h
>> endif
> 
> This series intends all headers are exported from uapi/, correct?
> Do we still need to check $(srctree)/arch/$(SRCARCH)/include/asm/*.h ?
> (related to [1])
No you're right, uapi/asm/*.h is enough. Those files should be exported only if
the uapi/asm/ counterpart exists.

> 
> 
> 
> [3]
> 
>> --- 7.1 header-n
>>
>> header-n is essentially used by include/uapi/linux/Kbuild to avoid
>> exporting specific headers (e.g. kvm.h) on architectures that do not
>> support it. It should be avoided as much as possible.
> 
> 
> Going forward, header-y will be never used
> because uapi/ is exported by default.
> 
> So, I wonder if we could rename this into something clearer.
> 
> Kbuild supports "no-clean-files".
> (Please see ./Kbuild for its usage)
> I guess this notation seems clearer
> when we want to negate the default behavior.
> 
> Can you consider "no-export", "no-export-files", "no-export-headers"
> or whatever you like?
No problem, let's use no-export-headers.


Thank you,
Nicolas
