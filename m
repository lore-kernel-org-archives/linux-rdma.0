From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH infiniband-diags] Add Bull device ID support to device
 white lists
Date: Mon, 19 Dec 2016 07:10:57 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E3C611A58@CRSMSX101.amr.corp.intel.com>
References: <e5ad4256-53fe-9ecc-f880-89347134ec42@dev.mellanox.co.il>
 <20161207145338.GD24724@phlsvsds.ph.intel.com> <584A8823.4070506@atos.net>
 <703b953b-7165-72d1-3c1e-c3b1f8c54f28@dev.mellanox.co.il>
 <584ABFE6.4070902@atos.net>
 <46fac349-4687-961a-4d63-697064f391da@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <46fac349-4687-961a-4d63-697064f391da-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Vincent Ficet <jean-vincent.ficet-BUmcmmAb0Fc@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> On 12/9/2016 9:29 AM, Vincent Ficet wrote:
> >> Would it be better to combine Bull Switch-IB and Switch-IB2 ranges
> >> into one check rather than keeping them separate as the device IDs
> >> are contiguous ?
> > I just wanted to separate SwitchIB and SwitchIB2 for clarity, but we can gather
> them if you wish to do so.
> >
> > Which option do you prefer, together or split ?
> 
> I prefer together.

Together is fine by me.

I was expecting a v2 of this patch.  Was that your intention?

Ira


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
