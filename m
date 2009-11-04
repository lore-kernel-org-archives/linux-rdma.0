From: Roland Dreier <rdreier@cisco.com>
Subject: Re: [PATCH 05/25] mlx4_core: add slave resource allocation
Date: Wed, 04 Nov 2009 10:19:51 -0800
Message-ID: <ada7hu617aw.fsf@cisco.com>
References: <4AF19E1E.4000102@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <4AF19E1E.4000102@mellanox.co.il> (Yevgeny Petrilin's message of
	"Wed, 04 Nov 2009 17:30:38 +0200")
Sender: netdev-owner@vger.kernel.org
To: Yevgeny Petrilin <yevgenyp@mellanox.co.il>
Cc: linux-rdma@vger.kernel.org, netdev@vger.kernel.org, liranl@mellanox.co.il, tziporet@mellanox.co.il
List-Id: linux-rdma@vger.kernel.org


 > +	u32 param1 = *((u32 *) &vhcr->in_param);
 > +	u32 param2 = *(((u32 *) &vhcr->in_param) + 1);

Is this endian clean?

 - R.
