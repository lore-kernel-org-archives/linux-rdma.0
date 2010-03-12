From: =?iso-8859-1?Q?H=E5kon_Bugge?= <Haakon.Bugge-UdXhSnd/wVw@public.gmane.org>
Subject: Re: [PATCH V3 0/2] Add support for enhanced atomic operations
Date: Fri, 12 Mar 2010 10:21:57 +0100
Message-ID: <BA082DF0-B3C6-4405-B480-F69B0193BF17@Sun.COM>
References: <20100310155749.GA25964@vlad-laptop>
 <A27E2E88-63A0-45EE-9A70-F95B2A0C25AD@Sun.com>
 <adaaaueelby.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <adaaaueelby.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mar 11, 2010, at 19:59 , Roland Dreier wrote:
> I think we can worry about that if/when an HCA comes along that suppo=
rts
> global atomics for ordinary atomics but not enhanced atomics.

With the proposed patches in place, how do you know if masked atomics a=
re implemented or not? Guess apps need to know this information already=
 on todays HCAs.

> Although perhaps it would be cleaner to change the atomic_cap enum to=
:
>=20
> 	/*
> 	 * IB_ATOMIC_NONE:	no atomic capability
> 	 * IB_ATOMIC_HCA:	all ops are atomic within HCA

But IB_ATOMIC_HCA  does not tell you if the masked ones are supported o=
r not.

> 	 * IB_ATOMIC_GLOB:	standard ops atomic with respect to all
> 				memory ops; masked ops atomic within HCA

What if an HCA supports standards ops with respect to all memory ops, b=
ut the HCA does not support masked atomics?

Hence, I think it would be cleaner if a new capability, masked_atomic_c=
ap, were introduced, using the original definitions (NONE, HCA, GLOB).


Thanks, H=E5kon


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
