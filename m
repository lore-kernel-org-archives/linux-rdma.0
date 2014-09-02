From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 4/5] dapl: add support for the s390x platform
Date: Tue, 2 Sep 2014 16:06:06 +0000
Message-ID: <54347E5A035A054EAE9D05927FB467F972E6F553@ORSMSX101.amr.corp.intel.com>
References: <1409135080-44991-1-git-send-email-aishchuk@linux.vnet.ibm.com>
 <1409135080-44991-5-git-send-email-aishchuk@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1409135080-44991-5-git-send-email-aishchuk-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexey Ishchuk <aishchuk-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "gilr-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <gilr-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "gmuelas-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org" <gmuelas-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, "utz.bacher-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org" <utz.bacher-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, "martin.schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org" <martin.schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, "frank.blaschka-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org" <frank.blaschka-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> Subject: [PATCH 4/5] dapl: add support for the s390x platform
> 
> This patch adds the dapl_os_atopmic_inc, dapl_os_atomic_dec, and
> dapl_os_atomic_assign function implementatios to the dapl userspace
> package to provide the DAPL API support on the s390x platform by adding
> Assembler language implemenation of those platform specific functions.
> 
> Signed-off-by: Alexey Ishchuk <aishchuk-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

Acked-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Committed. Thanks!

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
