From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv8 06/11] ipoib: avoid ipoib over IBoE
Date: Wed, 05 May 2010 15:27:51 -0700
Message-ID: <adamxweasrc.fsf@roland-alpha.cisco.com>
References: <20100218172420.GG12286@mtls03>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100218172420.GG12286@mtls03> (Eli Cohen's message of "Thu, 18
	Feb 2010 19:24:20 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > @@ -1383,6 +1385,9 @@ static void ipoib_remove_one(struct ib_device *device)
 >  	dev_list = ib_get_client_data(device, &ipoib_client);
 >  
 >  	list_for_each_entry_safe(priv, tmp, dev_list, list) {
 > +		if (rdma_port_link_layer(device, priv->port) != IB_LINK_LAYER_INFINIBAND)
 > +			continue;

Why do we need this chunk here?  How could a netdev get on our list if
we never create IPoIB interfaces for IBoE ports?

 - R.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
