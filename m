From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: Re: [PATCH 2/8] sockopt: Rename SO_TIMESTAMP* to SO_TIMESTAMP*_OLD
Date: Fri, 30 Nov 2018 14:38:27 -0800
Message-ID: <CABeXuvr7M4z6-7qsnBZqnXQEcGxfgVddGmsoV=iLwA-n=S5VkQ@mail.gmail.com>
References: <20181124022035.17519-1-deepa.kernel@gmail.com>
 <20181124022035.17519-3-deepa.kernel@gmail.com> <CAF=yD-KfxXK=Ta=+a8UYMcmUYzN=UokotfzSno2-xi=JeS6=0g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CAF=yD-KfxXK=Ta=+a8UYMcmUYzN=UokotfzSno2-xi=JeS6=0g@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
To: willemdebruijn.kernel@gmail.com
Cc: "David S. Miller" <davem@davemloft.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Network Devel Mailing List <netdev@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>, y2038 Mailman List <y2038@lists.linaro.org>, Helge Deller <deller@gmx.de>, David Howells <dhowells@redhat.com>, "James E.J. Bottomley" <jejb@parisc-linux.org>, Ralf Baechle <ralf@linux-mips.org>, rth@twiddle.net, linux-afs@lists.infradead.org, linux-alpha@vger.kernel.org, linux-arch <linux-arch@vger.kernel.org>, "open list:RALINK MIPS ARCHITECTURE" <linux-mips@linux-mips.org>, Parisc List <linux-parisc@vger.kernel.org>, linux-rdma@vger.kernel.org, sparclinux <sparclinux@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Nov 24, 2018 at 7:59 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Sat, Nov 24, 2018 at 3:58 AM Deepa Dinamani <deepa.kernel@gmail.com> wrote:
> >
> > SO_TIMESTAMP, SO_TIMESTAMPNS and SO_TIMESTAMPING options, the
> > way they are currently defined, are not y2038 safe.
> > Subsequent patches in the series add new y2038 safe versions
> > of these options which provide 64 bit timestamps on all
> > architectures uniformly.
> > Hence, rename existing options with OLD tag suffixes.
>
> Why do the existing interfaces have to be renamed when new interfaces are added?

Existing options need to be renamed because of the macro below:

#define SO_TIMESTAMP (sizeof(time_t) == sizeof(__kernel_long_t) ? \
            SO_TIMESTAMP_OLD : SO_TIMESTAMP_NEW)

SO_TIMESTAMP is now dependent on size of time_t because of the libc flag.

-Deepa
