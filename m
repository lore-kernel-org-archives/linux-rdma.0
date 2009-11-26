From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH RFC] opensm: compress IPV6 SNM groups to use a single
 MLID
Date: Thu, 26 Nov 2009 18:36:34 +0200
Message-ID: <20091126163634.GJ13817@me>
References: <20091113061948.GJ7192@me>
 <20091113062104.GK7192@me>
 <20091113201144.GS7192@me>
 <20091113203856.GT7192@me>
 <20091113204041.GU7192@me>
 <f0e08f230911160735i69ad3671m9a2667900b933e13@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f0e08f230911160735i69ad3671m9a2667900b933e13-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Slava Strebkov <slavas-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10:35 Mon 16 Nov     , Hal Rosenstock wrote:
> >
> > Unlike previous solution where all IPv6 Solicited node multicast (SNM)
> > requests were collapsed into a single multicast group in OpenSM, now
> > each IPv6 SNM group is represented as a separate multicast group and
> > all groups sharing same P_Key and scope values use a same MLID value.
> 
> Shouldn't this also ensure groups sharing MLIDs have the same MTU,
> rate, and packet lifetime ?

For IPv6 SNM it was never implemented, so my rework meets an original
plan.

And in general it is an interesting question. Do we really need to care
about those parameters while doing MGID to MLID compression? SA will
reply properly MGID "based" queries, an "extra" packets will be dropped
anyway, likely sooner is better, no?

> > This solution should be fully IBA complaint.
> 
> Why the should qualification ?

Only due to insufficient testing, etc..

> Shouldn't the IBA compliant issues fixed be documented here ?

Yes, but I cannot find where. The only needed change I found is in the
usage message and man page, but there is nothing about IBA compliance.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
