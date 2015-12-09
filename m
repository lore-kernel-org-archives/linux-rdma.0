From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 1/1] Ibacm: default pkey for partitioned fabrics
Date: Wed, 9 Dec 2015 10:15:22 -0500
Message-ID: <5668458A.7020809@dev.mellanox.co.il>
References: <1449595982-20781-1-git-send-email-kaike.wan@intel.com>
 <56682392.5000302@dev.mellanox.co.il>
 <3F128C9216C9B84BB6ED23EF16290AFB185810A2@CRSMSX101.amr.corp.intel.com>
 <56683080.1090801@dev.mellanox.co.il>
 <3F128C9216C9B84BB6ED23EF16290AFB185810D9@CRSMSX101.amr.corp.intel.com>
 <5668354B.4090903@dev.mellanox.co.il>
 <3F128C9216C9B84BB6ED23EF16290AFB18581111@CRSMSX101.amr.corp.intel.com>
 <56683C6C.7070106@dev.mellanox.co.il>
 <3F128C9216C9B84BB6ED23EF16290AFB185811ED@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3F128C9216C9B84BB6ED23EF16290AFB185811ED-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/9/2015 10:04 AM, Wan, Kaike wrote:
> I mean that the user needs to investigate why the fabric is not working out of box. 

My point is that an educated admin should _know_ to configure in these
cases and that debug is only when things are broken not by default in
these more complex cases. This means the limitations of the out of box
approach needs to be explained in the docs.

> This patch itself does not make configuration of the fabric harder.

Agreed.

> On the contrary, it relieves the user from having to configure ibacm on each node in those common cases.

Agreed.

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
