From: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: RE: Proposal for adding ib_usa to the Linux Infiniband Subsystem
Date: Fri, 21 May 2010 10:57:48 -0500
Message-ID: <4C2744E8AD2982428C5BFE523DF8CDCB49A488D170@MNEXMB1.qlogic.org>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49A488D12E@MNEXMB1.qlogic.org>
 <C14850BAABFD4BE789736D497B1DC825@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <C14850BAABFD4BE789736D497B1DC825-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Would it be better to omit the multicast support from ib_usa and simply=
 add it as a way to handle notifications?

-----Original Message-----
=46rom: Sean Hefty [mailto:sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org]=20
Sent: Friday, May 21, 2010 11:30 AM
To: Mike Heinz; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: RE: Proposal for adding ib_usa to the Linux Infiniband Subsyst=
em

>Why is this needed?
>-------------------
>The SA protocol allows notices and multicast membership to be managed =
at a CA
>port level.=A0 As a result, if multiple processes want to receive noti=
ces or join
>multicast groups, that registration must be coordinated per CA port.=A0=
 Existing
>code in the Linux kernel exists for this purpose, coordinating the nee=
ds of
>various Infiniband kernel modules and presenting a single "per server =
CA port"
>perspective to the SA.=A0 The IB user space SA module provides a mecha=
nism for
>user space applications to take advantage of this existing kernel code=
 for
>managing SA registrations.

The AF_IB support that is being requested for the rdma_cm would provide=
 greater
support for IB multicast join/leave membership.  Some additional work w=
ould be
needed to allow the user to specify the full MCMemberRecord, but the ba=
sic
infrastructure should be there.  Just mentioning this as a possibility.=
  (The IB
ACM code joins multicast groups using libibumad and sends MADs directly=
 to the
SA.)

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
