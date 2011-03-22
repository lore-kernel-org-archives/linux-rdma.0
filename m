From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: IB: increase DMA max_segment_size on Mellanox hardware
Date: Tue, 22 Mar 2011 10:01:12 +0200
Message-ID: <4D885748.6060600@mellanox.com>
References: <1295230184.2574.26.camel@obelisk.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1295230184.2574.26.camel-1q1vX8mYZiGLUyTwlgNVppKKF0rrzTr+@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

David Dillow wrote:
> This ups the value on Mellanox hardware to 2 GB, though there is no H=
W
> limit.

You've expressed intention to reduce that value to 1GB as of HW=20
limitations, it would also let you get rid from the warnings on the=20
current version

>  CC [M]  drivers/infiniband/hw/mthca/mthca_main.o
> drivers/infiniband/hw/mthca/mthca_main.c: In function =E2=80=98__mthc=
a_init_one=E2=80=99:
> drivers/infiniband/hw/mthca/mthca_main.c:1047: warning: integer overf=
low in expression
>   LD [M]  drivers/infiniband/hw/mthca/ib_mthca.o
>   CC [M]  drivers/net/mlx4/main.o
> drivers/net/mlx4/main.c: In function =E2=80=98__mlx4_init_one=E2=80=99=
:
> drivers/net/mlx4/main.c:1113: warning: integer overflow in expression

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
