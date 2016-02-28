From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: Re: SRPt oops with 4.5-rc3-ish
Date: Sat, 27 Feb 2016 20:47:08 -0800
Message-ID: <1456634828.19657.84.camel@haakon3.risingtidesystems.com>
References: <56C0A6C3.3010903@redhat.com>
	 <1456630639.19657.47.camel@haakon3.risingtidesystems.com>
	 <56D274F8.9070804@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56D274F8.9070804-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, 2016-02-27 at 20:18 -0800, Bart Van Assche wrote:
> On 02/27/16 19:37, Nicholas A. Bellinger wrote:
> > This is a fairly recent srpt shutdown regression, right..?
> 
> Hi Nic,
> 
> My patch series to make TMR handling synchronous fixes what Doug 
> reported. If you want I can rebase and repost that patch series.
> 

There aren't even any TMRs being processed, so I don't see how that has
anything to do with it.

>From the logs, this OOPsen is related to some manner of recent srpt
configfs se_node_acl + se_session active I/O shutdown regression.

So short of sitting down and reproducing myself on v4.5-rc code,
commit 59fae4de's removal of ib_create_cq() + ib_comp_handler callback
usage look like a good place to start the investigation.

It would be useful to first find out what changes introduced this
regression, and how far back Doug is able to reproduce.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
