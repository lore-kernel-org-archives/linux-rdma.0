From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V4 5/6] RDMA CM: Netlink Client
Date: Mon, 28 Feb 2011 09:13:26 +0200
Message-ID: <4D6B4B16.1070308@mellanox.com>
References: <1294068834-17778-1-git-send-email-nirm@voltaire.com>	<1294068834-17778-6-git-send-email-nirm@voltaire.com>	<20110107203742.GH1211@obsidianresearch.com> <adamxnc9x33.fsf@cisco.com>	<4D3417E1.9090903@voltaire.com> <adaaaizyyx6.fsf@cisco.com>	<20110117221141.GE995@obsidianresearch.com> <ada4o97yy7u.fsf@cisco.com>	<4D666604.7000700@voltaire.com> <4D666744.6010907@voltaire.com> <AANLkTik-uNbochFYz1VGLBGjyU69dp5=jG=1pkSNWsCv@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTik-uNbochFYz1VGLBGjyU69dp5=jG=1pkSNWsCv-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Nir Muchtar <nirmu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Roland Dreier wrote:
>>>> Is the schema documented anywhere, or does one have to read it from the code?

> Did we ever get any description of the schema, so we can ask
> netlink experts on netdev@ about it?

Roland, I'm pretty sure that any further review wouldn't go beyond the 
detailed work Jason did, but sure, we can ask for further feedback, just 
lets don't raise our expectations too much, the netdev guys aren't big 
favors of the various offloading kernel components (e.g iscsi, rdma, etc).

Nir, did you had some documentation going with the patches? can you 
point that out please?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
