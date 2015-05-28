From: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH 14/14] IB/mad: Add final OPA MAD processing
Date: Thu, 28 May 2015 16:21:46 +0000
Message-ID: <HE1PR05MB1418F6FC61A8DD55176F7DFBB1CA0@HE1PR05MB1418.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> >
> > Why do you have RDMA_NODE_IB_SWITCH related stuff inside the
> handle_opa_smi() function?
> > Is there a node type of "switch" in OPA similar to IB?
> >
> 
> Yes.  OPA uses the same node types as IB.
> 
> Ira
> 

No, OPA cannot impersonate IB.
It has to have distinct node and link types.

--Liran

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
