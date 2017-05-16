From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: Re: [PATCH v11 11/12] uapi: export all arch specifics directories
Date: Tue, 16 May 2017 13:59:27 +0900
Message-ID: <CAK7LNATBNU-2-+bkghurOHyU5CsC9JqqJD3b_nWVcJ_SYQ-xyQ@mail.gmail.com>
References: <CAK7LNAR_yp+O9jUZC8mKdaHgTiCkE7p2-ZbA9YZ8OGyp+uxhBQ@mail.gmail.com>
 <1490617217-30192-1-git-send-email-nicolas.dichtel@6wind.com>
 <1490617217-30192-12-git-send-email-nicolas.dichtel@6wind.com>
 <CAA9_cmf1LXqYmOwad0sRjGyLRyhVOo8W-bcLkp-XFK9sQiFuhg@mail.gmail.com> <CAA9_cmfm64EADryVO7YcdZG_steYbpjij8LNoyQNyiXZs_WJNQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kbuild-owner@vger.kernel.org>
In-Reply-To: <CAA9_cmfm64EADryVO7YcdZG_steYbpjij8LNoyQNyiXZs_WJNQ@mail.gmail.com>
Sender: linux-kbuild-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>, Arnd Bergmann <arnd@arndb.de>, Michal Marek <mmarek@suse.com>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, David Airlie <airlied@linux.ie>, David Miller <davem@davemloft.net>, Russell King <linux@armlinux.org.uk>, Borislav Petkov <bp@alien8.de>, slash.tmp@free.fr, Daniel Vetter <daniel.vetter@ffwll.ch>, Russell King <rmk+kernel@armlinux.org.uk>, msalter@redhat.com, jengelh@inai.de, Christoph Hellwig <hch@infradead.org>, Tobias Klauser <tklauser@distanz.ch>, Michael Ellerman <mpe@ellerman.id.au>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "Dmitry V. Levin" <ldv@altlinux.org>, Herbert Xu <he>
List-Id: linux-rdma@vger.kernel.org

Hi Dan,


2017-05-16 10:15 GMT+09:00 Dan Williams <dan.j.williams@intel.com>:
> On Mon, May 15, 2017 at 6:02 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>> On Mon, Mar 27, 2017 at 5:20 AM, Nicolas Dichtel
>> <nicolas.dichtel@6wind.com> wrote:
>>> This patch removes the need of subdir-y. Now all files/directories under
>>> arch/<arch>/include/uapi/ are exported.
>>>
>>> The only change for userland is the layout of the command 'make
>>> headers_install_all': directories asm-<arch> are replaced by arch-<arch>/.
>>> Those new directories contains all files/directories of the specified arch.
>>>
>>> Note that only cris and tile have more directories than only asm:
>>>  - arch-v[10|32] for cris;
>>>  - arch for tile.
>>>
>>> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
>>
>> Starting with commit 61562f981e92 "uapi: export all arch specifics
>> directories", a "make INSTALL_HDR_PATH=$root/usr headers_install"
>> operation will delete standard glibc headers and others in
>> $root/usr/include.
>
> Reverting commit 61562f981e92 fixes the problem for me.

Thank you for your bug report.

Could you check this?
https://patchwork.kernel.org/patch/9728323/



-- 
Best Regards
Masahiro Yamada
