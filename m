From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: Re: [PATCH v9 00/11] uapi: export all headers under uapi directories
Date: Mon, 13 Mar 2017 17:57:17 +0100
Message-ID: <96811b2b-25af-ed32-5094-14987aefd4d2@6wind.com>
References: <20170301045241.GB9156@gondor.apana.org.au>
 <1488473802-13354-1-git-send-email-nicolas.dichtel@6wind.com>
 <3df45ecc-1aa0-a029-d7e5-2598f0908874@6wind.com>
 <CAK7LNARpx7f0eV5_AiPmNYT7MsRbGFOygJwjfAzX_7aCpuHwuw@mail.gmail.com>
Reply-To: nicolas.dichtel@6wind.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK7LNARpx7f0eV5_AiPmNYT7MsRbGFOygJwjfAzX_7aCpuHwuw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Michal Marek <mmarek@suse.com>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, David Airlie <airlied@linux.ie>, "David S. Miller" <davem@davemloft.net>, Russell King <linux@armlinux.org.uk>, bp@alien8.de, slash.tmp@free.fr, daniel.vetter@ffwll.ch, rmk+kernel@armlinux.org.uk, msalter@redhat.com, jengelh@inai.de, hch@infradead.org, tklauser@distanz.ch, mpe@ellerman.id.au, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, ldv@altlinux.org, Herbert Xu <herbert@gondor.apana.org.au>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Le 11/03/2017 à 06:43, Masahiro Yamada a écrit :
[snip]
> 
> I will take care of this.
Thank you.

> 
> 
> 
>> kbuild tree has not been updated since two months (4.10-rc1) :/
> 
> Michal's tree is not active these days.
Ok, I didn't know that.

> Going forward, I will queue up Kbuild patches in my repository.
> 
> 
> 
> BTW, this series does not apply cleanly.
> 
> If you could rebase it onto v4.11-rc1 tag,
> it would be helpful.
You really want this on top of 4.11-rc1 or the last linus tag, ie v4.11-rc2?


Regards,
Nicolas
