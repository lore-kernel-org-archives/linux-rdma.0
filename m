From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH rdma-next 11/29] IB/rxe: Allocation pool for RDMA objects
Date: Wed, 15 Jun 2016 11:45:54 -0500
Message-ID: <015c01d1c725$622feb40$268fc1c0$@opengridcomputing.com>
References: <1464886657-14258-1-git-send-email-monis@mellanox.com> <1464886657-14258-12-git-send-email-monis@mellanox.com> <011101d1c721$5c22d590$146880b0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <011101d1c721$5c22d590$146880b0$@opengridcomputing.com>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, 'Kamal Heib' <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Amir Vadai' <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Leon Romanovsky' <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Also when using rxe with nvmf (among other bugs I'm chasing down), when you
> unload ib_rxe, there are allocated cq objects left in the the slab cache:
> 

I see the same thing running iser over rxe.  So I think somehow cq objects are
getting leaked in rxe...

Steve.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
