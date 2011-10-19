From: Kelly Burkhart <kelly.burkhart-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: RDMA_CM over RoCE
Date: Wed, 19 Oct 2011 08:28:57 -0500
Message-ID: <CAND8VyAWSO=i5uk_ahS15yNGUFq0cJgSDYcU4Go5tX10fj7o1w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello,

I'm having a problem connecting using RDMA_CM over ethernet.  I have
two machines each with a Mellanox MT26428.  The ethernet ports are
connected through an arista 10G switch.  The IB ports are connected
through an IB switch.

The test programs rdma_lat or ucmatose run successfully over the
infiniband.  Over the ethernet port ucmatose hangs and rdma_lat
reports an error immediately (Local lid 0x0 detected. Is an SM
running?).

Non RDMA_CM tests such as ib_send_lat work fine over both ports.
Also, when the ethernet ports were directly connected the RDMA_CM
programs work, it's only after connecting through a switch that they
fail.

Can anyone shed some light on why this fails or even if it should work?

I'm running OFED 1.5.3-1 from Mellanox on an openSUSE 11.3 machine.

Thanks in advance for any assistance,

-Kelly
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
