From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/ipoib: break linkage to neighbouring system
Date: Fri, 13 Jul 2012 14:04:16 +0300
Message-ID: <CAJZOPZKgR9qOyQKteujtq9h7HK3RFcw26kr3taXcJDhGZ2JAuQ@mail.gmail.com>
References: <1341914495-32730-1-git-send-email-ogerlitz@mellanox.com>
	<32E1700B9017364D9B60AED9960492BC0D47265A@FMSMSX108.amr.corp.intel.com>
	<36F7E4A28C18BE4DB7C86058E7B607241DC0E3A6@MTLDAG01.mtl.com>
	<20120712.175825.1973614213454644336.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120712.175825.1973614213454644336.davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Jul 13, 2012 at 3:58 AM, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org> wrote:

> You don't need a R/W lock for that, we have RCU hash tables that get
> resized dynamically and the lookup still only needs pure RCU protection.

Hi Dave,

Thanks for the feedback, Shlomo will look into this and if needed,
will ask for some coaching from you... Again, we're very excited from
finally resolving this long standing issue, Roland, any further
feedback? anything else you think need to be fixed/changed?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
