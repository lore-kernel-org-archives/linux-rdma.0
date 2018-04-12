From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [GIT PULL] asm-generic fixes for v4.17-rc1
Date: Thu, 12 Apr 2018 09:16:30 +0200
Message-ID: <CAK8P3a2brHyWJx=WwXgxr3Gkouu5DAgqBvBQiz0rcPvZ18xO8g@mail.gmail.com>
References: <CAK8P3a081_hkr5d0FRWpTaT-AsJoqznsS1=_WF4JVLTUOupUgg@mail.gmail.com>
 <CA+55aFx4_gaBeffy9roFRnkB30fnRa=nhh5qR=o=CgrWmgphiw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFx4_gaBeffy9roFRnkB30fnRa=nhh5qR=o=CgrWmgphiw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sinan Kaya <okaya@codeaurora.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-s390 <linux-s390@vger.kernel.org>, Linux ARM <linux-arm-kernel@lists.infradead.org>, linux-arch <linux-arch@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Ley Foon Tan <lftan@altera.com>, "moderated list:NIOS2 ARCHITECTURE" <nios2-dev@lists.rocketboards.org>, Michal Simek <monstr@monstr.eu>, "moderated list:H8/300 ARCHITECTURE" <uclinux-h8-devel@lists.sourceforge.jp>, Yoshinori Sato <ysato@users.sourceforge.jp>, sparclinux <sparclinux@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>, Guan
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 12, 2018 at 1:16 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Apr 11, 2018 at 8:40 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>>
>> are available in the git repository at:
>>
>>   git+ssh://gitolite@ra.kernel.org/pub/scm/linux/kernel/git/arnd/asm-generic.git
>> tags/asm-generic
>
> Yeah, no they aren't available there at all.
>
> That tag is some old tag from two years ago that just contains your
> ancient "asm-generic: use compat version for preadv2 and pwritev2".
>
> Forgot to push out? Or forgot to use "-f" to overwrite the old tag?

Yes, something like that, I first tagged the local branch in the wrong
tree which had an old branch of the same name, noticed my mistake
as I pushed it, but then screwed up again when I tried to correct it:
I force-pushed the correct branch again, but not the tag.

Pushed the right tag now, please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/arnd/asm-generic.git
tags/asm-generic

        Arnd
