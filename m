From: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH 1/3] IB/core: Add support of checksum capability reporting
 in ib verbs
Date: Wed, 16 Sep 2015 17:16:45 +0000
Message-ID: <DB4PR05MB575860ACB9BAC7FDB97A414AA5B0@DB4PR05MB575.eurprd05.prod.outlook.com>
References: <cover.1442413048.git.bodong@mellanox.com>
 <490a38ab04a96f24500d647392e931c38853ba45.1442413048.git.bodong@mellanox.com>
 <alpine.DEB.2.11.1509161201100.22920@east.gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.11.1509161201100.22920-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

For RX: if corresponding QP is not supported, it will not validate the csum, but packets are still received normally. 
For TX: if corresponding QP is not supported for csum calculation and user application sets the IBV_SEND_IP_CSUM flag, it will return error.

-----Original Message-----
From: Christoph Lameter [mailto:cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org] 
Sent: Wednesday, September 16, 2015 12:07 PM
To: Bodong Wang
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Bodong Wang; Or Gerlitz; jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org; Moshe Lazer; Haggai Eran; Matan Barak
Subject: Re: [PATCH 1/3] IB/core: Add support of checksum capability reporting in ib verbs

On Wed, 16 Sep 2015, Bodong Wang wrote:

> A new filed csum_cap is added to both ib_query_device. It contains two members:
> eth_csum_cap and ib_csum_cap, indicates checksum capability of 
> Ethernet and Infiniband link layer respectively for different QP types.
>
> Current checksum caps use the following enum members:
> - IB_CSUM_SUPPORT_UD: device supports validation/calculation of csum for UD QP.
> - IB_CSUM_SUPPORT_RAW: device supports validation/calculation of csum for raw QP.

A combination? Is it possible then to also support calculation without validation? Maybe we want to receive packets that do have invalid checksums.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
