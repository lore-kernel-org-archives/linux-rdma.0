From: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Subject: Re: Tutorials/howto to modify exiting tcp/ip app for rdma
Date: Sat, 29 Nov 2014 02:42:47 +0400
Message-ID: <CACaajQuSFVQRPgdEeX5EstrcJkian0YODq8JYpnpFtMMzUVMdw@mail.gmail.com>
References: <CACaajQv2-TFkmANMNBikryG8CE_xhnOx05Qt9aQC8MXfyeRLSg@mail.gmail.com>
 <5477298A.6060605@dev.mellanox.co.il> <CACaajQs6vP=LJ+H=SC7G4EuwOebsjz9G1vxay=aYiKyo1AwSjg@mail.gmail.com>
 <54774122.1020502@dev.mellanox.co.il> <5477584A.9050605@dev.mellanox.co.il> <54789E12.6000601@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54789E12.6000601-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

2014-11-28 19:08 GMT+03:00 Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>:
> Also, you need librdmacm 1.0.19-1 or later for this.
>
> rstream is the best example of how to use AF_IB.


THanks! As i understand i need kernel for example 3.14... =) and
librdmacm 1.0.19 or later and use rsockets to replace tcp/ip.
How about resolving? Sorry i'm try to take all pieces =).
For example i see that rdma_getaddrinfo can resolve address, but as i
see http://manpages.ubuntu.com/manpages/raring/man3/rdma_resolve_addr.3.html
i need ipoib.
In case of pure RDMA network without IP as i understand i need to
check opensm sources?
whether there is somewhere the minimum example how to work with guid
of ports without use ipoib ?
-- 
Vasiliy Tolstov,
e-mail: v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
jabber: vase-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
