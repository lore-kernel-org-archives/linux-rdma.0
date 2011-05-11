From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC] RDMA CM + XRC, take two
Date: Wed, 11 May 2011 23:47:15 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373BEFD@ORSMSX101.amr.corp.intel.com>
References: <4DC86BB2.1020002@systemfabricworks.com>
 <1828884A29C6694DAF28B7E6B8A82373BBE2@ORSMSX101.amr.corp.intel.com>
 <4DCAA047.2040904@systemfabricworks.com>
 <1828884A29C6694DAF28B7E6B8A82373BC59@ORSMSX101.amr.corp.intel.com>
 <4DCAD746.7050606@systemfabricworks.com>
 <1828884A29C6694DAF28B7E6B8A82373BE79@ORSMSX101.amr.corp.intel.com>
 <9ECD201D-0CD8-4339-81E0-163FC130C705@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9ECD201D-0CD8-4339-81E0-163FC130C705-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bob Pearson <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Cc: frank zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> There is a connection between the ini and TFT qps they have to exchange
> qpns so that they can check them later

Speaking of connecting the XRC INI/TGT QPs, how is this being done?  I don't see any patches to the IB CM to support XRC in Roland's git tree.  Is the setup of XRC expected to be done through proprietary means?

Btw, the libibverbs APIs to support XRC look entirely confusing to me.  For as much as the MPI developers have complained about how complicated it is to connect over RDMA, I'm surprised that they're adopting them.  Is there documentation somewhere that describes ALL of the steps needed to connect using XRC?

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
