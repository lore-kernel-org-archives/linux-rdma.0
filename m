From: Muni Sekhar <munisekharrms-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Basic query regarding the scatter-gather DMA
Date: Wed, 15 Jun 2016 16:47:06 +0530
Message-ID: <CAHhAz+it-Xd4m=8vnXAWMBhu8VsykHNbFnKc9ZL-jPTJ=xCEGA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi All,

I have a basic query regarding the scatter-gather DMA.


We have a device with scatter-gather capability. Is it okay to use
normal DMA API=E2=80=99s for this device driver?

Or driver only should use scatter-gather DMA API=E2=80=99s?


--=20
Thanks,
Sekhar
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
