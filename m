From: Vivek Kashyap <kashyapv-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: RE: rsockets and standard socket based TCP benchmarks
Date: Sun, 15 Jul 2012 21:46:37 -0700 (PDT)
Message-ID: <alpine.LRH.2.00.1207131640350.3944@oc4747053027.ibm.com>
References: <4FBD6981.2070502@us.ibm.com> <1828884A29C6694DAF28B7E6B8A8237346A23C38@ORSMSX101.amr.corp.intel.com> <alpine.LRH.2.00.1206081745150.3988@oc4747053027.ibm.com> <1828884A29C6694DAF28B7E6B8A8237346A2FA25@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237346A2FA25-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Sridhar Samudrala <sri-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "pradeeps-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org" <pradeeps-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>
>> Have you considered some other options to make this happen?
>>
>> Could we  skip creating the endpoint in raccept(), but actually create the
>> new endpoint during the frist receive or send? This would then allow the
>> fork() to occur without the complications with the pinned data.
>
> That's an interesting possibility.  I need to give something like this more thought, but establishing a connection over a normal socket, then using that to migrate communication to a QP on the first data exchange may allow for fork support.  That would have an effect on trying to handle fallback support (i.e. using standard sockets when RDMA fails), plus may have other issues, but there may some be ideas here worth considering.
>
Hi Sean,

Have you had a chance to look more into the above for fork() support?

thanks
Vivek

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
