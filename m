From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH V4 libibverbs 2/7] Add member functions to poll an
 extended CQ
Date: Tue, 31 May 2016 19:48:09 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB05CB9F@ORSMSX109.amr.corp.intel.com>
References: <1464533475-18949-1-git-send-email-yishaih@mellanox.com>
 <1464533475-18949-3-git-send-email-yishaih@mellanox.com>
 <574B6F71.9060808@redhat.com> <20160529233009.GA12420@obsidianresearch.com>
 <8F7BC9E2-75EC-413B-BEBE-11450225AF06@redhat.com>
 <20160530013507.GA19230@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB05CA6D@ORSMSX109.amr.corp.intel.com>
 <20160531180608.GA21834@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160531180608.GA21834-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > These are more thoughts than questions: If an app wants to support
> > iWarp/RoCE/OPA, is it just going to have a branch around the calls
> > anyway?
> 
> This doesn't really change one way or the other, apps have to
> understand what attributes are available on the CQ and do whatever
> branching is needed to access them.
> 
> It is a good question if we should have different accessors, like
> get_src_addr(buf,sizeof(buf)) or something that can handle the other
> protocols with less hassle.

I agree.

> But at the end of the day, the user will still have to cast the buf to
> the right type...

I think this depends on what the app is wanting or needing to do with this data.  If the app needs this in order to create an address handle, for example, this format of the data could be transparent to the app (assuming a new create ah API).

> > What data is actually needed by the apps?
> 
> The apps decide when they create the CQ what things the CQ is needed
> to return. So apps are in control. Are you musing if some of these are
> needed or not?

I was just musing which fields are needed by which apps and for what purpose.

> > Is there any relationship between the various calls?  For example,
> > if an app calls read_slid, is it more likely than not to also call
> > read_pkey_index and read_dlid_path_bits, etc.?
> > Is the app expected to retrieve addressing data piecemeal like this
> > for every possible architecture?  Are 5 function calls better than
> > one call that fills out a structure, when all fields are needed?
> 
> There are certainly logical groups, eg the various path parameters are
> almost always going to be needed together.
> 
> I was asking this same question.. I think the response was that
> memcpying into a stack struct was more expensive than the branches..
> 
> I'm skeptical of that, but maybe if the C ABI doesn't use return value
> optimization like C++ does it could get a bit costly....
> 
> Even so, it seems like an easier API for the end user...

Personally, I would lean toward having a an easier to use API, at the cost of a few extra cycles.  I guess if you add the equivalent of FABRIC_DIRECT to libibverbs, the proposed model seems like it would be optimal.  This probably requires that all CQs have the same format.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
