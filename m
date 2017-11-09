From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: Re: rdma-core stable releases
Date: Thu, 9 Nov 2017 13:11:01 +0100
Message-ID: <6012d1c3-cd18-25e8-c5ae-3d678142177b@suse.de>
References: <CY1PR0701MB2012C57AB3FDE0232D72F70688500@CY1PR0701MB2012.namprd07.prod.outlook.com>
 <20171106182756.GD18802@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171106182756.GD18802-uk2M96/98Pc@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Rahman, Ameen" <Ameen.Rahman-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Radzi, Amit" <Amit.Radzi-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



Le 06/11/2017 à 19:27, Jason Gunthorpe a écrit :
> On Mon, Nov 06, 2017 at 06:21:47PM +0000, Kalderon, Michal wrote:
>
>> I'd like to here if anyone has any objects / concerns on the matter
>> in general, and if there is a consensus about the need and whether
>> this is something the rdma-core maintainers would be willing to
>> provide.
> Previous discussions on this topic concluded that if someone wishes to
> maintain a stable branch scheme then we'd make space for that (eg a
> github branch or whatever).
>
> I don't think the existing maintainers are interested in directly
> working on this project, so there is room for a new volunteer!
>
>

I agree there is a big need for that. Currently reviewing all the patches I haven't read (only 1000 mails to go...) to see if they need to be backported on top on rdma-core 15 for the next SLES.
I'd gladly help maintaining this as I'm spending time on it anyway.
I'll leave wiser people debate and ready a doc on how this should be done though :)

Nicolas
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
