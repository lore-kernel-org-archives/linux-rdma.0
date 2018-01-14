From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [RFC] iser-target: avoid reinitializing rdma contexts for isert
 commands
Date: Sun, 14 Jan 2018 11:23:44 -0700
Message-ID: <20180114182344.GB9088@ziepe.ca>
References: <1511893687-29298-1-git-send-email-bharat@chelsio.com>
 <20171218231439.GA31621@ziepe.ca>
 <1515824443.24576.108.camel@haakon3.daterainc.com>
 <20180113180428.GA32353@ziepe.ca>
 <143bd378-193e-0bbd-1ee3-25299af61aa8@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <143bd378-193e-0bbd-1ee3-25299af61aa8-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Bharat Potnuri <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Jan 14, 2018 at 11:26:04AM +0200, Sagi Grimberg wrote:
> 
> >>Per Potnuri, it should be stable CC' to 4.11.y, and depends on:
> >>
> >>7a56dc8 iser-target: avoid posting a recv buffer twice
> >>555a65f iser-target: Fix queue-full response handling
> >>fa7e25c target: Fix unknown fabric callback queue-full errors
> >
> >Hi Nicholas,
> >
> >It is too late for us to revise this commit message in the RDMA tree,
> >someone will have to notify stable manually instead.
> 
> I think it would be easier if nab would take this through the target
> tree... Nic?

Too late for that too, it is in the rdma tree already.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
