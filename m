From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Infiniband stack allows references to freed memory
Date: Wed, 1 Feb 2012 14:06:48 -0800
Message-ID: <CAG4TOxNNTOc0hwjOuEa-p2SBf5GBnEjVQyOERiTq5gkprLioYQ@mail.gmail.com>
References: <20120201.161333.2203265702893105548.davem@davemloft.net>
 <CAG4TOxMHG04_REzB9faBcjgUS43845qG5CgDYCUfLDYC6sEjmw@mail.gmail.com>
 <20120201.165041.1820098802489365638.davem@davemloft.net> <20120201.170210.981802234698152048.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120201.170210.981802234698152048.davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 1, 2012 at 2:02 PM, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org> wrot=
e:
> So the crux of the matter is making sure we can get at the correct
> destination address in the packet header. =A0Also we might have to
> conditionalize the code based upon protocol type, does ipoib handle
> ipv6?

Yes, it does both v4 and v6.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
