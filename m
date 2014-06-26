From: Mark Lehrer <lehrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Need help with strange mlx4_core error
Date: Thu, 26 Jun 2014 10:59:14 -0600
Message-ID: <CADvaNzU0XdqCZ0t2Uob82tsLNTPKtfwH+7O2T--Qtk=xBAd41g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Feb 28, 2014, Vasiliy Tolstov wrote:

> I'm update firmware to 2.7.200 (that is the latest from ftp
> supermicro). Now i'm try to test it.

Which type of HCA do you have?  The firmware I downloaded from
ftp.supermicro.com was 2.9.1000, and once I upgraded to this version
from 2.7.200 I was able to use mlx4_en.

lspci shows my card as: Mellanox Technologies MT26428 [ConnectX VPI
PCIe 2.0 5GT/s - IB QDR / 10GigE]


Mark
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
