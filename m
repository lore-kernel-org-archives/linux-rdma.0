From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH rdma-core 0/3] libibumad: Add support for SA MCMemberRecord
Date: Mon, 20 Nov 2017 20:40:57 -0500
Message-ID: <f4b44991-78b7-fc36-520c-f6959e75fed4@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add umad_sa_mcm.h to support SA MCMemberRecord and add umad_sa_mcm_rereg_test.c (rewrite of infiniband-diags umad_rereg_test) using this new header.

Update umad_sa.h with some common enums, defines, and helpers shared with SA PathRecord and MultiPathRecord.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
