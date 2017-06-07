From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-next 1/6] IB/core: Enable QP creation which is
 associated to underlay QP
Date: Wed, 7 Jun 2017 11:44:10 -0600
Message-ID: <20170607174410.GA9757@obsidianresearch.com>
References: <20170530071602.8139-1-leon@kernel.org>
 <20170530071602.8139-2-leon@kernel.org>
 <20170530160447.GA21513@obsidianresearch.com>
 <1d799662-bc2b-ed12-882c-42d12d1ed8a1@dev.mellanox.co.il>
 <20170605153644.GA6749@obsidianresearch.com>
 <CAFgAxU9c1SwehkCY3o0RZPO_CTHGJb2A1omjVvJvyabO0V57iQ@mail.gmail.com>
 <20170606163320.GC8671@obsidianresearch.com>
 <CAFgAxU-=i2=yNnjE2kYHV0Re6Vrd=LyTB55q=p_1fc+zuotwvA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAFgAxU-=i2=yNnjE2kYHV0Re6Vrd=LyTB55q=p_1fc+zuotwvA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Alex @ Mellanox" <Alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 07, 2017 at 03:23:35PM +0300, Alex Rosenbaum wrote:
> We reviewed your suggestion in deeper details and agree with your
> suggested semantics to allow user to create a QP with user defined
> wire QPN, without mandating association of an overlay with underlay
> QP.

It would be excellent if this could be allowed for QP1 as well - the
user space SA could be greatly accelerated if it could send QP1
traffic without going through umad.

This would require multiple QP's with the source_qpn=1 set, for the
range of required PKeys.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
