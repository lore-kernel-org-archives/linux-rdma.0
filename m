From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] librdmacm/doc: document the limitations on the user
 provided private data length
Date: Fri, 01 Apr 2011 13:00:37 +0200
Message-ID: <1301655637.5661.21.camel@deela.quest-ce.net>
References: <alpine.LRH.2.00.1103281048280.17717@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LRH.2.00.1103281048280.17717-VYr5/9ddeaGSIdy2EShu12Xnswh1EIUO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Le lundi 28 mars 2011 =C3=A0 10:49 +0200, Or Gerlitz a =C3=A9crit :
> Document the limitations on the user provided private data length
> over Infiniband networks. These limitations are calculated by
> subtracting the rdma-cm header size (see IBA Annex A11 "RDMA CM IP
> Service") from IB's private data len for the REQ (rdma_connect) and
> REP (rdma_accept) messages

In Annex A11 "RMDA CM IP Service" of Infiniband Architecture Release
1.2.1 (November 2007), there's nothing about the REP messages. Only REQ
(table 532) messages are specified in this section.

=46or general REP messages, one have to look to table 103 : "REP Messag=
e
Contents" in section 12.6.8 REP - Reply to Request For Communication.

Am I correct ?

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
