From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next 0/9] mlx4 changes in virtual GID management
Date: Tue, 31 Mar 2015 08:57:56 -0400
Message-ID: <551A99D4.7060703@dev.mellanox.co.il>
References: <1427637093-6711-1-git-send-email-ogerlitz@mellanox.com> <CAJ3xEMj0T8QXBQdVHmfEFMXwjAFVD-O6ywAwyyVY+M3oRLzAVA@mail.gmail.com> <20150330.233602.155832546277570456.davem@davemloft.net> <CAL1RGDUmDGCGdTBeTTBiHygO5UgEbRm_Qgxtx-+bxo1vg1v-8g@mail.gmail.com> <CAJ3xEMjfbxt2Ouh4bhuf3_LMc7qY807h6FryvdCr0rr_gdiZAw@mail.gmail.com> <alpine.DEB.2.11.1503310735380.13128@gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.11.1503310735380.13128-gkYfJU5Cukgdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 3/31/2015 8:49 AM, Christoph Lameter wrote:
> Well this needs to be addressed yes but in order to have that done someone
> needs to step forward do the proper work, maintain git trees, do the
> review and show up for the conferences. Neither Roland nor Or was there at
> the Infiniband conferences in Monterey this year(!) and this is the prime
> venue for face to face conversation about the subsystem each year.
> 
> Just looked at the MAINTAINERS file: Surprise: We already have 3
> maintainers for the IB subsystem:
> 
> INFINIBAND SUBSYSTEM
> M:      Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> M:      Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> M:      Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> L:      linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> W:      http://www.openfabrics.org/
> Q:      http://patchwork.kernel.org/project/linux-rdma/list/
> T:      git git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git
> S:      Supported
> F:      Documentation/infiniband/
> F:      drivers/infiniband/
> F:      include/uapi/linux/if_infiniband.h
> 
> Sean and Hal showed up for the conference. Sean is active mostly in
> focusing on userspace stuff. Both could become more involved in the kernel
> ib tree and the review process? Hal is employed by Mellanox but is not
> participating in these patch related discussions? Can Mellanox give Hal
> more time for his role as the kernel ib subsystem maintainer? Maybe you
> could get that resolved at Mellanox? You already have one of your own as
> a maintainer of the IB subsystem.

My involvement is limited to IB management related aspects in the kernel.

-- Hal

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
