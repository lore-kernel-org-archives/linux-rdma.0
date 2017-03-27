From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: Re: [PATCH v10 00/11] uapi: export all headers under uapi directories
Date: Mon, 27 Mar 2017 14:26:51 +0900
Message-ID: <CAK7LNAQJWNCRjWoKMH_Br1bwqtq+mQG-6yaWu5fwhC6sJ1fV8Q@mail.gmail.com>
References: <CAK7LNARpx7f0eV5_AiPmNYT7MsRbGFOygJwjfAzX_7aCpuHwuw@mail.gmail.com>
 <1489496093-15315-1-git-send-email-nicolas.dichtel@6wind.com>
 <365519b5-d69e-34b7-fa2f-f11b8fabe69f@6wind.com> <CAK7LNAR_yp+O9jUZC8mKdaHgTiCkE7p2-ZbA9YZ8OGyp+uxhBQ@mail.gmail.com>
 <c963314f-bcde-f483-c6b1-cad975842e16@6wind.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <c963314f-bcde-f483-c6b1-cad975842e16@6wind.com>
Sender: linux-arch-owner@vger.kernel.org
To: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Michal Marek <mmarek@suse.com>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, David Airlie <airlied@linux.ie>, "David S. Miller" <davem@davemloft.net>, Russell King <linux@armlinux.org.uk>, bp@alien8.de, slash.tmp@free.fr, Daniel Vetter <daniel.vetter@ffwll.ch>, rmk+kernel@armlinux.org.uk, msalter@redhat.com, jengelh@inai.de, hch@infradead.org, Tobias Klauser <tklauser@distanz.ch>, mpe@ellerman.id.au, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "Dmitry V. Levin" <ldv@altlinux.org>, Herbert Xu <herbert@gondor.apana.org.au>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Hi Nocolas,


2017-03-24 18:03 GMT+09:00 Nicolas Dichtel <nicolas.dichtel@6wind.com>:
> Le 24/03/2017 =C3=A0 09:42, Masahiro Yamada a =C3=A9crit :
>> Hi Nicolas,
>>
>>
>> 2017-03-24 17:32 GMT+09:00 Nicolas Dichtel <nicolas.dichtel@6wind.com>:
>>> Le 14/03/2017 =C3=A0 13:54, Nicolas Dichtel a =C3=A9crit :
>>>> Patches #1 and #2 are just cleanup: some exported headers were still u=
nder
>>>> a non-uapi directory. Patch #3 is a fix to avoid exporting a file that=
 was
>>>> not under an uapi directory.
>>>> After these three patches, all exported headers are under an uapi dire=
ctory:
>>>> path #4 stops searching files in non uapi directories.
>>>> The patch #5 was spotted by code review: there is no in-tree user of t=
his
>>>> functionality.
>>>> Patch #6 fixes some warnings/errors reported by 0-day tests.
>>>> Patch #7 to #9 fix some errors when the corresponding files are includ=
ed by
>>>> userland.
>>>> Patches #10 and #11 remove the need to list explicitly headers. Now al=
l files
>>>> under an uapi directory are exported.
>>>>
>>>> This series has been tested with a 'make headers_install' on x86 and a
>>>> 'make headers_install_all'. I've checked the result of both commands.
>>>>
>>>> This patch is built on top of masahiroy/linux-kbuild.git#for-next (v4.=
11-rc1).
>>>> I didn't find any conflict with v4.11-rc2.
>>> Masahiro, is this series under review or do you expect something else o=
n my side?
>>>
>>
>> Under review.
>> Please give me time to take a closer look.
>> Sorry for the delay.
> No problem, take your time. I just wanted to be sure to not miss somethin=
g ;-)
>
>


As a whole, this series is amazing.  Thanks for your great work!


I added some comments, but they are trivial.




I wanted to leave comments/questions on 10/11,
but I could not find 10/11 in my mailbox.  I do not know why.


I am leaving comments on the cover-letter,
the following are related to 10/11.



[1]

>mandatory-y +=3D $(foreach hdr,$(opt-header), \
>              $(if \
>                $(wildcard \
>                        $(srctree)/arch/$(SRCARCH)/include/uapi/asm/$(hdr)=
 \
>                        $(srctree)/arch/$(SRCARCH)/include/asm/$(hdr) \
>                ), \
>                $(hdr) \
>                ))

What is this actually checking?

If ARCH has its own (uapi/)asm/{kvm.h,kvm_para.h,a.out.h},
they are added to mandatory-y, then they are checked if they exist.
But, we know they exist.


This check reminds us only when we added asm/*.h
but forgot to add uapi/asm/*.h

$(srctree)/arch/$(SRCARCH)/include/uapi/asm/$(hdr) seems unneeded at least.
(perhaps, the whole hunk might be unneeded.)



[2]

>ifeq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/uapi/asm/a.out.h \
>                 $(srctree)/arch/$(SRCARCH)/include/asm/a.out.h),)
>header-n +=3D a.out.h
>endif
>
>ifeq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/uapi/asm/kvm.h \
>                 $(srctree)/arch/$(SRCARCH)/include/asm/kvm.h),)
>header-n +=3D kvm.h
>endif
>
>ifeq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/uapi/asm/kvm_para.h \
>                 $(srctree)/arch/$(SRCARCH)/include/asm/kvm_para.h),)
>header-n +=3D kvm_para.h
>endif

This series intends all headers are exported from uapi/, correct?
Do we still need to check $(srctree)/arch/$(SRCARCH)/include/asm/*.h ?
(related to [1])



[3]

>--- 7.1 header-n
>
>header-n is essentially used by include/uapi/linux/Kbuild to avoid
>exporting specific headers (e.g. kvm.h) on architectures that do not
>support it. It should be avoided as much as possible.


Going forward, header-y will be never used
because uapi/ is exported by default.

So, I wonder if we could rename this into something clearer.

Kbuild supports "no-clean-files".
(Please see ./Kbuild for its usage)
I guess this notation seems clearer
when we want to negate the default behavior.

Can you consider "no-export", "no-export-files", "no-export-headers"
or whatever you like?




Thanks!



--=20
Best Regards
Masahiro Yamada
