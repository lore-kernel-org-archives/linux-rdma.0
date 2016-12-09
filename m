From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH infiniband-diags] Add Bull device ID support to device
 white lists
Date: Fri, 9 Dec 2016 09:15:38 -0500
Message-ID: <703b953b-7165-72d1-3c1e-c3b1f8c54f28@dev.mellanox.co.il>
References: <e5ad4256-53fe-9ecc-f880-89347134ec42@dev.mellanox.co.il>
 <20161207145338.GD24724@phlsvsds.ph.intel.com> <584A8823.4070506@atos.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <584A8823.4070506-BUmcmmAb0Fc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vincent Ficet <jean-vincent.ficet-BUmcmmAb0Fc@public.gmane.org>, "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/9/2016 5:32 AM, Vincent Ficet wrote:
> Hello,
> 
> The patch proposed by Hal Rosenstock does not list all Bull device IDs.
> 
> Please apply the attached patch which contains an up to date list of such IDs.

Would it be better to combine Bull Switch-IB and Switch-IB2 ranges into
one check rather than keeping them separate as the device IDs are
contiguous ?

Also, looks like similar change should also be done in
ibdiag_common.c:is_mlnx_ext_port_info_supported.

-- Hal

> Best Regards,
> 
> Vincent
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
