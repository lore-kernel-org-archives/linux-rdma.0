From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH net-next V2] gro: introduce gro_mac_header_len
Date: Tue, 7 Feb 2012 18:29:15 +0200
Message-ID: <CAJZOPZJFeXwakk=TpghbDVSupZ2BU2C44d3odfsy7wCFz43srA@mail.gmail.com>
References: <20120206.141223.332863167187002998.davem@davemloft.net>
	<CAG4TOxNgJ3=AFuA==Km815YzW8eQ7nD_UAzkXLSXcAyaCAAvPg@mail.gmail.com>
	<20120206.143230.1415707004934341114.davem@davemloft.net>
	<20120206.145148.558736903670696169.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120206.145148.558736903670696169.davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org> wrote:

> Actually there is a way to make this work.
> Define your ipoib_skb_cb something like:
> struct ipoib_skb_cb {
> =A0 =A0 =A0 =A0struct qdisc_skb_cb =A0 =A0 qdisc_cb;
>
> =A0 =A0 =A0 =A0... ipoib stuff goes here ...
> };
> That way you can use the SKB cb area for your ipoib info
> without interfering with the packet scheduler.

Roland,

Want me to try and come up with that patch? I can look on that.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
