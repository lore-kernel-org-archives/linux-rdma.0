From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 2/10] DAPL v2.0: common: new IB collective provider for
 Mellanox Fabric Collective Agent
Date: Thu, 11 Aug 2011 15:35:13 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E3E6B5@FMSMSX151.amr.corp.intel.com>
References: <54347E5A035A054EAE9D05927FB467F916E42B22@FMSMSX151.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54347E5A035A054EAE9D05927FB467F916E42B22-Q3cL8pyY+6ukrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu0@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> +static int create_member(struct dapl_hca *hca)
> +{
> +	ib_hca_transport_t *tp = &hca->ib_trans;
> +	int size, ret = EFAULT;
> +
> +	dapl_log(DAPL_DBG_TYPE_EXTENSION,
> +		 " create_member: tp=%p, ctx=%p\n", tp, tp->m_ctx);
> +
> +	if (!tp->m_ctx)
> +		goto bail;
> +
> +	/* FCA address information */
> +	tp->f_info = fca_get_rank_info(tp->m_ctx, &size);
> +	if (!tp->f_info) {
> +		dapl_log(DAPL_DBG_TYPE_ERR,
> +			"create_member: fca_get_rank_info() ERR ret=%s ctx=%p\n",
> +			strerror(errno), tp->m_ctx);
> +		ret = errno;
> +		goto err;
> +	}
> +
> +	tp->m_info = malloc(sizeof(DAT_SOCK_ADDR) + size);
> +	if (!tp->m_info) {
> +		dapl_log(DAPL_DBG_TYPE_ERR,
> +			"create_member: malloc() ERR ret=%s ctx=%p\n",
> +			strerror(errno), tp->m_ctx);
> +		fca_free_rank_info(tp->f_info);
> +		goto err;
> +	}
> +	dapl_os_memzero(tp->m_info, sizeof(DAT_SOCK_ADDR) + size);
> +
> +	if ((tp->l_sock = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
> +		dapl_log(DAPL_DBG_TYPE_ERR,
> +			"create_member: socket() ERR ret=%s \n",
> +			strerror(errno));
> +		ret = errno;
> +		goto err;
> +	}
> +
> +	dapl_log(DAPL_DBG_TYPE_EXTENSION, " create_member listen socket\n");
> +
> +	/*
> +	 * only rank0 needs listen, but we don't know who is rank0 yet.
> +	 * Everyone listen, start on seed port until find one unused
> +	 */
> +	memcpy((void*)&tp->m_addr, (void*)&hca->hca_address,
> sizeof(DAT_SOCK_ADDR));
> +	tp->m_addr.sin_port = htons(DAT_COLL_SID-1);
> +
> +	do {
> +		tp->m_addr.sin_port++;

You're in network-byte order here.  ++ probably isn't what you want here.

> +		ret = bind(tp->l_sock,
> +			   (struct sockaddr *)&tp->m_addr,
> +			   sizeof(DAT_SOCK_ADDR));
> +
> +	} while (ret == -1 && errno == EADDRINUSE);
> +
> +	if (ret == -1)
> +		goto err;
> +
> +	if ((ret = listen(tp->l_sock, 1024)) < 0)
> +		goto err;
> +
> +	dapl_log(DAPL_DBG_TYPE_EXTENSION,
> +		"create_member: listen port 0x%x,%d \n",
> +		ntohs(tp->m_addr.sin_port),
> +		ntohs(tp->m_addr.sin_port));
> +
> +	/* local fca_info and sock_addr to member buffer for MPI exchange */
> +	tp->f_size = size;
> +	tp->m_size = size + sizeof(DAT_SOCK_ADDR);
> +	memcpy(tp->m_info, tp->f_info, size);
> +	memcpy( ((char*)tp->m_info + size), &tp->m_addr, sizeof(DAT_SOCK_ADDR));
> +
> +	/* free rank info after getting */
> +	fca_free_rank_info(tp->f_info);
> +	tp->f_info = NULL;
> +
> +	dapl_log(DAPL_DBG_TYPE_EXTENSION,
> +		 "create_member: m_ptr=%p, sz=%d exit SUCCESS\n",
> +		 tp->m_info, tp->m_size);
> +
> +	return 0;
> +err:
> +	/* cleanup */
> +	if (tp->f_info) {
> +		fca_free_rank_info(tp->f_info);
> +		tp->f_info = NULL;
> +	}
> +
> +	if (tp->m_info) {
> +		free(tp->m_info);
> +		tp->m_info = NULL;
> +	}
> +	if (tp->l_sock > 0)
> +		close(tp->l_sock);
> +bail:
> +	return 1;
> +}
> +

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
