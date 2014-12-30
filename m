From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 1/6] IB/Core: Changes to the IB Core infrastructure for
 RoCEv2 support
Date: Tue, 30 Dec 2014 17:40:27 +0200
Message-ID: <CAG9sBKP0k=dT+X9=Em8FVS=GQ5uHt-7jw4XTKTEKk-=pD_nMNQ@mail.gmail.com>
References: <99a3d3b9-842b-450f-916a-87eb197048a3@CMEXHTCAS2.ad.emulex.com>
	<CAG9sBKMus3vbEYS43EM01GaOLE9qSz1sxhNn=Z3eOdq8NNO7rg@mail.gmail.com>
	<29f65b01-b077-4147-b316-808ee03a1c73@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <29f65b01-b077-4147-b316-808ee03a1c73-3RiH6ntJJkP8BX6JNMqfyFjyZtpTMMwT@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Somnath Kotur <Somnath.Kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Cc: "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Devesh Sharma <Devesh.Sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Although you follow the spec here, 3 types of RDMA_NETWORK are not
> really required. Maybe we can get rid of this
> Maybe we can get rid of this duplication
>
> [SOM]: Not sure i understood the duplication here or why it's not required?
> We now have a new 'network/L3' layer on top of L2 - that was the reason, does it not make sense?
>
Once you know pair (type of RoCE and GID value) you know what is the
network type
And once you know network type you know the pair.
So, it is not really necessary to keep them all stored.
My idea is to get rid if the type that describes network type

> [SOM]: Well, partly the use of get_port_type() was motivated by the SPEC(Query HCA - 17.5.x.x IIRC) talking about the need to have a port_type
> attribute as part of RoCEV2 that would indicate if a HW device/port supported RoCEV2 or not.  It was also serving another purpose
> in cma_acqure_dev() as you can see above in the patch where it was helping the use case of devices that only support V2 and not V1.
> Still feel it doesn't make sense?
> Not sure how/where did you want point 2 coming from - sysfs/proc/debugfs?
> I'd prefer to have that in the next stage of the patchset

Spec is confusing. Under the section QUERY HCA it describes changes to
the port attr.
Anyway, I see that spec points to the ability of querying capabilities
and comparing them against decisions but not as a method to take
decisions.
What I would do is to add 2 flags to ib_port_cap_flags,
IB_PORT_ROCE_SUP and IB_PORT_ROCE_V2_SUP.

I think that the main difference between approaches is how to decide
about the RoCE type to use for a session.
This is also why I think that we should not postpone the change in
cma_acquire_dev to later.

thanks
Moni
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
