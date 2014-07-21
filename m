From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [for-next 1/2] xprtrdma: take reference of rdma provider module
Date: Mon, 21 Jul 2014 13:30:49 -0400
Message-ID: <0CDA5340-DDD6-42F8-8359-0069BBC9E24C@oracle.com>
References: <1405605697-11583-1-git-send-email-devesh.sharma@emulex.com> <3e39e90f-7095-4eb9-a844-516672a355ad@CMEXHTCAS2.ad.emulex.com> <53C7E546.3080008@opengridcomputing.com> <1828884A29C6694DAF28B7E6B8A823739933FCA3@ORSMSX109.amr.corp.intel.com> <53C81CB7.2030000@oracle.com> <006d01cfa1f2$65d020d0$31706270$@opengridcomputing.com> <1828884A29C6694DAF28B7E6B8A823739933FDEA@ORSMSX109.amr.corp.intel.com> <008301cfa1fa$f231f550$d695dff0$@opengridcomputing.com> <DF7CE85B-288D-4CC2-AD51-B326D5F1EE1A@oracle.com> <008c01cfa201$f1eecda0$d5cc68e0$@opengridcomputing.com> <EE7902D3F51F404C82415C4803930ACD3FE1482F@CMEXMB1.ad.emulex.com> <002401cfa28c$11feb4e0$35fc1ea0$@opengridcomputing.com> <53C94199.4050601@oracle.com> <EE7902D3F51F404C82415C4803930ACD3FE1C7B7@CMEXMB1.ad.emulex.com> <a6345162-863d
 -447c-b7c2-059ced190a13@CMEXHTCAS1.ad.emulex.com> <27ACE237-161A-4CA5-AA5C-6349CC4118E3@oracle.com> <005701cfa4f4$f7a64c00$e6f2e400$@opengridcomputing.com> <D88D1952-83A1-4FF9-B028-AAE7A859!
 A 5B1@oracle.com> <005e01cfa4f7$9dd4cc80$d97e6580$@opengridcomputing.com> <EE7902D3F51F404C82415C4803930ACD3FE1D9CF@CMEXMB1.ad.emulex.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <EE7902D3F51F404C82415C4803930ACD3FE1D9CF-DWYeeINJQrxExQ8dmkPuX0M9+F4ksjoh@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Jul 21, 2014, at 1:07 PM, Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org> w=
rote:

>>>>> Until that support is in place, obviously I would prefer that the
>>>>> removal of the underlying driver be prevented while there are NFS
>>>>> mounts in place. I think that's what NFS users have come to expec=
t.
>>>>>=20
>>>>> In other words, don't allow device removal until we have support
>>>>> for device insertion :-)
>=20
> This needs a fresh series of patches?

=93do not allow removal=94 would likely take an approach similar to wha=
t you
originally posted, unless someone has an idea how to use a CM_EVENT to
make this work, or there is an objection from the kernel RDMA folks.

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
