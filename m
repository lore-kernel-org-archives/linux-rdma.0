From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Infiniband stack allows references to freed memory
Date: Wed, 1 Feb 2012 13:42:30 -0800
Message-ID: <CAG4TOxMHG04_REzB9faBcjgUS43845qG5CgDYCUfLDYC6sEjmw@mail.gmail.com>
References: <20120201.152213.433850213028883896.davem@davemloft.net>
 <CAG4TOxPrAhac1y-TzA=x47sm88JfQdkrpWW4Em_mBD=KbyRo+g@mail.gmail.com> <20120201.161333.2203265702893105548.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120201.161333.2203265702893105548.davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 1, 2012 at 1:13 PM, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org> wrote:
>> Perhaps we could do some RCU-ish thing where we don't actually
>> free the ipoib_neigh immediately?

> RCU could be used to fix the race, but the difficulty in converting
> this code over to dst_lookup_neigh() would remain and the latter is
> more important to me than the former right now :-)

OK.  So do you have any thoughts about what the generic key available
at transmit time (as you alluded to in your first message) might be?

As far as I can figure things, it has to be something roughly
equivalent to the neighbour, since it has to have the same type of
information as what ARP/ND tells us.

I guess I don't understand the on-demand lookup of the neigh.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
