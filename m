From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 2/2] librdmacm: fix resource leaks when
 CMA_CREATE_MSG_CMD_RESP fails
Date: Mon, 22 Aug 2011 22:39:54 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E47245@ORSMSX101.amr.corp.intel.com>
References: <201108151438.56670.dotanb@sw.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201108151438.56670.dotanb-g2bIKuvJtcQanlnWow0HJg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> -#define CMA_CREATE_MSG_CMD_RESP(msg, cmd, resp, type, size) \
> +#define CMA_CREATE_MSG_CMD_RESP(msg, cmd, resp, type, size, clean_cmd) \

This starts to get ugly, especially with usage that ends up looking like this:

> -	CMA_CREATE_MSG_CMD_RESP(msg, cmd, resp, UCMA_CMD_DESTROY_ID, size);
> +	CMA_CREATE_MSG_CMD_RESP(msg, cmd, resp, UCMA_CMD_DESTROY_ID, size, );

I think a cleaner fix would be to replace CMA_CREATE_MSG_CMD_RESP and CMA_CREATE_MSG_CMD with macros that simply initialize structures and do not call return.  I'll update the code and either apply patch 1 or make sure that the necessary cleanup is added, depending on how the resulting code gets structured.

Does anyone know of any reason why we can't change the structures in rdma_cma_abi.h?  (Binary compatibility with the kernel would be preserved, obviously.)

Thanks,
Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
