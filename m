From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/3] Support out of order data placement
Date: Sat, 22 Jul 2017 10:09:39 -0600
Message-ID: <20170722160939.GA30007@obsidianresearch.com>
References: <VI1PR0502MB3008E04612EED6BC83F37115D1CD0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <fbdcf05b-ccd8-bd9c-c9c8-86f373303250@talpey.com>
 <VI1PR0502MB30089271EB542493AA58060CD1C20@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <fb11f261-b80b-f71a-8076-204706267798@talpey.com>
 <VI1PR0502MB3008D488FEE8A7104A7B0A7CD1A60@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <142c2fed-baa5-1295-1458-be765c94b957@talpey.com>
 <VI1PR0502MB300886ED1B5B1363B55F53F0D1A50@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <e5cee768-586c-516a-6056-ea4a44f89134@talpey.com>
 <VI1PR0502MB30089915EB792CD20CA9D179D1A50@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <4444a96a-c1e6-ad33-204a-680982e19bfe@talpey.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4444a96a-c1e6-ad33-204a-680982e19bfe-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Cc: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Idan Burstein <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Jul 22, 2017 at 07:51:33AM -0700, Tom Talpey wrote:
> Well, if the broken applications won't use the extension, and
> the existing storage protocols and applications will have to
> change both their implementation and their protocol to use it,
> who do you envision actually doing so?

The apps are not broken, it appears that this extension allows the
receiver HCA to process inbound packets without seeing earlier
packets.

This means it can really start doing things out of order, subject only
to the ability of the transmitter to halt sending (eg fence) until
acks are seen.

Since there is no way to predict what is in the data the HCA didn't
see, this would seem to allow quite a lot of out of order execution
inside the HCA.

Eg

 RDMA-W VA=0 Data=1
 RDMA-R VA=0
 RDMA-W VA=0 Data=2

What does the read return? Spec says 1, but it sounds like this
relaxed ordering could return 2.

Whta about

 RDMA-W VA=0 Data=1
 SEND WITH INVALIDATE VA=0
 RDMA-W VA=0 Data=2

Spec says the second RDMA-W must fail, but it sounds like this relaxed
ordering would allow it to happen.

So it cannot be turned on by default.. But a traditional well behaved
storage ULP will only do single access to a single VA and should be
able to safely turn something like this on.

All of these is independent to observability at the CPU..

All this means it needs to be negotiated via RDMA-CM, and making it a
common verbs option would make sense - is there a plan to do that?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
