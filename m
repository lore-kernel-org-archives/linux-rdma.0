From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: Re: [PATCH v10 07/11] btrfs_tree.h: fix include from userland
Date: Mon, 27 Mar 2017 11:45:17 +0200
Message-ID: <f82705b0-1727-ef4a-138c-e268f3530f07@6wind.com>
References: <CAK7LNARpx7f0eV5_AiPmNYT7MsRbGFOygJwjfAzX_7aCpuHwuw@mail.gmail.com>
 <1489496093-15315-1-git-send-email-nicolas.dichtel@6wind.com>
 <1489496093-15315-8-git-send-email-nicolas.dichtel@6wind.com>
 <CAK7LNATUdjuNVdOEhitsPrpeORFOR2ER3OYDf9Pxn1JP639FeQ@mail.gmail.com>
Reply-To: nicolas.dichtel@6wind.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <CAK7LNATUdjuNVdOEhitsPrpeORFOR2ER3OYDf9Pxn1JP639FeQ@mail.gmail.com>
Sender: linux-arch-owner@vger.kernel.org
To: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Michal Marek <mmarek@suse.com>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, David Airlie <airlied@linux.ie>, "David S. Miller" <davem@davemloft.net>, Russell King <linux@armlinux.org.uk>, bp@alien8.de, slash.tmp@free.fr, Daniel Vetter <daniel.vetter@ffwll.ch>, rmk+kernel@armlinux.org.uk, msalter@redhat.com, jengelh@inai.de, hch@infradead.org, Tobias Klauser <tklauser@distanz.ch>, mpe@ellerman.id.au, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "Dmitry V. Levin" <ldv@altlinux.org>, Herbert Xu <herbert@gondor.apana.org.au>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Hi Masahiro,

Le 27/03/2017 à 07:53, Masahiro Yamada a écrit :
> Hi Nicolas,
> 
> 
> 2017-03-14 21:54 GMT+09:00 Nicolas Dichtel <nicolas.dichtel@6wind.com>:
[snip]
>> diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
>> index 6a261cb52d95..6a754ada59af 100644
>> --- a/include/uapi/linux/btrfs_tree.h
>> +++ b/include/uapi/linux/btrfs_tree.h
>> @@ -2,6 +2,7 @@
>>  #define _BTRFS_CTREE_H_
>>
>>  #include <linux/types.h>
>> +#include <linux/btrfs.h>
>>
> 
> Can you move <linux/types.h> below <linux/btrfs.h>
> to sort the includes alphabetically?
Ok.

> 
> This also applies to:
> 
> include/uapi/linux/qrtr.h in 06/11
> include/uapi/linux/cryptouser.h  in 08/11
Ok.


Regards,
Nicolas
