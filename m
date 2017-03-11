From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: Re: [PATCH v9 00/11] uapi: export all headers under uapi directories
Date: Sat, 11 Mar 2017 14:43:15 +0900
Message-ID: <CAK7LNARpx7f0eV5_AiPmNYT7MsRbGFOygJwjfAzX_7aCpuHwuw@mail.gmail.com>
References: <20170301045241.GB9156@gondor.apana.org.au> <1488473802-13354-1-git-send-email-nicolas.dichtel@6wind.com>
 <3df45ecc-1aa0-a029-d7e5-2598f0908874@6wind.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kbuild-owner@vger.kernel.org>
In-Reply-To: <3df45ecc-1aa0-a029-d7e5-2598f0908874@6wind.com>
Sender: linux-kbuild-owner@vger.kernel.org
To: nicolas.dichtel@6wind.com
Cc: Arnd Bergmann <arnd@arndb.de>, Michal Marek <mmarek@suse.com>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, David Airlie <airlied@linux.ie>, "David S. Miller" <davem@davemloft.net>, Russell King <linux@armlinux.org.uk>, bp@alien8.de, slash.tmp@free.fr, daniel.vetter@ffwll.ch, rmk+kernel@armlinux.org.uk, msalter@redhat.com, jengelh@inai.de, hch@infradead.org, tklauser@distanz.ch, mpe@ellerman.id.au, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, ldv@altlinux.org, Herbert Xu <herbert@gondor.apana.org.au>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Hi Nicolas,


2017-03-11 1:34 GMT+09:00 Nicolas Dichtel <nicolas.dichtel@6wind.com>:
> Le 02/03/2017 =C3=A0 17:56, Nicolas Dichtel a =C3=A9crit :
>> Patches #1 and #2 are just cleanup: some exported headers were still und=
er
>> a non-uapi directory. Patch #3 is a fix to avoid exporting a file that w=
as
>> not under an uapi directory.
>> After these three patches, all exported headers are under an uapi direct=
ory:
>> path #4 stops searching files in non uapi directories.
>> The patch #5 was spotted by code review: there is no in-tree user of thi=
s
>> functionality.
>> Patch #6 fixes some warnings/errors reported by 0-day tests.
>> Patch #7 to #9 fix some errors when the corresponding files are included=
 by
>> userland.
>> Patches #10 and #11 remove the need to list explicitly headers. Now all =
files
>> under an uapi directory are exported.
>>
>> This series has been tested with a 'make headers_install' on x86 and a
>> 'make headers_install_all'. I've checked the result of both commands.
>>
>> This patch is built against linus tree. If I must rebase it against the =
kbuild
>> tree, just tell me.
>> Michal, is this series going through your tree?
> Still waiting to know who may take this series in its tree ;-)


I will take care of this.



> kbuild tree has not been updated since two months (4.10-rc1) :/

Michal's tree is not active these days.
Going forward, I will queue up Kbuild patches in my repository.



BTW, this series does not apply cleanly.

If you could rebase it onto v4.11-rc1 tag,
it would be helpful.



Thanks!

--=20
Best Regards
Masahiro Yamada
