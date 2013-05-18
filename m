From: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: list corruption in IPOIB
Date: Sat, 18 May 2013 23:36:07 +0200
Message-ID: <5197F447.5020702@profitbricks.com>
References: <519686B4.7010300@profitbricks.com> <CAJZOPZJNA7E005x9+XdVMG31fLEZm2mKB1nkpt5m3hA1qh7fYg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZJNA7E005x9+XdVMG31fLEZm2mKB1nkpt5m3hA1qh7fYg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dongsu Park <dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 2013=E5=B9=B405=E6=9C=8818=E6=97=A5 21:37, Or Gerlitz wrote:
> On Fri, May 17, 2013 at 10:36 PM, Jack Wang <jinpu.wang@profitbricks.=
com> wrote:
>> We've seen below neigh->list list corruption warning during testing,
>=20
> So about little heads up on what kernel you are using? what's the way
> to trigger this warning?
Hi Or,

I tried 3.4.23, and mainline kernel from Roland's rdma-for-linus, we
added bug injection interface,  run multithread iperf, and switched ib
mode between connected and datagram in sync on each side as Shlomo
suggested.
>=20
>>  From Dongsu's and my opinion, several place also need
>> netif_tx_lock(_bh)/netif_tx_unlock(_bh) pairs around neigh->list , I
>> tried to add netif_tx_lock/netif_tx_unlock into ipoib_cm_destroy_tx,=
 it
>> improved the situation, there're some other places in ipoib_main.c a=
nd
>> ipoib_mcast.c, but I don't know which lock should be added, if you c=
an
>> take some time to look into it, that will be great.
>=20
>=20
> what do you mean by improved the situation? the waring is gone? and i=
f
> yes, what's remain?
>=20
I mean it take longer time to reproduce this warning.

Regards
Jack
> Or.
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
