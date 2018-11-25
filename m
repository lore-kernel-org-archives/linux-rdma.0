From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: Re: [PATCH 7/8] socket: Add SO_TIMESTAMP[NS]_NEW
Date: Sun, 25 Nov 2018 09:38:41 -0500
Message-ID: <CAF=yD-+ZiBR+VFzDnKOKPBCuNF_wbAe6goNO8KXYQH105Sg=0g@mail.gmail.com>
References: <20181124022035.17519-1-deepa.kernel@gmail.com>
 <20181124022035.17519-8-deepa.kernel@gmail.com> <CAF=yD-K=ZLZ_S=Y6YnhvvkfKQS=21ujwiGd7+JB9yDMtiX_9hg@mail.gmail.com>
 <CAF=yD-K3Ga8qojSh5Epa6m4EYn-Lvdo=e38MnFqOKch1128VHw@mail.gmail.com>
 <CABeXuvoDPvT45CCt2L0TReqtb1Q_-E8+toYu6qjiP0cxfdQNdA@mail.gmail.com> <CABeXuvr6fi9UPwMvuafx7MwEta-Sx1TLNN0KQ8HQHhn=vAne5Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CABeXuvr6fi9UPwMvuafx7MwEta-Sx1TLNN0KQ8HQHhn=vAne5Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Deepa Dinamani <deepa.kernel@gmail.com>
Cc: David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>, y2038 Mailman List <y2038@lists.linaro.org>, jejb@parisc-linux.org, ralf@linux-mips.org, rth@twiddle.net, linux-alpha@vger.kernel.org, linux-mips@linux-mips.org, linux-parisc@vger.kernel.org, linux-rdma@vger.kernel.org, sparclinux@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

> > > > Same for the tcp case above, really, and in the case of the next patch
> > > > for SO_TIMESTAMPING_NEW
> > >
> > > That naming convention, ..._2038, is not the nicest, of course. That
> > > is not the relevant bit in the above comment.
>
> it could be  __sock_recv_timestamp64().
> But, these timestamps should be doing exactly the same thing as the
> old ones and I thought it would be nicer to keep the same code path.
> I can change it to as per above.

Please minimize code changes. It breaks git blame and longer patches
are harder to review.

In this specific case, from a readability point of view, I find new functions
that map one-to-one onto the new interfaces also more readable than
deeper nested branches in place.

> > So we introduce new y2038 safe timestamp options for 32 bit ABIs. We
> > assume that 32 bit applications will switch to new ABIs at some point,
> > but leave the older timestamps as is.
> > I can update the commit text as per above.
>
> We have been avoiding adding timeval64 timestamps to discourage users
> from using these types in the interfaces.
> We want to keep all the uapi time interfaces to use __kernel_*
> interfaces. And, we already provide __kernel_timespec interface for
> such instances.
> But, in this case we do not have an option. So we introduce a type
> specific to sockets.

This structure just holds a timestamp. It does not seem socket specific.
I don't mean to bikeshed the naming point too much, but timeval_ll or
so may be more representative than tying it to a socket.

As for the general naming, xxx64 or xxx2038 are more descriptive than xxx_NEW.
