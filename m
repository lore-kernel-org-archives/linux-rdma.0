From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: HA mode bonding for IB over SDP
Date: Mon, 11 Apr 2011 08:22:24 +0000
Message-ID: <14E57612D748984B982C350F6A78109E4DE2FA@MTRCASDAG01.mtl.com>
References: <loom.20110401T070836-761@post.gmane.org>
	<BANLkTikSRxjYP+GThu7u5jLwGq+v_7JFAA@mail.gmail.com>
 <BANLkTimjnBA=rJLP0d+zQ_EuY_FKpC1nEg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTimjnBA=rJLP0d+zQ_EuY_FKpC1nEg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: bhavinkumar thumar <bhawinkumar.thumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Nir Monovich <nirm-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Thanks a lot for providing me such useful details.

Besides the APM functionality one thing I don't understand is that why =
is the IB-bonding not working with SDP, as SDP also uses IPoIB for addr=
essing. Can you please describe about the problem which doesn't allow t=
he fail-over to take place with IB-bonding driver? This would be more h=
elpful in tackling the problem.

Again, I appreciate for your valuable information.

Thanking You,
Bhavin=A0=20

Hi Bhavin =20
Bonding enslaves netdev devices (i.e. IPoIB interfaces) but SDP doesn't=
 send/recv traffic on these interfaces.
SDP uses to IB interfaces to send/recv traffic to the network and socke=
t interface to send/recv data from/to application.
However, IPoIb interfaces are used for address resolution so you can't =
give them up completely.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
