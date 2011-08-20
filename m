From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [patch v2 02/37] add opcodes to ib_pack.h
Date: Sat, 20 Aug 2011 16:47:21 +0200
Message-ID: <CAO+b5-qV9uxs=V_uHbVZ_3sm1LqkQUB0em=K=nrRxUvFQYWo5A@mail.gmail.com>
References: <20110724194300.421253331@systemfabricworks.com>
 <20110724201228.204265835@systemfabricworks.com> <CAO+b5-pb3p0n5MZYNSJicAdUfZ4PtMNG5vdzDOiZNQwLnB3Wcw@mail.gmail.com>
 <03e001cc5b66$9e9b6e40$dbd24ac0$@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <03e001cc5b66$9e9b6e40$dbd24ac0$@systemfabricworks.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bob Pearson <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Aug 15, 2011 at 6:15 PM, Bob Pearson
<rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org> wrote:
> I want to eventually complete the IB transport parts of the driver although
> they are not used by RoCE. They would be useful for a soft IB implementation
> with say an FPGA based MAC/PHY. The long term goal is to have a complete
> reference implementation of the IB Architecture.

Having a complete reference implementation of the IB architecture
available would be great. IMHO at least the following should be added
to ib_rxe (not necessarily in the first version) before it can called
a reference implementation:
- Support for secondary GIDs. These make it easy to implement
fail-over in a H.A. cluster.
- Support for multicast.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
