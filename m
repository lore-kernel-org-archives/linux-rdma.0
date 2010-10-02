From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: gratuitous arps lost during IB switch failure
Date: Sat, 2 Oct 2010 22:19:36 +0200
Message-ID: <AANLkTikuCisjCZpMhdaSOUf=apEvDu5ZKdf0_CUkX2OB@mail.gmail.com>
References: <4C9942F3.5090206@oracle.com>
	<loom.20101001T010729-594@post.gmane.org>
	<AANLkTinwGJq-aRM43ct9_1PrUCkn7QMecPczPpEyD2pQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinwGJq-aRM43ct9_1PrUCkn7QMecPczPpEyD2pQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sumeet <Sumeet.Lahorani-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Sumeet <Sumeet.Lahorani-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> It turns out that this problem was being caused because we had multip=
le IPs
> configured on the bonded infiniband interface. It appears that grat. =
arps are
> being sent out for only one of those IPs. [...] =A0Can the bonding
> driver be fixed to send out grat arps for both these IPs?

is there anything that makes you think this issue has something to do
with ipoib/bonding? did you check with ethernet? the bonding driver
isn't maintained over linux-rdma but rather over netdev.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
