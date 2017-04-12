From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH rdma-next 17/18] IB/core: Define 'ib' and 'eth'
 rdma_ah_attr types
Date: Wed, 12 Apr 2017 14:05:25 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB111C5D@ORSMSX109.amr.corp.intel.com>
References: <1491932545-60894-1-git-send-email-dasaratharaman.chandramouli@intel.com>
 <1491932545-60894-18-git-send-email-dasaratharaman.chandramouli@intel.com>
 <VI1PR0502MB3008F933EA086C3A47C025B3D1000@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <9873c7bd-5fe7-7b9a-c28f-e11ffa5d53e9@intel.com>
 <VI1PR0502MB30081ACB86A0ADEEE2C68743D1030@VI1PR0502MB3008.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <VI1PR0502MB30081ACB86A0ADEEE2C68743D1030-o1MPJYiShExKsLr+rGaxW8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Chandramouli, Dasaratharaman" <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > I can change the type check into a function if you feel its open
> coded.
> > One of the benefits of adding type to ah_attr is exactly the above
> code.
> > The caller doesnt have to call into the core (rdma_cap_eth_ah) to
> know what
> > 'protocol' its working with. That information is contained in the
> ah_attr itself.
> >
> I was referring to have helper function like rdma_cap_eth_ah, but for
> ah_attr_type
> as,
> is_ah_attr_eth(ah_attr).
> 
> I think it will be more useful, as there is more code in grh
> processing coming up, that needs to diverge based on ib vs roce.
> And there are few places we have that comparison anyway below. It just
> keep code neat.

FWIW, I don't see a benefit to converting a simple type check of an enum into a function.  The type allows its use in a switch statement, rather than needing to use if - else-if - else-if.

> While we are at it, I was thinking since iWarp doesn't use AH, we
> better name ah->type as ROCE, to avoid this confusion happening again?

I agree, though I'm still not sure v1 and v2 need all the same fields or use them in the same way.  Conceptually, a GRH in v2 doesn't make sense to me.  (I should go read the spec.)  But in any case v1/v2 separation could come as follow on changes.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
