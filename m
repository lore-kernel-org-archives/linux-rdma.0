From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 14/14] SIWv2: Documentation: siw.txt
Date: Sun, 19 Jun 2011 08:04:23 +0300
Message-ID: <4DFD8357.3090406@mellanox.com>
References: <1308228174-22788-1-git-send-email-bmt@zurich.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1308228174-22788-1-git-send-email-bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Bernard Metzler wrote:

> +/sys/class/infiniband/siw*/stats:
> +	Summary of allocated WQE's, PD's, QP's, CQ's, SRQ's, MR's, CEP's.
> +	WQE statistics are not gathered if 'DPRINT_MASK' is set to '0'
> +/sys/class/infiniband/siw*/qp:
> +	Summary of allocated queue pairs. If queue pairs are allocated,
> +	after reading 'qp' a more detailed status of all queue pairs has
> +/sys/class/infiniband/siw*/cep:
> +	Summary of allocated connection end points. If connection endpoints
> +	are allocated, after reading 'cep' a more detailed status of all
> +	CEP's is printed to the kernel syslog and can be retrieved via

any reason not to use the IB stack netlink infrastructure to support 
these counters?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
