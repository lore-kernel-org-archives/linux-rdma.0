From: "Hefty, Sean" <sean.hefty@intel.com>
Subject: RE: [RFC 2/3] RDMA/cma: Add support for netlink statistics export
Date: Fri, 13 May 2011 17:21:02 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373F428@ORSMSX101.amr.corp.intel.com>
References: <1305303525-11113-1-git-send-email-roland@kernel.org>
 <1305303525-11113-3-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1305303525-11113-3-git-send-email-roland@kernel.org>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

> +struct rdma_cm_id_stats {
> +	__u32	qp_num;
> +	__u32	bound_dev_if;
> +	__u32	port_space;
> +	__s32	pid;
> +	__u8	cm_state;
> +	__u8	node_type;
> +	__u8	port_num;
> +	__u8	reserved;
> +};

We may also want to add qp_type
