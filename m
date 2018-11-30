From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: Re: [PATCH 2/8] sockopt: Rename SO_TIMESTAMP* to SO_TIMESTAMP*_OLD
Date: Fri, 30 Nov 2018 18:33:57 -0500
Message-ID: <CAF=yD-+DNdGpitd9TABeHjnBFRPcrN4E-AcQNmGMD-Lt9th7mw@mail.gmail.com>
References: <20181124022035.17519-1-deepa.kernel@gmail.com>
 <20181124022035.17519-3-deepa.kernel@gmail.com> <CAF=yD-KfxXK=Ta=+a8UYMcmUYzN=UokotfzSno2-xi=JeS6=0g@mail.gmail.com>
 <CABeXuvr7M4z6-7qsnBZqnXQEcGxfgVddGmsoV=iLwA-n=S5VkQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CABeXuvr7M4z6-7qsnBZqnXQEcGxfgVddGmsoV=iLwA-n=S5VkQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Deepa Dinamani <deepa.kernel@gmail.com>
Cc: David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>, y2038 Mailman List <y2038@lists.linaro.org>, Helge Deller <deller@gmx.de>, David Howells <dhowells@redhat.com>, jejb@parisc-linux.org, ralf@linux-mips.org, rth@twiddle.net, linux-afs@lists.infradead.org, linux-alpha@vger.kernel.org, linux-arch@vger.kernel.org, linux-mips@linux-mips.org, linux-parisc@vger.kernel.org, linux-rdma@vger.kernel.org, sparclinux@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Nov 30, 2018 at 5:38 PM Deepa Dinamani <deepa.kernel@gmail.com> wrote:
>
> On Sat, Nov 24, 2018 at 7:59 PM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > On Sat, Nov 24, 2018 at 3:58 AM Deepa Dinamani <deepa.kernel@gmail.com> wrote:
> > >
> > > SO_TIMESTAMP, SO_TIMESTAMPNS and SO_TIMESTAMPING options, the
> > > way they are currently defined, are not y2038 safe.
> > > Subsequent patches in the series add new y2038 safe versions
> > > of these options which provide 64 bit timestamps on all
> > > architectures uniformly.
> > > Hence, rename existing options with OLD tag suffixes.
> >
> > Why do the existing interfaces have to be renamed when new interfaces are added?
>
> Existing options need to be renamed because of the macro below:
>
> #define SO_TIMESTAMP (sizeof(time_t) == sizeof(__kernel_long_t) ? \
>             SO_TIMESTAMP_OLD : SO_TIMESTAMP_NEW)
>
> SO_TIMESTAMP is now dependent on size of time_t because of the libc flag.

Yes, I understand the mechanism based on libc's definition of time_t
after Arnd's explanation. Please do capture that in the commit
message, for possible future readers who stumble upon the code with
git blame.
