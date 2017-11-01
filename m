From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: Perftest fails when declaring support for MW_TYPE_2A
Date: Wed, 1 Nov 2017 10:45:27 -0600
Message-ID: <20171101164527.GC1030@ziepe.ca>
References: <CY1PR0701MB2012478CF41D9E2292887ABC885F0@CY1PR0701MB2012.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CY1PR0701MB2012478CF41D9E2292887ABC885F0-UpKza+2NMNLHMJvQ0dyT705OhdzP3rhOnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: Zohar Ben Aharon <zoharb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "lunnys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <lunnys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "idos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <idos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 01, 2017 at 03:35:54PM +0000, Kalderon, Michal wrote:
> Hi Mellanox/ Accelio, 
> 
> There is a very old commit in perftest 96050b8b that assumes bit 23
> in device cap flags means there is driver support for contiguous
> buffer allocation of user data

Wow.

This is

https://github.com/linux-rdma/perftest/blob/master/src/perftest_resources.c#L272

And it is totally unacceptable for upstream'ed open source code to
have crap like this.

Delete it.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
