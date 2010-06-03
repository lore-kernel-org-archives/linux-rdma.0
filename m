From: =?iso-8859-1?Q?H=E5kon_Bugge?= <Haakon.Bugge-UdXhSnd/wVw@public.gmane.org>
Subject: Re: [PATCH] libibverbs: Force line-buffering in ibv_asyncwatch
Date: Thu, 03 Jun 2010 12:54:31 +0200
Message-ID: <E334136B-3CA6-4ABD-9F4F-94410908C76A@Sun.COM>
References: <ED0695A5-CBE3-4CE2-A20C-BBC7BEF28C33@Sun.com>
 <e2e108261001210618p476ed03bofa2e46c223578e1a@mail.gmail.com>
 <C25CCF03-2542-4C8D-9AF4-122DBF56F856@Sun.COM>
 <ada7hmhtle3.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <ada7hmhtle3.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Jun 2, 2010, at 19:05 , Roland Dreier wrote:

>> setlinebuf() is pretty intuitive to understand, compared to setvbuf(=
).
>=20
> I finally applied this; however in the end I decided to do
>=20
> 	setvbuf(stdout, NULL, _IOLBF, 0);
>=20
> instead of setlinebuf(), since in the past I've prefered more pedanti=
c
> stuff (eg posix_memalign instead of memalign) to the older simpler
> traditional functions.  Kind of a trivial issue either way anyway.


Agree. Thanks anyway.


H=E5kon

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
