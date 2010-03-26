From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC] [PATCH 0/22] [for 2.6.36] rdma/cm: add support for native IB addressing
Date: Fri, 26 Mar 2010 10:33:16 -0700
Message-ID: <0A0128A82FB742ACB5BC532BB98F84AA@amr.corp.intel.com>
References: <2F3826558E79459EAD2A457A604221C1@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2F3826558E79459EAD2A457A604221C1-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

To help with discussion, here is a new API that was added to the librdmacm to
support AF_IB.

#define RAI_PASSIVE		1

struct rdma_addrinfo {
	int			ai_flags;
	int			ai_family;
	int			ai_qp_type;
	int			ai_port_space;
	socklen_t		ai_src_len;
	socklen_t		ai_dst_len;
	struct sockaddr		*ai_src_addr;
	struct sockaddr		*ai_dst_addr;
	char			*ai_src_canonname;
	char			*ai_dst_canonname;
	size_t			ai_route_len;
	void			*ai_route;
	size_t			ai_connect_len;
	void			*ai_connect;
	struct rdma_addrinfo	*ai_next;
};

int rdma_getaddrinfo(char *node, char *service,
		     struct rdma_addrinfo *hints,
		     struct rdma_addrinfo **res);

The hope is that applications can replace calls to getaddrinfo with
rdma_getaddrinfo.  The output of getaddrinfo can be fed into the existing APIs,
or apps can make use of a simpler routine which replaces rdma_create_id,
rdma_bind_addr/rdma_resolve_addr, and rdma_resolve_route.

int rdma_create_ep(struct rdma_cm_id **id, struct rdma_addrinfo *res,
		   struct ibv_pd *pd, struct ibv_qp_init_attr *qp_init_attr);

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
