From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH v3 00/13] Request for Comments on SoftiWarp
Date: Fri, 2 Feb 2018 11:56:40 -0700
Message-ID: <20180202185640.GC9080@ziepe.ca>
References: <031f01d38fad$422520c0$c66f6240$@opengridcomputing.com>
 <20180114223603.19961-1-bmt@zurich.ibm.com>
 <OFD1018BEE.35589194-ON00258228.00505F2B-00258228.00505F31@notes.na.collabserv.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <OFD1018BEE.35589194-ON00258228.00505F2B-00258228.00505F31-8eTO7WVQ4XIsd+ienQ86orlN3bxYEBpz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Feb 02, 2018 at 02:37:52PM +0000, Bernard Metzler wrote:

> I added libsiw to the current (as of today) rmda-core bundle
> as found at https://github.com/linux-rdma/rdma-core.git, see

Can you use the standard OFA license please? IBM is an OFA member and
is behloden to the membership agreement requring the common dual
license.

> It enables user level clients for the siw driver. Let me
> know if we need a patch for user land as well for now.
> I don't want to spam the list.

We will eventually..

+static const struct verbs_match_ent rnic_table[] = {
+	VERBS_NAME_MATCH("siw", NULL),
+	{},
+};

I really don't want to add more VERBS_NAME_MATCH, but I don't have an
alternative ready right now :(

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
