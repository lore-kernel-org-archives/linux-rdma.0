From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: ibstat does not recognize iWARP RNIC adapters
Date: Thu, 26 Apr 2012 06:31:01 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373469D85A8@ORSMSX101.amr.corp.intel.com>
References: <8A71B368A89016469F72CD08050AD3340B8AAE7F@maui.asicdesigners.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8A71B368A89016469F72CD08050AD3340B8AAE7F-utt48SW1nMZEErodcbzraFjMPmZJtkid@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Troy Leedberg <troy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I noticed that doing ibstat, none of the iWARP RNIC adapters were sho=
wing
> up.=A0 I have attached a patch to address the issue (libibumad.patch)=
=2E
>=20
> SYS_NODE_TYPE for iWARP RNIC is 4 and is_ib_type only checked to 3.

I don't think libibumad should support RNICs.  Users can use ibv_devinf=
o instead.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
