From: "Paul Grun" <pgrun-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Subject: RE: RDMAoE / lossless Ethernet (ewg: SC'09 BOF - Meeting notes)
Date: Wed, 23 Dec 2009 16:09:04 -0800
Message-ID: <002d01ca842d$4f62cbf0$ee2863d0$@com>
References: <2ED289D4E09FBD4D92D911E869B97FDD01AF10F2@mtlexch01.mtl.com>	 <4B31D048.5040001@voltaire.com>	 <adahbrh1yd0.fsf@roland-alpha.cisco.com>	 <001101ca8411$68244b80$386ce280$@com> <15ddcffd0912231417h6e47db36ledbdb2ad6cc66c0e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <15ddcffd0912231417h6e47db36ledbdb2ad6cc66c0e-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Or Gerlitz' <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: 'Roland Dreier' <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, 'Or Gerlitz' <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, 'Liran Liss' <liranl-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, 'Yevgeny Petrilin' <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, 'Richard Frank' <richard.frank-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Linux RDMA list' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Or -
The emergence of standards-based lossless Ethernet (DCB) was the
precipitating factor that allowed us for the first time to talk about
running the IB message transport on what had formerly been a lossy network.

That said, there is a distinction to be made between 'works better' and 'is
required in order to work'.  Again, I don't think there is an argument to be
made for REQUIRING the use of DCB as a prerequisite to RoCEE.
Make sense?
-Paul

-----Original Message-----
From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
[mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Or Gerlitz
Sent: Wednesday, December 23, 2009 2:18 PM
To: Paul Grun
Cc: Roland Dreier; Or Gerlitz; Liran Liss; Yevgeny Petrilin; Richard Frank;
Sean Hefty; Linux RDMA list
Subject: Re: RDMAoE / lossless Ethernet (ewg: SC'09 BOF - Meeting notes)

Paul Grun <pgrun-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org> wrote:
> there doesn't appear to be an argument in favor of requiring DCB with
RoCEE

Interesting, the ofa server is down now, so I don't have access to ofa
IBoE materials, from my memory I recall that in ALL of them you have
made the IBoE/CEE bundling very clear & evident, e.g this  IBTA
presentation made to T11 @
http://www.t11.org/ftp/t11/pub/fc/study/09-543v0.pdf

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
