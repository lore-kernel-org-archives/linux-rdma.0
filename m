From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH V4 libmlx4] Infra-structure changes to support verbs
 extensions
Date: Tue, 16 Oct 2012 23:56:50 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346AAE2AA@ORSMSX101.amr.corp.intel.com>
References: <1350232988-22388-1-git-send-email-yishaih@mellanox.com>
	<1828884A29C6694DAF28B7E6B8A8237346AAE11F@ORSMSX101.amr.corp.intel.com>
 <CABWw6V1qTaaeuRye0nw4kDSPBGiVniq3nvfgMcijC1KQMO2Lcg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CABWw6V1qTaaeuRye0nw4kDSPBGiVniq3nvfgMcijC1KQMO2Lcg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> ABI version 2 is really not supported any more in verbs ext mode.
> The idea in this change was to fail the driver registration and not wait that
> ibv_cmd_get_context will be called and fail.
> See patch for libibverbs.
> 
> To have a correct error message we can increase MLX4_UVERBS_MIN_ABI_VERSION to
> be 3 (assuming that was no ABI version between 2 to 3)  and use "if
> (abi_version < MLX4_UVERBS_MIN_ABI_VERSION ..."  instead of <=

This makes more sense.  MIN_ABI_VERSION should be the minimum supported version.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
