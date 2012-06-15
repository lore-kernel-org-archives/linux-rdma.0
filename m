From: Albert Strasheim <fullung-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: IPoIB and RDMA CM
Date: Fri, 15 Jun 2012 15:06:13 +0200
Message-ID: <CALfB72CA5+c21pwVT10yMamOy4UXR+B2dqF-vvZykoO1_gOYhA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello all

Can anyone recommend something I can read to find out more about how
IPoIB bonding and librdmacm work together?

Some googling seems to allude to the fact that patches in this area
went in a few years ago, but I'd like to find some detailed
information about how it works.

I would also like to echo this question from Yann Droneaud:

http://www.spinics.net/lists/linux-rdma/msg12130.html

He said:

"How will interact vHCA/HCA regarding Automatic Path Migration (APM)
and IPoIB bonding with fail-over (HA), with RDMA_CM and IP usages in
mind?"

Will it make sense to run guests on top of KVM in future, with SR-IOV
exposing a single HCA to the guest, regardless of whether the host has
one or many HCAs with one or two ports?

Regards

Albert
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
