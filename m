From: Tamir Ronen <tamirr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH] infiniband-diags: add support for ibnetdiscover
 grouping for Mellanox switches
Date: Tue, 15 Feb 2011 12:10:24 +0000
Message-ID: <AA090FF3B57CA34BBC78B3CE7624333AB376@MTRCASDAG01.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Ira,

We know that there are switches  with different node descriptors format.  Those switches will be classified as chassis switches without Line/Spine classification (as before the patch).
We are trying to find out if there is a different format specification for those switches.
We will also try to arrange additional testing in Mellanox labs.

The node descriptors is RO and should not be modified by the user.

Regards
 - Tamir

-----Original Message-----
From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Ira Weiny
Sent: Tuesday, February 15, 2011 2:07 AM
To: Tamir Ronen
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: [PATCH] infiniband-diags: add support for ibnetdiscover grouping for Mellanox switches

Tamir,

I have this in a for-next branch.  Can someone from Mellanox verify this will work on all their switches.  I did not think they always labeled their switches this way but perhaps they do.

Can the user program node descriptors in those chassis?  I thought this was possible but I am unable to verify this today.

Ira


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
