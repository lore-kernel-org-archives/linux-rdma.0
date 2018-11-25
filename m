From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 7/8] socket: Add SO_TIMESTAMP[NS]_NEW
Date: Sun, 25 Nov 2018 23:35:11 +0100
Message-ID: <CAK8P3a2_i=RwcyjeDTn9HrzvPN7FYEYdFuyo3RXSVS_N4sbYeg@mail.gmail.com>
References: <20181124022035.17519-1-deepa.kernel@gmail.com>
 <20181124022035.17519-8-deepa.kernel@gmail.com> <CAF=yD-K=ZLZ_S=Y6YnhvvkfKQS=21ujwiGd7+JB9yDMtiX_9hg@mail.gmail.com>
 <CAF=yD-K3Ga8qojSh5Epa6m4EYn-Lvdo=e38MnFqOKch1128VHw@mail.gmail.com>
 <CABeXuvoDPvT45CCt2L0TReqtb1Q_-E8+toYu6qjiP0cxfdQNdA@mail.gmail.com> <CAF=yD-LngkYq23Q2TCJv_0PRiAryznYRWRbqYFaQkNO=U0w9gQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CAF=yD-LngkYq23Q2TCJv_0PRiAryznYRWRbqYFaQkNO=U0w9gQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: Deepa Dinamani <deepa.kernel@gmail.com>, David Miller <davem@davemloft.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Networking <netdev@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, y2038 Mailman List <y2038@lists.linaro.org>, "James E.J. Bottomley" <jejb@parisc-linux.org>, Ralf Baechle <ralf@linux-mips.org>, Richard Henderson <rth@twiddle.net>, linux-alpha@vger.kernel.org, "open list:RALINK MIPS ARCHITECTURE" <linux-mips@linux-mips.org>, Parisc List <linux-parisc@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, sparclinux <sparclinux@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Nov 25, 2018 at 3:33 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
> On Sun, Nov 25, 2018 at 12:28 AM Deepa Dinamani <deepa.kernel@gmail.com> wrote:
> > So failing here means adding a bunch of ifdef's to verify it is not
> > executing on 64 bit arch or something like x32.
>
> The code as is adds branches on platforms that do not need it. Ifdefs
> are ugly, but if they can be contained to the few helper functions needed
> for the _2038 variants of cmsg_put, that is acceptable in my opinion.

In general, I think we should plan for the new code to be the fast path,
not the old one. Initially that obviously won't be the case, but I hope
that in a couple of years from now, 32-bit user space will normally use
64-bit time_t.

This also means that the compat handling for these timestamps
can be identical to the native 64-bit bit version, while the old
32-bit code can be hidden behind a flag that is only active
as the slowpath in native 32-bit mode or in compat mode.

I'd also want to see the same thing for the naming, with the
64-bit time_t based code having the obvious name.
SOCK_TSTAMP_NEW is fine, otherwise we can try to
just use SOCK_TSTAMP as the name in the kernel but
make it refer to the new version.

The two special cases we have consider are x86 with x32
user space, which wants 64-bit timestamps in compat mode
with SOCK_TSTAMP_OLD, and sparc64, which has an
incompatible layout of timeval, so we need to make sure
that sparc64 can handle all three layouts correctly.

> > The existing timestamp options: SO_TIMESTAMP* fail to provide proper
> > timestamps beyond year 2038 on 32 bit ABIs.
> > But, these work fine on 64 bit native ABIs.
> > So now we need a way of updating these timestamps so that we do not
> > break existing userspace: 64 bit ABIs should not have to change
> > userspace, 32 bit ABIs should work as is until 2038 after which they
> > have bad timestamps.
> > So we introduce new y2038 safe timestamp options for 32 bit ABIs. We
> > assume that 32 bit applications will switch to new ABIs at some point,
> > but leave the older timestamps as is.
> > I can update the commit text as per above.
>
> So on 32-bit platforms SO_TIMESTAMP_NEW introduces a new struct
> sock_timeval with both 64-bit fields.
>
> Does this not break existing applications that compile against SO_TIMESTAMP
> and expect struct timeval? For one example, the selftests under tools/testing.
>
> The kernel will now convert SO_TIMESTAMP (previously constant 29) to
> different SO_TIMESTAMP_NEW (62) and returns a different struct. Perhaps
> with a library like libc in the middle this can be fixed up
> transparently, but for
> applications that don't have a more recent libc or use a library at
> all, it breaks
> the ABI.
>
> I suspect that these finer ABI points may have been discussed outside the
> narrow confines of socket timestamping. But on its own, this does worry me.

The entire purpose of the complexities in the patch set is to not break
the user space ABI after an application gets recompiled with a 64-bit
time_t defined by a new libc version:

#define SO_TIMESTAMP (sizeof(time_t) == sizeof(__kernel_long_t) ? \
            SO_TIMESTAMP_OLD : SO_TIMESTAMP_NEW)

This delays the evaluation of SO_TIMESTAMP to the point where
it is first used, the assumption being that at this point we have included
the libc header file that defines both 'time_t' and 'struct timeval'.
[If we have not included that header, we get a compile-time error,
which is also necessary because the compiler has no way of deciding
whether to use SO_TIMESTAMP_OLD or SO_TIMESTAMP_NEW
in that case].

If the application is built with a 32-bit time_t, or with on a 64-bit
architecture (all of which have 64-bit time_t and __kernel_long_t),
or on x32 (which also has 64-bit time_t and __kernel_long_t),
the result is SO_TIMESTAMP_OLD, so we tell the kernel
to send back a timestamp in the old format, and everything works
as it did before.

The only thing that changes is 32-bit user space (other than x32) with
a 64-bit time_t. In this case, the application expects a structure
that corresponds to the new sock_timeval (which is compatible
with the user space timeval based on 64-bit time_t), so we must
use the new constant in order to tell the kernel which one we want.

      Arnd
