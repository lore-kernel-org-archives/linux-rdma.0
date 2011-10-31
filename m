From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: UDP -> IPoIB -> Verbs
Date: Mon, 31 Oct 2011 14:18:49 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E8B287@ORSMSX101.amr.corp.intel.com>
References: <CAND8VyDABEXdztz-qm4oJnSeXmTo1j_gnjo9AF=di5rPqT8rdA@mail.gmail.com>
 <1828884A29C6694DAF28B7E6B8A8237316E8B205@ORSMSX101.amr.corp.intel.com>
 <4EAE5DBD.4050701@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4EAE5DBD.4050701-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Kelly Burkhart <kelly.burkhart-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Sean,  wait, the rdmacm IPoIB port space allows librdmacm consumers to
> subscribe to multicast groups created by IPoIB and vise versa, so for
> udp/multicast the answer is yes, agree?

Good point - for multicast it should work.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
