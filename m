From: "Yevgeny Petrilin" <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: RE: clarification on the mlx4 CQE structure
Date: Tue, 19 Jan 2010 15:03:26 +0200
Message-ID: <2ED289D4E09FBD4D92D911E869B97FDD02783427@mtlexch01.mtl.com>
References: <Pine.LNX.4.64.1001191416160.22919@zuben.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-class: urn:content-classes:message
In-Reply-To: <Pine.LNX.4.64.1001191416160.22919-aDiYczhfhVLdX2U7gxhm1tBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> @@ -692,14 +692,13 @@ repoll:
> -		wc->sl		   = cqe->sl >> 4;
> +		wc->sl		   = be16_to_cpu(cqe->sl_vid >> 12);
> 
> I wasn't sure if/why a conversion from network order to host order is
neeed here, can you clarify that?

This commit has an endianess bug, that was fixed in commit f781a22f.
The cqe->sl_vid field is a be16, so we needed to convert the sl value to
host order.
Before the commit this field was two u8 fields, so no conversion was
needed.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
