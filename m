From: Vivek Kashyap <kashyapv-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: RE: rsockets and standard socket based TCP benchmarks
Date: Mon, 11 Jun 2012 14:02:22 -0700 (PDT)
Message-ID: <alpine.LRH.2.00.1206111220550.4907@oc4747053027.ibm.com>
References: <4FBD6981.2070502@us.ibm.com> <1828884A29C6694DAF28B7E6B8A8237346A23C38@ORSMSX101.amr.corp.intel.com> <alpine.LRH.2.00.1206081745150.3988@oc4747053027.ibm.com> <1828884A29C6694DAF28B7E6B8A8237346A2FA25@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-739396015-1339448545=:4907"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237346A2FA25-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Sridhar Samudrala <sri-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "pradeeps-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org" <pradeeps-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-739396015-1339448545=:4907
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT

On Sat, 9 Jun 2012, Hefty, Sean wrote:

>> But to map standard networking applications to rsockets we will run into the
>> above problem i.e. fork() will not work.  It would be very useful to
>> allow for the standard networking paradigm of: bind()->listen()->accept()-
>> ->fork(), and then the server goes back to accept(). That would allow us to
>> use rsockets transparently with existing applications.
>
> I'm aware that fork() support does not work.  The problems lie within the RDMA stack, and maybe there's some way around this, but I'm not sure what it would be at this point.  I can't say that I fully grasp all the low level issues involved in 'fixing' it.

Yeah..I looked a bit inot it. It seems easy enough to, within this restricted
paradigm, to use shared memory for the data buffer and share it between the
parent and the child. The QP/CQ accesses are not that straightforward and I 
need to understand more before I can suggest anything myself.


>
>> Is it possible to support fork() for this standard model where the parent
>> closes its copy of the newly created socket and goes back to waiting on the
>> original socket in accept, and the child continues with the newly created
>> socket?
>
> IMO, it seems that if we can limit the usage model to what you're describing, then we may at least have a chance at supporting fork().
>
>> Have you considered some other options to make this happen?
>>
>> Could we  skip creating the endpoint in raccept(), but actually create the
>> new endpoint during the frist receive or send? This would then allow the
>> fork() to occur without the complications with the pinned data.
>
> That's an interesting possibility.  I need to give something like this more thought, but establishing a connection over a normal socket, then using that to migrate communication to a QP on the first data exchange may allow for fork support.

yes.


>That would have an effect on trying to handle fallback support (i.e. using standard sockets when RDMA fails), plus may have other issues, but there may some be ideas here worth considering.
>

Though one can consider the fall-back in reverse order i.e. if the 
rdma connection fails  continue with the already established connection (over 
the normal inet socket).

Vivek

> - Sean
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
--8323328-739396015-1339448545=:4907--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
