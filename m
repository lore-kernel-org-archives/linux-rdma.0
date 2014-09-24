From: Mohammed Rafi K C <muhammedrafi13-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: RDMA connection establishment flow.
Date: Wed, 24 Sep 2014 15:28:48 +0530
Message-ID: <1411552728.6278.3.camel@rafi>
Reply-To: muhammedrafi13-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi All,

I was trying to write an application in rdma . I understood that when a connection is established between remote endpoints, RDMA_CM_EVENT_ESTABLISHED event is generated in both server and client.

My question is Who will get RDMA_CM_EVENT_ESTABLISHED notification first, Server or client ? Is there any order to keep it strictly .

Can we set the connection is established if any of the side to get the events or should we need wait to get the RDMA_CM_EVENT_ESTABLISHED event in both side.

Thanks & Regards
Rafi KC

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
