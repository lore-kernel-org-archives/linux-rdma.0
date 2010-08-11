From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2] rdma/ib_pack.h: add new bth opcodes
Date: Wed, 11 Aug 2010 10:12:56 +0300
Message-ID: <4C624D78.8030407@Voltaire.com>
References: <00a901cb3785$4a032810$de097830$@com>	<CF9C39F99A89134C9CF9C4CCB68B8DDF25A954BCAF@orsmsx501.amr.corp.intel.com> <4C616D38.7090506@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C616D38.7090506-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bob Pearson <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>, Paul Grun <pgrun-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Bob Pearson wrote:
> My interest is supporting the rxe driver, a software implementation of
> the IB transport over Ethernet, [...] I spent a little time looking at
> trying to exploit congestion notification to see if it would bu useful in this context.

Hi Bob,

As the IB congestion control / notification has the part of the IB switches marking 
packets with FECNs, I don't see how does IB CCA fits into IBoE scheme, Paul?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
