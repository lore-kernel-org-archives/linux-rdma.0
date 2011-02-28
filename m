From: Nir Muchtar <nirmu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V4 5/6] RDMA CM: Netlink Client
Date: Mon, 28 Feb 2011 12:49:25 +0200
Message-ID: <1298890165-13425-1-git-send-email-nirmu@mellanox.com>
References: <AANLkTik-uNbochFYz1VGLBGjyU69dp5=jG=1pkSNWsCv@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTik-uNbochFYz1VGLBGjyU69dp5=jG=1pkSNWsCv-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: nirmu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

Here's a description of the schema. Sorry, I thought I had already sent
it to you. it must've gotten lost somehow...

The schema for RDMA CM is a series of netlink messages. Each one
contains an rdma_cm_stat struct. Additionally, two netlink attributes
are created for the addresses for each message (if applicable).
Their types:
IBNL_RDMA_CM_ATTR_SRC_ADDR (The source address for this ID)
IBNL_RDMA_CM_ATTR_DST_ADDR (The destination address for this ID)
sockaddr_* structs are encapsulated within these attributes.

Please let me know if something is still vague, or if you have any
further questions.

Thanks,
Nir
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
