From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: wireshark's RPC-over-RDMA dissector
Date: Wed, 9 Nov 2016 11:05:19 -0500
Message-ID: <2975B49B-2696-4E2A-B9D0-2D6CB607EC59@oracle.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, List Linux RDMA Mailing <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi-

Thanks to Yan Berman, for a couple of years now we've had a basic
RPC-over-RDMA dissector in wireshark that can be used with ibdump
captures. There have been some bugs noted, but no-one has had the
cycles to dig in and address.

Recently Tom Haynes helped me set up my own wireshark build so I
could help address some of the known issues.

http://git.linux-nfs.org/?p=cel/wireshark.git;a=shortlog;h=refs/heads/rpc-rdma-fixes

Posting here for review before I take the next steps to push these
to the wireshark community. Constructive critique and other
suggestions are welcome.

The fixes so far focus on dissecting transport headers correctly.
There continue to be significant open issues with the dissector:
	• There does not appear to be any support for dissecting
	  RPC-over-RDMA on iWARP or RoCE
	• The NFS dissector does not handle portions of the XDR
	  stream that were transmitted via RDMA Read/Write
	• RPC messages conveyed via RDMA_NOMSG are not recognized
	  or dissected
	• There is no association between RDMA Reads and Writes
	  and the RPC-over-RDMA message they go with
	• A CREQ / CREP pair are needed to identify which QP
	  numbers are used for RPC-over-RDMA traffic
	• With TCP, the dissector fully outdents the RPC and NFS
	  dissection results; but with RDMA, the dissector places
	  the results in the tree under the Infiniband header
	• Not enough error detection in the dissector

--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
