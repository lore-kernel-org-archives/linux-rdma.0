From: Hari Subramoni <subramon-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>
Subject: Re: Issue with RDMA_CM on systems with multiple IB HCA's.
Date: Mon, 26 Jul 2010 14:42:41 -0400 (EDT)
Message-ID: <Pine.GSO.4.40.1007261442050.20664-100000@omicron.cse.ohio-state.edu>
References: <AANLkTi=s4TWfji7Jkz7SipK6WABKGdB5CurhSqPMxXPw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=s4TWfji7Jkz7SipK6WABKGdB5CurhSqPMxXPw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

Yes, both cards are on the same IB subnet.

The machines are down for maintanence now. We will send out the
information you requested as soon as they are up.

Thanks a lot,
Hari.

On Fri, 23 Jul 2010, Or Gerlitz wrote:

> Hari Subramoni <subramon-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org> wrote:
>
> > The nodes have LID's assigned to them and OpenSM is running fine.
> > I've attached the configurations of the two hosts along with this e-mail.
> >  As Jonathan mentioned, we are able to ping between them.
>
> are the two HCAs on each of the nodes connected to the same IB subnet?
>
> > The issue is intermittent. It happens at times and at other times, things
> > work fine. Please let us know if you need any more information.
>
> lets focus on rping, please use both -v -d  flags with rping, also
> when  rping fails, please send the neighbours info (#ip neigh show)
> from host .5
>
> Or.
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
