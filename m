From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH v3 03/13] Attach/detach SoftiWarp to/from network and RDMA subsystem
Date: Tue, 23 Jan 2018 11:43:58 -0600
Message-ID: <014701d39471$bf4ac500$3de04f00$@opengridcomputing.com>
References: <011801d3946b$53ef0060$fbcd0120$@opengridcomputing.com>,<20180114223603.19961-1-bmt@zurich.ibm.com> <20180114223603.19961-4-bmt@zurich.ibm.com> <00ff01d39467$f1f31b60$d5d95220$@opengridcomputing.com> <20180123164316.GC30670@ziepe.ca> <OF34749881.4216E578-ON0025821E.005F897C-0025821E.005F8983@notes.na.collabserv.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <OF34749881.4216E578-ON0025821E.005F897C-0025821E.005F8983-8eTO7WVQ4XIsd+ienQ86orlN3bxYEBpz@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Bernard Metzler' <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Cc: 'Jason Gunthorpe' <jgg-uk2M96/98Pc@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> >"At the Data Source, the DDP layer MUST segment the data contained in
> >   a ULP message into a series of DDP Segments, where each DDP
> >Segment
> >   contains a DDP Header and ULP Payload, and MUST be no larger than
> >the
> >   MULPDU value Advertised by the LLP."
> 
> TCP advertises 64k on the kernel socket ;)

Yes, but it also advertises the actual wire MSS, right?


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
