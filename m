From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 6/7] ibverbs: Update man pages to include cvlan
 offloads options
Date: Tue, 14 Mar 2017 10:57:35 -0600
Message-ID: <20170314165735.GA20314@obsidianresearch.com>
References: <1489490143-29018-1-git-send-email-yishaih@mellanox.com>
 <1489490143-29018-7-git-send-email-yishaih@mellanox.com>
 <20170314154849.GC3244@obsidianresearch.com>
 <25fdeb74-15dc-23f4-0886-9b309c404df7@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <25fdeb74-15dc-23f4-0886-9b309c404df7-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 14, 2017 at 06:41:17PM +0200, Yishai Hadas wrote:
> On 3/14/2017 5:48 PM, Jason Gunthorpe wrote:
> >On Tue, Mar 14, 2017 at 01:15:42PM +0200, Yishai Hadas wrote:
> >>From: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >>
> >>Provide information about the cvlan stripping offload for
> >>- ibv_create_wq
> >>- ibv_modify_wq
> >>- ibv_create_cq_ex
> >>- ibv_query_device_ex
> >
> >I continue to be annoyed that these patches are extending the 'common'
> >API without providing enough descriptive information to understand
> >exactly what these new options are supposed to do and how to implement
> >them.
> 
> This man page patch follows other man pages spirit which basically adds the
> new fields with some extra notes, there is no new verbs around and we expect
> that it will be enough.
> 
> In addition, each patch expects to be clear from usage point of view and its
> purpose, it includes relevant notes in code when we found it helpful and has
> a detailed commit log.
>
> However, if you find some specific patch that needs some extended commit log
> or you can point on a specific note that needs some man page extension
> please point on and we'll send an update for.

As I said, it is all inadequate.

If you want to extend the comon API you need to describe your
extensions *somewhere* to a spec-level quality.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
