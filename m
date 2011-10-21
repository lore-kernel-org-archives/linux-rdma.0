From: Kelly Burkhart <kelly.burkhart-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: RDMA_CM over RoCE
Date: Fri, 21 Oct 2011 08:35:30 -0500
Message-ID: <CAND8VyCztMJPaFT1YRDac+rSiW5njCGi-Y081i-OqKshEu_-Mg@mail.gmail.com>
References: <CAND8VyAWSO=i5uk_ahS15yNGUFq0cJgSDYcU4Go5tX10fj7o1w@mail.gmail.com>
	<CAND8VyC9cm4J8fktvt2Et0LMpBQcKCcaRNEkFDkB_8VbrzLiqw@mail.gmail.com>
	<CAJZOPZKYHBXB-C+LJAOtGS4xDCWfSjBoj2JNCwKGWw7cU=2ZxQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZKYHBXB-C+LJAOtGS4xDCWfSjBoj2JNCwKGWw7cU=2ZxQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is in a lab environment and our network admin was doing some
experimentation that he didn't think would affect me since I wasn't
using multicast (does rdma_cm use multicast or IGMP?).  His
description:

I was running a test last week to simulate multiple switch hops by
connecting the switch to itself (in another vlan) several times.  With
this setup, I had a host on the lab network that was multiple switch
hops away.  It appears that one of these other vlans somehow became
designated at the IGMP querier and either queries weren=92t being sent
or weren=92t being processed.  Removing the first link in this chain
caused the queries to start working again.  Without an appropriate
querier, the switch didn=92t think it had to forward any groups (other
than the 224.0.0.x reserved range that is always flooded).

This kind of odd switch connection would obviously never happen in prod=
uction.


On Thu, Oct 20, 2011 at 4:01 PM, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrot=
e:
> Kelly Burkhart <kelly.burkhart-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>>> I'm having a problem connecting using RDMA_CM over ethernet....
>> Actually not. =A0My network admin found some sort of misconfiguratio=
n on
>> the switch that caused the problem =A0Everything works now.
>
> Interesting, could you share the nature of =A0problem?
>
> Or.
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
