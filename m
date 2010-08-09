From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v2] rdma/ib_pack.h: add new bth opcodes
Date: Mon, 9 Aug 2010 16:36:12 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A954BCAF@orsmsx501.amr.corp.intel.com>
References: <00a901cb3785$4a032810$de097830$@com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <00a901cb3785$4a032810$de097830$@com>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert Pearson <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Several new opcodes have been added since the last time ib_pack.h was
> updated.
> These changes add them.

Will anything make use of these?

> diff --git a/include/rdma/ib_pack.h b/include/rdma/ib_pack.h
> index cbb50f4..df10acc 100644
> --- a/include/rdma/ib_pack.h
> +++ b/include/rdma/ib_pack.h
> @@ -73,8 +73,11 @@ enum {
>         IB_OPCODE_UC                                = 0x20,
>         IB_OPCODE_RD                                = 0x40,
>         IB_OPCODE_UD                                = 0x60,
> +       IB_OPCODE_CN                                = 0x80,
> +       IB_OPCODE_XRC                               = 0xA0,

The XRC and RD values all look correct, but I must have fallen asleep and missed something.  What's CN?

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
