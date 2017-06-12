From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/3] Support out of order data placement
Date: Mon, 12 Jun 2017 15:22:07 -0600
Message-ID: <20170612212207.GB27649@obsidianresearch.com>
References: <074a01d2e39f$edc28860$c9479920$@opengridcomputing.com>
 <VI1PR0502MB3008CE85A4F274886B74DF2BD1CD0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <3fa7a4b5-5c19-8c6a-d78b-93219a9be888@intel.com>
 <1828884A29C6694DAF28B7E6B8A82373AB142A9B@ORSMSX109.amr.corp.intel.com>
 <VI1PR0502MB300885A1DD676E1649CDB268D1CD0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <b5279c09-027f-e374-ffde-7f236c52322c@intel.com>
 <1828884A29C6694DAF28B7E6B8A82373AB142BEC@ORSMSX109.amr.corp.intel.com>
 <085201d2e3be$81070ce0$831526a0$@opengridcomputing.com>
 <20170612210259.GA25652@obsidianresearch.com>
 <086401d2e3c1$72d54b20$587fe160$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <086401d2e3c1$72d54b20$587fe160$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: "'Hefty, Sean'" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "'Dalessandro, Dennis'" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Parav Pandit' <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Idan Burstein' <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 12, 2017 at 04:18:34PM -0500, Steve Wise wrote:

> buffer when it polls the recv completion for the SEND or WRITE_W_IMMD.  An iWARP
> RNIC _must_ guarantee in-order delivery of data (but not actual placement).  Am
> I making sense?

Yes, and IB is technically the same.

As Tom pointed out, it is a quirk of the x86 & mellanox combination
that apps can reliably 'spin on the last byte', it is certainly not
guaranteed by any spec.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
