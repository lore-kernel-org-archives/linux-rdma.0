From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: rstream application
Date: Thu, 16 Nov 2017 09:13:00 -0500
Message-ID: <32c5f678-a7b2-7b62-730c-533dce361cc8@dev.mellanox.co.il>
References: <CY1PR0701MB20123BEF45FFB6AF762D4468882E0@CY1PR0701MB2012.namprd07.prod.outlook.com>
 <CY1PR0701MB2012D019C936BFC566F41DD4882E0@CY1PR0701MB2012.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CY1PR0701MB2012D019C936BFC566F41DD4882E0-UpKza+2NMNLHMJvQ0dyT705OhdzP3rhOnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Radzi, Amit" <Amit.Radzi-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/16/2017 5:39 AM, Kalderon, Michal wrote:
> Hi,
> 
> We've been debugging an issue with the rstream application, would be glad to get your help. 
> This application is part of the OFA logo program and therefore we've been debugging it.
> Intermittently we get an error: Connection refused (stale connection ) on the second connect in the test.
> (rstream -S all -T a )
> It looks like in some cases the server side gets a new connection request before destroying the cm-id,
> Leaving the remote id and remote qp in the remote_id_table and remote_qp_table

The connection goes into timewait state on disconnect. This timeout is 2
* PathRecord:PacketLifeTime plus the remote's Ack Delay.

RoCE spec says "The default value for SubnetTimeout shall be 18 and can
be modified by Ethernet management practices.The default SubnetTimeout
value can be used as an upper bound estimate of InfiniBand PacketLifeTime".

A subsequent incoming REQ for same remote ID and remote QPN while in
this state will result in REJ for stale connection. This is at CM and
CMA levels. I am not sure whether or not the errors returned from
rconnect are sufficient to isolate this case from other connection
refusal cases. Sean would know.

I think there is same issue in some other rsocket examples as well.

-- Hal

> Attached are two traces (using ftrace)
> good_trace when second connect succeeds
> bad_trace when second connect attempt fails
> 
> I think this can be considered as an application issue, and rstream could be modified to try and re-connect
> In case it fails. 
> 
> Your input on this will be highly appreciated, 
> 
> Thanks,
> Michal
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
