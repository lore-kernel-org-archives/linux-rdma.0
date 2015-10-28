From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH 2/2] IB/mlx5: Publish mlx5 driver support for extended
 create QP
Date: Wed, 28 Oct 2015 18:44:05 +0000
Message-ID: <HE1PR05MB1355F83A223671CA59BC940AC5210@HE1PR05MB1355.eurprd05.prod.outlook.com>
References: <1445993915-111262-1-git-send-email-eli@mellanox.com>
 <1445993915-111262-3-git-send-email-eli@mellanox.com>
 <20151028163225.GA14310@obsidianresearch.com>
 <HE1PR05MB1355F2259428B7DB0D096583C5210@HE1PR05MB1355.eurprd05.prod.outlook.com>
 <20151028182400.GB26645@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151028182400.GB26645-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org" <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Did you read the above thread?
>
> Don't set uverbs_ex_cmd_mask in drivers.

But that's not how it is currently. IB core does not set any of the extended verbs flags for all the devices.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
