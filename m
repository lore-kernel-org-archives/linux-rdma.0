From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: Re: [PATCH v10 00/11] uapi: export all headers under uapi directories
Date: Fri, 24 Mar 2017 10:03:08 +0100
Message-ID: <c963314f-bcde-f483-c6b1-cad975842e16@6wind.com>
References: <CAK7LNARpx7f0eV5_AiPmNYT7MsRbGFOygJwjfAzX_7aCpuHwuw@mail.gmail.com>
 <1489496093-15315-1-git-send-email-nicolas.dichtel@6wind.com>
 <365519b5-d69e-34b7-fa2f-f11b8fabe69f@6wind.com>
 <CAK7LNAR_yp+O9jUZC8mKdaHgTiCkE7p2-ZbA9YZ8OGyp+uxhBQ@mail.gmail.com>
Reply-To: nicolas.dichtel@6wind.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <CAK7LNAR_yp+O9jUZC8mKdaHgTiCkE7p2-ZbA9YZ8OGyp+uxhBQ@mail.gmail.com>
Sender: linux-arch-owner@vger.kernel.org
To: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Michal Marek <mmarek@suse.com>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, David Airlie <airlied@linux.ie>, "David S. Miller" <davem@davemloft.net>, Russell King <linux@armlinux.org.uk>, bp@alien8.de, slash.tmp@free.fr, Daniel Vetter <daniel.vetter@ffwll.ch>, rmk+kernel@armlinux.org.uk, msalter@redhat.com, jengelh@inai.de, hch@infradead.org, Tobias Klauser <tklauser@distanz.ch>, mpe@ellerman.id.au, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "Dmitry V. Levin" <ldv@altlinux.org>, Herbert Xu <herbert@gondor.apana.org.au>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Le 24/03/2017 à 09:42, Masahiro Yamada a écrit :
> Hi Nicolas,
> 
> 
> 2017-03-24 17:32 GMT+09:00 Nicolas Dichtel <nicolas.dichtel@6wind.com>:
>> Le 14/03/2017 à 13:54, Nicolas Dichtel a écrit :
>>> Patches #1 and #2 are just cleanup: some exported headers were still under
>>> a non-uapi directory. Patch #3 is a fix to avoid exporting a file that was
>>> not under an uapi directory.
>>> After these three patches, all exported headers are under an uapi directory:
>>> path #4 stops searching files in non uapi directories.
>>> The patch #5 was spotted by code review: there is no in-tree user of this
>>> functionality.
>>> Patch #6 fixes some warnings/errors reported by 0-day tests.
>>> Patch #7 to #9 fix some errors when the corresponding files are included by
>>> userland.
>>> Patches #10 and #11 remove the need to list explicitly headers. Now all files
>>> under an uapi directory are exported.
>>>
>>> This series has been tested with a 'make headers_install' on x86 and a
>>> 'make headers_install_all'. I've checked the result of both commands.
>>>
>>> This patch is built on top of masahiroy/linux-kbuild.git#for-next (v4.11-rc1).
>>> I didn't find any conflict with v4.11-rc2.
>> Masahiro, is this series under review or do you expect something else on my side?
>>
> 
> Under review.
> Please give me time to take a closer look.
> Sorry for the delay.
No problem, take your time. I just wanted to be sure to not miss something ;-)


Thank you,
Nicolas
