From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: v4.11-rc2: DMAR: Allocating domain for mlx4_0 failed
Date: Mon, 13 Mar 2017 18:25:00 +0000
Message-ID: <1489429487.2658.4.camel@sandisk.com>
References: <1BCFE3F4-A455-4EFC-845E-1FAAF3902D55@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1BCFE3F4-A455-4EFC-845E-1FAAF3902D55-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Content-ID: <05E7F7AFBA8C56448D5B81C16E924E27-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-03-13 at 14:21 -0400, Chuck Lever wrote:
> When I boot v4.11-rc1 or -rc2 on my systems, the CX-3 Pro cards
> are no longer plumbed. Booting with v4.10 works as expected.

Hello Chuck,

Please the patch that is available at the following URL:
https://www.spinics.net/lists/linux-rdma/msg47043.html.

Thanks,

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
