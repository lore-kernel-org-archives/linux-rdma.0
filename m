From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-next 27/31] IB/cm: Fix honor address handle
 attribute init error
Date: Tue, 14 Nov 2017 16:38:41 -0700
Message-ID: <20171114233841.GC25894@ziepe.ca>
References: <20171114125218.20477-1-leon@kernel.org>
 <20171114125218.20477-28-leon@kernel.org>
 <CAJ3xEMjPsD7+YnN80A7Z3WjxEey20=TYKpxrRK_mRhKVMEnA8Q@mail.gmail.com>
 <VI1PR0502MB3008514AED6DA3E970381088D1280@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <CAJ3xEMg6bJt0obWHrSae86ZUN7RgCYqWJJiQXw9on82P=zO_VA@mail.gmail.com>
 <VI1PR0502MB300851A707AFA9DEC77B232ED1280@VI1PR0502MB3008.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <VI1PR0502MB300851A707AFA9DEC77B232ED1280-o1MPJYiShExKsLr+rGaxW8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 14, 2017 at 10:27:42PM +0000, Parav Pandit wrote:

> > On Wed, Nov 15, 2017 at 12:13 AM, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > wrote:
> > >> From: Or Gerlitz [mailto:gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
> > 
> > >> any reason not to point out the commit that introduced the bug?
> > > No particular reason. I am not sure few years back it was bug or not. In current
> > code it appear so.
> > > So I continued without Fixes commit line.
> > 
> > 
> > The idea is that you do the git blaming and such work to get the
> > Fixes line, and later, the maintainer of the sub-system and
> > maintainers of stable kernel use that to decide if/where they want
> > this to go beyond the -rc kernel you are fixing

> Yes, I understand. But would that be a bug in initial commit, which
> transport was it handling.. without error code check what could have
> gone wrong..  I do not have answer for those questions. So I omitted
> the Fixes line.  Wherever I knew for sure in this or other series, I
> have added.

While the fixes line is nice, the more important question is if any of
these patches should have a 'Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org' ?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
