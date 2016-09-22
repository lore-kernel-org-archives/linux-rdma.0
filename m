From: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH libibverbs v3 1/3] Add new call ibv_cmd_create_ah_ex
 which supports extra parameters
Date: Thu, 22 Sep 2016 06:46:14 +0200
Message-ID: <1474519574.20134.257.camel@oracle.com>
References: <cover.b0b7418bec346c028215053b3e58e097aa822563.1474352400.git-series.knut.omang@oracle.com>
         <d551c3792e884443903c67212f505082cd53b135.1474352400.git-series.knut.omang@oracle.com>
         <550041ef-b105-c079-068c-d96278ec34f1@dev.mellanox.co.il>
         <20160920153217.GE32020@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160920153217.GE32020-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mukesh Kacker <mukesh.kacker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2016-09-20 at 09:32 -0600, Jason Gunthorpe wrote:
> On Tue, Sep 20, 2016 at 02:17:04PM +0300, Yishai Hadas wrote:
> 
> > Any reason to add 1.4 instead of using 1.3 ? in my understanding the idea is
> > that new symbols for next release will use a new ABI version, this is what
> > 1.3 already supplied. Added Jason for his input as well.
> 
> Doug indicated he was going to roll a 1.3 release RSN, up to him what
> number it will be eventually.
>  
> > >+	global:
> > >+		ibv_cmd_create_ah_ex;
> > 
> > When do you plan to contribute the driver code for that ? for now no
> > upstream drivers uses this API, taking some code for future usage with no
> > current usage is not the preferred way.
> 
> Even a github reference with your pre-submission driver would be useful

Tried to find an Oracle employee active user without success so far, 
so I need to validate that this is ok. In parallel I am pursuing getting 
public git repos on the Oracle OSS site for it.

My plan is to post the driver in a big
file-by-file commit series rebased to the latest, but I have 
got a bit delayed by other work, so I think realistically 
that I am not ready until mid-Oct.

Thanks,
Knut

> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
