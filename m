From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 0/9] mlx4 changes in virtual GID management
Date: Mon, 30 Mar 2015 20:47:05 -0700
Message-ID: <CAL1RGDUmDGCGdTBeTTBiHygO5UgEbRm_Qgxtx-+bxo1vg1v-8g@mail.gmail.com>
References: <1427637093-6711-1-git-send-email-ogerlitz@mellanox.com>
 <CAJ3xEMj0T8QXBQdVHmfEFMXwjAFVD-O6ywAwyyVY+M3oRLzAVA@mail.gmail.com> <20150330.233602.155832546277570456.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150330.233602.155832546277570456.davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Roland, I have to genuinely agree with Or, that your handling of
> patch integration is sub-par and really painful for anyone actually
> trying to get real work done here.
>
> If you simply don't have the time to devote to constantly reviewing
> patches as they come in, and doing so in a timely manner, please let
> someone who is actually interested and has the time to take over.

It's a fair criticism, and certainly for at least the last year or so
I have not had the time to do enough work as a maintainer.  I have
hope that some of the things that have been keeping me busy are dying
down and that I'll have more time to spend on handling the RDMA tree,
but that's just talk until I actually get more done.

I really would like to get more people involved in handling the flow
of patches but I'm not sure who has not only the interest and the time
but also the judgement and expertise to take over.  Certainly Or has
been a long time contributor who has done a lot of great things, but I
still worry about things like ABI stability and backwards
compatibility.

But I'm open to ideas.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
