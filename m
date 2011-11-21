From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] dapltest-server segfault seen on recent OFED-1.5.4
 daily build
Date: Mon, 21 Nov 2011 20:21:52 +0000
Message-ID: <54347E5A035A054EAE9D05927FB467F916EA4CE2@ORSMSX101.amr.corp.intel.com>
References: <20111118090155.GB17346@kumars-PC.asicdesigners.com>
 <54347E5A035A054EAE9D05927FB467F916EA49A5@ORSMSX101.amr.corp.intel.com>
 <4ECA3402.8030203@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4ECA3402.8030203-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "divy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org" <divy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> Thank you for the two patches. I tried the two patches and now, I have
> not seen a segfault till now on dapl-server at least.
> However, after about 2 hours of test, some of dapl-client throws below
> error on console:
> ----
> Server Name: 3.4.5.1
> Server Net Address: 3.4.5.1
> DT_cs_Client: Starting Test ...
> FAIL: 16 Server test connections did not report ready.
> FAIL: 16 Server test connections did not report ready.
> ----
> 
> dapl-client is stalled at this stage, and needs to be manually killed
> by
> Ctrl+C.
> And below errors are seen on dapl-server console:
> ----
> Test Error: Client_Mem_Info_Send-reaping DTO problem, status = FAILURE
> Test Error: Client_Mem_Info_Send-reaping DTO problem, status = FAILURE
> Test[b368]: Warning: dat_ep_disconnect (abrupt) #2 error
> DAT_INVALID_STATE DAT_INVALID_STATE_EP_UNCONNECTED
> Test[b368]: dat_evd_free (creq) error: DAT_INVALID_STATE
> DAT_INVALID_STATE_EVD_IN_USE
> Test[b368]: Warning: dat_ep_disconnect (abrupt) #3 error
> DAT_INVALID_STATE DAT_INVALID_STATE_EP_UNCONNECTED
> Test[b368]: dat_evd_free (creq) error: DAT_INVALID_STATE
> DAT_INVALID_STATE_EVD_IN_USE
> ...
> ----

Can you send me your scripts so I can attempt to duplicate?
Did this test setup run successfully before OFED 1.5.4 RC3 release?

Thanks,

Arlin


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
