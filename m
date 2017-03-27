From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: Re: [PATCH v10 01/11] h8300: put bitsperlong.h in uapi
Date: Mon, 27 Mar 2017 14:31:21 +0900
Message-ID: <CAK7LNASeY8-74c_7wcgVdw5BwCgJGO48YsTMzc06rAFRRqAyPw@mail.gmail.com>
References: <CAK7LNARpx7f0eV5_AiPmNYT7MsRbGFOygJwjfAzX_7aCpuHwuw@mail.gmail.com>
 <1489496093-15315-1-git-send-email-nicolas.dichtel@6wind.com> <1489496093-15315-2-git-send-email-nicolas.dichtel@6wind.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kbuild-owner@vger.kernel.org>
In-Reply-To: <1489496093-15315-2-git-send-email-nicolas.dichtel@6wind.com>
Sender: linux-kbuild-owner@vger.kernel.org
To: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Michal Marek <mmarek@suse.com>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, David Airlie <airlied@linux.ie>, "David S. Miller" <davem@davemloft.net>, Russell King <linux@armlinux.org.uk>, bp@alien8.de, slash.tmp@free.fr, Daniel Vetter <daniel.vetter@ffwll.ch>, rmk+kernel@armlinux.org.uk, msalter@redhat.com, jengelh@inai.de, hch@infradead.org, Tobias Klauser <tklauser@distanz.ch>, mpe@ellerman.id.au, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "Dmitry V. Levin" <ldv@altlinux.org>, Herbert Xu <herbert@gondor.apana.org.au>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Hi Nicolas,


2017-03-14 21:54 GMT+09:00 Nicolas Dichtel <nicolas.dichtel@6wind.com>:
> This header file is exported, thus move it to uapi.
>
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>



> -#endif /* __ASM_H8300_BITS_PER_LONG */
> diff --git a/arch/h8300/include/uapi/asm/bitsperlong.h b/arch/h8300/include/uapi/asm/bitsperlong.h
> new file mode 100644
> index 000000000000..e56cf72369b6
> --- /dev/null
> +++ b/arch/h8300/include/uapi/asm/bitsperlong.h
> @@ -0,0 +1,14 @@
> +#ifndef _UAPI_ASM_H8300_BITS_PER_LONG
> +#define _UAPI_ASM_H8300_BITS_PER_LONG


Just a minor comment.

The include guard was originally __ASM_H8300_BITS_PER_LONG.
This will change it into _ASM_H8300_BITS_PER_LONG
(after _UAPI is stripped by headers_install.sh)

I just thought _UAPI__ASM_H8300_BITS_PER_LONG might be even safer,
but I know I am nit-picking.  I can apply this as-is.
I leave it to you.


-- 
Best Regards
Masahiro Yamada
