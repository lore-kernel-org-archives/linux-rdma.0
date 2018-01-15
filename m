From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-core 07/17] verbs: Use kernel uapi names for
 identical structs
Date: Mon, 15 Jan 2018 10:01:12 -0700
Message-ID: <20180115170112.GC30978@mellanox.com>
References: <20180111221340.965-1-jgg@ziepe.ca>
 <20180111221340.965-8-jgg@ziepe.ca>
 <2f04c4d8-bc14-9293-2e03-b29074e08637@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2f04c4d8-bc14-9293-2e03-b29074e08637-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 15, 2018 at 06:48:06PM +0200, Yishai Hadas wrote:
> >  	IBV_INIT_CMD_RESP(cmd, cmd_size, ALLOC_PD, resp, resp_size);
> >@@ -338,7 +338,7 @@ int ibv_cmd_open_xrcd(struct ibv_context *context, struct verbs_xrcd *xrcd,
> >  		      int vxrcd_size,
> >  		      struct ibv_xrcd_init_attr *attr,
> >  		      struct ibv_open_xrcd *cmd, size_t cmd_size,
> >-		      struct ibv_open_xrcd_resp *resp, size_t resp_size)
> >+		      struct ib_uverbs_close_xrcd *resp, size_t resp_size)
> 
> This had to be ib_uverbs_open_xrcd_resp, correct ? need to fix in the
> drivers' code that uses this as well.

For clarity, yes. I will fix it.. I manually caught many others like
this but missed this one

The two structs are identical, which is why they got conflated
together, so it doesn't create a bug - just confusion:

struct ib_uverbs_open_xrcd_resp {
        __u32 xrcd_handle;
};

struct ib_uverbs_close_xrcd {
        __u32 xrcd_handle;
};
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
