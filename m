From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: FW: [PATCH v2] rdma/ib_pack.h: add new bth opcodes
Date: Mon, 09 Aug 2010 11:10:50 +0300
Message-ID: <4C5FB80A.6010906@Voltaire.com>
References: <00a901cb3785$4a032810$de097830$@com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <00a901cb3785$4a032810$de097830$@com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert Pearson <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Robert Pearson wrote:
> Several new opcodes have been added since the last time ib_pack.h was updated.
> These changes add them.
> +++ b/include/rdma/ib_pack.h
> +       IB_OPCODE_CN                                = 0x80,
> +       IB_OPCODE_XRC                               = 0xA0,

Is this tied to some IBA 1.2 existing/new annex? pointer would be appreciated

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
