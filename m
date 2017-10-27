From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-next 00/16] Flow counters support
Date: Fri, 27 Oct 2017 09:59:55 -0600
Message-ID: <20171027155955.GA15922@obsidianresearch.com>
References: <1508424118-27205-1-git-send-email-yishaih@mellanox.com>
 <20171023165118.GA18097@obsidianresearch.com>
 <b003f6e5-d7ce-3775-a1dc-0fd0f507a515@dev.mellanox.co.il>
 <20171025151734.GA15557@obsidianresearch.com>
 <AM6PR0502MB3783A1186AA0ABDCCD5359AEBD5A0@AM6PR0502MB3783.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <AM6PR0502MB3783A1186AA0ABDCCD5359AEBD5A0-md96bDB8+JV1k1TWM4Wt8cDSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Guy Shattah <sguy-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Raed Salem <raeds-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Rosenbaum <alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Oct 27, 2017 at 03:46:57PM +0000, Guy Shattah wrote:
> ?   
> On Wed, Oct 25, 2017 at 06:17:15PM +0300, Jason Gunthorpe wrote:
> >On Wed, Oct 25, 2017 at 05:58:15PM +0300, Yishai Hadas wrote:
> >
> >> Hi Jason, please go over the patches/uapi, we believe that you'll find it
> >> quite easy to be used by an application, however we plan to improve as of
> >> below.
> >
> >No, it is not, this proposal relies too much on device-specific
> >information to make sense in a multi-vendor context. Counters should
> >not be grouped in a hardware unique way.
> 
> counters are not group in hardware unique but in an intuitive way.

I don't think you understand my remark.

I do not want to expose the idea of hardware limited groupings of
counters to the user at all.

If the user needs counters 1,2 then the user should request those
counters only. Hardware that needs to sample, say, counter 1,2,3,4 to
get those will have to figure that out internally.

If the API requires a complex query interface just for the user it use
it at all, then it is a total failure in my view. And that seems to be
what is proposed here.

> >That is unfortunate, and kind of lame, but you can still use the
> >proposed API by re-ordering things. Continue to have
> >ibv_add_sampling_point_flow, however a NULL flow argument will make
> >the counters become added when the flow is created:
> >
> >?counters = ibv_create_counters([..]);
> >?ibv_add_sampling_point_flow(counters, 1, NULL, [..])
> >?flow_attr.counters = counters;
> >?ibv_create_flow(qp, &flow_attr);
> 
> As mentioned earlier - current hardware support attachment of counters
> only during the creation of the object (flow/qp/etc).

And as I explained, the above addresses that.

> Your proposal could be useful in the case where a structure of a dynamic
> counter set is to be modified. However - since it is not the current case,
> there is no benefit in dividing the build of such a counter-set into
> several steps.

The purpose is to make the API less dependent on specific
implementation details.

Mellanox drivers may wish to implement ibv_add_sampling_point_* as
some kind of internal bookkeeping in userspace, other drives may wish
to do kernel calls. It depends on how each type of hardware works.

You need to stop looking at the API through a Mellanox only lense.

In any case, having broken down APIs is far easier to use for the user.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
