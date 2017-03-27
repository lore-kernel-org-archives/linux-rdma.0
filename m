From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: Re: [PATCH v11 00/12] uapi: export all headers under uapi directories
Date: Tue, 28 Mar 2017 00:35:07 +0900
Message-ID: <CAK7LNATG6M7Q_sXbfRRLF6ALJPRkbr=h5zz9VjFRQEsDNL1AQA@mail.gmail.com>
References: <CAK7LNAR_yp+O9jUZC8mKdaHgTiCkE7p2-ZbA9YZ8OGyp+uxhBQ@mail.gmail.com>
 <1490617217-30192-1-git-send-email-nicolas.dichtel@6wind.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kbuild-owner@vger.kernel.org>
In-Reply-To: <1490617217-30192-1-git-send-email-nicolas.dichtel@6wind.com>
Sender: linux-kbuild-owner@vger.kernel.org
To: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Michal Marek <mmarek@suse.com>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, David Airlie <airlied@linux.ie>, "David S. Miller" <davem@davemloft.net>, Russell King <linux@armlinux.org.uk>, bp@alien8.de, slash.tmp@free.fr, Daniel Vetter <daniel.vetter@ffwll.ch>, rmk+kernel@armlinux.org.uk, msalter@redhat.com, jengelh@inai.de, hch@infradead.org, Tobias Klauser <tklauser@distanz.ch>, mpe@ellerman.id.au, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "Dmitry V. Levin" <ldv@altlinux.org>, Herbert Xu <herbert@gondor.apana.org.au>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

2017-03-27 21:20 GMT+09:00 Nicolas Dichtel <nicolas.dichtel@6wind.com>:
>
>
> Patches #1 and #2 are just cleanup: some exported headers were still under
> a non-uapi directory. Patch #3 is a fix to avoid exporting a file that was
> not under an uapi directory.
> After these three patches, all exported headers are under an uapi directory:
> path #4 stops searching files in non uapi directories.
> The patch #5 was spotted by code review: there is no in-tree user of this
> functionality.
> Patch #6 fixes some warnings/errors reported by 0-day tests.
> Patch #7 to #9 fix some errors when the corresponding files are included by
> userland.
> Patches #10 and #11 remove the need to list explicitly headers. Now all files
> under an uapi directory are exported.
> Patch #12 is also a small cleanup.
>
> This series has been tested with a 'make headers_install' on x86 and a
> 'make headers_install_all'. I've checked the result of both commands.
>
> This patch is built on top of masahiroy/linux-kbuild.git#for-next (v4.11-rc1).
> I didn't find any conflict with v4.11-rc4.
>
> v10 -> v11:
>   - patch #1: restore the double '_' in the header guard
>   - patch #6, #7, #8: order '#include' in alphabetical order
>   - patch #10: rename header-n to no-export-headers
>                cleanup management of kvm.h, kvm_para.h and a.out.h
>   - patch #12: add it
>   - rebase on top of masahiroy/linux-kbuild.git#for-next


Series, applied to linux-kbuild/uapi.  Thanks!


-- 
Best Regards
Masahiro Yamada
