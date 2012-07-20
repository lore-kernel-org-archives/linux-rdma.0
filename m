From: "Haralanov, Mitko" <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: qle7322 and rhel5.8
Date: Fri, 20 Jul 2012 20:44:30 +0000
Message-ID: <F5ED8E150D0FF14F82CAF3C46756763210781042@FMSMSX107.amr.corp.intel.com>
References: <CABOsP2P=7FG4zJy12x442pV=Hk3SkeBg5qTOtGy41GSFQLsBHA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CABOsP2P=7FG4zJy12x442pV=Hk3SkeBg5qTOtGy41GSFQLsBHA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Di Domenico <mdidomenico4-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Michael,

The ibv_dev* utilities need the ib_uverbs module to be loaded on the system. Could you please check whether it is? If the module is loaded and you still can't get ibv_dev* to work, may be use can provide any error messages displayed.

As far as IPoIB, I assume that the ib_ipoib module is also loaded? If it is, 'ifconfig -a' should show you the 'ib0' IPoIB device.

Mitko

> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Michael Di Domenico
> Sent: Friday, July 20, 2012 13:23
> To: linux-rdma
> Subject: qle7322 and rhel5.8
> 
> i'm trying to use redhat 5.8 with a qle7322 qdr infiniband card.  i've loaded the
> requisite openfabrics rpm's through yum, but i can't seem to get ipoib going
> 
> even when i run ibv_devinfo or ibv_devices the system doesn't see the card
> 
> is there something missing somewhere?  i'm only interested in getting ipoib
> working, but i don't want to install the vendor stack on this machine if
> possible
> 
> lspci does see the card (and with a proper name) and i have a bunch of
> identical machines that all behave the same, so i know it's not a hardware
> problem
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the
> body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
