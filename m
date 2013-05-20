From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: MLX4 Cq Question
Date: Mon, 20 May 2013 19:58:19 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823736FD2955D@ORSMSX109.amr.corp.intel.com>
References: <51968438.7070907@opengridcomputing.com>
 <CAG4TOxNi0PxxskqXgxRhMPG0bmr+sS-x0_RG-zKyvLW1LNzoBg@mail.gmail.com>
 <201305201753.10806.jackm@dev.mellanox.co.il>
 <519A7EB2.8090206@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <519A7EB2.8090206-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> My reading of the code (i.e. hw/mlx4/cq.c) is that the hardware cqe
> owner_sr_opcode field contains MLX4_CQE_OPCODE_ERROR when there is an
> error and therefore, the only way to recover what the opcode was is
> through the wr_id you used when submitting the WR.
> 
> Is my reading of the code correct?

I believe this is true wrt the IB spec.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
