From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V1 rdma-core 0/2] Optimize RoCE address handle creation
 for userspace
Date: Mon, 5 Dec 2016 16:44:02 -0700
Message-ID: <20161205234402.GA1937@obsidianresearch.com>
References: <1480866806-5052-1-git-send-email-yishaih@mellanox.com>
 <20161205170702.GA27306@obsidianresearch.com>
 <7b8e90ac-c653-6a54-846d-75adeeb8059f@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <7b8e90ac-c653-6a54-846d-75adeeb8059f-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 06, 2016 at 12:01:13AM +0200, Yishai Hadas wrote:
> >I'm not sure where we are in the release cycle right now.. Doug - if
> >we didn't make a release with the 1.3 symbol tag (this was created
> >just before rdma-core) then this should go into 1.3 when it gets
> >merged..
> 
> Jason,
> You pointed to use 1.4, the series followed that.

Yes, but I realized we may not have made a ibverbs release before
starting rdma-core.

> Doug,
> Can you please comment here ? we should have a clear definition what defined
> to be a "release" which requires a new number.
> In case we want to use 1.3 please let me know if I need to re-spin or you
> will change as part of the merge.

Doug/Leon/You have to check this stuff before merging any series that
touches a map file, beacuse it depends on when in the cycle the patch
gets merged.

After the first rdma-core release is done we should denote the map
stanzas with a comment indicating which release number they are for so
it is easier to keep track.

eg we are nearing the release for 4.9, so presumably Doug will tag a
rdma-core relase soon. If this series does not make that cutoff 1.4
would be correct.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
