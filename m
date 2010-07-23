From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Issue with RDMA_CM on systems with multiple IB HCA's.
Date: Fri, 23 Jul 2010 23:03:32 +0300
Message-ID: <AANLkTi=s4TWfji7Jkz7SipK6WABKGdB5CurhSqPMxXPw@mail.gmail.com>
References: <AANLkTinco6znrHkoE9vL1n7KrrZ68zPExPUPQeDHD64i@mail.gmail.com>
	<Pine.GSO.4.40.1007221320200.17-300000@kappa.cse.ohio-state.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.GSO.4.40.1007221320200.17-300000-ItQMRKI8FOvVp4Hyp30HIZ9NZdITTVap@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hari Subramoni <subramon-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hari Subramoni <subramon-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org> wrote:

> The nodes have LID's assigned to them and OpenSM is running fine.
> I've attached the configurations of the two hosts along with this e-mail.
>  As Jonathan mentioned, we are able to ping between them.

are the two HCAs on each of the nodes connected to the same IB subnet?

> The issue is intermittent. It happens at times and at other times, things
> work fine. Please let us know if you need any more information.

lets focus on rping, please use both -v -d  flags with rping, also
when  rping fails, please send the neighbours info (#ip neigh show)
from host .5

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
