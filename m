From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v11 08/12] cryptouser.h: fix include from userland
Date: Tue, 11 Apr 2017 10:40:22 +0800
Message-ID: <20170411024022.GA10615@gondor.apana.org.au>
References: <CAK7LNAR_yp+O9jUZC8mKdaHgTiCkE7p2-ZbA9YZ8OGyp+uxhBQ@mail.gmail.com>
 <1490617217-30192-1-git-send-email-nicolas.dichtel@6wind.com>
 <1490617217-30192-9-git-send-email-nicolas.dichtel@6wind.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1490617217-30192-9-git-send-email-nicolas.dichtel@6wind.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc: yamada.masahiro@socionext.com, arnd@arndb.de, mmarek@suse.com, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, airlied@linux.ie, davem@davemloft.net, linux@armlinux.org.uk, bp@alien8.de, slash.tmp@free.fr, daniel.vetter@ffwll.ch, rmk+kernel@armlinux.org.uk, msalter@redhat.com, jengelh@inai.de, hch@infradead.org, tklauser@distanz.ch, mpe@ellerman.id.au, mingo@kernel.org, tglx@linutronix.de, ldv@altlinux.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 27, 2017 at 02:20:13PM +0200, Nicolas Dichtel wrote:
> This patch prepares the uapi export by fixing the following error:
> 
> .../linux/cryptouser.h:58:16: error: ‘CRYPTO_MAX_ALG_NAME’ undeclared here (not in a function)
>   char cru_name[CRYPTO_MAX_ALG_NAME];
> 
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Can we revert this patch please? I had forgotten about it when
increasing the in-kernel CRYPTO_MAX_ALG_NAME so it now conflicts
with the crypto tree.  The crypto tree has fixed the problem in
a different way.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
