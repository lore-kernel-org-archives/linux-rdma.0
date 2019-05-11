From: Sowmini Varadhan <sowmini05@gmail.com>
Subject: Re: Annoying gcc / rdma / networking warnings
Date: Sat, 11 May 2019 16:02:35 -0400
Message-ID: <20190511200235.GA257@gmail.com>
References: <CAHk-=whbuwm5FbkPSfftZ3oHMWw43ZNFXqvW1b6KFMEj5wBipA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHk-=whbuwm5FbkPSfftZ3oHMWw43ZNFXqvW1b6KFMEj5wBipA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jason Gunthorpe <jgg@mellanox.com>, David Miller <davem@davemloft.net>, Doug Ledford <dledford@redhat.com>, linux-rdma <linux-rdma@vger.kernel.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On (05/11/19 12:52), Linus Torvalds wrote:
> 
> So David, arguably the kernel "struct sockaddr" is simply wrong, if it
> can't contain a "struct sockaddr_in6". No? Is extending it a huge
> problem for other users that don't need it (mainly stack, I assume..)?

The ipv6 working group came up with sockaddr_storage to solve this.
See RFC 2553. However, in practice, since sizeof(struct sockaddr_storage)
is much larger than simply creating a union of sockaddr_in and sockaaddr_in6,
most userspace networking applications will do the latter.

The strucut sockaddr is the mereely the generic pointer cast
that is expected to be used for the common posix fucntions like
bind/connect etc.

> Also equally arguably, the rdma code could just use a "struct
> sockaddr_in6 for this use and avoid the gcc issue, couldn't it? It has

Yes, that would be the right solution.

--Sowmini
