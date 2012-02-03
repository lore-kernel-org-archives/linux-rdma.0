From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [patch 2/3] ib_srpt: checking NULL instead of ERR_PTR
Date: Fri, 3 Feb 2012 09:08:57 -0800
Message-ID: <CAL1RGDU0HkrS_ME12H6j43e=Fkn=C9Ms64mXNjxf4_dS_PV7EQ@mail.gmail.com>
References: <20111104182732.GH5796@elgon.mountain> <1320443697.5859.171.camel@haakon2.linux-iscsi.org>
 <CA+_b7DK-=ORJQ20aHE_aVgEud4vAPQG_sskOeMqftabzun0h+A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+_b7DK-=ORJQ20aHE_aVgEud4vAPQG_sskOeMqftabzun0h+A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <error27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: nab-4mckEHfoRW3KI0RCH6AXYZqQE7yCjDx5@public.gmane.org, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Feb 3, 2012 at 5:01 AM, Dan Carpenter <error27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote=
:
> All the others seem to fixed up. =A0It's just these two place which n=
eed
> to be fixed still. =A0My patch still applies fine with a little fuzz.=
 =A0;)

I have a few pending srpt patches, coincidentally including one that hi=
ts
very near yours leading to a trivial conflict.  So I just merged yours =
into
your tree as well and I guess I'll send to Linus shortly.

Thanks,
  Roland
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
