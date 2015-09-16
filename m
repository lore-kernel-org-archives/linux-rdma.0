From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/3] IB/core: Add support of checksum capability reporting
 in ib verbs
Date: Wed, 16 Sep 2015 12:07:23 -0500 (CDT)
Message-ID: <alpine.DEB.2.11.1509161201100.22920@east.gentwo.org>
References: <cover.1442413048.git.bodong@mellanox.com> <490a38ab04a96f24500d647392e931c38853ba45.1442413048.git.bodong@mellanox.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <490a38ab04a96f24500d647392e931c38853ba45.1442413048.git.bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bodong Wang <wbd2905-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, 16 Sep 2015, Bodong Wang wrote:

> A new filed csum_cap is added to both ib_query_device. It contains two members:
> eth_csum_cap and ib_csum_cap, indicates checksum capability of Ethernet and
> Infiniband link layer respectively for different QP types.
>
> Current checksum caps use the following enum members:
> - IB_CSUM_SUPPORT_UD: device supports validation/calculation of csum for UD QP.
> - IB_CSUM_SUPPORT_RAW: device supports validation/calculation of csum for raw QP.

A combination? Is it possible then to also support calculation without
validation? Maybe we want to receive packets that do have invalid
checksums.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
