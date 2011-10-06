From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/3] RDMA/nes: Print ip address for critcal errors
Date: Thu, 6 Oct 2011 12:53:54 -0700
Message-ID: <CAL1RGDU+xag8AtQ18yrZmqU24u9QM6cajhca4MmrCGtmPbxKLg@mail.gmail.com>
References: <20110926013344.GA5260@FLATIF-MOBL4>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110926013344.GA5260@FLATIF-MOBL4>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_ERR PFX "Remote ip addr =3D=
 %u.%u.%u.%u\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rem_addr[3], rem_addr[2=
], rem_addr[1], rem_addr[0]);

Any reason this couldn't use %pI4 and be a lot cleaner?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
