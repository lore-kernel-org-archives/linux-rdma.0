From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: rstream application
Date: Mon, 20 Nov 2017 18:59:24 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB1AC288@ORSMSX109.amr.corp.intel.com>
References: <CY1PR0701MB20123BEF45FFB6AF762D4468882E0@CY1PR0701MB2012.namprd07.prod.outlook.com>
 <CY1PR0701MB2012D019C936BFC566F41DD4882E0@CY1PR0701MB2012.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CY1PR0701MB2012D019C936BFC566F41DD4882E0-UpKza+2NMNLHMJvQ0dyT705OhdzP3rhOnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Radzi, Amit" <Amit.Radzi-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> We've been debugging an issue with the rstream application, would be
> glad to get your help.
> This application is part of the OFA logo program and therefore we've
> been debugging it.
> Intermittently we get an error: Connection refused (stale connection )
> on the second connect in the test.
> (rstream -S all -T a )
> It looks like in some cases the server side gets a new connection
> request before destroying the cm-id, Leaving the remote id and remote
> qp in the remote_id_table and remote_qp_table

Can you provide more details on when the problem occurs?  Is the client attempting to connect to a server that is not yet active, or trying to connect to a server that already accepted a connection?  Do you know if the hardware re-uses QPNs?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
