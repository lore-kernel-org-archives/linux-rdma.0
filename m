From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/3] Support out of order data placement
Date: Mon, 12 Jun 2017 15:41:35 -0600
Message-ID: <20170612214135.GB30578@obsidianresearch.com>
References: <20170612064918.12510-1-leon@kernel.org>
 <1497281280.2770.1.camel@wdc.com>
 <VI1PR0502MB3008478FC7C70D1F398FE2B2D1CD0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170612162917.GA11993@obsidianresearch.com>
 <VI1PR0502MB3008EA451DA9ECEBECE27362D1CD0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170612164343.GA12435@obsidianresearch.com>
 <VI1PR0502MB300831A1560531E67B29589DD1CD0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170612165536.GB12435@obsidianresearch.com>
 <6747e257-67b0-a364-be21-04f73ef82ffe@talpey.com>
 <VI1PR0502MB30080B672B80836FF0A328DCD1CD0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <VI1PR0502MB30080B672B80836FF0A328DCD1CD0-o1MPJYiShExKsLr+rGaxW8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Idan Burstein <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 12, 2017 at 09:32:30PM +0000, Parav Pandit wrote:

> There can be cases in deployment where responder has support for
> receiving out-of-order, but requester doesn't.  Read responses

You still haven't explained at all what the transmitter side does
differently..

Is this actually some kind of selective retransmit scheme?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
