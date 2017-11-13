From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: Re: rdma-core stable releases
Date: Mon, 13 Nov 2017 11:17:36 +0100
Message-ID: <da396bd3-c135-9256-9614-24211f470c11@suse.de>
References: <CY1PR0701MB2012C57AB3FDE0232D72F70688500@CY1PR0701MB2012.namprd07.prod.outlook.com>
 <20171106182756.GD18802@ziepe.ca>
 <6012d1c3-cd18-25e8-c5ae-3d678142177b@suse.de>
 <54347E5A035A054EAE9D05927FB467F9B61778A9@ORSMSX101.amr.corp.intel.com>
 <20171110202455.GP18825@mtr-leonro.local> <20171110211448.GF17451@ziepe.ca>
 <1eba9063-80a4-ad9d-4adf-93770b9ed7c9@suse.de>
 <20171113070856.GZ18825@mtr-leonro.local>
 <BN3PR07MB2578CD2BC31353CA84CE7CD1F82B0@BN3PR07MB2578.namprd07.prod.outlook.com>
 <02b4efe8-1af5-aa9e-ed7e-ed8be1b57cdd@suse.de>
 <BN3PR07MB2578249E444CC72D72FF2FA0F82B0@BN3PR07MB2578.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BN3PR07MB2578249E444CC72D72FF2FA0F82B0-EldUQEzkDQfpW3VS/XPqkOFPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Rahman, Ameen" <Ameen.Rahman-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Radzi, Amit" <Amit.Radzi-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



Le 13/11/2017 à 11:11, Amrani, Ram a écrit :
>> When I mean no ABI changes I mean that anything compiled against rdma-core X.Y also compiles (and and run without
>> recompiling) against X.Z with Z >= Y.
>> This is very important for distro maintenance. You cannot break your user code just to add a fix.
> "compiled against" implies an application.
> We are talking about the kernel/user ABI as well, right?

I was talking about the application side of things.
For the kernel side, any rdma-core version is supposed to work against any kernel so as long as it's still true after applying the fix, I don't see much of a risk there.

Nicolas
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
