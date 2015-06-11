From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next V3 0/8] Add completion timestamping support
Date: Thu, 11 Jun 2015 11:53:07 -0600
Message-ID: <20150611175307.GA20142@obsidianresearch.com>
References: <1434029727-6062-1-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1434029727-6062-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 11, 2015 at 04:35:19PM +0300, Or Gerlitz wrote:
> Jason had another comment calling for re-thinking / questioning the 
> need for a dedicated uverbs_ex_cmd_mask in the IB device. This goes 
> beyond the scope of this specific series. 

How is properly setting up the new verbs you added beyond the scope of
this series? It is a trivial change to move this:

+       ibdev->ib_dev.uverbs_ex_cmd_mask |=
+               (1ull << IB_USER_VERBS_EX_CMD_QUERY_DEVICE) |
+               (1ull << IB_USER_VERBS_EX_CMD_CREATE_CQ);

Into the right core function so it is enabled for all drivers.

That isn't re thinking at all, that is how the extension mechanism was
always intended to work.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
