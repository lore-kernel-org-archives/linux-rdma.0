From: Josh England <jjengla-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: NULL pointer dereference in rdma_ucm
Date: Tue, 20 Jul 2010 12:55:03 -0700
Message-ID: <AANLkTinOmOrg14OZGnj2qe1dwPaXQbN28-0kz2TINF6n@mail.gmail.com>
References: <AANLkTikwDEJY_F1ziGNPhYMBJEBC5UqD2XOLM7wSByj1@mail.gmail.com>
	<4C4544CC.3090405@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C4544CC.3090405-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Arthur Kepner <akepner-sJ/iWh9BUns@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Do you think upgrading to OFED-1.5.1 would help at all?

-JE

On Mon, Jul 19, 2010 at 11:40 PM, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org> wr=
ote:
> Josh England wrote:
>>
>> It may be that the in-kernel field cm_id_priv has a NULL ->alt_av.po=
rt ,
>> causing the Oops, but I don't know for sure. =A0Any ideas on how to =
debug
>> this?
>
> seems like this was reported in the past but remained unsolved,
> http://lists.openfabrics.org/pipermail/general/2009-August/thread.htm=
l#61522
>
> Or.
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
