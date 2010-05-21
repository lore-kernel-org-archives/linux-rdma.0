From: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: Proposal for adding ib_usa to the Linux Infiniband Subsystem
Date: Fri, 21 May 2010 08:42:56 -0500
Message-ID: <4C2744E8AD2982428C5BFE523DF8CDCB49A488D12E@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello, all.

=46or the past few years, we (QLogic) have been using the IB user space=
 SA module that was originally written by Sean Hefty. We think it would=
 be great if this module were to become part of the official Linux Infi=
niband subsystem - but rather than simply dumping this on Roland as a s=
urprise, I thought it might be a good idea to talk about it, first, and=
 find out what the best approach would be.


What is ib_usa?
---------------
The ib_usa module adds two features to the Infiniband Subsystem. It all=
ows user applications to subscribe to SA notifications (remote port up,=
 remote port down, etc.) and it allows user applications to subscribe t=
o multicast groups. It does this via a device file, /dev/infiniband/ib_=
usa, similar to /dev/infiniband/uverbs and /dev/infiniband/umad.


Why is this needed?
-------------------
The SA protocol allows notices and multicast membership to be managed a=
t a CA port level.=A0 As a result, if multiple processes want to receiv=
e notices or join multicast groups, that registration must be coordinat=
ed per CA port.=A0 Existing code in the Linux kernel exists for this pu=
rpose, coordinating the needs of various Infiniband kernel modules and =
presenting a single "per server CA port" perspective to the SA.=A0 The =
IB user space SA module provides a mechanism for user space application=
s to take advantage of this existing kernel code for managing SA regist=
rations.

By providing this mechanism, ib_usa provides a convenient and useful wa=
y for user applications to detect when nodes enter or leave the fabric.=
 This is useful for fabric monitoring applications (like a system admin=
 dashboard) or, conceivably, to allow a cluster application to detect p=
roblems and to dynamically balance a computational load across the fabr=
ic.

In addition, the multicast functionality will allow user applications t=
o use properly verbs to receive multicast traffic.


How will it integrate into the existing Infiniband subsystem?
-------------------------------------------------------------
We recommend including Sean's original module, and we can provide a ver=
sion of it that works fine with the latest versions of OFED. This will =
add a new kernel module to the ofa_kernel package, ib_usa.ko.=20

In addition, there will be a need for a shared library to provide an AP=
I to provide access to ib_usa. I would suggest adding the needed functi=
ons to OFED management module, as part of the libibumad library, or to =
their own libibusa library. In either case, I would provide the needed =
code and a sample/test application.

So, how about it? What's the best way forward here?



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
