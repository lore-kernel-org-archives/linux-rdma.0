From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/3] Support out of order data placement
Date: Mon, 12 Jun 2017 15:57:41 -0600
Message-ID: <20170612215741.GA31693@obsidianresearch.com>
References: <VI1PR0502MB3008CE85A4F274886B74DF2BD1CD0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <3fa7a4b5-5c19-8c6a-d78b-93219a9be888@intel.com>
 <1828884A29C6694DAF28B7E6B8A82373AB142A9B@ORSMSX109.amr.corp.intel.com>
 <VI1PR0502MB300885A1DD676E1649CDB268D1CD0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <b5279c09-027f-e374-ffde-7f236c52322c@intel.com>
 <1828884A29C6694DAF28B7E6B8A82373AB142BEC@ORSMSX109.amr.corp.intel.com>
 <085201d2e3be$81070ce0$831526a0$@opengridcomputing.com>
 <20170612210259.GA25652@obsidianresearch.com>
 <086401d2e3c1$72d54b20$587fe160$@opengridcomputing.com>
 <VI1PR0502MB30082486BC3B1669FE48764ED1CD0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <VI1PR0502MB30082486BC3B1669FE48764ED1CD0-o1MPJYiShExKsLr+rGaxW8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "'Hefty, Sean'" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "'Dalessandro, Dennis'" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Idan Burstein <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 12, 2017 at 09:53:55PM +0000, Parav Pandit wrote:
> I will add following more details to Documentation.
> 1. Mention about pcie relax ordering - Barts point
> 2. Include responder side table like Table 79 to crisply describe all cases and ordering with respect to send and other messages
> 3. Also indicate that C9-28 is relaxed when ooo is enabled on a QP as a description to new responder side table.
> This was offline comment that I received.
> 4. Provide examples that Steve and Jason highlighted, with multiple writes to same memory location.
> 5. Reiterate table 79, to make it clear that what doesn't change, or changes.
> Let me know if you want to see any more details.

Explain why this needs to be negotiated and what it does to the
transmit side of a QP.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
