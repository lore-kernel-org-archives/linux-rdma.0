From: Vivek Kashyap <kashyapv-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: RE: rsockets and standard socket based TCP benchmarks
Date: Wed, 13 Jun 2012 23:06:58 -0700 (PDT)
Message-ID: <alpine.LRH.2.00.1206132110190.13728@oc4747053027.ibm.com>
References: <4FBD6981.2070502@us.ibm.com> <1828884A29C6694DAF28B7E6B8A8237346A23C38@ORSMSX101.amr.corp.intel.com> <alpine.LRH.2.00.1206081745150.3988@oc4747053027.ibm.com> <1828884A29C6694DAF28B7E6B8A8237346A2FA25@ORSMSX101.amr.corp.intel.com>
 <alpine.LRH.2.00.1206111220550.4907@oc4747053027.ibm.com> <1828884A29C6694DAF28B7E6B8A8237346A2FE06@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237346A2FE06-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Sridhar Samudrala <sri-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "pradeeps-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org" <pradeeps-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On Mon, 11 Jun 2012, Hefty, Sean wrote:

>> Though one can consider the fall-back in reverse order i.e. if the
>> rdma connection fails  continue with the already established connection (over
>> the normal inet socket).
>
> When I consider fallback, one of the issues is handling the case where one of the two sides is not using rsockets.  This prevents us from injecting new traffic into the TCP stream.
>

Yes, good point. If the other side does not have rsockets then it is not that
straightforward.

Some thoughts:

1. The best option might be if we exchanged an option during
connection setup. This tells the peers if the other side is capable of RDMA.
If it is then one can switch to support of RDMA.

One obvious area of capability exchange is with TCP option. This requires TCP
extension though.

Is there any other mechanism to exchange capabilities?


2. In IPoIB, the address resolution returns RC or UD flags. This can allow 
one to determine if the remote peer is capabile of RDMA i.e. use of RC but 
does not tell us if rsockets is present on the peer. 
Can one still attmept an rsockets based connection over RC mode?


3. Use a service discovery mechanism to determine if the remote peer supports
rsockets. This will need to determine if the remote port is enabled; not just 
that rsockets is present on the system.

thanks
Vivek



> Still, if there's a way for rsockets to support fork for a significant number of apps, I'd be willing to live with these trade-offs.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
